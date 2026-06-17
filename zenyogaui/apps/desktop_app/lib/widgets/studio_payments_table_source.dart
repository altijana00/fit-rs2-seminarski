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

class _StudioPaymentsTableData {
  final List<PaymentResponseDto> payments;
  final Map<int, String> userNames;
  final Map<int, String> studioNames;

  _StudioPaymentsTableData({
    required this.payments,
    required this.userNames,
    required this.studioNames,
  });
}

class StudioPaymentsTableSource extends DataTableSource {
  final BuildContext context;
  final List<PaymentResponseDto> payments;
  final Map<int, String> userNames;
  final Map<int, String> studioNames;


  StudioPaymentsTableSource({required this.context, required this.payments, required this.userNames, required this.studioNames});

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



class StudioPaymentsTableView extends StatefulWidget {
  const StudioPaymentsTableView({super.key});

  @override
  State<StudioPaymentsTableView> createState() => StudioPaymentsTableViewState();
}


class StudioPaymentsTableViewState extends State<StudioPaymentsTableView>{
  late Future<_StudioPaymentsTableData> _tableFuture;


  @override
  void initState(){
    super.initState();
    final paymentProvider = context.read<PaymentProvider>();
    final userProvider = context.read<UserProvider>();
    final studioProvider = context.read<StudioProvider>();
    final user = ModalRoute.of(context)!.settings.arguments as UserResponseDto;


    _tableFuture = _loadTableData(

      paymentProvider,
      userProvider,
      studioProvider,
      user
    );

  }

  Future<_StudioPaymentsTableData> _loadTableData(
      PaymentProvider paymentProvider,
      UserProvider userProvider,
      StudioProvider studioProvider,
      UserResponseDto user

      ) async {
    final results = await Future.wait([
      paymentProvider.repository.getPaymentsOfOwnerStudios(user.id),
      userProvider.repository.getAllUsers(),
      studioProvider.repository.getAllStudios(),
    ]);

    final payments = results[0] as List<PaymentResponseDto>;
    final users = results[1] as List<UserResponseDto>;
    final studios = results[2] as List<StudioResponseDto>;

    return _StudioPaymentsTableData(
        payments: payments,
        userNames: {
          for(final u in users) u.id: "${u.firstName} ${u.lastName}"
        },
        studioNames: {
          for(final s in studios) s.id: s.name,
        }
    );
  }



  @override
  Widget build(BuildContext context) {

    return FutureBuilder<_StudioPaymentsTableData>(
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
                if(data.payments.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(
                      child: Text(
                        "No payments found",
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

                    source: StudioPaymentsTableSource(
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