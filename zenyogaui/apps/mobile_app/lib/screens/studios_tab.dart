import 'package:core/dto/responses/studio_response_dto.dart';
import 'package:core/models/city_model.dart';
import 'package:core/services/providers/auth_service.dart';
import 'package:core/services/providers/city_service.dart';
import 'package:core/services/providers/studio_service.dart';
import 'package:core/services/providers/user_class_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/screens/studio_details_screen.dart';
import 'package:provider/provider.dart';

import '../widgets/studio_card.dart';

class _StudiosTabData {
  final List<StudioResponseDto> studios;
  final List<StudioResponseDto> recStudios;
  final Map<int, String> cityNames;

  _StudiosTabData({
    required this.studios,
    required this.recStudios,
    required this.cityNames,
  });
}

class StudioFilter {
  String? search;
  int? cityId;
}

class StudiosTab extends StatefulWidget {
  const StudiosTab({super.key});

  @override
  State<StudiosTab> createState() => _StudiosTabState();
}

class _StudiosTabState extends State<StudiosTab> {
  late Future<_StudiosTabData> _studiosDataFuture;

  final StudioFilter _filter = StudioFilter();
  final TextEditingController _searchController = TextEditingController();




  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    final studioProvider = context.read<StudioProvider>();
    final cityProvider = context.read<CityProvider>();
    final userClassProvider = context.read<UserClassProvider>();

    setState(() {
      _studiosDataFuture = _loadStudiosData(studioProvider, cityProvider, userClassProvider);


    });
  }


  Future<_StudiosTabData> _loadStudiosData(
      StudioProvider studioProvider,
      CityProvider cityProvider,
      UserClassProvider userClassProvider
      ) async {
    final results = await Future.wait([
      studioProvider.repository.getStudiosQuery(_filter.search, _filter.cityId),
      cityProvider.repository.getAllCities(),
      userClassProvider.repository.getUserRecommendedStudios(context.read<AuthProvider>().user!.id)
    ]);

    final studios = results[0] as List<StudioResponseDto>;
    final cities = results[1] as List<CityModel>;
    final recStudios = results[2] as List<StudioResponseDto>;

    return _StudiosTabData(
      studios: studios,
      cityNames: {for (final c in cities) c.id: c.name},
      recStudios: recStudios
    );
  }

  Widget _buildFilters(_StudiosTabData data) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // SEARCH
          TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: "Search studios",
              prefixIcon: Icon(Icons.search),
            ),
          ),

          const SizedBox(height: 12),



          InkWell(
            onTap: () => _openCityPicker(data),
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: "City",
                prefixIcon: Icon(Icons.location_city),
                border: OutlineInputBorder(),
              ),
              child: Text(
                _filter.cityId == null
                    ? "All cities"
                    : data.cityNames[_filter.cityId]!,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ACTION BUTTONS
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.search),
                  label: const Text("Search"),
                  onPressed: () {
                    _filter.search = _searchController.text.trim();
                    _refresh();
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
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
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 24, bottom: 12),
            child: Center(
              child: Image.asset(
                'assets/logo.png',
                height: 80,
              ),
            ),
          ),


          FutureBuilder<_StudiosTabData>(
            future: _studiosDataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasError) {
                return Expanded(
                  child: Center(
                    child: Text(
                      "Error: ${snapshot.error}",
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                );
              }

              final data = snapshot.data!;

              return Expanded(
                child: Column(
                  children: [
                    _buildFilters(data),
                    Text(
                      "Recommended for you",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    Expanded(
                      child: data.recStudios.isEmpty
                          ? const Center(
                        child: Text(
                          "",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                          : ListView.builder(
                        itemCount: data.recStudios.length,
                        itemBuilder: (_, index) {
                          final studio = data.recStudios[index];
                          return StudioCard(
                            studio: studio,
                            cityName:
                            data.cityNames[studio.cityId] ?? '-',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => StudioDetailsScreen(
                                    studio: studio,
                                    cityName: data.cityNames[studio.cityId] ?? '-',
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          FutureBuilder<_StudiosTabData>(
            future: _studiosDataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasError) {
                return Expanded(
                  child: Center(
                    child: Text(
                      "Error: ${snapshot.error}",
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                );
              }

              final data = snapshot.data!;

              return Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: data.studios.isEmpty
                          ? const Center(
                        child: Text(
                          "No studios found for the selected filters",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                          : ListView.builder(
                        itemCount: data.studios.length,
                        itemBuilder: (_, index) {
                          final studio = data.studios[index];
                          return StudioCard(
                            studio: studio,
                            cityName:
                            data.cityNames[studio.cityId] ?? '-',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => StudioDetailsScreen(
                                    studio: studio,
                                    cityName: data.cityNames[studio.cityId] ?? '-',
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _openCityPicker(_StudiosTabData data) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return SafeArea(
          child: ListView(
            children: [
              const ListTile(
                title: Text(
                  "Select city",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(),
              ListTile(
                title: const Text("All cities"),
                onTap: () {
                  setState(() => _filter.cityId = null);
                  Navigator.pop(context);
                  _refresh();
                },
              ),
              ...data.cityNames.entries.map(
                    (e) => ListTile(
                  title: Text(e.value),
                  onTap: () {
                    setState(() => _filter.cityId = e.key);
                    Navigator.pop(context);
                    _refresh();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
