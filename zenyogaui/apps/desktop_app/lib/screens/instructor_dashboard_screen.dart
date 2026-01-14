import 'package:core/dto/requests/class_filter.dart';
import 'package:core/dto/responses/class_response_dto.dart';
import 'package:core/dto/responses/studio_response_dto.dart';
import 'package:core/dto/responses/user_response_dto.dart';
import 'package:core/dto/responses/yoga_type_response_dto.dart';
import 'package:core/services/providers/class_service.dart';
import 'package:core/services/providers/studio_service.dart';
import 'package:core/services/providers/yoga-type_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../core/theme.dart';
import '../widgets/add_class_dialog.dart';
import '../widgets/edit_class_dialog.dart';

/* ================= FORMATTERS ================= */

final DateFormat dateFormatter = DateFormat('dd.MM.yyyy HH:mm');

/* ================= TABLE DATA ================= */

class _InstructorClassesTableData {
  final List<ClassResponseDto> classes;
  final Map<int, String> studioNames;
  final Map<int, String> yogaTypeNames;

  _InstructorClassesTableData({
    required this.classes,
    required this.studioNames,
    required this.yogaTypeNames,
  });
}

/* ================= TABLE SOURCE ================= */

class InstructorClassesTableSource extends DataTableSource {
  final List<ClassResponseDto> classes;
  final Map<int, String> studioNames;
  final Map<int, String> yogaTypeNames;
  final void Function(ClassResponseDto) onEditRequest;
  final void Function(ClassResponseDto) onDeleteRequest;

  InstructorClassesTableSource({
    required this.classes,
    required this.studioNames,
    required this.yogaTypeNames,
    required this.onEditRequest,
    required this.onDeleteRequest,
  });

  @override
  DataRow getRow(int index) {
    if (index >= classes.length) return const DataRow(cells: []);

    final c = classes[index];

    return DataRow(cells: [
      DataCell(Text(c.name)),
      DataCell(Text(yogaTypeNames[c.yogaTypeId] ?? "-")),
      DataCell(Text(studioNames[c.studioId] ?? "-")),
      DataCell(Text(dateFormatter.format(c.startDate))),
      DataCell(Text(dateFormatter.format(c.endDate))),
      DataCell(Text(c.maxParticipants.toString())),
      DataCell(Text(c.location ?? "")),
      DataCell(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.edit),
              label: const Text("Edit"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                fixedSize: const Size(80, 30),
              ),
              onPressed: () => onEditRequest(c),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              icon: const Icon(Icons.delete),
              label: const Text("Delete"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.darkRed,
                fixedSize: const Size(80, 30),
              ),
              onPressed: () => onDeleteRequest(c),
            ),
          ],
        ),
      ),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => classes.length;

  @override
  int get selectedRowCount => 0;
}

/* ================= VIEW ================= */

class InstructorDashboard extends StatefulWidget {
  const InstructorDashboard({super.key});

  @override
  State<InstructorDashboard> createState() => _InstructorDashboardState();
}

class _InstructorDashboardState extends State<InstructorDashboard> {
  late Future<_InstructorClassesTableData> _tableFuture;

  final ClassFilter _filter = ClassFilter();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refresh();
    });
  }

  void _refresh() {
    final classProvider = context.read<ClassProvider>();
    final studioProvider = context.read<StudioProvider>();
    final yogaTypeProvider = context.read<YogaTypeProvider>();
    final user = ModalRoute.of(context)!.settings.arguments as UserResponseDto;

    setState(() {
      _tableFuture = _loadTableData(
        classProvider,
        studioProvider,
        yogaTypeProvider,
        user.id,
      );
    });
  }

  Future<_InstructorClassesTableData> _loadTableData(
      ClassProvider classProvider,
      StudioProvider studioProvider,
      YogaTypeProvider yogaTypeProvider,
      int instructorId,
      ) async {
    final results = await Future.wait([
      classProvider.repository.getByInstructorId(instructorId, search: _filter.search, yogaTypeId: _filter.yogaTypeId),
      studioProvider.repository.getAllStudios(),
      yogaTypeProvider.repository.getAllYogaTypes(),
    ]);

    final classes = results[0] as List<ClassResponseDto>;
    final studios = results[1] as List<StudioResponseDto>;
    final yogaTypes = results[2] as List<YogaTypeResponseDto>;

    return _InstructorClassesTableData(
      classes: classes,
      studioNames: {
        for (final s in studios)  s.id: s.name,
      },
      yogaTypeNames: {
        for (final y in yogaTypes) y.id: y.name,
      },
    );
  }



  Widget _buildFilters(_InstructorClassesTableData data) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          SizedBox(
            width: 260,
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: "Search classes",
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),

          ElevatedButton.icon(
            icon: const Icon(Icons.search),
            label: const Text("Search"),
            onPressed: () {
              _filter.search = _searchController.text.trim();
              _refresh();
            },
          ),

          DropdownButton<int?>(
            hint: const Text("Yoga Type"),
            value: _filter.yogaTypeId,
            items: [
              const DropdownMenuItem(value: null, child: Text("All yoga types")),
              ...data.yogaTypeNames.entries.map(
                    (e) => DropdownMenuItem(
                  value: e.key,
                  child: Text(e.value),
                ),
              ),
            ],
            onChanged: (value) {
              _filter.yogaTypeId = value;
              _refresh();
            },
          ),


          TextButton.icon(
            icon: const Icon(Icons.clear),
            label: const Text("Reset"),
            onPressed: () {
              _searchController.clear();
              _filter
                ..search = null
                ..yogaTypeId = null;
              _refresh();
            },
          ),
        ],
      ),
    );
  }

  /* ================= BUILD ================= */

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as UserResponseDto;

    return Scaffold(
      appBar: AppBar(title: const Text("Instructor Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome, ${user.firstName} ${user.lastName}!",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text("Add Class"),
              style: ElevatedButton.styleFrom(fixedSize: const Size(120, 32)),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AddClassDialog(
                    onAddDto: (newClass) async {
                      await context
                          .read<ClassProvider>()
                          .repository
                          .addClass(newClass, user.id);

                      _refresh();

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Class added successfully"),
                          backgroundColor: AppColors.deepGreen,
                        ),
                      );
                    },
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            Expanded(
              child: FutureBuilder<_InstructorClassesTableData>(
                future: _tableFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Error: ${snapshot.error}",
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  final data = snapshot.data!;

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFilters(data),
                        if(data.classes.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(24),
                            child: Center(
                              child: Text(
                                "No classes found for the selected filters",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ),
                          )
                        else
                          PaginatedDataTable(
                            header: const Text("My Classes"),
                            rowsPerPage: 10,
                            showCheckboxColumn: false,
                            columns: const [
                              DataColumn(label: Text("Name")),
                              DataColumn(label: Text("Yoga Type")),
                              DataColumn(label: Text("Studio")),
                              DataColumn(label: Text("Start")),
                              DataColumn(label: Text("End")),
                              DataColumn(label: Text("Max")),
                              DataColumn(label: Text("Location")),
                              DataColumn(label: Text("Actions")),
                            ],
                            source: InstructorClassesTableSource(
                              classes: data.classes,
                              studioNames: data.studioNames,
                              yogaTypeNames: data.yogaTypeNames,
                              onEditRequest: _confirmEdit,
                              onDeleteRequest: _confirmDelete,
                            ),
                          ),
                      ],
                    )
                  );

                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /* ================= ACTIONS ================= */

  void _confirmEdit(ClassResponseDto c) {
    showDialog(
      context: context,
      builder: (ctx) => EditClassDialog(
        classToEdit: c,
        onAdd: (updatedClass) async {
          await context
              .read<ClassProvider>()
              .repository
              .editClass(updatedClass, c.id);

          _refresh();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Class updated successfully"),
              backgroundColor: AppColors.deepGreen,
            ),
          );
        },
      ),
    );
  }

  void _confirmDelete(ClassResponseDto c) {
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
              await context
                  .read<ClassProvider>()
                  .repository
                  .deleteClass(c.id);
              _refresh();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Class deleted successfully"),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:zenyogaui/dto/responses/class_response_dto.dart';
// import 'package:zenyogaui/services/providers/studio_service.dart';
// import 'package:zenyogaui/services/providers/yoga-type_service.dart';
// import 'package:intl/intl.dart';
//
// import '../core/theme.dart';
// import '../models/class_model.dart';
// import '../models/user_model.dart';
// import '../services/providers/class_service.dart';
// import '../widgets/add_class_dialog.dart';
// import '../widgets/edit_class_dialog.dart';
//
//
// final DateFormat dateFormatter = DateFormat('dd.MM.yyyy HH:mm');
//
// class _InstructorDashboardData {
//   final List<ClassResponseDto> classes;
//   final Map<int, String> studioNames;
//   final Map<int, String> yogaTypeNames;
//
//   _InstructorDashboardData({
//    required this.classes,
//    required this.studioNames,
//    required this.yogaTypeNames,
// });
// }
//
// class InstructorDashboard extends StatelessWidget {
//   const InstructorDashboard({super.key});
//
//
//
//   Future<_InstructorDashboardData> _loadDashboardData(
//       ClassProvider classProvider,
//       StudioProvider studioProvider,
//       YogaTypeProvider yogaTypeProvider,
//       int instructorId
//       ) async {
//     final classes = await classProvider.repository.getByInstructorId(instructorId);
//
//     final studios = await studioProvider.repository.getAllStudios();
//     final yogaTypes = await yogaTypeProvider.repository.getAllYogaTypes();
//
//     final studioMap = {
//       for(final s in studios) if (s.id != null) s.id!: s.name,
//     };
//
//     final yogaTypeMap = {
//       for(final y in yogaTypes) y.id: y.name
//     };
//
//     return _InstructorDashboardData(classes: classes, studioNames: studioMap, yogaTypeNames: yogaTypeMap);
//   }
//
//   @override
//   Widget build (BuildContext context){
//     final user = ModalRoute.of(context)!.settings.arguments as UserModel;
//     final classProvider = Provider.of<ClassProvider>(context);
//
//
//     return Scaffold(
//       appBar: AppBar(title: Text("Instructor Dashboard")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Welcome, ${user.firstName} ${user.lastName}!",
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             Container(
//               margin: const EdgeInsets.only(top:20.0, bottom: 40.0),
//               child: ElevatedButton.icon(
//                 onPressed: () {
//                   showDialog(
//                     context: context,
//                     builder: (ctx) => AddClassDialog(
//                       onAddDto: (newClass) async {
//                         try{
//                           await classProvider.repository.addClass(newClass, user.id);
//
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text("Class added successfully"),
//                               backgroundColor: AppColors.deepGreen,
//                             ),
//                           );
//
//                           classProvider.notifyListeners();
//                         } catch (e) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text(e.toString())),
//                           );
//                         }
//
//                       },
//                     ),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(fixedSize: const Size(110, 30)),
//                 icon: Icon(Icons.add),
//                 label: Text("Add Class"),
//               ),
//             ),
//
//
//
//
//             Expanded(
//               child: FutureBuilder<_InstructorDashboardData>(
//                 future: _loadDashboardData(
//                     classProvider,
//                     context.read<StudioProvider>(),
//                     context.read<YogaTypeProvider>(),
//                     user.id
//                 ),
//
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Center(child: CircularProgressIndicator());
//                   }
//
//                   if (snapshot.hasError) {
//                     return Center(
//                       child: Text(
//                         "Error: ${snapshot.error}",
//                         style: TextStyle(color: Colors.red),
//                       ),
//                     );
//                   }
//
//                   if (!snapshot.hasData || snapshot.data!.classes.isEmpty) {
//                     return Center(child: Text("No classes found"));
//                   }
//
//                   final data = snapshot.data!;
//                   final classes = data.classes;
//
//                   return SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: DataTable(
//                       columnSpacing: 20,
//
//                       columns: const [
//                         DataColumn(label: Text("Name")),
//                         DataColumn(label: Text("Yoga Type")),
//                         DataColumn(label: Text("Studio")),
//                         DataColumn(label: Text("Start")),
//                         DataColumn(label: Text("End")),
//                         DataColumn(label: Text("Max")),
//                         DataColumn(label: Text("Location")),
//                         DataColumn(label: Text("Actions")),
//                       ],
//                       rows: classes.map((c) {
//                         return DataRow(cells: [
//                           DataCell(Text(c.name)),
//                           DataCell(Text(data.yogaTypeNames[c.yogaTypeId] ?? "-")),
//                           DataCell(Text(data.studioNames[c.studioId] ?? "-")),
//                           DataCell(Text(dateFormatter.format(c.startDate))),
//                           DataCell(Text(dateFormatter.format(c.endDate))),
//                           DataCell(Text(c.maxParticipants.toString())),
//                           DataCell(Text(c.location.toString())),
//                           DataCell(
//                             Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 ElevatedButton.icon(
//                                   onPressed: () {
//                                     showDialog(
//                                       context: context,
//                                       builder: (ctx) => EditClassDialog(
//                                         classToEdit: c,
//                                         onAdd: (newClass) async {
//                                           try {
//                                             await classProvider.repository.editClass(newClass, c.id);
//                                             ScaffoldMessenger.of(context).showSnackBar(
//                                               const SnackBar(
//                                                 content: Text("Class updated successfully"),
//                                                 backgroundColor: AppColors.deepGreen,
//                                               ),
//                                             );
//                                             classProvider.notifyListeners();
//                                           } catch (e) {
//                                             ScaffoldMessenger.of(context).showSnackBar(
//                                               SnackBar(content: Text(e.toString())),
//                                             );
//                                           }
//
//
//                                         },
//                                       ),
//                                     );
//                                   },
//                                   style: ElevatedButton.styleFrom(fixedSize: const Size(80, 30), backgroundColor: Colors.indigo),
//                                   icon: Icon(Icons.edit),
//                                   label: Text("Edit"),
//                                 ),
//                                 SizedBox(width: 8),
//                                 ElevatedButton.icon(
//                                   onPressed: () {
//                                     showDialog<void>(
//                                       context: context,
//                                       barrierDismissible: false,
//                                       builder: (BuildContext context) {
//                                         return AlertDialog(
//                                           title: const Text("Delete class"),
//                                           content:  SingleChildScrollView(
//                                             child: ListBody(
//                                               children: <Widget>[
//                                                 Text('Deleting the class will remove it from all users and scheduled classes.'),
//                                                 Text('Are you sure you want to delete the class ${c.name} ?', style: TextStyle(fontWeight: FontWeight.bold),),
//                                               ],
//                                             ),
//                                           ),
//                                           actions: <Widget>[
//                                             TextButton(
//                                               child: const Text('No', style: TextStyle(color: Colors.white)),
//                                               onPressed: () {
//                                                 Navigator.of(context).pop();
//                                               },
//                                               style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
//
//                                             ),
//                                             TextButton(
//                                               child: const Text('Yes', style: TextStyle(color: Colors.white)),
//                                               onPressed: () async {
//                                                 await classProvider.repository.deleteClass(c.id);
//                                                 Navigator.of(context).pop();
//                                                 ScaffoldMessenger.of(context).showSnackBar(
//                                                     SnackBar(content: Text("Class deleted!")));
//                                               },
//                                               style: ElevatedButton.styleFrom(backgroundColor: AppColors.darkRed),
//                                             ),
//                                           ],
//                                         );
//                                       },
//                                     );
//                                   }, style: ElevatedButton.styleFrom(backgroundColor: AppColors.darkRed, fixedSize: const Size(80, 30)),label: Text("Delete"), icon: Icon(Icons.delete)),
//                               ],
//                             ),
//                           ),
//
//
//                         ]);
//                       }).toList(),
//                     ),
//                   );
//                 },
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }