import 'package:core/dto/responses/notification_response_dto.dart';
import 'package:core/dto/responses/user_response_dto.dart';
import 'package:core/services/providers/notification_service.dart';
import 'package:core/services/providers/user_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:zenyogaui/widgets/edit_notification_dialog.dart';
import '../core/theme.dart';
import 'package:core/dto/requests/notification_filter.dart';

final DateFormat dateFormatter = DateFormat('dd.MM.yyyy HH:mm');


class _NotificationsTableData {
  final List<NotificationResponseDto> notifications;
  final Map<int, String> userNames;


  _NotificationsTableData({
    required this.notifications,
    required this.userNames,
  });
}



class NotificationsTableSource extends DataTableSource {
  final List<NotificationResponseDto> notifications;
  final void Function(NotificationResponseDto) onDeleteRequest;
  final void Function(NotificationResponseDto) onEditRequest;
  final Map<int, String> userNames;

  NotificationsTableSource({
    required this.notifications,
    required this.onDeleteRequest,
    required this.onEditRequest,
    required this.userNames,
  });

  @override
  DataRow getRow(int index) {
    if (index >= notifications.length) return const DataRow(cells: []);

    final n = notifications[index];

    return DataRow(cells: [
      DataCell(Text(n.title)),
      DataCell(Text(n.content!)),
      DataCell(Text(n.type)),
      DataCell(Text(userNames[n.userId] ?? "-")),
      DataCell(Text(n.isRead.toString())),
      DataCell(Text(dateFormatter.format(n.createdAt))),
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
              onPressed: () => onEditRequest(n),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              icon: const Icon(Icons.delete),
              label: const Text("Delete"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.darkRed,
                fixedSize: const Size(80, 30),
              ),
              onPressed: () => onDeleteRequest(n),
            ),
          ],
        ),
      ),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => notifications.length;

  @override
  int get selectedRowCount => 0;
}



class NotificationsTableView extends StatefulWidget {
  const NotificationsTableView({super.key});

  @override
  State<NotificationsTableView> createState() => _NotificationsTableViewState();
}

class _NotificationsTableViewState extends State<NotificationsTableView> {
  late Future<_NotificationsTableData> _tableFuture;
  UserResponseDto? _loggedUser;

  final NotificationFilter _filter = NotificationFilter();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _loggedUser ??= ModalRoute.of(context)!.settings.arguments as UserResponseDto;
  }

  void _refresh() {
    final notificationProvider = context.read<NotificationProvider>();
    final userProvider = context.read<UserProvider>();

    setState(() {
      _tableFuture = _loadTableData(
          notificationProvider,
          userProvider
      );
    });
  }

  Future<_NotificationsTableData> _loadTableData(
      NotificationProvider notificationProvider,
      UserProvider userProvider
      ) async {
    final results = await Future.wait([
      notificationProvider.repository.getNotificationsQuery(
        _filter.search,
      ),
      userProvider.repository.getAllUsers()
    ]);

    final notifications = results[0] as List<NotificationResponseDto>;
    final users = results[1] as List<UserResponseDto>;

    return _NotificationsTableData(
      notifications: notifications,
      userNames: {
        for(final u in users) u.id: "${u.firstName} ${u.lastName}"
      },
    );
  }



  Widget _buildFilters(_NotificationsTableData data) {
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
                labelText: "Search notifications",
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

    return FutureBuilder<_NotificationsTableData>(
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
              if (data.notifications.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(
                    child: Text(
                      "No notifications found for the selected filters",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                )
              else
                PaginatedDataTable(
                  header: const Text("Notifications"),
                  rowsPerPage: 10,
                  showCheckboxColumn: false,
                  columns: const [
                    DataColumn(label: Text("Title")),
                    DataColumn(label: Text("Content")),
                    DataColumn(label: Text("Type")),
                    DataColumn(label: Text("User")),
                    DataColumn(label: Text("Is Read")),
                    DataColumn(label: Text("Created")),
                    DataColumn(label: Text("Actions")),
                  ],
                  source: NotificationsTableSource(
                    notifications: data.notifications,
                    userNames: data.userNames,
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



  void _confirmDelete(NotificationResponseDto notification) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete notification"),
        content: Text(
          "Are you sure you want to delete ${notification.title} notification?",
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
                await context.read<NotificationProvider>()
                    .repository
                    .deleteNotification(notification.id, _loggedUser!.id);
                _refresh();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Notification deleted successfully"),
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

  void _confirmEdit(NotificationResponseDto notification) {
    showDialog(
      context: context,
      builder: (ctx) => EditNotificationDialog(
        notificationToEdit: notification,
        onEdit: (updatedNotification) async {
          await context
              .read<NotificationProvider>()
              .repository
              .editNotification(updatedNotification, notification.id);
          _refresh();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Notification edited successfully"),
              backgroundColor: AppColors.deepGreen,
            ),
          );
        },
      ),
    );
    }
}
