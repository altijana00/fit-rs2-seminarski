import 'package:core/core/constants.dart';
import 'package:core/core/payment_status_enum.dart';
import 'package:core/dto/requests/payment_filter.dart';
import 'package:core/dto/responses/payment_response_dto.dart';
import 'package:core/dto/responses/studio_response_dto.dart';
import 'package:core/dto/responses/user_response_dto.dart';
import 'package:core/services/providers/payment_service.dart';
import 'package:core/services/providers/studio_service.dart';
import 'package:core/services/providers/user_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

final DateFormat dateFormatter = DateFormat(Constants.dateTimeFormat);

class _PaymentsTableData {
  final List payments;
  final Map<int, String> userNames;
  final Map<int, String> studioNames;

  _PaymentsTableData({
    required this.payments,
    required this.userNames,
    required this.studioNames,
  });
}

class PaymentsTableSource extends DataTableSource {
  final BuildContext context;
  final List payments;
  final Map<int, String> userNames;
  final Map<int, String> studioNames;
  final VoidCallback onRefresh;

  PaymentsTableSource({
    required this.context,
    required this.payments,
    required this.userNames,
    required this.studioNames,
    required this.onRefresh,
  });

  @override
  DataRow getRow(int index) {
    if (index >= payments.length) return const DataRow(cells: []);
    final p = payments[index];

    return DataRow(cells: [
      DataCell(Text(userNames[p.userId] ?? "-")),
      DataCell(Text(studioNames[p.studioId] ?? "-")),
      DataCell(Text(p.amount.toString() + Constants.currencyUSD)),
      DataCell(Text(p.status)),
      DataCell(Text(dateFormatter.format(p.paymentDate))),
      DataCell(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.payments),
              label: const Text("Refund payment"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                fixedSize: const Size(120, 30),
              ),
              onPressed: p.paymentStatus == PaymentStatus.succeeded
                  ? () async {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text("Refund payment"),
                    content: Text(
                      "Are you sure you want to refund payment by ${userNames[p.userId]}?",
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
                          try {
                            final paymentProvider =
                            context.read<PaymentProvider>();

                            await paymentProvider.repository.refundPayment(
                              p.userId,
                              p.studioId,
                            );
                            onRefresh();
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Payment refunded successfully'),
                                ),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Refund failed: $e'),
                                ),
                              );
                            }
                          }
                        },
                        child: const Text("Yes"),
                      ),
                    ],
                  ),
                );
              }
                  : null,
            ),
          ],
        ),
      ),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => payments.length;

  @override
  int get selectedRowCount => 0;
}

class PaymentsTableView extends StatefulWidget {
  const PaymentsTableView({super.key});

  @override
  State createState() => PaymentsTableViewState();
}

class PaymentsTableViewState extends State<PaymentsTableView> {
  final PaymentFilter _filter = PaymentFilter();
  final TextEditingController _searchController = TextEditingController();
  late Future<_PaymentsTableData> _tableFuture;

  @override
  void initState() {
    super.initState();
    _tableFuture = _loadTableData();
  }

  Future<_PaymentsTableData> _loadTableData() async {
    final paymentProvider = context.read<PaymentProvider>();
    final userProvider = context.read<UserProvider>();
    final studioProvider = context.read<StudioProvider>();

    final results = await Future.wait([
      paymentProvider.repository.getPaymentsQuery(_filter.search),
      userProvider.repository.getAllUsers(),
      studioProvider.repository.getAllStudios(),
    ]);

    final payments = results[0] as List<PaymentResponseDto>;
    final users = results[1] as List<UserResponseDto>;
    final studios = results[2] as List<StudioResponseDto>;

    return _PaymentsTableData(
      payments: payments,
      userNames: {
        for (final u in users) u.id: "${u.firstName} ${u.lastName}"
      },
      studioNames: {
        for (final s in studios) s.id: s.name,
      },
    );
  }

  void _refresh() async {
    final paymentProvider = context.read<PaymentProvider>();
    final userProvider = context.read<UserProvider>();
    final studioProvider = context.read<StudioProvider>();


    final results = await Future.wait([
      paymentProvider.repository.getPaymentsQuery(_filter.search),
      userProvider.repository.getAllUsers(),
      studioProvider.repository.getAllStudios(),
    ]);

    final payments = results[0] as List<PaymentResponseDto>;
    final users = results[1] as List<UserResponseDto>;
    final studios = results[2] as List<StudioResponseDto>;

    final newData = _PaymentsTableData(
      payments: payments,
      userNames: {
        for (final u in users) u.id: "${u.firstName} ${u.lastName}"
      },
      studioNames: {
        for (final s in studios) s.id: s.name,
      },
    );

    setState(() {
      _tableFuture = Future.value(newData);
    });
  }

  Widget _buildFilters() {
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
                labelText: "Search payments",
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
    return FutureBuilder<_PaymentsTableData>(
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
              _buildFilters(),
              if (data.payments.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(
                    child: Text(
                      "No payments found for the selected filters",
                    ),
                  ),
                )
              else
                PaginatedDataTable(
                  header: const Text("Payments"),
                  rowsPerPage: 10,
                  columnSpacing: 20,
                  showCheckboxColumn: false,
                  columns: const [
                    DataColumn(label: Text("User")),
                    DataColumn(label: Text("Studio")),
                    DataColumn(label: Text("Amount")),
                    DataColumn(label: Text("Status")),
                    DataColumn(label: Text("Payment Date")),
                    DataColumn(label: Text("Actions")),
                  ],
                  source: PaymentsTableSource(
                    context: context,
                    payments: data.payments,
                    userNames: data.userNames,
                    studioNames: data.studioNames,
                    onRefresh: _refresh,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}