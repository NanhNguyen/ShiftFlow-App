import 'dart:ui';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../resource/app_strings.dart';
import '../../../data/constant/enums.dart';
import '../../../data/model/meal_model.dart';
import '../../../data/service/auth_service.dart';
import '../../di/di_config.dart';
import 'cubit/meal_cubit.dart';
import 'cubit/meal_state.dart';
import '../main/cubit/main_cubit.dart';
import '../../theme/app_theme.dart';

@RoutePage()
class MealPage extends StatefulWidget {
  const MealPage({super.key});

  @override
  State<MealPage> createState() => _MealPageState();
}

class _MealPageState extends State<MealPage>
    with SingleTickerProviderStateMixin {
  late final MealCubit _cubit;
  TabController? _tabController;
  DateTime _overviewDate = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _overviewDate = DateTime.now();
    _selectedDay = _overviewDate;
    _focusedDay = _overviewDate;

    _cubit = getIt<MealCubit>()..loadMeals();
    final role = getIt<AuthService>().currentUser?.role;
    if (role == UserRole.HR) {
      _tabController = TabController(length: 2, vsync: this, initialIndex: 1);
      _cubit.loadAllRegistrations();
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  bool get _isHR => getIt<AuthService>().currentUser?.role == UserRole.HR;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: InternaCrystal.bgDeep,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [InternaCrystal.accentPurple, InternaCrystal.accentBlue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
          ),
          foregroundColor: Colors.white,
          title: Text(
            'Lịch ăn cơm',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => context.read<MainCubit>().setIndex(0),
          ),
          centerTitle: true,
          bottom: _isHR
              ? TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'Của tôi'),
                    Tab(text: 'Thống kê'),
                  ],
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white.withOpacity(0.5),
                  indicatorColor: InternaCrystal.accentPurple,
                  indicatorWeight: 4,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicator: const UnderlineTabIndicator(
                    borderSide: BorderSide(width: 4.0, color: InternaCrystal.accentPurple),
                    insets: EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                )
              : null,
          elevation: 0,
        ),
        body: _isHR
            ? TabBarView(
                controller: _tabController,
                children: [_buildMyMealsView(), _buildOverviewView()],
              )
            : _buildMyMealsView(),
        floatingActionButton: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: InternaCrystal.accentPurple.withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: FloatingActionButton.extended(
            onPressed: () => _showMealFormSheet(context),
            backgroundColor: InternaCrystal.accentPurple,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add_rounded),
            label: Text(
              'Đăng ký cơm',
              style: GoogleFonts.inter(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  // --- HR Overview View ---
  Widget _buildOverviewView() {
    return BlocBuilder<MealCubit, MealState>(
      builder: (context, state) {
        final filteredMeals = _getMealsForDay(state.allRegistrations, _overviewDate);
        
        return LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 800;
            
            if (isWide) {
              return Column(
                children: [
                   _buildMealStatsHeader(filteredMeals),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 12,
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              children: [
                                _buildCustomCalendarHeader(),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: InternaCrystal.bgCard.withOpacity(0.6),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: InternaCrystal.borderSubtle),
                                      ),
                                      child: _buildCalendarRibbon(
                                        state.allRegistrations,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                _buildSummaryCard(filteredMeals),
                              ],
                            ),
                          ),
                        ),
                        const VerticalDivider(width: 1),
                        Expanded(
                          flex: 8,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: InternaCrystal.bgSidebar,
                                  border: Border(
                                    bottom: BorderSide(color: InternaCrystal.borderSubtle),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.people_outline,
                                      color: InternaCrystal.accentPurple,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Danh sách đăng ký',
                                      style: GoogleFonts.inter(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: InternaCrystal.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  color: InternaCrystal.bgDeep,
                                  child: _buildOverviewList(filteredMeals),
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

            return RefreshIndicator(
              onRefresh: () => _cubit.loadAllRegistrations(),
              child: Column(
                children: [
                  _buildCustomCalendarHeader(),
                  _buildCalendarRibbon(state.allRegistrations),
                  if (state.status == BaseStatus.error)
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: InternaCrystal.accentRed.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: InternaCrystal.accentRed.withOpacity(0.3)),
                      ),
                      width: double.infinity,
                      child: Text(
                        'Lỗi: ${state.errorMessage}',
                        style: const TextStyle(color: InternaCrystal.accentRed, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  Expanded(
                    child: state.status == BaseStatus.loading && state.allRegistrations.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : Column(
                            children: [
                              _buildSummaryCard(filteredMeals),
                              Expanded(child: _buildOverviewList(filteredMeals)),
                            ],
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMealStatsHeader(List<MealModel> filteredMeals) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
           _buildOverviewStatCard(
            'Tổng suất cơm',
            '${filteredMeals.length}',
            'Hôm nay',
            Icons.restaurant_rounded,
            InternaCrystal.accentPurple,
          ),
          const SizedBox(width: 20),
          _buildOverviewStatCard(
            'Cơm trưa',
            '${filteredMeals.where((m) => m.shift == MealShift.LUNCH).length}',
            'Hệ thống đang hỗ trợ',
            Icons.lunch_dining_rounded,
            InternaCrystal.accentBlue,
          ),
          const SizedBox(width: 20),
          _buildOverviewStatCard(
            'Lặp lại',
            '${filteredMeals.where((m) => m.isRecurring).length}',
            'Đăng ký hàng tuần',
            Icons.loop_rounded,
            InternaCrystal.accentGreen,
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewStatCard(String title, String value, String sub, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: InternaCrystal.bgCard,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: InternaCrystal.borderSubtle, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: InternaCrystal.textMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: GoogleFonts.outfit(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: InternaCrystal.textPrimary,
                    ),
                  ),
                  Text(
                    sub,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: InternaCrystal.textSecondary.withOpacity(0.6),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarRibbon(List<MealModel> allMeals) {
    return TableCalendar(
      headerVisible: false,
      firstDay: DateTime(2020),
      lastDay: DateTime(2030),
      focusedDay: _focusedDay,
      calendarFormat: CalendarFormat.week,
      availableCalendarFormats: const {CalendarFormat.week: 'Week'},
      locale: 'vi',
      rowHeight: 110,
      daysOfWeekHeight: 40,
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: GoogleFonts.inter(
          fontWeight: FontWeight.bold,
          fontSize: 13,
          color: InternaCrystal.textMuted,
        ),
        weekendStyle: GoogleFonts.inter(
          fontWeight: FontWeight.bold,
          fontSize: 13,
          color: InternaCrystal.accentRed.withOpacity(0.8),
        ),
      ),
      calendarStyle: CalendarStyle(
        defaultTextStyle: GoogleFonts.inter(color: InternaCrystal.textPrimary, fontSize: 13),
        weekendTextStyle: GoogleFonts.inter(color: InternaCrystal.textMuted, fontSize: 13),
        todayTextStyle: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold),
        todayDecoration: BoxDecoration(
          color: InternaCrystal.accentPurple.withOpacity(0.4),
          shape: BoxShape.circle,
        ),
        selectedTextStyle: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold),
        selectedDecoration: const BoxDecoration(
          color: InternaCrystal.accentPurple,
          shape: BoxShape.circle,
        ),
        outsideDaysVisible: false,
      ),
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
          _overviewDate = selectedDay;
        });
      },
      onPageChanged: (focusedDay) {
        setState(() => _focusedDay = focusedDay);
      },
      calendarBuilders: CalendarBuilders(
        dowBuilder: (context, day) {
          final text = DateFormat.E('vi').format(day);
          return Center(
            child: Text(
              text,
              style: GoogleFonts.inter(
                color: day.weekday == DateTime.sunday
                    ? InternaCrystal.accentRed.withOpacity(0.8)
                    : InternaCrystal.textMuted,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          );
        },
        defaultBuilder: (context, day, focusedDay) => _buildWeekDayCell(
          day,
          allMeals,
          isSelected: false,
          isToday: false,
        ),
        todayBuilder: (context, day, focusedDay) => _buildWeekDayCell(
          day,
          allMeals,
          isSelected: false,
          isToday: true,
        ),
        selectedBuilder: (context, day, focusedDay) => _buildWeekDayCell(
          day,
          allMeals,
          isSelected: true,
          isToday: false,
        ),
      ),
    );
  }

  Widget _buildCustomCalendarHeader() {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              DateFormat.yMMMM('vi').format(_focusedDay).toUpperCase(),
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: InternaCrystal.textPrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Row(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    _focusedDay = DateTime.now();
                    _selectedDay = DateTime.now();
                    _overviewDate = DateTime.now();
                  });
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [InternaCrystal.accentPurple, InternaCrystal.accentBlue],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: InternaCrystal.accentPurple.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    AppStrings.today,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _buildNavBtn(
                Icons.chevron_left,
                () => setState(() {
                  _focusedDay = _focusedDay.subtract(const Duration(days: 7));
                }),
              ),
              const SizedBox(width: 8),
              _buildNavBtn(
                Icons.chevron_right,
                () => setState(() {
                  _focusedDay = _focusedDay.add(const Duration(days: 7));
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: InternaCrystal.bgElevated,
          shape: BoxShape.circle,
          border: Border.all(color: InternaCrystal.borderSubtle),
        ),
        child: Icon(icon, size: 20, color: InternaCrystal.textPrimary),
      ),
    );
  }

  Widget _buildWeekDayCell(
    DateTime day,
    List<MealModel> allMeals, {
    required bool isSelected,
    required bool isToday,
  }) {
    final dayMeals = _getMealsForDay(allMeals, day);
    final count = dayMeals.length;
    final isWeekend = day.weekday == DateTime.saturday || day.weekday == DateTime.sunday;

    Color dayNumColor;
    Color bgColor;
    Color borderColor;

    if (isSelected) {
      bgColor = InternaCrystal.accentPurple;
      dayNumColor = Colors.white;
      borderColor = InternaCrystal.accentPurple;
    } else if (isToday) {
      bgColor = InternaCrystal.accentPurple.withOpacity(0.12);
      dayNumColor = InternaCrystal.accentPurple;
      borderColor = InternaCrystal.accentPurple.withOpacity(0.3);
    } else if (isWeekend) {
      bgColor = Colors.white.withOpacity(0.02);
      dayNumColor = InternaCrystal.textSecondary.withOpacity(0.4);
      borderColor = Colors.transparent;
    } else {
      bgColor = InternaCrystal.bgElevated;
      dayNumColor = InternaCrystal.textPrimary;
      borderColor = InternaCrystal.borderSubtle;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: isSelected ? [
          BoxShadow(
            color: InternaCrystal.accentPurple.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ] : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${day.day}',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: dayNumColor,
            ),
          ),
          const SizedBox(height: 6),
          _buildShiftBadge(
            label: 'Trưa',
            count: count,
            color: InternaCrystal.accentPurple,
            bgColor: isSelected ? Colors.white.withOpacity(0.2) : InternaCrystal.accentPurple.withOpacity(0.15),
            isSelected: isSelected,
          ),
        ],
      ),
    );
  }

  Widget _buildShiftBadge({
    required String label,
    required int count,
    required Color color,
    required Color bgColor,
    required bool isSelected,
  }) {
    final hasMark = count > 0;
    final bColor = !hasMark
        ? (isSelected ? Colors.white.withOpacity(0.15) : InternaCrystal.bgDeep)
        : (isSelected ? Colors.white.withOpacity(0.25) : bgColor);

    final lColor = !hasMark
        ? (isSelected ? Colors.white.withOpacity(0.4) : InternaCrystal.textMuted.withOpacity(0.5))
        : (isSelected ? Colors.white : color);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      height: 28,
      decoration: BoxDecoration(
        color: bColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(
        child: Text(
          hasMark ? '$count' : label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: lColor,
          ),
        ),
      ),
    );
  }

  List<MealModel> _getMealsForDay(List<MealModel> meals, DateTime day) {
    return meals.where((m) {
      final date = DateTime(day.year, day.month, day.day);
      final start = DateTime(
        m.startDate.year,
        m.startDate.month,
        m.startDate.day,
      );
      final end = m.endDate != null
          ? DateTime(m.endDate!.year, m.endDate!.month, m.endDate!.day)
          : start;

      bool isInRange =
          (date.isAtSameMomentAs(start) ||
          (date.isAfter(start) &&
              date.isBefore(end.add(const Duration(days: 1)))) ||
          date.isAtSameMomentAs(end));

      if (!isInRange) return false;

      if (m.isRecurring) {
        return m.weekdays.any((w) => w.weekdayNumber == day.weekday);
      }

      return true;
    }).toList();
  }

  Widget _buildSummaryCard(List<MealModel> items) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: InternaCrystal.bgCard.withOpacity(0.6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: InternaCrystal.borderSubtle, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: InternaCrystal.accentPurple.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.restaurant_rounded,
                            color: InternaCrystal.accentPurple,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'TỔNG SUẤT ĂN',
                            style: GoogleFonts.outfit(
                              color: InternaCrystal.accentPurple,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Hệ thống tổng hợp ngày ${DateFormat('dd/MM', 'vi').format(_overviewDate)}',
                        style: GoogleFonts.inter(
                          color: InternaCrystal.textSecondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                    gradient: InternaCrystal.brandGradient,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: InternaCrystal.accentPurple.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    '${items.length}',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewList(List<MealModel> items) {
    if (items.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.no_meals_rounded,
                size: 80,
                color: InternaCrystal.textMuted.withOpacity(0.2),
              ),
              const SizedBox(height: 20),
              Text(
                'Không có ai đăng ký cơm ngày này',
                style: GoogleFonts.inter(
                  color: InternaCrystal.textMuted,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final meal = items[index];
        final name = meal.userMetadata?['name'] ?? 'Ẩn danh';
        return Container(
          decoration: BoxDecoration(
            color: InternaCrystal.bgCard.withOpacity(0.4),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [InternaCrystal.accentPurple, InternaCrystal.accentBlue],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: InternaCrystal.accentPurple.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            title: Text(
              name,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: InternaCrystal.textPrimary,
              ),
            ),
            subtitle: Text(
              meal.isRecurring ? 'Đăng ký lặp lại hàng tuần' : 'Đăng ký một lần',
              style: GoogleFonts.inter(
                color: InternaCrystal.textSecondary,
                fontSize: 13,
              ),
            ),
            trailing: IconButton(
              icon: const Icon(
                Icons.delete_outline,
                color: InternaCrystal.accentRed,
                size: 24,
              ),
              onPressed: () => _confirmDelete(context, meal.id),
            ),
          ),
        );
      },
    );
  }

  // --- My Meals View ---
  Widget _buildMyMealsView() {
    return BlocConsumer<MealCubit, MealState>(
      listener: (context, state) {
        if (state.submitStatus == BaseStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Thành công!',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
              backgroundColor: InternaCrystal.accentGreen,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        } else if (state.submitStatus == BaseStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errorMessage ?? 'Thất bại',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
              backgroundColor: InternaCrystal.accentRed,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        }
      },
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () => _cubit.loadMeals(),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: _buildRegisterCard(context, state),
                    ),
                  ),
                  if (state.meals.isNotEmpty) ...[
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 16, 20, 12),
                        child: Text(
                          'Đăng ký của tôi',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: InternaCrystal.textPrimary,
                          ),
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => _buildMealItem(state.meals[index]),
                        childCount: state.meals.length,
                      ),
                    ),
                  ] else if (state.status != BaseStatus.loading)
                    const SliverFillRemaining(
                      child: Center(
                        child: Text(
                          'Bạn chưa đăng ký suất ăn nào.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRegisterCard(BuildContext context, MealState state) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: InternaCrystal.bgCard.withOpacity(0.6),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: InternaCrystal.borderSubtle),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: InternaCrystal.accentPurple.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.restaurant_menu_rounded, size: 48, color: InternaCrystal.accentPurple),
              ),
              const SizedBox(height: 20),
              Text(
                'Đăng ký cơm cho nhân viên',
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: InternaCrystal.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Đăng ký suất ăn để bộ phận HR chuẩn bị chu đáo nhất nhé.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: InternaCrystal.textSecondary,
                  height: 1.5,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [InternaCrystal.accentPurple, InternaCrystal.accentBlue],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: InternaCrystal.accentPurple.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () => _showMealFormSheet(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      'Bắt đầu đăng ký',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMealItem(MealModel meal) {
    final isRecurring = meal.isRecurring;
    final shift = meal.shift.displayName;
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: InternaCrystal.bgCard.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  InternaCrystal.accentPurple.withOpacity(0.15),
                  InternaCrystal.accentBlue.withOpacity(0.15),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              isRecurring ? Icons.repeat_rounded : Icons.calendar_today_rounded,
              color: InternaCrystal.accentPurple,
              size: 24,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shift,
                  style: GoogleFonts.inter(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: InternaCrystal.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                if (isRecurring && meal.weekdays.isNotEmpty)
                  Text(
                    meal.weekdays.map((w) => w.displayName).join(', '),
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: InternaCrystal.accentPurple,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                else
                  Text(
                    'Từ: ${dateFormat.format(meal.startDate)}',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: InternaCrystal.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _confirmDelete(context, meal.id),
            icon: const Icon(Icons.delete_outline, color: InternaCrystal.accentRed),
            splashRadius: 24,
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: InternaCrystal.bgCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: InternaCrystal.borderSubtle),
        ),
        title: Text(
          'Xóa đăng ký cơm',
          style: GoogleFonts.outfit(color: InternaCrystal.textPrimary, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Bạn có muốn hủy đăng ký suất cơm này không?',
          style: GoogleFonts.inter(color: InternaCrystal.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Hủy',
              style: GoogleFonts.inter(color: InternaCrystal.textMuted, fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8, bottom: 8),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                _cubit.deleteMeal(id).then((_) {
                  if (_isHR) _cubit.loadMealOverview(_overviewDate);
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: InternaCrystal.accentRed.withOpacity(0.1),
                foregroundColor: InternaCrystal.accentRed,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Xóa', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  void _showMealFormSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: _cubit,
        child: const _MealFormSheet(),
      ),
    );
  }
}

class _MealFormSheet extends StatefulWidget {
  const _MealFormSheet();

  @override
  State<_MealFormSheet> createState() => _MealFormSheetState();
}

class _MealFormSheetState extends State<_MealFormSheet> {
  final MealShift _selectedShift = MealShift.LUNCH;
  bool _isRecurring = true;
  final Set<MealWeekday> _selectedWeekdays = {
    MealWeekday.MONDAY,
    MealWeekday.TUESDAY,
    MealWeekday.WEDNESDAY,
    MealWeekday.THURSDAY,
    MealWeekday.FRIDAY,
  };
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 30));
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (_, controller) => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                decoration: BoxDecoration(
                  color: InternaCrystal.bgDeep.withOpacity(0.95),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                  border: Border.all(color: InternaCrystal.borderSubtle, width: 0.5),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    Container(
                      width: 48,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(2.5),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Đăng ký cơm trưa',
                      style: GoogleFonts.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: InternaCrystal.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 1,
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      color: Colors.white.withOpacity(0.05),
                    ),
                Expanded(
                  child: ListView(
                    controller: controller,
                    padding: const EdgeInsets.all(24),
                    children: [
                      _buildInfoBox(),
                      const SizedBox(height: 24),
                      _buildRecurringToggle(),
                      if (_isRecurring) ...[
                        const SizedBox(height: 20),
                        _buildWeekdaySelector(),
                      ],
                      const SizedBox(height: 24),
                      _buildDateSection(
                        _isRecurring ? 'Ngày bắt đầu' : 'Ngày đăng ký',
                        _startDate,
                        (date) => setState(() => _startDate = date),
                      ),
                      if (_isRecurring) ...[
                        const SizedBox(height: 16),
                        _buildDateSection(
                          'Ngày kết thúc',
                          _endDate,
                          (date) => setState(() => _endDate = date),
                          minDate: _startDate,
                        ),
                      ],
                      const SizedBox(height: 24),
                      _buildNoteField(),
                      const SizedBox(height: 32),
                      _buildSubmitButton(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  ),
);
}

  Widget _buildInfoBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: InternaCrystal.accentPurple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: InternaCrystal.accentPurple.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: InternaCrystal.accentPurple, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Hệ thống hiện tại áp dụng cho suất cơm buổi trưa.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: InternaCrystal.accentPurple,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecurringToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lặp lại hàng tuần',
              style: GoogleFonts.inter(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: InternaCrystal.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Tự động đăng ký cho tương lai',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: InternaCrystal.textSecondary,
              ),
            ),
          ],
        ),
        Switch(
          value: _isRecurring,
          onChanged: (v) => setState(() => _isRecurring = v),
          activeColor: InternaCrystal.accentPurple,
          activeTrackColor: InternaCrystal.accentPurple.withOpacity(0.3),
        ),
      ],
    );
  }

  Widget _buildWeekdaySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Chọn các thứ trong tuần',
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: InternaCrystal.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: MealWeekday.values.map((day) {
            final selected = _selectedWeekdays.contains(day);
            return FilterChip(
              label: Text(day.displayName),
              selected: selected,
              onSelected: (val) {
                setState(() {
                  if (val) _selectedWeekdays.add(day); else _selectedWeekdays.remove(day);
                });
              },
              labelStyle: GoogleFonts.inter(
                color: selected ? Colors.white : InternaCrystal.textSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              backgroundColor: InternaCrystal.bgCard.withOpacity(0.5),
              selectedColor: InternaCrystal.accentPurple,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDateSection(String label, DateTime date, ValueChanged<DateTime> onPicked, {DateTime? minDate}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: InternaCrystal.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () => InternaCrystal.showPremiumDatePicker(
            context,
            initialDate: date,
            minimumDate: minDate,
            onChanged: onPicked,
          ),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            decoration: BoxDecoration(
              color: InternaCrystal.bgCard.withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: InternaCrystal.borderSubtle, width: 0.5),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today_rounded, size: 18, color: InternaCrystal.accentPurple),
                const SizedBox(width: 12),
                Text(
                  DateFormat('dd MMMM, yyyy', 'vi').format(date),
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: InternaCrystal.textPrimary,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: InternaCrystal.textSecondary),
              ],
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildNoteField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ghi chú',
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: InternaCrystal.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _noteController,
          style: GoogleFonts.inter(color: InternaCrystal.textPrimary),
          decoration: InputDecoration(
            hintText: 'ví dụ: không ăn cay...',
            hintStyle: GoogleFonts.inter(color: InternaCrystal.textSecondary.withOpacity(0.5)),
            filled: true,
            fillColor: InternaCrystal.bgDeep.withOpacity(0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: InternaCrystal.accentPurple),
            ),
          ),
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return BlocBuilder<MealCubit, MealState>(
      builder: (context, state) => SizedBox(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [InternaCrystal.accentPurple, InternaCrystal.accentBlue],
            ),
            boxShadow: [
              BoxShadow(
                color: InternaCrystal.accentPurple.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: state.submitStatus == BaseStatus.loading ? null : () => _submit(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            child: state.submitStatus == BaseStatus.loading
                ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : Text(
                    'Xác nhận đăng ký',
                    style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
          ),
        ),
      ),
    );
  }

  void _submit(BuildContext context) {
    if (_isRecurring && _selectedWeekdays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Chọn ít nhất 1 thứ')));
      return;
    }
    final note = _noteController.text.trim();
    final finalEndDate = _isRecurring ? _endDate : _startDate;

    final data = {
      'shift': _selectedShift.name,
      'isRecurring': _isRecurring,
      'weekdays': _isRecurring ? _selectedWeekdays.map((w) => w.name).toList() : [],
      'startDate': _startDate.toIso8601String(),
      'endDate': finalEndDate.toIso8601String(),
      'note': note,
    };

    context.read<MealCubit>().submitMeal(data).then((success) {
      if (success && mounted) Navigator.pop(context);
    });
  }
}
