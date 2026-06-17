import 'package:core/dto/requests/register_user_dto.dart';
import 'package:core/dto/responses/city_response_dto.dart';
import 'package:core/services/providers/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zenyogaui/core/app_roles.dart';

class AddUserDialog extends StatefulWidget {
  final Function(RegisterUserDto) onAddDto;
  final List<CityResponseDto> cities;

  const AddUserDialog({super.key, required this.onAddDto, required this.cities,});

  @override
  State<AddUserDialog> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  final _formKey = GlobalKey<FormState>();

  String? firstName;
  String? lastName;
  String? gender;
  DateTime? dateOfBirth;
  int? selectedCityId;
  String? email;
  String? password;

  bool _submitting = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => _submitting = true);

    await context.read<UserProvider>().repository.addUser(
      RegisterUserDto(
        firstName: firstName!,
        lastName: lastName!,
        gender: gender,
        dateOfBirth: dateOfBirth,
        email: email!,
        password: password!,
        roleId: AppRole.participant,
        cityId: selectedCityId!,
        profileImageUrl: "test",
      ),
    );

    setState(() => _submitting = false);

  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000).toUtc(),
      firstDate: DateTime(1900).toUtc(),
      lastDate: DateTime(2008).toUtc(),
    );
    if (picked != null) setState(() => dateOfBirth = picked);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Add user',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              TextFormField(
                decoration: const InputDecoration(labelText: 'First name'),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'First name is required!';
                  }
                  if (v.length > 30) {
                    return "Must be less than 30 characters.";
                  }
                  return null;
                },
                onSaved: (v) => firstName = v?.trim(),
              ),
              const SizedBox(height: 16),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Last name'),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Last name is required!';
                  }
                  if (v.length > 30) {
                    return "Must be less than 30 characters.";
                  }
                  return null;
                },
                onSaved: (v) => lastName = v?.trim(),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Gender'),
                items: const [
                  DropdownMenuItem(value: 'M', child: Text('Male')),
                  DropdownMenuItem(value: 'F', child: Text('Female')),
                ],
                validator: (v) => v == null ? 'Required' : null,
                onChanged: (v) => gender = v,
              ),
              const SizedBox(height: 16),

              TextFormField(
                readOnly: true,
                decoration: const InputDecoration(labelText: 'Date of birth'),
                controller: TextEditingController(
                  text: dateOfBirth == null
                      ? ''
                      : '${dateOfBirth!.year}-${dateOfBirth!.month}-${dateOfBirth!.day}',
                ),
                validator: (_) => dateOfBirth == null ? 'Required' : null,
                onTap: _pickDate,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'City'),
                items: widget.cities
                    .map((c) => DropdownMenuItem(
                  value: c.id,
                  child: Text(c.name),
                ))
                    .toList(),
                validator: (v) => v == null ? 'City is required!' : null,
                onChanged: (v) => selectedCityId = v,
              ),
              const SizedBox(height: 16),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Email is required!';
                  }

                  final emailRegex =
                  RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

                  if (!emailRegex.hasMatch(v)) {
                    return 'Please enter a valid email address format.';
                  }

                  return null;
                },
                onSaved: (v) => email = v?.trim(),
              ),
              const SizedBox(height: 16),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Password is required!';
                  }
                  if (v.length < 6) {
                    return 'Password must be at least 6 characters.';
                  }
                  return null;
                },
                onSaved: (v) => password = v,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(fixedSize: const Size(90, 32)),
          onPressed: _submitting ? null : _submit,
          child: _submitting
              ? const SizedBox(
            height: 18,
            width: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
              : const Text('Add user'),

        ),
      ],
    );
  }

}
