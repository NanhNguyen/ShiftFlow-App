import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../di/di_config.dart';
import '../../theme/app_theme.dart';
import '../../../../data/model/schedule_request_model.dart';
import '../../../../data/constant/enums.dart';
import '../../../../data/service/auth_service.dart';
import 'cubit/schedule_cubit.dart';
import 'cubit/schedule_state.dart';
import '../../../resource/app_strings.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late final UserRole _userRole;
  final TextEditingController _searchController = TextEditingController();
  String _filterEmployee = '';

  @override
  void initState() {
    super.initState();
    _userRole = getIt<AuthService>().currentUser?.role ?? UserRole.INTERN;
    _selectedDay = _focusedDay;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isManagerOrHR =
        _userRole == UserRole.MANAGER || _userRole == UserRole.HR;

    return BlocProvider.value(
      value: getIt<ScheduleCubit>(),
      child: Scaffold(
        backgroundColor: InternaCrystal.bgDeep,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: InternaCrystal.brandGradient,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
          ),
          foregroundColor: Colors.white,
          title: Text(
            isManagerOrHR
                ? AppStrings.staffSchedule
                : AppStrings.myWorkSchedule,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          elevation: 0,
          centerTitle: true,
        ),
        body: DefaultTabController(
          length: 2,
          child: BlocListener<ScheduleCubit, ScheduleState>(
            listenWhen: (prev, curr) => curr.resetTrigger != prev.resetTrigger,
            listener: (context, state) {
              if (state.resetTrigger != null) {
                setState(() {
                  _focusedDay = DateTime.now();
                  _selectedDay = DateTime.now();
                });
              }
            },
            child: Column(
              children: [
                if (isManagerOrHR) _buildSearchBar(),
                Container(
                  decoration: const BoxDecoration(
                    gradient: InternaCrystal.brandGradient,
                  ),
                  child: TabBar(
                    indicatorColor: Colors.white,
                    indicatorWeight: 3,
                    labelStyle: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    unselectedLabelStyle: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white60,
                    tabs: const [
                      Tab(text: AppStrings.recurringLeave),
                      Tab(text: AppStrings.adhocLeave),
                    ],
                  ),
                ),
                Expanded(
                  child: BlocBuilder<ScheduleCubit, ScheduleState>(
                    builder: (context, state) {
                      if (state.status == BaseStatus.loading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return TabBarView(
                        children: [
                          _buildCalendarTab(context, state, isManagerOrHR, true),
                          _buildCalendarTab(context, state, isManagerOrHR, false),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarTab(
    BuildContext context,
    ScheduleState state,
    bool isManagerOrHR,
    bool isRecurringTab,
  ) {
    final format = isRecurringTab ? CalendarFormat.week : CalendarFormat.month;

    final filteredSchedules = isManagerOrHR && _filterEmployee.isNotEmpty
        ? state.approvedSchedules.where((s) {
            final name = (s.userMetadata?['name'] ?? '')
                .toString()
                .toLowerCase();
            return name.contains(_filterEmployee.toLowerCase());
          }).toList()
        : state.approvedSchedules;

    return RefreshIndicator(
      onRefresh: () => context.read<ScheduleCubit>().loadSchedules(_userRole),
      color: InternaCrystal.accentPurple,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 800;
          final calendarWidget = Container(
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: InternaCrystal.bgCard.withOpacity(0.6),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              border: Border.all(color: InternaCrystal.borderSubtle),
            ),
            child: Column(
              children: [
                _buildCustomCalendarHeader(format),
                TableCalendar(
                  headerVisible: false,
                  firstDay: DateTime(2020),
                  lastDay: DateTime(2030),
                  focusedDay: _focusedDay,
                  calendarFormat: format,
                  availableCalendarFormats: const {
                    CalendarFormat.month: 'Month',
                    CalendarFormat.week: 'Week',
                  },
                  locale: 'vi',
                  rowHeight: format == CalendarFormat.week ? 180 : 80,
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: InternaCrystal.accentPurple,
                    ),
                  ),
                  daysOfWeekHeight: 45,
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: InternaCrystal.textSecondary,
                    ),
                    weekendStyle: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: InternaCrystal.accentRed.withOpacity(0.7),
                    ),
                  ),
                  calendarStyle: CalendarStyle(
                    defaultTextStyle: GoogleFonts.inter(
                      color: InternaCrystal.textPrimary,
                      fontSize: 15,
                    ),
                    todayTextStyle: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    todayDecoration: BoxDecoration(
                      color: InternaCrystal.accentPurple.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                    selectedTextStyle: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    selectedDecoration: const BoxDecoration(
                      color: InternaCrystal.accentPurple,
                      shape: BoxShape.circle,
                    ),
                    outsideTextStyle: GoogleFonts.inter(
                      color: InternaCrystal.textMuted,
                    ),
                    weekendTextStyle: GoogleFonts.inter(
                      color: InternaCrystal.textMuted,
                      fontSize: 15,
                    ),
                  ),
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    setState(() => _focusedDay = focusedDay);
                  },
                  eventLoader: (day) => _getSchedulesForDay(
                    filteredSchedules,
                    day,
                  ).where((s) => s.isRecurring == isRecurringTab).toList(),
                  calendarBuilders: CalendarBuilders(
                    dowBuilder: (context, day) {
                      final text = DateFormat.E('vi').format(day);
                      return Center(
                        child: Text(
                          text,
                          style: GoogleFonts.inter(
                            color: day.weekday == DateTime.sunday
                                ? InternaCrystal.accentRed.withOpacity(0.7)
                                : InternaCrystal.textSecondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      );
                    },
                    defaultBuilder: format == CalendarFormat.week
                        ? (context, day, focusedDay) => _buildWeekDayCell(
                            day,
                            filteredSchedules
                                .where((s) => s.isRecurring == isRecurringTab)
                                .toList(),
                            isSelected: false,
                            isToday: false,
                            isManagerOrHR: isManagerOrHR,
                          )
                        : null,
                    todayBuilder: format == CalendarFormat.week
                        ? (context, day, focusedDay) => _buildWeekDayCell(
                            day,
                            filteredSchedules
                                .where((s) => s.isRecurring == isRecurringTab)
                                .toList(),
                            isSelected: false,
                            isToday: true,
                            isManagerOrHR: isManagerOrHR,
                          )
                        : null,
                    selectedBuilder: format == CalendarFormat.week
                        ? (context, day, focusedDay) => _buildWeekDayCell(
                            day,
                            filteredSchedules
                                .where((s) => s.isRecurring == isRecurringTab)
                                .toList(),
                            isSelected: true,
                            isToday: false,
                            isManagerOrHR: isManagerOrHR,
                          )
                        : null,
                    markerBuilder: (context, date, events) {
                      if (format == CalendarFormat.week) {
                        return const SizedBox();
                      }
                      if (events.isEmpty) return const SizedBox();
                      final items = events
                          .cast<ScheduleRequestModel>()
                          .where((s) => s.isRecurring == isRecurringTab)
                          .toList();
                      if (items.isEmpty) return const SizedBox();
                      return _buildMonthMarkerDots(items, isManagerOrHR);
                    },
                  ),
                ),
              ],
            ),
          );

          final eventListWidget = _buildEventList(
            filteredSchedules
                .where((s) => s.isRecurring == isRecurringTab)
                .toList(),
            isManagerOrHR,
          );

          if (isWide) {
            return Column(
              children: [
                _buildDesktopStats(state, isManagerOrHR),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 12,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(24, 0, 12, 24),
                          child: Column(
                            children: [
                              _buildLegend(isManagerOrHR),
                              calendarWidget,
                            ],
                          ),
                        ),
                      ),
                      VerticalDivider(
                        width: 1,
                        thickness: 1,
                        color: InternaCrystal.borderSubtle,
                      ),
                      Expanded(
                        flex: 7,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 20,
                              ),
                              decoration: BoxDecoration(
                                color: InternaCrystal.bgCard.withOpacity(0.5),
                                border: Border(
                                  bottom: BorderSide(
                                    color: InternaCrystal.borderSubtle,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: InternaCrystal.accentPurple.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.event_note_rounded,
                                      color: InternaCrystal.accentPurple,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    _selectedDay != null
                                        ? 'Lịch trình ngày ${DateFormat('dd/MM', 'vi').format(_selectedDay!)}'
                                        : 'Chọn một ngày',
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: InternaCrystal.textPrimary,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: InternaCrystal.bgDeep,
                                child: eventListWidget,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                _buildLegend(isManagerOrHR),
                calendarWidget,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Divider(color: InternaCrystal.borderSubtle),
                ),
                SizedBox(
                  height: 400,
                  child: eventListWidget,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDesktopStats(ScheduleState state, bool isManagerOrHR) {
    final today = DateTime.now();
    final todaySchedules = _getSchedulesForDay(state.approvedSchedules, today);
    final leaveCount = todaySchedules.where((s) => s.type == ScheduleType.LEAVE).length;
    final workCount = todaySchedules.where((s) => s.type == ScheduleType.WORK).length;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          _buildStatCard(
            'Nhân viên nghỉ phép',
            '$leaveCount',
            'Hôm nay',
            Icons.beach_access_rounded,
            InternaCrystal.accentPurple,
          ),
          const SizedBox(width: 20),
          _buildStatCard(
            'Nhân viên làm việc',
            '$workCount',
            'Tổng cộng nhân sự',
            Icons.work_rounded,
            InternaCrystal.accentBlue,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, String sub, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: InternaCrystal.bgCard.withOpacity(0.6),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: InternaCrystal.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: InternaCrystal.textPrimary,
                    letterSpacing: -1,
                  ),
                ),
                Text(
                  sub,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: InternaCrystal.textMuted,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomCalendarHeader(CalendarFormat format) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 400;
        
        return Container(
          padding: EdgeInsets.fromLTRB(isNarrow ? 12 : 24, 20, isNarrow ? 12 : 24, 12),
          decoration: BoxDecoration(
            color: InternaCrystal.accentPurple.withOpacity(0.05),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_month_rounded, color: InternaCrystal.accentPurple, size: 18),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            DateFormat.yMMMM('vi').format(_focusedDay).toUpperCase(),
                            style: GoogleFonts.inter(
                              fontSize: isNarrow ? 14 : 16,
                              fontWeight: FontWeight.w800,
                              color: InternaCrystal.accentPurple,
                              letterSpacing: 0.5,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Row(
                    children: [
                      _buildNavButton(
                        icon: Icons.chevron_left,
                        onTap: () {
                          setState(() {
                            if (format == CalendarFormat.week) {
                              _focusedDay = _focusedDay.subtract(const Duration(days: 7));
                            } else {
                              _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1, _focusedDay.day);
                            }
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      _buildNavButton(
                        icon: Icons.chevron_right,
                        onTap: () {
                          setState(() {
                            if (format == CalendarFormat.week) {
                              _focusedDay = _focusedDay.add(const Duration(days: 7));
                            } else {
                              _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1, _focusedDay.day);
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              if (isNarrow) const SizedBox(height: 12),
              if (isNarrow)
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _focusedDay = DateTime.now();
                        _selectedDay = DateTime.now();
                      });
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: InternaCrystal.bgElevated,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: InternaCrystal.borderSubtle),
                      ),
                      child: Text(
                        AppStrings.today,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: InternaCrystal.textPrimary,
                        ),
                      ),
                    ),
                  ),
                )
              else
                const SizedBox.shrink(),
            ],
          ),
        );
      }
    );
  }

  Widget _buildNavButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: InternaCrystal.bgElevated,
          shape: BoxShape.circle,
          border: Border.all(color: InternaCrystal.borderSubtle),
        ),
        child: Icon(icon, size: 18, color: InternaCrystal.textPrimary),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      color: InternaCrystal.bgCard.withOpacity(0.5),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => setState(() => _filterEmployee = value),
        style: GoogleFonts.inter(color: InternaCrystal.textPrimary),
        decoration: InputDecoration(
          hintText: 'Tìm theo tên...',
          hintStyle: GoogleFonts.inter(fontSize: 14, color: InternaCrystal.textMuted),
          prefixIcon: const Icon(
            Icons.person_search_rounded,
            color: InternaCrystal.accentPurple,
            size: 22,
          ),
          suffixIcon: _filterEmployee.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, size: 18, color: InternaCrystal.textMuted),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _filterEmployee = '');
                  },
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildWeekDayCell(
    DateTime day,
    List<ScheduleRequestModel> allSchedules, {
    required bool isSelected,
    required bool isToday,
    bool isManagerOrHR = false,
  }) {
    final daySchedules = _getSchedulesForDay(allSchedules, day);
    final hasSchedules = daySchedules.isNotEmpty;

    final morningCount = daySchedules
        .where((s) =>
            s.shift == 'MORNING' ||
            s.shift == 'SÁNG' ||
            s.shift == 'ALL_DAY' ||
            s.shift == 'CẢ NGÀY')
        .length;
    final afternoonCount = daySchedules
        .where((s) =>
            s.shift == 'AFTERNOON' ||
            s.shift == 'CHIỀU' ||
            s.shift == 'ALL_DAY' ||
            s.shift == 'CẢ NGÀY')
        .length;

    final isWeekend =
        day.weekday == DateTime.saturday || day.weekday == DateTime.sunday;

    Color dayNumColor;
    Color bgColor;
    Color borderColor;
    if (isSelected) {
      bgColor = InternaCrystal.accentPurple;
      dayNumColor = Colors.white;
      borderColor = InternaCrystal.accentPurple;
    } else if (isToday) {
      bgColor = InternaCrystal.accentPurple.withOpacity(0.3);
      dayNumColor = Colors.white;
      borderColor = InternaCrystal.accentPurple;
    } else if (isWeekend) {
      bgColor = InternaCrystal.bgCard.withOpacity(0.3);
      dayNumColor = InternaCrystal.textMuted;
      borderColor = Colors.transparent;
    } else {
      bgColor = Colors.transparent;
      dayNumColor = InternaCrystal.textPrimary;
      borderColor = Colors.transparent;
    }

    final dividerColor = isSelected
        ? Colors.white24
        : InternaCrystal.borderSubtle;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDay = day;
          _focusedDay = day;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                '${day.day}',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: dayNumColor,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Container(
              height: 1,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              color: dividerColor,
            ),
            const SizedBox(height: 6),
            _buildShiftBadge(
              label: 'SA',
              count: hasSchedules ? morningCount : 0,
              color: InternaCrystal.accentPurple,
              bgColor: InternaCrystal.accentPurple.withOpacity(0.15),
              isSelected: isSelected,
              isEmpty: !hasSchedules,
            ),
            const SizedBox(height: 4),
            _buildShiftBadge(
              label: 'CH',
              count: hasSchedules ? afternoonCount : 0,
              color: InternaCrystal.accentOrange,
              bgColor: InternaCrystal.accentOrange.withOpacity(0.15),
              isSelected: isSelected,
              isEmpty: !hasSchedules,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShiftBadge({
    required String label,
    required int count,
    required Color color,
    required Color bgColor,
    required bool isSelected,
    bool isEmpty = false,
  }) {
    final isIntern = _userRole == UserRole.INTERN;
    final hasMark = count > 0;

    final badgeColor = isEmpty || !hasMark
        ? (isSelected ? Colors.white.withOpacity(0.1) : InternaCrystal.bgCard.withOpacity(0.3))
        : (isSelected ? Colors.white.withOpacity(0.22) : bgColor);

    final labelColor = isEmpty || !hasMark
        ? (isSelected ? Colors.white24 : InternaCrystal.textMuted)
        : (isSelected ? Colors.white : color);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Container(
        width: double.infinity,
        height: 32,
        decoration: BoxDecoration(
          color: badgeColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: isIntern || !hasMark
              ? MainAxisAlignment.center
              : MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Padding(
                  padding: EdgeInsets.only(left: (isIntern || !hasMark) ? 0 : 6),
                  child: Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: labelColor,
                    ),
                  ),
                ),
              ),
            ),
            if (!isIntern && hasMark)
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '$count',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: isSelected ? Colors.white : color,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthMarkerDots(
    List<ScheduleRequestModel> items,
    bool isManagerOrHR,
  ) {
    final leaveItems = items.where((s) => s.type == ScheduleType.LEAVE).toList();
    final hasLeave = leaveItems.isNotEmpty;
    final hasWork = items.any((s) => s.type == ScheduleType.WORK);

    final leaveCount = isManagerOrHR
        ? leaveItems.map((s) => s.employeeId).toSet().length
        : 0;

    return Positioned(
      bottom: 2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasLeave) ...[
            if (isManagerOrHR && leaveCount > 0) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                decoration: BoxDecoration(
                  color: InternaCrystal.accentPurple,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$leaveCount',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
              ),
            ] else
              _dot(InternaCrystal.accentPurple),
          ],
          if (hasWork) _dot(InternaCrystal.accentBlue),
        ],
      ),
    );
  }

  Widget _buildLegend(bool isManagerOrHR) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [],
      ),
    );
  }

  Widget _dot(Color color) {
    return Container(
      width: 6,
      height: 6,
      margin: const EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  List<ScheduleRequestModel> _getSchedulesForDay(
    List<ScheduleRequestModel> schedules,
    DateTime day,
  ) {
    return schedules.where((s) {
      final date = DateTime(day.year, day.month, day.day);
      final start = DateTime(s.startDate.year, s.startDate.month, s.startDate.day);
      final end = DateTime(s.endDate.year, s.endDate.month, s.endDate.day);

      bool isInRange =
          (date.isAtSameMomentAs(start) ||
          (date.isAfter(start) && date.isBefore(end)) ||
          date.isAtSameMomentAs(end));

      if (!isInRange) return false;

      if (s.isRecurring) {
        return _weekdayMatches(s.weekday, day.weekday);
      }

      return true;
    }).toList();
  }

  String _getWeekdayString(int day) {
    switch (day) {
      case DateTime.monday: return 'MONDAY';
      case DateTime.tuesday: return 'TUESDAY';
      case DateTime.wednesday: return 'WEDNESDAY';
      case DateTime.thursday: return 'THURSDAY';
      case DateTime.friday: return 'FRIDAY';
      case DateTime.saturday: return 'SATURDAY';
      case DateTime.sunday: return 'SUNDAY';
      default: return '';
    }
  }

  String _weekdayDisplayName(String dbValue) {
    switch (dbValue.toUpperCase()) {
      case 'MONDAY': case 'THỨ 2': return 'Thứ 2';
      case 'TUESDAY': case 'THỨ 3': return 'Thứ 3';
      case 'WEDNESDAY': case 'THỨ 4': return 'Thứ 4';
      case 'THURSDAY': case 'THỨ 5': return 'Thứ 5';
      case 'FRIDAY': case 'THỨ 6': return 'Thứ 6';
      case 'SATURDAY': case 'THỨ 7': return 'Thứ 7';
      case 'SUNDAY': case 'CHỦ NHẬT': return 'Chủ nhật';
      default: return dbValue;
    }
  }

  bool _weekdayMatches(String? storedWeekday, int dateWeekday) {
    if (storedWeekday == null) return false;
    final engName = _getWeekdayString(dateWeekday);
    final viMap = <String, String>{
      'MONDAY': 'THỨ 2',
      'TUESDAY': 'THỨ 3',
      'WEDNESDAY': 'THỨ 4',
      'THURSDAY': 'THỨ 5',
      'FRIDAY': 'THỨ 6',
      'SATURDAY': 'THỨ 7',
      'SUNDAY': 'CHỦ NHẬT',
    };
    final viName = viMap[engName] ?? '';
    final upper = storedWeekday.toUpperCase();
    return upper == engName || upper == viName;
  }

  Widget _buildEventList(
    List<ScheduleRequestModel> events,
    bool isManagerOrHR,
  ) {
    final filteredEvents = _selectedDay != null
        ? _getSchedulesForDay(events, _selectedDay!)
        : <ScheduleRequestModel>[];

    if (filteredEvents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 48, color: InternaCrystal.textMuted),
            const SizedBox(height: 8),
            Text(
              '${AppStrings.noSchedulesFor} ${DateFormat('EEEE, d/M', 'vi').format(_selectedDay ?? _focusedDay)}',
              style: GoogleFonts.inter(color: InternaCrystal.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: filteredEvents.length,
      itemBuilder: (context, index) {
        final req = filteredEvents[index];
        final isLeave = req.type == ScheduleType.LEAVE;
        final shiftColor = _getColorForShift(req.shift) ?? InternaCrystal.accentPurple;
        final statusColor = req.status == RequestStatus.APPROVED
            ? InternaCrystal.accentGreen
            : (req.status == RequestStatus.PENDING
                  ? InternaCrystal.accentOrange
                  : InternaCrystal.accentRed);

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: InternaCrystal.bgCard.withOpacity(0.6),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: shiftColor.withOpacity(0.2)),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: SizedBox(
              width: 48,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isLeave ? Icons.beach_access : Icons.work_outline,
                    color: shiftColor,
                    size: 20,
                  ),
                  const SizedBox(height: 2),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      req.shift,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: shiftColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            title: Text(
              isManagerOrHR
                  ? (req.userMetadata?['name'] ?? AppStrings.staff)
                  : (isLeave ? AppStrings.personalLeave : AppStrings.myShift),
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                color: InternaCrystal.textPrimary,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (req.description != null && req.description!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 4),
                    child: Text(
                      req.description!,
                      style: GoogleFonts.inter(
                        fontSize: isManagerOrHR ? 14 : 13,
                        fontWeight: isManagerOrHR
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: InternaCrystal.textSecondary,
                      ),
                    ),
                  ),
                if (!isManagerOrHR)
                  Row(
                    children: [
                      Icon(Icons.circle, size: 8, color: statusColor),
                      const SizedBox(width: 4),
                      Text(
                        req.status.displayName,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: statusColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (req.isRecurring && req.weekday != null) ...[
                        const SizedBox(width: 8),
                        Icon(
                          Icons.repeat,
                          size: 12,
                          color: InternaCrystal.textMuted,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          _weekdayDisplayName(req.weekday!),
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: InternaCrystal.textMuted,
                          ),
                        ),
                      ],
                    ],
                  ),
              ],
            ),
            trailing: isManagerOrHR
                ? IconButton(
                    icon: Icon(
                      Icons.info_outline,
                      color: InternaCrystal.textSecondary,
                    ),
                    onPressed: () {
                      _showRequestDetails(context, req);
                    },
                  )
                : null,
          ),
        );
      },
    );
  }

  Color? _getColorForShift(String shift) {
    if (shift == AppStrings.morning || shift.toUpperCase() == 'SÁNG') {
      return InternaCrystal.accentBlue;
    } else if (shift == AppStrings.afternoon || shift.toUpperCase() == 'CHIỀU') {
      return InternaCrystal.accentOrange;
    } else if (shift == AppStrings.allDay || shift.toUpperCase() == 'CẢ NGÀY') {
      return InternaCrystal.accentPurple;
    }
    return null;
  }

  void _showRequestDetails(BuildContext context, ScheduleRequestModel req) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(req.userMetadata?['name'] ?? AppStrings.details),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${AppStrings.type}: ${req.type.name}'),
            Text('${AppStrings.shift}: ${req.shift}'),
            Text('${AppStrings.requestStatus}: ${req.status.name}'),
            if (req.description != null)
              Text('${AppStrings.note}: ${req.description}'),
            Text(
              '${AppStrings.registeredAt}: ${DateFormat('yyyy-MM-dd HH:mm').format(req.createdAt)}',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.close),
          ),
        ],
      ),
    );
  }
}
