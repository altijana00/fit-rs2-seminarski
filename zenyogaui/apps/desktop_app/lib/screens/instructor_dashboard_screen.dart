import 'package:core/dto/requests/class_filter.dart';
import 'package:core/dto/responses/class_response_dto.dart';
import 'package:core/dto/responses/instructor_response_dto.dart';
import 'package:core/dto/responses/studio_response_dto.dart';
import 'package:core/dto/responses/user_response_dto.dart';
import 'package:core/dto/responses/yoga_type_response_dto.dart';
import 'package:core/services/providers/auth_service.dart';
import 'package:core/services/providers/class_service.dart';
import 'package:core/services/providers/studio_service.dart';
import 'package:core/services/providers/yoga-type_service.dart';
import 'package:core/services/providers/instructor_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../core/theme.dart';
import '../widgets/add_class_dialog.dart';
import '../widgets/edit_class_dialog.dart';
import '../widgets/edit_instructor_dialog.dart';

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
  final void Function(int) onAddRequest;
  final void Function(ClassResponseDto) onEditRequest;
  final void Function(ClassResponseDto) onDeleteRequest;

  InstructorClassesTableSource({
    required this.classes,
    required this.studioNames,
    required this.yogaTypeNames,
    required this.onEditRequest,
    required this.onDeleteRequest,
    required this.onAddRequest
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
  InstructorResponseDto? _instructor;
  bool _isLoadingInstructor = true;




  final ClassFilter _filter = ClassFilter();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refresh();
    });
  }

  Future<void> _loadInstructor(int userId) async {
    setState(() {
      _isLoadingInstructor = true;
    });

    final instructor = await context
        .read<InstructorProvider>()
        .repository
        .getById(userId);

    if (!mounted) return;

    setState(() {
      _instructor = instructor;
      _isLoadingInstructor = false;
    });
  }


  void _refresh() {
    final classProvider = context.read<ClassProvider>();
    final studioProvider = context.read<StudioProvider>();
    final yogaTypeProvider = context.read<YogaTypeProvider>();
    final user = ModalRoute.of(context)!.settings.arguments as UserResponseDto;

    _loadInstructor(user.id);

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
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [

            // -------- SEARCH INPUT --------
            SizedBox(
              width: 260,
              child: TextField(
                controller: _searchController,
                textInputAction: TextInputAction.search,
                onSubmitted: (value) {
                  _filter.search = value.trim();
                  _refresh();
                },
                decoration: const InputDecoration(
                  labelText: "Search classes",
                  prefixIcon: Icon(Icons.search),
                ),

              ),
            ),

            const SizedBox(width: 12),

            // -------- SEARCH BUTTON --------
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.lavender,
                minimumSize: const Size(90, 48),
              ),
              onPressed: () {
                _filter.search = _searchController.text.trim();
                _refresh();
              },
              child: const Text("Search"),
            ),

            const SizedBox(width: 12),

            // -------- YOGA TYPE DROPDOWN --------
            DropdownButton<int?>(
              value: _filter.yogaTypeId,
              hint: const Text("Yoga Type"),
              onChanged: (value) {
                _filter.yogaTypeId = value;
                _refresh();
              },
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text("All yoga types"),
                ),
                ...data.yogaTypeNames.entries.map(
                      (e) => DropdownMenuItem(
                    value: e.key,
                    child: Text(e.value),
                  ),
                ),
              ],
            ),

            const SizedBox(width: 12),

            // -------- RESET BUTTON --------
            TextButton(
              onPressed: () {
                _searchController.clear();
                _filter
                  ..search = null
                  ..yogaTypeId = null;
                _refresh();
              },
              child: const Text("Reset"),
            ),
          ],
        ),
      ),
    );
  }


  /* ================= BUILD ================= */

  @override
  Widget build(BuildContext context) {
    final instructor = _instructor;

    return Scaffold(
          body: _isLoadingInstructor ? const Center(child: CircularProgressIndicator()) :  instructor == null ?
                Center(
                  child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Image.asset(
                            'assets/logo.png',
                            height: 64,
                          ),
                        ),
                        Center(
                          child: Text(
                            "You are not assigned to any studio yet...",
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Center(
                            child:
                            GestureDetector(
                              onTap: () {

                                Navigator.of(context).pushNamed('/');
                              },
                              child: Text('Log out.', style: TextStyle(decoration: TextDecoration.underline)),
                            )
                        ),
                      ],
                    )
                ): Row(
                children: [

                  // ================= LEFT SIDEBAR =================
                  Container(
                    width: 72,
                    color: AppColors.lavender,
                    child: Column(
                      children: [
                        const Spacer(),
                        IconButton(
                          tooltip: "Profile",
                          icon: const Icon(Icons.person, color: Colors.white),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => EditInstructorDialog(
                                instructorToEdit: instructor,
                                onEdit: (updatedInstructor) async {
                                  await context
                                      .read<InstructorProvider>()
                                      .repository
                                      .editInstructor(updatedInstructor, instructor.id);

                                  _refresh();

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Profile details updated successfully"),
                                      backgroundColor: AppColors.deepGreen,
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),


                        const Divider(color: Colors.white),

                        IconButton(
                          tooltip: "Logout",
                          icon: const Icon(Icons.logout, color: Colors.white),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text("Logout"),
                                content: const Text("Are you sure you want to logout?"),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.pop(ctx);
                                      await context.read<AuthProvider>().logout();

                                      if (!context.mounted) return;

                                      Navigator.of(context)
                                          .pushNamedAndRemoveUntil('/', (_) => false);
                                    },
                                    child: const Text("Logout"),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 12),
                      ],
                    ),
                  ),

                  // ================= MAIN CONTENT =================
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Image.asset(
                              'assets/logo.png',
                              height: 64,
                            ),
                          ),
                          Text(
                            "Welcome, ${instructor.firstName} ${instructor.lastName}!",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 20),



                          // -------- TABLE AREA --------
                          Expanded(
                            child: FutureBuilder<_InstructorClassesTableData>(
                              future: _tableFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                if (snapshot.hasError) {
                                  return Center(
                                    child: Text(
                                      "Error: ${snapshot.error}",
                                      style:
                                      const TextStyle(color: Colors.red),
                                    ),
                                  );
                                }

                                final data = snapshot.data!;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    _buildFilters(data),

                                    const SizedBox(height: 12),

                                    // -------- ADD CLASS --------
                                    ElevatedButton.icon(
                                      icon: const Icon(Icons.add),
                                      label: const Text("Add Class"),
                                      style: ElevatedButton.styleFrom(
                                        fixedSize: const Size(120, 32),
                                      ),
                                      onPressed: () => _confirmAdd(instructor.id)

                                    ),

                                    const SizedBox(height: 24),

                                    Expanded(
                                      child: data.classes.isEmpty
                                          ? const Center(
                                        child: Text(
                                          "No classes found for the selected filters",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      )
                                          : SingleChildScrollView(
                                        child: PaginatedDataTable(
                                          header:
                                          const Text("My Classes"),
                                          rowsPerPage: 10,
                                          showCheckboxColumn: false,
                                          columns: const [
                                            DataColumn(
                                                label: Text("Name")),
                                            DataColumn(
                                                label:
                                                Text("Yoga Type")),
                                            DataColumn(
                                                label:
                                                Text("Studio")),
                                            DataColumn(
                                                label:
                                                Text("Start")),
                                            DataColumn(
                                                label: Text("End")),
                                            DataColumn(
                                                label: Text("Max")),
                                            DataColumn(
                                                label:
                                                Text("Location")),
                                            DataColumn(
                                                label:
                                                Text("Actions")),
                                          ],
                                          source:
                                          InstructorClassesTableSource(
                                            classes: data.classes,
                                            studioNames:
                                            data.studioNames,
                                            yogaTypeNames:
                                            data.yogaTypeNames,
                                            onEditRequest: _confirmEdit,
                                            onDeleteRequest: _confirmDelete,
                                            onAddRequest: _confirmAdd
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),


    );
  }


  /* ================= ACTIONS ================= */

  void _confirmAdd(int instructorId) {
      showDialog(
        context: context,
        builder: (ctx) => AddClassDialog(
          onAddDto: (newClass) async {
            await ctx.read<ClassProvider>().repository.addClass(newClass, instructorId);

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
  }


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
                  backgroundColor: AppColors.deepGreen,
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




