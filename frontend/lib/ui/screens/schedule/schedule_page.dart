import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../di/di_config.dart';
import '../../../../data/model/schedule_request_model.dart';
import '../../../../data/constant/enums.dart';
import '../../../../data/service/auth_service.dart';
import 'cubit/schedule_cubit.dart';
import 'cubit/schedule_state.dart';
import '../../router/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  late final UserRole _userRole;

  @override
  void initState() {
    super.initState();
    _userRole = getIt<AuthService>().currentUser?.role ?? UserRole.INTERN;
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    final isManagerOrHR =
        _userRole == UserRole.MANAGER || _userRole == UserRole.HR;

    return BlocProvider(
      create: (context) => getIt<ScheduleCubit>()..loadSchedules(_userRole),
      child: Scaffold(
        appBar: AppBar(
          title: Text(isManagerOrHR ? 'Staff Schedule' : 'My Work Schedule'),
          elevation: 0,
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () =>
                    context.read<ScheduleCubit>().loadSchedules(_userRole),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.notifications_none),
              onPressed: () => context.pushRoute(const NotificationRoute()),
            ),
          ],
        ),
        body: BlocBuilder<ScheduleCubit, ScheduleState>(
          builder: (context, state) {
            if (state.status == BaseStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            return RefreshIndicator(
              onRefresh: () =>
                  context.read<ScheduleCubit>().loadSchedules(_userRole),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    _buildLegend(isManagerOrHR),
                    Card(
                      margin: const EdgeInsets.all(12),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TableCalendar(
                        firstDay: DateTime(2020),
                        lastDay: DateTime(2030),
                        focusedDay: _focusedDay,
                        calendarFormat: _calendarFormat,
                        rowHeight: _calendarFormat == CalendarFormat.week
                            ? 220
                            : 85,
                        availableCalendarFormats: const {
                          CalendarFormat.month: 'Month',
                          CalendarFormat.week: 'Week',
                        },
                        headerStyle: HeaderStyle(
                          formatButtonVisible: true,
                          formatButtonShowsNext: false,
                          titleCentered: false,
                          titleTextStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                          formatButtonDecoration: BoxDecoration(
                            color: Colors.blueAccent.withOpacity(0.1),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(12.0),
                            ),
                          ),
                          formatButtonTextStyle: const TextStyle(
                            color: Colors.blueAccent,
                          ),
                          leftChevronIcon: const Icon(
                            Icons.chevron_left,
                            color: Colors.blueAccent,
                          ),
                          rightChevronIcon: const Icon(
                            Icons.chevron_right,
                            color: Colors.blueAccent,
                          ),
                        ),
                        daysOfWeekStyle: const DaysOfWeekStyle(
                          weekdayStyle: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                          weekendStyle: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onFormatChanged: (format) {
                          if (_calendarFormat != format) {
                            setState(() {
                              _calendarFormat = format;
                            });
                          }
                        },
                        selectedDayPredicate: (day) =>
                            isSameDay(_selectedDay, day),
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                          });
                        },
                        eventLoader: (day) => _getSchedulesForDay(
                          state.approvedSchedules
                              .where((s) => s.status == RequestStatus.APPROVED)
                              .toList(),
                          day,
                        ),
                        calendarStyle: CalendarStyle(
                          todayDecoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.blue, width: 1),
                          ),
                          todayTextStyle: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                          selectedDecoration: const BoxDecoration(
                            color: Colors.blueAccent,
                            shape: BoxShape.circle,
                          ),
                          markerDecoration: const BoxDecoration(
                            color: Colors.transparent,
                          ),
                        ),
                        calendarBuilders: CalendarBuilders(
                          markerBuilder: (context, date, events) {
                            if (events.isEmpty) return null;
                            final schedules = events
                                .cast<ScheduleRequestModel>();
                            final isWeek =
                                _calendarFormat == CalendarFormat.week;

                            final items = schedules
                                .where(
                                  (s) => s.status == RequestStatus.APPROVED,
                                )
                                .toList();

                            if (items.isEmpty) return null;

                            final workingCount = items
                                .where((s) => s.type == ScheduleType.WORK)
                                .map((s) => s.employeeId)
                                .toSet()
                                .length;
                            final leaveCount = items
                                .where((s) => s.type == ScheduleType.LEAVE)
                                .map((s) => s.employeeId)
                                .toSet()
                                .length;

                            return Positioned(
                              top: isWeek ? 45 : null,
                              bottom: isWeek ? null : 2,
                              left: 4,
                              right: 4,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (isManagerOrHR)
                                    isWeek
                                        ? _buildWeekIndicators(
                                            workingCount,
                                            leaveCount,
                                            isManagerOrHR,
                                          )
                                        : _buildMonthIndicators(
                                            workingCount,
                                            leaveCount,
                                            isManagerOrHR,
                                          ),
                                  if (!isWeek && !isManagerOrHR) ...[
                                    const SizedBox(height: 2),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: _buildMarkers(items),
                                    ),
                                  ],
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Divider(),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: _buildEventList(
                        state
                            .approvedSchedules, // Show all in the list, but list will filter internally
                        isManagerOrHR,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLegend(bool isManagerOrHR) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _legendItem(Colors.blue, 'Working'),
          const SizedBox(width: 24),
          _legendItem(Colors.red, 'On Leave'),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  List<Widget> _buildMarkers(List<ScheduleRequestModel> schedules) {
    // Only show dots for APPROVED schedules on the calendar
    final approvedSchedules = schedules
        .where((s) => s.status == RequestStatus.APPROVED)
        .toList();

    bool hasWork = approvedSchedules.any((s) => s.type == ScheduleType.WORK);
    bool hasLeave = approvedSchedules.any((s) => s.type == ScheduleType.LEAVE);

    List<Widget> markers = [];
    if (hasWork) {
      markers.add(_dot(Colors.blue));
    }
    if (hasLeave) {
      markers.add(_dot(Colors.red));
    }
    return markers;
  }

  Widget _buildWeekIndicators(int working, int leave, bool isManagerOrHR) {
    if (!isManagerOrHR) return const SizedBox.shrink();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (working > 0)
          _indicatorPill(
            Icons.group_rounded,
            '$working Staff',
            Colors.blue,
            isWeek: true,
          ),
        const SizedBox(height: 6),
        if (leave > 0)
          _indicatorPill(
            Icons.person_off_rounded,
            '$leave Off',
            Colors.red,
            isWeek: true,
          ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildMonthIndicators(int working, int leave, bool isManagerOrHR) {
    if (!isManagerOrHR) return const SizedBox.shrink();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (working > 0) _miniBadge(working.toString(), Colors.blue),
        if (working > 0 && leave > 0) const SizedBox(width: 3),
        if (leave > 0) _miniBadge(leave.toString(), Colors.red),
      ],
    );
  }

  Widget _indicatorPill(
    IconData icon,
    String text,
    MaterialColor color, {
    bool isWeek = false,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isWeek ? 12 : 8,
        vertical: isWeek ? 8 : 5,
      ),
      decoration: BoxDecoration(
        color: color.shade50.withOpacity(0.95),
        borderRadius: BorderRadius.circular(isWeek ? 12 : 8),
        border: Border.all(color: color.shade200, width: 0.8),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: isWeek ? 16 : 12, color: color.shade700),
          SizedBox(width: isWeek ? 8 : 6),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                fontSize: isWeek ? 13 : 10.5,
                color: color.shade900,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.3,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniBadge(String count, MaterialColor color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.shade600,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 3,
            offset: const Offset(0, 1.5),
          ),
        ],
      ),
      child: Text(
        count,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
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
      final start = DateTime(
        s.startDate.year,
        s.startDate.month,
        s.startDate.day,
      );
      final end = DateTime(s.endDate.year, s.endDate.month, s.endDate.day);

      // Check date range
      bool isInRange =
          (date.isAtSameMomentAs(start) ||
          (date.isAfter(start) && date.isBefore(end)) ||
          date.isAtSameMomentAs(end));

      if (!isInRange) return false;

      // If recurring, check weekday match
      if (s.isRecurring) {
        return s.weekday == _getWeekdayString(day.weekday);
      }

      return true;
    }).toList();
  }

  String _getWeekdayString(int day) {
    switch (day) {
      case DateTime.monday:
        return 'MONDAY';
      case DateTime.tuesday:
        return 'TUESDAY';
      case DateTime.wednesday:
        return 'WEDNESDAY';
      case DateTime.thursday:
        return 'THURSDAY';
      case DateTime.friday:
        return 'FRIDAY';
      case DateTime.saturday:
        return 'SATURDAY';
      case DateTime.sunday:
        return 'SUNDAY';
      default:
        return '';
    }
  }

  Widget _buildEventList(
    List<ScheduleRequestModel> schedules,
    bool isManagerOrHR,
  ) {
    final events = _selectedDay != null
        ? _getSchedulesForDay(schedules, _selectedDay!)
        : <ScheduleRequestModel>[];

    if (events.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 8),
            Text(
              'No schedules for ${DateFormat('EEEE, MMM d').format(_selectedDay ?? _focusedDay)}',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final req = events[index];
        final isLeave = req.type == ScheduleType.LEAVE;
        final color = isLeave ? Colors.red : Colors.blue;
        final statusColor = req.status == RequestStatus.APPROVED
            ? Colors.green
            : (req.status == RequestStatus.PENDING
                  ? Colors.orange
                  : Colors.red);

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: color.withOpacity(0.2)),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isLeave ? Icons.beach_access : Icons.work_outline,
                  color: color,
                ),
                Text(
                  req.shift,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            title: Text(
              isManagerOrHR
                  ? (req.userMetadata?['name'] ?? 'Staff')
                  : (isLeave ? 'Personal Leave' : 'My Shift'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (req.description != null && req.description!.isNotEmpty)
                  Text(
                    req.description!,
                    style: const TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.circle, size: 8, color: statusColor),
                    const SizedBox(width: 4),
                    Text(
                      req.status.name,
                      style: TextStyle(
                        fontSize: 11,
                        color: statusColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (req.isRecurring) ...[
                      const SizedBox(width: 8),
                      Icon(Icons.repeat, size: 12, color: Colors.grey.shade600),
                      const SizedBox(width: 2),
                      Text(
                        'Recurring',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            trailing: isManagerOrHR
                ? IconButton(
                    icon: const Icon(Icons.info_outline),
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

  void _showRequestDetails(BuildContext context, ScheduleRequestModel req) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(req.userMetadata?['name'] ?? 'Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type: ${req.type.name}'),
            Text('Shift: ${req.shift}'),
            Text('Status: ${req.status.name}'),
            if (req.description != null) Text('Note: ${req.description}'),
            Text(
              'Registered At: ${DateFormat('yyyy-MM-dd HH:mm').format(req.createdAt)}',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
