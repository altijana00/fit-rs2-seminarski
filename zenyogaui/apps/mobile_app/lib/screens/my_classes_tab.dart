import 'package:core/dto/responses/class_response_dto.dart';
import 'package:core/services/providers/auth_service.dart';
import 'package:core/services/providers/instructor_service.dart';
import 'package:core/services/providers/user_class_service.dart';
import 'package:core/services/providers/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';


class MyClassesTab extends StatefulWidget {
  const MyClassesTab({super.key});

  @override
  State<MyClassesTab> createState() => MyClassesTabState();
}

class MyClassesTabState extends State<MyClassesTab> {
  Map<DateTime, List<ClassResponseDto>> events = {};
  DateTime selectedDay = DateTime.now();
  List<ClassResponseDto> selectedClasses = [];
  Map<int, String> instructorMap = {};

  @override
  void initState() {
    super.initState();
    loadJoinedClasses();
  }

  void loadJoinedClasses() async {
    final userProvider = context.read<UserProvider>();
    final user = context.read<AuthProvider>().user;
    final userClassProvider = context.read<UserClassProvider>();
    final instructorProvider = context.read<InstructorProvider>();

    final userId = user!.id;
    if (userId == null) return;

    final classes = await userClassProvider.repository.getByUserId(userId);
    final instructors = await instructorProvider.repository.getAllInstructors();
    final instructorNames = {for (final i in instructors) i.id:'${i.firstName} ${i.lastName}'};

    final grouped = groupClassesByDate(classes);

    setState(() {
      events = grouped;
      selectedClasses = events[selectedDay] ?? [];
      instructorMap = instructorNames;
    });
  }

  Map<DateTime, List<ClassResponseDto>> groupClassesByDate(List<ClassResponseDto> classes) {
    Map<DateTime, List<ClassResponseDto>> grouped = {};

    for (var c in classes) {
      final date = c.startDate;
      final day = DateTime(date.year, date.month, date.day);

      grouped[day] ??= [];
      grouped[day]!.add(c);
    }

    return grouped;
  }

  // Optional: Color by yoga type
  Color getYogaTypeColor(int typeId) {
    switch(typeId) {
      case 1:
        return Colors.deepPurple.shade300;
      case 2:
        return Colors.orange.shade300;
      case 3:
        return Colors.green.shade300;
      default:
        return Colors.grey.shade300;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Classes")),
      body: Column(
        children: [
          TableCalendar<ClassResponseDto>(
            firstDay: DateTime.utc(2023, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: selectedDay,
            eventLoader: (day) {
              final key = DateTime(day.year, day.month, day.day);
              return events[key] ?? [];
            },
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(color: Colors.deepPurple, shape: BoxShape.circle),
              selectedDecoration: BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
            ),
            selectedDayPredicate: (day) => isSameDay(day, selectedDay),
            onDaySelected: (selected, focused) {
              final key = DateTime(selected.year, selected.month, selected.day);
              setState(() {
                selectedDay = key;
                selectedClasses = events[key] ?? [];
              });
            },
          ),

          const SizedBox(height: 12),

          Expanded(
            child: selectedClasses.isEmpty
                ? const Center(child: Text("No classes on this day"))
                : ListView.builder(
              itemCount: selectedClasses.length,
              itemBuilder: (context, index) {
                final c = selectedClasses[index];
                final instructorName =
                    instructorMap[c.instructorId] ?? 'Unknown Instructor';
                final color = getYogaTypeColor(c.yogaTypeId);

                return Card(
                  color: color.withOpacity(0.3),
                  margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  child: ListTile(
                    title: Text(c.name),
                    subtitle: Text(
                        "${c.startDate.hour.toString().padLeft(2,'0')}:${c.startDate.minute.toString()} - Instructor: $instructorName"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text("Delete class"),
                            content: Text(
                              "Are you sure you want to delete ${c.name}?",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text("No"),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.pop(ctx);
                                  final user = context.read<AuthProvider>().user;
                                  await context.read<UserClassProvider>().repository.deleteClass(c.id, user!.id);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Class deleted successfully"),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  loadJoinedClasses();
                                },
                                child: const Text("Yes"),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
