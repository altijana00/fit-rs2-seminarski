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


final DateFormat dateFormatter = DateFormat('dd.MM HH:mm');

class _PaymentsTableData {
  final List<PaymentResponseDto> payments;
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
  final List<PaymentResponseDto> payments;
  final Map<int, String> userNames;
  final Map<int, String> studioNames;


  PaymentsTableSource({required this.context, required this.payments, required this.userNames, required this.studioNames});

  @override
  DataRow getRow(int index) {
    if (index >= payments.length) return const DataRow(cells: []);
    final p = payments[index];

    return DataRow(cells: [
      DataCell(Text(userNames[p.userId] ?? "-")),
      DataCell(Text(studioNames[p.studioId] ?? "-")),
      DataCell(Text(p.amount.toString())),
      DataCell(Text(p.status)),
      DataCell(Text(dateFormatter.format(p.paymentDate))),
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
  State<PaymentsTableView> createState() => PaymentsTableViewState();
}


class PaymentsTableViewState extends State<PaymentsTableView>{
  late Future<_PaymentsTableData> _tableFuture;

  final PaymentFilter _filter = PaymentFilter();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState(){
    super.initState();
    final paymentProvider = context.read<PaymentProvider>();
    final userProvider = context.read<UserProvider>();
    final studioProvider = context.read<StudioProvider>();


    _tableFuture = _loadTableData(

      paymentProvider,
      userProvider,
      studioProvider,

    );

  }

  Future<_PaymentsTableData> _loadTableData(
      PaymentProvider paymentProvider,
      UserProvider userProvider,
      StudioProvider studioProvider,

      ) async {
    final results = await Future.wait([
      paymentProvider.repository.getPaymentsQuery(
        _filter.search,
      ),
      userProvider.repository.getAllUsers(),
      studioProvider.repository.getAllStudios(),
    ]);

    final payments = results[0] as List<PaymentResponseDto>;
    final users = results[1] as List<UserResponseDto>;
    final studios = results[2] as List<StudioResponseDto>;

    return _PaymentsTableData(
        payments: payments,
        userNames: {
          for(final u in users) u.id: "${u.firstName} ${u.lastName}"
        },
        studioNames: {
          for(final s in studios) s.id: s.name,
        }
    );
  }

  void _refresh(){
    final paymentProvider = context.read<PaymentProvider>();
    final userProvider = context.read<UserProvider>();
    final studioProvider = context.read<StudioProvider>();
    setState(() {
      _tableFuture = _loadTableData(paymentProvider, userProvider, studioProvider);
    });
  }


  Widget _buildFilters(_PaymentsTableData data) {
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
          Padding(
              padding: const EdgeInsets.only(top:5.0),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.search),
                label: const Text("Search"),
                style: ElevatedButton.styleFrom(fixedSize: const Size(90, 30)),
                onPressed: () {
                  _filter.search = _searchController.text.trim();
                  _refresh();
                },
              )
          ),



          TextButton.icon(
            icon: const Icon(Icons.clear),
            label: const Text("Reset"),
            onPressed: () {
              _searchController.clear();
              _filter
                .search = null;
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
            child: Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.red)),
          );
        }

        final data = snapshot.data!;



        return SingleChildScrollView(

            child: Column (
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFilters(data),
                if(data.payments.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(
                      child: Text(
                        "No payments found for the selected filters",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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

                    ],

                    source: PaymentsTableSource(
                        context:context,
                        payments: data.payments,
                        userNames: data.userNames,
                        studioNames: data.studioNames,
                    ),

                  ),
              ],
            )

        );


      },
    );
  }
}