import 'package:core/dto/responses/role_response_dto.dart';
import 'package:core/services/providers/role_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zenyogaui/widgets/edit_role_dialog.dart';
import '../core/theme.dart';
import 'package:core/dto/requests/role_filter.dart';




class _RolesTableData {
  final List<RoleResponseDto> roles;


  _RolesTableData({
    required this.roles,
  });
}



class RolesTableSource extends DataTableSource {
  final List<RoleResponseDto> roles;
  final void Function(RoleResponseDto) onDeleteRequest;
  final void Function(RoleResponseDto) onEditRequest;

  RolesTableSource({
    required this.roles,
    required this.onDeleteRequest,
    required this.onEditRequest,
  });

  @override
  DataRow getRow(int index) {
    if (index >= roles.length) return const DataRow(cells: []);

    final r = roles[index];

    return DataRow(cells: [
      DataCell(Text(r.name)),
      DataCell(Text(r.description!)),
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
              onPressed: () => onEditRequest(r),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              icon: const Icon(Icons.delete),
              label: const Text("Delete"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.darkRed,
                fixedSize: const Size(80, 30),
              ),
              onPressed: () => onDeleteRequest(r),
            ),
          ],
        ),
      ),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => roles.length;

  @override
  int get selectedRowCount => 0;
}



class RolesTableView extends StatefulWidget {
  const RolesTableView({super.key});

  @override
  State<RolesTableView> createState() => _RolesTableViewState();
}

class _RolesTableViewState extends State<RolesTableView> {
  late Future<_RolesTableData> _tableFuture;

  final RoleFilter _filter = RoleFilter();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    final roleProvider = context.read<RoleProvider>();

    setState(() {
      _tableFuture = _loadTableData(
          roleProvider
      );
    });
  }

  Future<_RolesTableData> _loadTableData(
      RoleProvider roleProvider,
      ) async {
    final results = await Future.wait([
      roleProvider.repository.getRolesQuery(
        _filter.search,
      ),
    ]);

    final roles = results[0];

    return _RolesTableData(
      roles: roles,
    );
  }



  Widget _buildFilters(_RolesTableData data) {
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
                labelText: "Search roles",
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


          TextButton.icon(
            icon: const Icon(Icons.clear),
            label: const Text("Reset"),
            onPressed: () {
              _searchController.clear();
              _filter.search = null;
              _refresh();
            },
          ),
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_RolesTableData>(
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
              if (data.roles.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(
                    child: Text(
                      "No roles found for the selected filters",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                )
              else
                PaginatedDataTable(
                  header: const Text("Roles"),
                  rowsPerPage: 10,
                  showCheckboxColumn: false,
                  columns: const [
                    DataColumn(label: Text("Name")),
                    DataColumn(label: Text("Description")),
                    DataColumn(label: Text("Actions")),
                  ],
                  source: RolesTableSource(
                    roles: data.roles,
                    onDeleteRequest: _confirmDelete,
                    onEditRequest: _confirmEdit,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }



  void _confirmDelete(RoleResponseDto role) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete role"),
        content: Text(
          "Are you sure you want to delete ${role.name} role?",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () async {

              if (!context.mounted) return;

              Navigator.pop(ctx);
              try {
                await context.read<RoleProvider>()
                    .repository
                    .deleteRole(role.id);
                _refresh();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Role deleted successfully"),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(e.toString()),
                    backgroundColor: AppColors.darkRed,
                  ),
                );
              }

            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

  void _confirmEdit(RoleResponseDto role) {
    showDialog(
      context: context,
      builder: (ctx) => EditRoleDialog(
        roleToEdit: role,
        onEdit: (updatedRole) async {
          await context
              .read<RoleProvider>()
              .repository
              .editRole(updatedRole, role.id);
          _refresh();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Role edited successfully"),
              backgroundColor: AppColors.deepGreen,
            ),
          );
        },
      ),
    );
  }
}
