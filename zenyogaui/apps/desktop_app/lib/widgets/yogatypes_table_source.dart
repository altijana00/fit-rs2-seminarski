import 'package:core/dto/responses/yoga_type_response_dto.dart';
import 'package:core/services/providers/yoga-type_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import 'package:core/dto/requests/yogatype_filter.dart';

import 'edit_yogatype_dialog.dart';



class _YogaTypesTableData {
  final List<YogaTypeResponseDto> yogaTypes;


  _YogaTypesTableData({
    required this.yogaTypes,
  });
}



class YogaTypesTableSource extends DataTableSource {
  final List<YogaTypeResponseDto> yogaTypes;
  final void Function(YogaTypeResponseDto) onDeleteRequest;
  final void Function(YogaTypeResponseDto) onEditRequest;

  YogaTypesTableSource({
    required this.yogaTypes,
    required this.onDeleteRequest,
    required this.onEditRequest,
  });

  @override
  DataRow getRow(int index) {
    if (index >= yogaTypes.length) return const DataRow(cells: []);

    final yt = yogaTypes[index];

    return DataRow(cells: [
      DataCell(Text(yt.name)),
      DataCell(Text(yt.description!)),
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
              onPressed: () => onEditRequest(yt),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              icon: const Icon(Icons.delete),
              label: const Text("Delete"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.darkRed,
                fixedSize: const Size(80, 30),
              ),
              onPressed: () => onDeleteRequest(yt),
            ),
          ],
        ),
      ),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => yogaTypes.length;

  @override
  int get selectedRowCount => 0;
}



class YogaTypesTableView extends StatefulWidget {
  const YogaTypesTableView({super.key});

  @override
  State<YogaTypesTableView> createState() => _YogaTypesTableViewState();
}

class _YogaTypesTableViewState extends State<YogaTypesTableView> {
  late Future<_YogaTypesTableData> _tableFuture;

  final YogaTypeFilter _filter = YogaTypeFilter();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    final yogaTypeProvider = context.read<YogaTypeProvider>();

    setState(() {
      _tableFuture = _loadTableData(
          yogaTypeProvider
      );
    });
  }

  Future<_YogaTypesTableData> _loadTableData(
      YogaTypeProvider yogaTypeProvider,
      ) async {
    final results = await Future.wait([
      yogaTypeProvider.repository.getYogaTypeQuery(
        _filter.search,
      ),
    ]);

    final yogaTypes = results[0];

    return _YogaTypesTableData(
      yogaTypes: yogaTypes,
    );
  }



  Widget _buildFilters(_YogaTypesTableData data) {
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
                labelText: "Search yoga types",
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
    return FutureBuilder<_YogaTypesTableData>(
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
              if (data.yogaTypes.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(
                    child: Text(
                      "No yoga types found for the selected filters",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                )
              else
                PaginatedDataTable(
                  header: const Text("Yoga Types"),
                  rowsPerPage: 10,
                  showCheckboxColumn: false,
                  columns: const [
                    DataColumn(label: Text("Name")),
                    DataColumn(label: Text("Description")),
                    DataColumn(label: Text("Actions")),
                  ],
                  source: YogaTypesTableSource(
                    yogaTypes: data.yogaTypes,
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



  void _confirmDelete(YogaTypeResponseDto yogaType) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete yoga type"),
        content: Text(
          "Are you sure you want to delete ${yogaType.name} yoga type?",
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
                await context.read<YogaTypeProvider>()
                    .repository
                    .deleteYogaType(yogaType.id);
                _refresh();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Yoga type deleted successfully"),
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

  void _confirmEdit(YogaTypeResponseDto yogaType) {
    showDialog(
      context: context,
      builder: (ctx) => EditYogaTypeDialog(
        yogaTypeToEdit: yogaType,
        onEdit: (updatedYogaType) async {
          await context
              .read<YogaTypeProvider>()
              .repository
              .editYogaType(updatedYogaType, yogaType.id);
          _refresh();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Yoga type edited successfully"),
              backgroundColor: AppColors.deepGreen,
            ),
          );
        },
      ),
    );
  }
}
