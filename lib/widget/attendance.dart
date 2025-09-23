import 'package:attendance/model/attendance_model.dart';
import 'package:attendance/view_model/home_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class Attendance extends ConsumerStatefulWidget {
  const Attendance({super.key});

  @override
  ConsumerState<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends ConsumerState<Attendance> {
  DateTime now = DateTime.now();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      HomeService.fetchAttendance(ref, DateTime.now());
      ref.read(HomeService.selectedDay.notifier).state = now;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final fDay = ref.watch(HomeService.focusedDay);
    final sDay = ref.watch(HomeService.selectedDay) ?? DateTime.now();
    final attData = ref.watch(HomeService.attendanceData);
    final list = ref.watch(HomeService.list);
    final isLoading = ref.watch(HomeService.isLoading);

    Color getColor(String status) {
      switch (status) {
        case "Present":
          return Colors.green;
        case "Absent":
          return Colors.red;
        case "Half Day":
          return Colors.orange;
        case "In Complete":
          return Colors.blue;
        default:
          return Colors.grey;
      }
    }

    Widget buildLegend() {
      final statuses = [
        "Present",
        "Absent",
        "Half Day",
        "In Complete",
        "No Data"
      ];
      return Card(
        margin: EdgeInsets.all(8.0),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Legend",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Wrap(
                children: statuses
                    .map((status) => Padding(
                          padding: EdgeInsets.only(right: 16, bottom: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: getColor(status),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              SizedBox(width: 4),
                              Text(status, style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Container(
        constraints: BoxConstraints(minHeight: size.height - 200),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "Monthly Attendance",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    if (isLoading)
                      SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(),
                      ),
                  ],
                ),
              ),
              Card(
                child: TableCalendar(
                  firstDay: DateTime.utc(now.year - 1, 1, 1),
                  lastDay: DateTime.utc(now.year + 1, 12, 31),
                  focusedDay: fDay,
                  availableCalendarFormats: {CalendarFormat.month: 'Month'},
                  weekendDays: [DateTime.sunday],
                  selectedDayPredicate: (day) => isSameDay(sDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    ref.read(HomeService.selectedDay.notifier).state =
                        selectedDay;
                    ref.read(HomeService.focusedDay.notifier).state =
                        focusedDay;
                  },
                  onPageChanged: (focusedDay) {
                    HomeService.fetchAttendance(ref, focusedDay);
                    ref.read(HomeService.focusedDay.notifier).state =
                        focusedDay;
                  },
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) {
                      final dayKey = DateTime(day.year, day.month, day.day);
                      final status = attData[dayKey];
                      if (status == null && day.isAfter(DateTime.now())) {
                        return null;
                      }
                      final color = getColor(status ?? 'Absent');
                      return Container(
                        decoration: BoxDecoration(
                          color: color.withAlpha(80),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: color, width: 1),
                        ),
                        margin: const EdgeInsets.all(2),
                        alignment: Alignment.center,
                        child: Text(
                          "${day.day}",
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                    selectedBuilder: (context, day, focusedDay) {
                      final dayKey = DateTime(day.year, day.month, day.day);
                      final status = attData[dayKey];
                      if (status == null && day.isAfter(DateTime.now())) {
                        return null;
                      }
                      final color = getColor(status ?? 'Absent');

                      return Container(
                        decoration: BoxDecoration(
                          color: color.withAlpha(80),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black, width: 2),
                        ),
                        margin: const EdgeInsets.all(2),
                        alignment: Alignment.center,
                        child: Text(
                          "${day.day}",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Builder(
                  builder: (context) {
                    final dayKey = DateTime(sDay.year, sDay.month, sDay.day);
                    final status = attData[dayKey] ??
                        (dayKey.isAfter(DateTime.now()) ? "No Data" : "Absent");
                    final color = getColor(status);

                    List<AttendanceData>? info;
                    if (list.isNotEmpty) {
                      try {
                        info = list['$dayKey'];
                      } catch (e) {
                        info = null;
                      }
                    }

                    DateTime? checkIn;
                    DateTime? checkOut;

                    if (info != null && info.isNotEmpty) {
                      info.sort((a, b) => a.date.compareTo(b.date));
                      final inPunch = info
                          .where((p) => p.inout.toLowerCase() == "in")
                          .toList();
                      if (inPunch.isNotEmpty) {
                        checkIn = inPunch.first.date;
                      }
                      final outPunch = info
                          .where((p) => p.inout.toLowerCase() == "out")
                          .toList();
                      if (outPunch.isNotEmpty) {
                        checkOut = outPunch.last.date;
                      }
                    }

                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 20),
                      decoration: BoxDecoration(
                        color: color.withAlpha(50),
                        border: Border.all(color: color),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Status on ${sDay.day}/${sDay.month}/${sDay.year} ",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                status,
                                style: TextStyle(
                                  color: color,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Text(
                            'Check In : ${checkIn == null ? '00:00 AM' : DateFormat('hh:mm:s a').format(checkIn)}',
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Check Out : ${checkOut == null ? '00:00 AM' : DateFormat('hh:mm:s a').format(checkOut)}',
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              buildLegend(),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
