import 'package:core/dto/requests/user_filter_dto.dart';
import 'package:core/dto/responses/user_response_dto.dart';
import 'package:core/models/city_model.dart';
import 'package:core/models/role_model.dart';
import 'package:core/services/providers/city_service.dart';
import 'package:core/services/providers/role_service.dart';
import 'package:core/services/providers/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import 'edit_user_dialog.dart';

/* ================= TABLE DATA ================= */

class _UsersTableData {
  final List<UserResponseDto> users;
  final Map<int, String> roleNames;
  final Map<int, String> cityNames;

  _UsersTableData({
    required this.users,
    required this.roleNames,
    required this.cityNames,
  });
}

/* ================= TABLE SOURCE ================= */

class UsersTableSource extends DataTableSource {
  final List<UserResponseDto> users;
  final Map<int, String> roleNames;
  final Map<int, String> cityNames;
  final void Function(UserResponseDto) onDeleteRequest;
  final void Function(UserResponseDto) onEditRequest;

  UsersTableSource({
    required this.users,
    required this.roleNames,
    required this.cityNames,
    required this.onDeleteRequest,
    required this.onEditRequest,
  });

  @override
  DataRow getRow(int index) {
    if (index >= users.length) return const DataRow(cells: []);

    final u = users[index];

    return DataRow(cells: [
      DataCell(Text(u.id.toString())),
      DataCell(Text(u.firstName)),
      DataCell(Text(u.lastName)),
      DataCell(Text(u.email)),
      DataCell(Text(roleNames[u.roleId] ?? "-")),
      DataCell(Text(cityNames[u.cityId] ?? "-")),
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
              onPressed: () => onEditRequest(u),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              icon: const Icon(Icons.delete),
              label: const Text("Delete"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.darkRed,
                fixedSize: const Size(80, 30),
              ),
              onPressed: () => onDeleteRequest(u),
            ),
          ],
        ),
      ),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => users.length;

  @override
  int get selectedRowCount => 0;
}

/* ================= VIEW ================= */

class UsersTableView extends StatefulWidget {
  const UsersTableView({super.key});

  @override
  State<UsersTableView> createState() => _UsersTableViewState();
}

class _UsersTableViewState extends State<UsersTableView> {
  late Future<_UsersTableData> _tableFuture;

  final UserFilter _filter = UserFilter();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    final userProvider = context.read<UserProvider>();
    final cityProvider = context.read<CityProvider>();
    final roleProvider = context.read<RoleProvider>();

    setState(() {
      _tableFuture = _loadTableData(
        userProvider,
        cityProvider,
        roleProvider,
      );
    });
  }

  Future<_UsersTableData> _loadTableData(
      UserProvider userProvider,
      CityProvider cityProvider,
      RoleProvider roleProvider,
      ) async {
    final results = await Future.wait([
      userProvider.repository.getUsersQuery(
        _filter.search,
         _filter.roleId,
         _filter.cityId,
      ),
      cityProvider.repository.getAllCities(),
      roleProvider.repository.getAllRoles(),
    ]);

    final users = results[0] as List<UserResponseDto>;
    final cities = results[1] as List<CityModel>;
    final roles = results[2] as List<RoleModel>;

    return _UsersTableData(
      users: users,
      cityNames: {for (final c in cities) c.id: c.name},
      roleNames: {for (final r in roles) r.id: r.name},
    );
  }

  /* ================= FILTER UI ================= */

  Widget _buildFilters(_UsersTableData data) {
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
                labelText: "Search users",
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
            hint: const Text("Role"),
            value: _filter.roleId,
            items: [
              const DropdownMenuItem(value: null, child: Text("All roles")),
              ...data.roleNames.entries.map(
                    (e) => DropdownMenuItem(
                  value: e.key,
                  child: Text(e.value),
                ),
              ),
            ],
            onChanged: (value) {
              _filter.roleId = value;
              _refresh();
            },
          ),

          DropdownButton<int?>(
            hint: const Text("City"),
            value: _filter.cityId,
            items: [
              const DropdownMenuItem(value: null, child: Text("All cities")),
              ...data.cityNames.entries.map(
                    (e) => DropdownMenuItem(
                  value: e.key,
                  child: Text(e.value),
                ),
              ),
            ],
            onChanged: (value) {
              _filter.cityId = value;
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
                ..roleId = null
                ..cityId = null;
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
    return FutureBuilder<_UsersTableData>(
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
              if (data.users.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(
                    child: Text(
                      "No users found for the selected filters",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                )
              else
              PaginatedDataTable(
                header: const Text("Users"),
                rowsPerPage: 10,
                showCheckboxColumn: false,
                columns: const [
                  DataColumn(label: Text("ID")),
                  DataColumn(label: Text("First name")),
                  DataColumn(label: Text("Last name")),
                  DataColumn(label: Text("Email")),
                  DataColumn(label: Text("Role")),
                  DataColumn(label: Text("City")),
                  DataColumn(label: Text("Actions")),
                ],
                source: UsersTableSource(
                  users: data.users,
                  roleNames: data.roleNames,
                  cityNames: data.cityNames,
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

  /* ================= ACTIONS ================= */

  void _confirmDelete(UserResponseDto user) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete user"),
        content: Text(
          "Are you sure you want to delete ${user.firstName} ${user.lastName}?",
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
              await context.read<UserProvider>()
                  .repository
                  .deleteUser(user.id);
              _refresh();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("User deleted successfully"),
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

  void _confirmEdit(UserResponseDto user) {
    showDialog(
      context: context,
      builder: (ctx) => EditUserDialog(
        userToEdit: user,
        onAdd: (updatedUser) async {
          await context
              .read<UserProvider>()
              .repository
              .editUser(updatedUser, user.id);
          _refresh();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("User edited successfully"),
              backgroundColor: AppColors.deepGreen,
            ),
          );
        },
      ),
    );
  }
}
