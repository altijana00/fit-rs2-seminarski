import 'package:core/dto/requests/register_user_dto.dart';
import 'package:core/dto/responses/city_response_dto.dart';
import 'package:core/models/city_model.dart';
import 'package:core/services/providers/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignupFormMobile extends StatefulWidget {
  final List<CityModel> cities;
  final VoidCallback? onSignupSuccess;

  const SignupFormMobile({
    super.key,
    required this.cities,
    this.onSignupSuccess,
  });

  @override
  State<SignupFormMobile> createState() => _SignupFormMobileState();
}

class _SignupFormMobileState extends State<SignupFormMobile> {
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
        roleId: 4, // fixed mobile role
        cityId: selectedCityId!,
        profileImageUrl: "test",
      ),
    );

    setState(() => _submitting = false);
    widget.onSignupSuccess?.call();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime(2008),
    );
    if (picked != null) setState(() => dateOfBirth = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset('assets/logo.png', height: 100),
          const SizedBox(height: 24),
          const Text(
            'Sign up',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),

          TextFormField(
            decoration: const InputDecoration(labelText: 'First name'),
            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            onSaved: (v) => firstName = v,
          ),
          const SizedBox(height: 16),

          TextFormField(
            decoration: const InputDecoration(labelText: 'Last name'),
            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            onSaved: (v) => lastName = v,
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
                .map(
                  (c) => DropdownMenuItem(
                value: c.id,
                child: Text(c.name),
              ),
            )
                .toList(),
            validator: (v) => v == null ? 'Required' : null,
            onChanged: (v) => selectedCityId = v,
          ),
          const SizedBox(height: 16),

          TextFormField(
            decoration: const InputDecoration(labelText: 'Email'),
            validator: (v) => v == null || !v.contains('@') ? 'Invalid email' : null,
            onSaved: (v) => email = v,
          ),
          const SizedBox(height: 16),

          TextFormField(
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (v) => v == null || v.length < 6 ? 'Min 6 characters' : null,
            onSaved: (v) => password = v,
          ),
          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: _submitting ? null : _submit,
            child: _submitting
                ? const SizedBox(
              height: 18,
              width: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : const Text('Sign up'),
          ),
        ],
      ),
    );
  }
}
