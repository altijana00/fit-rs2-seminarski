import 'package:core/dto/responses/city_response_dto.dart';
import 'package:core/services/providers/city_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import 'edit_city_dialog.dart';
import 'package:core/dto/requests/city_filter.dart';



class _CitiesTableData {
  final List<CityResponseDto> cities;


  _CitiesTableData({
    required this.cities,
  });
}



class CitiesTableSource extends DataTableSource {
  final List<CityResponseDto> cities;
  final void Function(CityResponseDto) onDeleteRequest;
  final void Function(CityResponseDto) onEditRequest;

  CitiesTableSource({
    required this.cities,
    required this.onDeleteRequest,
    required this.onEditRequest,
  });

  @override
  DataRow getRow(int index) {
    if (index >= cities.length) return const DataRow(cells: []);

    final c = cities[index];

    return DataRow(cells: [
      DataCell(Text(c.name)),
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
  int get rowCount => cities.length;

  @override
  int get selectedRowCount => 0;
}



class CitiesTableView extends StatefulWidget {
  const CitiesTableView({super.key});

  @override
  State<CitiesTableView> createState() => _CitiesTableViewState();
}

class _CitiesTableViewState extends State<CitiesTableView> {
  late Future<_CitiesTableData> _tableFuture;

  final CityFilter _filter = CityFilter();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    final cityProvider = context.read<CityProvider>();

    setState(() {
      _tableFuture = _loadTableData(
        cityProvider
      );
    });
  }

  Future<_CitiesTableData> _loadTableData(
      CityProvider cityProvider,
      ) async {
    final results = await Future.wait([
      cityProvider.repository.getCitiesQuery(
        _filter.search,
      ),
    ]);

    final cities = results[0];

    return _CitiesTableData(
      cities: cities,
    );
  }



  Widget _buildFilters(_CitiesTableData data) {
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
                labelText: "Search cities",
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
    return FutureBuilder<_CitiesTableData>(
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
              if (data.cities.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(
                    child: Text(
                      "No cities found for the selected filters",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                )
              else
                PaginatedDataTable(
                  header: const Text("Cities"),
                  rowsPerPage: 10,
                  showCheckboxColumn: false,
                  columns: const [
                    DataColumn(label: Text("Name")),
                    DataColumn(label: Text("Actions")),
                  ],
                  source: CitiesTableSource(
                    cities: data.cities,
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



  void _confirmDelete(CityResponseDto city) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete city"),
        content: Text(
          "Are you sure you want to delete ${city.name} city?",
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
                await ctx.read<CityProvider>()
                    .repository
                    .deleteCity(city.id);
                _refresh();
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(
                    content: Text("City deleted successfully"),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(ctx).showSnackBar(
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

  void _confirmEdit(CityResponseDto city) {
    showDialog(
      context: context,
      builder: (ctx) => EditCityDialog(
        cityToEdit: city,
        onEdit: (updatedCity) async {
          await ctx
              .read<CityProvider>()
              .repository
              .editCity(updatedCity, city.id);
          _refresh();
          ScaffoldMessenger.of(ctx).showSnackBar(
            const SnackBar(
              content: Text("City edited successfully"),
              backgroundColor: AppColors.deepGreen,
            ),
          );
        },
      ),
    );
  }
}
