import 'package:core/dto/requests/studio_filter.dart';
import 'package:core/dto/responses/studio_response_dto.dart';
import 'package:core/dto/responses/user_response_dto.dart';
import 'package:core/models/city_model.dart';
import 'package:core/services/providers/city_service.dart';
import 'package:core/services/providers/studio_service.dart';
import 'package:core/services/providers/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zenyogaui/widgets/studio_statistics_modal.dart';
import '../core/theme.dart';
import 'edit_studio_dialog.dart';

class _StudiosTableData {
  final List<StudioResponseDto> studios;
  final Map<int, String> ownerNames;
  final Map<int, String> cityNames;

  _StudiosTableData({
    required this.studios,
    required this.ownerNames,
    required this.cityNames,
  });
}

class StudiosTableSource extends DataTableSource {
  final BuildContext context;
  final List<StudioResponseDto> studios;
  final Map<int, String> ownerNames;
  final Map<int, String> cityNames;
  final void Function(StudioResponseDto studio) onDeleteRequest;
  final void Function(StudioResponseDto studio) onEditRequest;

  StudiosTableSource({required this.context, required this.studios, required this.ownerNames, required this.cityNames, required this.onDeleteRequest, required this.onEditRequest});

  @override
  DataRow getRow(int index) {
    if (index >= studios.length) return const DataRow(cells: []);
    final s = studios[index];

    return DataRow(cells: [
      DataCell(Text(s.id.toString())),
      DataCell(Text(ownerNames[s.ownerId] ?? "-")),
      DataCell(Text(s.name)),
      DataCell(Text(s.address!)),
      DataCell(Text(s.contactEmail!)),
      DataCell(Text(s.contactPhone!)),
      DataCell(Text(cityNames[s.cityId] ?? "-")),
      DataCell(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.bar_chart),
              label: const Text("Statistics"),
              style: ElevatedButton.styleFrom(fixedSize: const Size(80, 30)),
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (ctx) => StudioStatisticsDialog(studioId: s.id),
                );
              },
            ),
            ElevatedButton.icon(
              onPressed: () => onEditRequest(s),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, fixedSize: const Size(80, 30)) , label: Text("Edit"), icon: Icon(Icons.edit)

            ),
            SizedBox(width: 8),
            ElevatedButton.icon(
                onPressed: () => onDeleteRequest(s),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.darkRed, fixedSize: const Size(80, 30)) , label: Text("Delete"), icon: Icon(Icons.delete)),
          ],
        )
      ),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => studios.length;

  @override
  int get selectedRowCount => 0;
}



class StudiosTableView extends StatefulWidget {
  const StudiosTableView({super.key});

  @override
  State<StudiosTableView> createState() => _StudiosTableViewState();
}


class _StudiosTableViewState extends State<StudiosTableView>{
late Future<_StudiosTableData> _tableFuture;

final StudioFilter _filter = StudioFilter();
final TextEditingController _searchController = TextEditingController();

@override
void initState(){
  super.initState();
  final studioProvider = context.read<StudioProvider>();
  final userProvider = context.read<UserProvider>();
  final cityProvider = context.read<CityProvider>();

  _tableFuture = _loadTableData(
    studioProvider,
    userProvider,
    cityProvider,
  );

}

Future<_StudiosTableData> _loadTableData(
    StudioProvider studioProvider,
    UserProvider userProvider,
    CityProvider cityProvider,
    ) async {
  final results = await Future.wait([
    studioProvider.repository.getStudiosQuery(
      _filter.search,
      _filter.cityId,
    ),
    userProvider.repository.getAllUsers(),
    cityProvider.repository.getAllCities(),
  ]);

  final studios = results[0] as List<StudioResponseDto>;
  final owners = results[1] as List<UserResponseDto>;
  final cities = results[2] as List<CityModel>;

  return _StudiosTableData(
      studios: studios,
      ownerNames: {
        for(final o in owners) o.id: "${o.firstName} ${o.lastName}"
      },
      cityNames: {
        for(final c in cities) c.id: c.name,
      }
  );
}

  void _refresh(){
  final studioProvider = context.read<StudioProvider>();
  final userProvider = context.read<UserProvider>();
  final cityProvider = context.read<CityProvider>();
  setState(() {
    _tableFuture = _loadTableData(studioProvider, userProvider, cityProvider);
  });
  }

void _confirmDelete(StudioResponseDto studio) {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      title: const Text("Delete studio"),
      content: Text(
        "Are you sure you want to delete ${studio.name}  studio?",
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text("No"),
        ),
        TextButton(
          onPressed: () async {
            Navigator.of(ctx).pop();
            await context.read<StudioProvider>()
                .repository
                .deleteStudio(studio.id);
            _refresh();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Studio deleted successfully"),
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

void _confirmEdit(StudioResponseDto studio) {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => EditStudioDialog(
      studioToEdit: studio,
      onAdd: (newStudio) async {
        try {
          await context.read<StudioProvider>().repository.editStudio(newStudio, studio.id);
          _refresh();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Studio edited successfully"),
              backgroundColor: AppColors.deepGreen,
            ),
          );

        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        }
      },
    ),
  );
}

Widget _buildFilters(_StudiosTableData data) {
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
              labelText: "Search studios",
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
              ..cityId = null;
            _refresh();
          },
        ),
      ],
    ),
  );
}



  @override
  Widget build(BuildContext context) {

    return FutureBuilder<_StudiosTableData>(
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
                  if(data.studios.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(
                        child: Text(
                          "No studios found for the selected filters",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                    )
                  else
                    PaginatedDataTable(
                      header: const Text("Studios"),
                      rowsPerPage: 10,
                      columnSpacing: 20,
                      showCheckboxColumn: false,
                      columns: const [
                        DataColumn(label: Text("ID")),
                        DataColumn(label: Text("Owner")),
                        DataColumn(label: Text("Name")),
                        DataColumn(label: Text("Address")),
                        DataColumn(label: Text("Contact email")),
                        DataColumn(label: Text("Contact phone")),
                        DataColumn(label: Text("City")),
                        DataColumn(label: Text("Actions")),
                      ],

                      source: StudiosTableSource(
                          context:context,
                          studios: data.studios,
                          ownerNames: data.ownerNames,
                          cityNames: data.cityNames,
                          onDeleteRequest: _confirmDelete,
                          onEditRequest: _confirmEdit
                      ),

                    ),
                ],
              )

            );


      },
    );
  }
}