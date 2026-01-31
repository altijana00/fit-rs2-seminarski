import 'package:core/dto/responses/city_response_dto.dart';
import 'package:core/dto/responses/instructor_response_dto.dart';
import 'package:core/dto/responses/studio_response_dto.dart';
import 'package:core/dto/responses/user_response_dto.dart';
import 'package:core/models/city_model.dart';
import 'package:core/models/instructor_model.dart';
import 'package:core/services/providers/auth_service.dart';
import 'package:core/services/providers/city_service.dart';
import 'package:core/services/providers/instructor_service.dart';
import 'package:core/services/providers/studio_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zenyogaui/core/theme.dart';
import '../widgets/add_instructor_dialog.dart';
import '../widgets/add_studio_stepper.dart';
import '../widgets/studio_details_card.dart';

class OwnerDashboard extends StatefulWidget {
  const OwnerDashboard({super.key});

  @override State<OwnerDashboard> createState() => _OwnerDashboardState();

}
class _OwnerDashboardState extends State<OwnerDashboard> {
  int _selectedIndex = 0;
  List<StudioResponseDto> studios = [];
  bool _loadingStudios = true;
  Map<int, String>? cityNames;
  List<CityModel> dropdownCities = [];

  @override void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadStudios();
    });
  }

  Future<void> _loadStudios() async {
    final user = ModalRoute .of(context)!.settings.arguments as UserResponseDto;
    final studioProvider = Provider.of<StudioProvider>(context, listen: false);
    final fetchedStudios = await studioProvider.repository.getStudioByOwner( user.id);
    final cityProvider = Provider.of<CityProvider>(context, listen: false);
    final cities = await cityProvider.repository.getAllCities();

    final cityMap = {
      for(final c in cities) c.id: c.name
    };

    setState(() {
      studios = fetchedStudios;
      _loadingStudios = false;
      cityNames = cityMap;
      dropdownCities = cities;
    });
  }

  Future<void> _reloadStudios() async {
    setState(() => _loadingStudios = true);
    await _loadStudios();
  }

  @override Widget build(BuildContext context) {
    final user = ModalRoute .of(context)!.settings.arguments as UserResponseDto;
    final studioProvider = Provider.of<StudioProvider>(context);
    final instructorProvider = Provider.of<InstructorProvider>(context);

    if (_loadingStudios) {
      return const Center(child: CircularProgressIndicator());
    }
    if (studios.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Time to add your studio!"),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddStudioStepper(
                  loggedUser: user,
                  studioRepository: studioProvider.repository,
                  instructorRepository: instructorProvider .repository,
                  cities: dropdownCities,
                ),
              ),
            );
            if (result != null) {
              studioProvider.notifyListeners();
            }
            },
            icon: const Icon(Icons.add),
            label: const Text("Add Studio"),
            style: ElevatedButton.styleFrom( backgroundColor: Colors.green),
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          NavigationRail(
            backgroundColor: AppColors.lavender,
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
              },
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                selectedIcon: Icon(Icons.apartment, color: AppColors.lavender,),
                icon: Icon(Icons.apartment, color: Colors.white),
                label: Text("Studios", style: TextStyle(color: Colors.white),
                ),
              ),
              NavigationRailDestination(
                selectedIcon: Icon(Icons.people, color: AppColors.lavender,),
                icon: Icon(Icons.people, color: Colors.white),
                label: Text("Employees", style: TextStyle(color: Colors.white)),
              ),
            ],

            trailing: Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Divider(color: Colors.white),
                  IconButton(
                    tooltip: "Logout",
                    icon: const Icon(Icons.logout, color: Colors.white),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text("Logout"),
                          content: const Text("Are you sure you want to logout?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(ctx);
                                await context.read<AuthProvider>().logout();

                                if (!context.mounted) return;

                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/',
                                      (_) => false,
                                );
                              },
                              child: const Text("Logout"),
                            ),
                          ],
                        ),
                      );

                    },
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _selectedIndex == 0
                  ? BuildStudiosTab(
                context: context,
                user: user,
                studioProvider: studioProvider,
                instructorProvider: instructorProvider,
                studios: studios,
                cityNames: cityNames!,
                onReloadStudios: _reloadStudios,
                cities: dropdownCities
              )
                  : BuildEmployeesTab(
                  context: context,
                  user: user,
                  instructorProvider: instructorProvider,
                  studioProvider: studioProvider,
                  studios: studios),
            ),
          ),
        ],
      ),
    );
  }
}

class BuildStudiosTab extends StatefulWidget {
  final List<StudioResponseDto> studios;
  final BuildContext context;
  final UserResponseDto user;
  final StudioProvider studioProvider;
  final InstructorProvider instructorProvider;
  final Future<void> Function() onReloadStudios;
  final List<CityModel> cities;

  final Map<int, String> cityNames;

  const BuildStudiosTab({
    super.key,
    required this.context,
    required this.user,
    required this.studioProvider,
    required this.instructorProvider,
    required this.studios,
    required this.cityNames,
    required this.onReloadStudios,
    required this.cities
  });

  @override BuildStudiosTabState createState() => BuildStudiosTabState();
}

class BuildStudiosTabState extends State<BuildStudiosTab>{

  @override Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Image.asset(
            'assets/logo.png',
            height: 64,
          ),
        ),
        Text("Welcome ${widget.user.firstName}!",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        Container(
          margin: const EdgeInsets.only(top:20.0, bottom: 40.0),
          child: ElevatedButton.icon(
            onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddStudioStepper(
                  loggedUser: widget.user,
                  studioRepository: widget.studioProvider.repository,
                  instructorRepository: widget.instructorProvider .repository,
                  cities: widget.cities,
                ),
              ),
            );

            final fetchedStudios = await widget.studioProvider.repository.getStudioByOwner(widget.user.id);

            setState(() {
              widget.studios.clear();
              widget.studios.addAll(fetchedStudios);
            });
            },
            icon: const Icon(Icons.add),
            label: const Text("Add Studio"),
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.lavender,
                fixedSize: const Size(140, 30)),
          ),
        ),

        Expanded(
          child: ListView.builder(
            itemCount: widget.studios.length,
            itemBuilder: (context, index) {
              final studio = widget.studios[index];

              return StudioDetailsCard(
                studio: studio,
                studioProvider: widget.studioProvider,
                cityNames: widget.cityNames,
                onReload: widget.onReloadStudios,
              );
              },
          ),
        ),
      ],
    );
  }
}

class BuildEmployeesTab extends StatefulWidget {
  final List<StudioResponseDto> studios;
  final BuildContext context;
  final UserResponseDto user;
  final StudioProvider studioProvider;
  final InstructorProvider instructorProvider;

  const BuildEmployeesTab({
    super.key,
    required this.context,
    required this.user,
    required this.studioProvider,
    required this.instructorProvider,
    required this.studios,
  });

  @override BuildEmployeesTabState createState() => BuildEmployeesTabState();
}

class BuildEmployeesTabState extends State<BuildEmployeesTab>{
  StudioResponseDto? selectedStudio;

  Widget build(BuildContext context) {


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Pick a studio"),
        Container(
          width: 250,
          child: DropdownButtonFormField<StudioResponseDto>(
            isExpanded: true,
            value: selectedStudio,
            hint: const Text('Pick a studio'),
            items: widget.studios.map((studio) {
              return DropdownMenuItem<StudioResponseDto>(
                value: studio,
                child: Text(studio.name),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedStudio = value;
              });
              },
          ),
        ),
        const SizedBox(height: 16),

        if (selectedStudio != null)
          FutureBuilder<List<InstructorResponseDto>>(
              future: widget.instructorProvider.repository.getByStudioId(selectedStudio!.id!),
              builder: (context, instructorSnapshot) {
                if (instructorSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (instructorSnapshot.hasError) {
                  return Center(
                    child: Text("Error loading instructors: ${instructorSnapshot .error}",
                      style: const TextStyle(color: AppColors.darkRed),
                    ),
                  );
                }

                final instructors = instructorSnapshot.data ?? [];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AddInstructorDialog(
                              onAdd: (newInstructor, email) async {
                                try {
                                  await widget.instructorProvider.repository .addInstructor(newInstructor, email, selectedStudio!.id!);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Instructor added successfully"),
                                      backgroundColor: AppColors.deepGreen,
                                    ),
                                  );
                                  widget.instructorProvider.notifyListeners();
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(e.toString())),
                                  );
                                }
                                },
                            ),
                          );
                          },
                        style: ElevatedButton.styleFrom(fixedSize: const Size(140, 30)),
                        label: Text("Add Employee"),
                        icon: Icon(Icons.add),
                      ),
                    ),
                    const SizedBox(height: 16),
                    instructors.isEmpty ? Center(child:
                    Text("No employees added yet.")):
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: [
                            DataColumn(label: Text("Name")),
                            DataColumn(label: Text("Email")),
                            DataColumn(label: Text("Biography")),
                            DataColumn(label: Text("Diplomas")),
                            DataColumn(label: Text("Certificates")),
                            DataColumn(label: Text("")), ],
                          rows: instructors.map((inst) {
                            return DataRow(cells:
                            [
                              DataCell(Text("${inst.firstName} ${inst.lastName}")),
                              DataCell(Text(inst.email)),
                              DataCell(Text(inst.biography?.isNotEmpty == true ? inst.biography! : "-")),
                              DataCell(Text(inst.diplomas?.isNotEmpty == true ? inst.diplomas! : "-")),
                              DataCell(Text(inst.certificates?.isNotEmpty == true ? inst.certificates! : "-")),
                              DataCell(ElevatedButton.icon(onPressed: (){
                                showDialog<void>(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Delete instructor"),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: <Widget>[
                                            Text('Deleting the instructor will remove the user from the app entirely.'),
                                            Text('Are you sure you want to delete the instructor ${inst.firstName} ${inst.lastName} ?',
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('No', style: TextStyle(color: Colors.white)),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            },
                                          style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                                        ),
                                        TextButton(
                                          child: const Text('Yes', style: TextStyle(color: Colors.white)),
                                          onPressed: () async {
                                            await widget.instructorProvider.repository.deleteInstructor(inst.id);
                                            Navigator.of(context).pop();
                                            ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text("Instructor deleted!")));
                                            },
                                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.darkRed),
                                        ),
                                      ],
                                    );
                                    },
                                );
                                },
                                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.darkRed, fixedSize: const Size(80, 30)) ,
                                  label: Text("Delete"),
                                  icon: Icon(Icons.delete)))
                            ]);
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                );
              }
              )
      ],
    );
  }
}
