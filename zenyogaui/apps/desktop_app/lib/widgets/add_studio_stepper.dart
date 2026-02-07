import 'dart:io';

import 'package:core/dto/requests/add_instructor_dto.dart';
import 'package:core/dto/requests/add_studio_dto.dart';
import 'package:core/dto/responses/studio_response_dto.dart';
import 'package:core/dto/responses/user_response_dto.dart';
import 'package:core/models/city_model.dart';
import 'package:core/repositories/instructor_repository.dart';
import 'package:core/repositories/studio_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../core/theme.dart';


class AddStudioStepper extends StatefulWidget {
  final UserResponseDto loggedUser;
  final StudioRepository studioRepository;
  final InstructorRepository instructorRepository;
  final List<CityModel> cities;
  const AddStudioStepper({
    super.key,
    required this.loggedUser,
    required this.studioRepository,
    required this.instructorRepository,
    required this.cities,
  });

  @override
  State<AddStudioStepper> createState() => _AddStudioStepperState();
}

class _AddStudioStepperState extends State<AddStudioStepper> {
  int _currentStep = 0;

  // separate form keys for each step
  final _studioFormKey = GlobalKey<FormState>();
  final _instructorFormKey = GlobalKey<FormState>();

  // temporary maps to store form data
  final Map<String, dynamic> _studioData = {};
  final Map<String, dynamic> _instructorData = {};
  StudioResponseDto? _createdStudio;

  bool _isSubmitting = false;
  bool _studioAdded = false;
  bool _instructorAdded = false;

  File? selectedImage;
  String studioPhotoUrl = "";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Studio")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Welcome, ${widget.loggedUser.firstName} ${widget.loggedUser.lastName}!",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Stepper(
                currentStep: _currentStep,
                onStepContinue: _onStepContinue,
                onStepCancel: _onStepCancel,
                steps: _buildSteps(),
                controlsBuilder: (context, details) {
                  return Row(
                    children: [
                      ElevatedButton(
                        onPressed: details.onStepContinue,
                        child: Text(_currentStep == 2 ? "Finish" : "Next"),
                      ),
                      const SizedBox(width: 16),
                      if (_currentStep != 0)
                        TextButton(
                          onPressed: details.onStepCancel,
                          child: const Text("Back"),
                        ),
                      // skip instructors if desired
                      if (_currentStep == 1)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _currentStep = 2;
                            });
                          },
                          child: const Text("Skip"),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Step> _buildSteps() {
    // convenience to show editing state for the active step
    bool isEditing(int stepIndex) => _currentStep == stepIndex;

    return [
      // Step 0: Studio details
      Step(
        title: const Text("Studio Details"),
        content: Form(
          key: _studioFormKey,
          child: Column(
            children: [

              Padding(
                padding: const EdgeInsets.only(bottom: 16, top: 16),
                child: TextFormField(
                  decoration: const InputDecoration(labelText: "Studio Name"),
                  validator: (value) => value == null || value.isEmpty ? "Required" : null,
                  onSaved: (value) => _studioData['name'] = value,
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: TextFormField(
                  decoration: const InputDecoration(labelText: "Address"),
                  onSaved: (value) => _studioData['address'] = value,
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: TextFormField(
                  decoration: const InputDecoration(labelText: "Description"),
                  onSaved: (value) => _studioData['description'] = value,
                ),
              ),

              // Padding(
              //   padding: const EdgeInsets.only(bottom: 16),
              //   child: TextFormField(
              //     decoration: const InputDecoration(labelText: "City (id)"),
              //     onSaved: (value) =>
              //     _studioData['cityId'] = int.tryParse(value ?? "0") ?? 0,
              //     validator: (value) =>
              //     value == null || value.isEmpty ? "Required" : null,
              //   ),
              // ),

              DropdownButtonFormField<int>(
                value: _studioData['cityId'],
                decoration: const InputDecoration(labelText: "City"),
                items: widget.cities
                    .map((c) => DropdownMenuItem<int>(
                  value: c.id,
                  child: Text(c.name),
                ))
                    .toList(),
                validator: (v) => v == null ? "Required" : null,
                onChanged: (v) => setState(() => _studioData['cityId'] = v),
              ),
              const SizedBox(height: 24),

              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: TextFormField(
                  decoration: const InputDecoration(labelText: "Contact email"),
                  onSaved: (value) => _studioData['contactEmail'] = value,
                  validator: (value) {
                   if(value !=null && (!value.contains('@')))  {
                     return 'Please enter a valid email format: name@example.com';
                   }
                     return null;
                  }
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: const InputDecoration(labelText: "Contact phone"),
                  onSaved: (value) => _studioData['contactPhone'] = value,
                  // validator: (value) {
                  //   final n = num.tryParse(value!);
                  //   if (n != null && (n < 9 || n > 15)) {
                  //     return 'Please enter a valid phone number with digits only';
                  //   }
                  //   return null;
                  // },
                ),
              ),

              ElevatedButton(
                onPressed: () async {
                  final picked = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                  );

                  if (picked == null) return;

                  final selectedphoto = File(picked.path);
                  final studiourlphoto =
                  await widget.studioRepository.uploadStudioPhoto(selectedphoto);

                  setState(() {
                    selectedImage = selectedphoto;
                    studioPhotoUrl = studiourlphoto;
                  });
                },

                style: ElevatedButton.styleFrom(fixedSize: const Size(140, 30)),
                child: Text(
                  selectedImage == null
                      ? "Upload profile image"
                      : "Image picked ✔",
                ),

              ),
            ],
          ),
        ),
        isActive: _currentStep >= 0,
        state: _studioAdded
            ? StepState.complete
            : (isEditing(0) ? StepState.editing : StepState.indexed),
      ),

      // Step 1: Add instructors (optional)
      Step(
        title: const Text("Add Instructors"),
        content: Form(
          key: _instructorFormKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "Email", suffixIcon: const Tooltip(
                  message:
                  "Instructors must already have an account registered with this email.",
                  waitDuration: Duration(milliseconds: 300),
                  showDuration: Duration(seconds: 4),
                  child: Icon(Icons.info_outline),
                ),
                ),
                validator: (value) => value == null || value.isEmpty ? "Required" : null,
                onSaved: (value) => _instructorData['email'] = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Biography"),
                onSaved: (value) => _instructorData['biography'] = value,
                maxLines: 3,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Diplomas"),
                onSaved: (value) => _instructorData['diplomas'] = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Certificates"),
                onSaved: (value) => _instructorData['certificates'] = value,
              ),
            ],
          ),
        ),
        isActive: _currentStep >= 1,
        state: _instructorAdded
            ? StepState.complete
            : (isEditing(1) ? StepState.editing : StepState.indexed),
      ),

      // Step 2: Confirmation
      Step(
        title: const Text("Confirmation"),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.green, size: 80),
            const SizedBox(height: 8),
            Text(_studioAdded ? "Studio added" : "Studio not added yet"),
            if (_instructorAdded) const Text("Instructor added"),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {

                Navigator.pop(context, _createdStudio);
              },
              child: const Text("Done"),
            ),
          ],
        ),
        isActive: _currentStep >= 2,
        state: (_studioAdded && (_instructorAdded || !_instructorAdded && !isEditing(2)))
            ? StepState.complete
            : (isEditing(2) ? StepState.editing : StepState.indexed),
      ),
    ];
  }

  void _onStepContinue() async {
    // STEP 0: add studio
    if (_currentStep == 0) {
      final form = _studioFormKey.currentState!;
      if (form.validate()) {
        form.save();

        setState(() => _isSubmitting = true);
        try {

          await widget.studioRepository.addStudio(
            AddStudioDto(
              ownerId: widget.loggedUser.id,
              name: _studioData['name'],
              description: _studioData['description'],
              address: _studioData['address'],
              cityId: _studioData['cityId'],
              contactEmail: _studioData['contactEmail'],
              contactPhone: _studioData['contactPhone'],
              profileImageUrl: studioPhotoUrl,
            ),
          );


          _createdStudio = await widget.studioRepository.getStudioByOwnerAndStudioName(
              widget.loggedUser.id, _studioData['name']);

          setState(() {
            _studioAdded = true;
            _currentStep = 1;
          });
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to add studio: $e")),
          );
        } finally {
          setState(() => _isSubmitting = false);
        }
      }
    }

    // STEP 1: add instructor (optional)
    else if (_currentStep == 1) {
      final form = _instructorFormKey.currentState!;
      if (form.validate()) {
        form.save();

        if (_createdStudio == null || _createdStudio!.id == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("You must add a studio first.")),
          );
          return;
        }

        setState(() => _isSubmitting = true);
        try {
          final instructor = AddInstructorDto(

            diplomas: _instructorData['diplomas'],
            certificates: _instructorData['certificates'],
            biography: _instructorData['biography'],


          );

          await widget.instructorRepository.addInstructor(
            instructor,
            _instructorData['email'],
            _createdStudio!.id!,
          );

          setState(() {
            _instructorAdded = true;
            _currentStep = 2; // move to confirmation
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Instructor added successfully")),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to add instructor: $e"), backgroundColor: AppColors.darkRed,),
          );
        } finally {
          setState(() => _isSubmitting = false);
        }
      }
    }

    // STEP 2: finish
    else if (_currentStep == 2) {
      Navigator.pop(context, _createdStudio);
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }
}


