import 'package:core/dto/requests/register_user_dto.dart';
import 'package:core/models/city_model.dart';
import 'package:core/models/role_model.dart';
import 'package:core/services/providers/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zenyogaui/core/theme.dart';


class SignupForm extends StatefulWidget {
  final List<CityModel> cities;
  final List<RoleModel> roles;

  const SignupForm({super.key, required this.cities, required this.roles});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  int _step = 0;

  final _step1Key = GlobalKey<FormState>();
  final _step2Key = GlobalKey<FormState>();


  String? firstName;
  String? lastName;
  String? gender;
  DateTime? dateOfBirth;
  int? selectedCityId;

  RoleModel? selectedRole;
  String? email;
  String? password;
  String? confirmPassword;

  bool _submitting = false;
  bool _success = false;



  @override
  void initState() {
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Image.asset(
              'assets/logo.png',
              height: 64,
            ),
          ),

          if (_success) _confirmation() else _formSteps(),
        ],
      ),
    );
  }

  Widget _formSteps() {
    return IndexedStack(
      index: _step,
      children: [
        _stepOne(),
        _stepTwo(),
      ],
    );
  }



  Widget _stepOne() {
    return Form(
      key: _step1Key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _title("Sign up"),

          TextFormField(
            decoration: const InputDecoration(labelText: "First name"),
            validator: (v) => v == null || v.isEmpty ? "Required" : null,
            onSaved: (v) => firstName = v,
          ),
          const SizedBox(height: 12),

          TextFormField(
            decoration: const InputDecoration(labelText: "Last name"),
            validator: (v) => v == null || v.isEmpty ? "Required" : null,
            onSaved: (v) => lastName = v,
          ),
          const SizedBox(height: 12),

          DropdownButtonFormField<String>(
            value: gender,
            decoration: const InputDecoration(labelText: "Gender"),
            items: const [
              DropdownMenuItem(value: "M", child: Text("Male")),
              DropdownMenuItem(value: "F", child: Text("Female")),
            ],
            validator: (v) => v == null ? "Required" : null,
            onChanged: (v) => setState(() => gender = v),
          ),
          const SizedBox(height: 12),

          TextFormField(
            readOnly: true,
            decoration: const InputDecoration(labelText: "Date of birth"),
            controller: TextEditingController(
              text: dateOfBirth == null
                  ? ""
                  : "${dateOfBirth!.year}-${dateOfBirth!.month}-${dateOfBirth!.day}",
            ),
            validator: (_) => dateOfBirth == null ? "Required" : null,
            onTap: _pickDate,
          ),
          const SizedBox(height: 12),


          DropdownButtonFormField<int>(
            value: selectedCityId,
            decoration: const InputDecoration(labelText: "City"),
            items: widget.cities
                .map((c) => DropdownMenuItem<int>(
              value: c.id,
              child: Text(c.name),
            ))
                .toList(),
            validator: (v) => v == null ? "Required" : null,
            onChanged: (v) => setState(() => selectedCityId = v),
          ),
          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: _next,
            child: const Text("Next"),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.deepGreen),
          ),
          const SizedBox(height: 15),
          Center(
            child:
            GestureDetector(
              onTap: () {

                Navigator.of(context).pushNamed('/');
              },
              child: Text('Already have an account? Log in.', style: TextStyle(decoration: TextDecoration.underline)),
            )
          ),

        ],
      ),
    );
  }



  Widget _stepTwo() {
    return Form(
      key: _step2Key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _title("Account details"),

          DropdownButtonFormField<RoleModel>(
            value: selectedRole,
            decoration: const InputDecoration(labelText: "Role"),
            items: widget.roles
                .map((r) => DropdownMenuItem(
              value: r,
              child: Text(r.name),
            ))
                .toList(),
            validator: (v) => v == null ? "Required" : null,
            onChanged: (v) => setState(() => selectedRole = v),
          ),
          const SizedBox(height: 12),

          TextFormField(
            decoration: const InputDecoration(labelText: "Email"),
            validator: (v) =>
            v == null || !v.contains('@') ? "Invalid email" : null,
            onSaved: (v) => email = v,
          ),
          const SizedBox(height: 12),

          TextFormField(
            decoration: const InputDecoration(labelText: "Password"),
            obscureText: true,
            validator: (v) =>
            v == null || v.length < 6 ? "Min 6 characters" : null,
            onSaved: (v) => password = v,
          ),
          const SizedBox(height: 12),

          // TextFormField(
          //   decoration: const InputDecoration(labelText: "Confirm password"),
          //   obscureText: true,
          //   validator: (v) => v != password ? "Passwords do not match" : null,
          // ),
          // const SizedBox(height: 24),

          Row(
            children: [
              TextButton(
                onPressed: () => setState(() => _step = 0),
                child: const Text("Back"),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.deepGreen),
                child: _submitting
                    ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const Text("Sign up"),

              ),
              const SizedBox(height: 15),
              Center(
                  child:
                  GestureDetector(
                    onTap: () {

                      Navigator.of(context).pushNamed('/');
                    },
                    child: Text('Already have an account? Log in.', style: TextStyle(decoration: TextDecoration.underline)),
                  )
              ),

            ],
          ),
        ],
      ),
    );
  }



  Widget _confirmation() {
    return Column(
      children: [
        const Icon(Icons.check_circle, color: Colors.green, size: 72),
        const SizedBox(height: 16),
        const Text(
          "Registration successful",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: () =>
            Navigator.of(context).pushNamedAndRemoveUntil('/', (_) => false),
            child: const Text("Back to login"),

        )
      ],
    );
  }



  void _next() {
    if (_step1Key.currentState!.validate()) {
      _step1Key.currentState!.save();
      setState(() => _step = 1);
    }
  }

  Future<void> _submit() async {
    if (!_step2Key.currentState!.validate()) return;
    _step2Key.currentState!.save();

    setState(() => _submitting = true);
   final cityId = selectedCityId!;
    await context.read<UserProvider>().repository.addUser(
      RegisterUserDto(
        firstName: firstName!,
        lastName: lastName!,
        gender: gender,
        dateOfBirth: dateOfBirth,
        email: email!,
        password: password!,
        roleId: selectedRole!.id,
        cityId: cityId,
        profileImageUrl: "test",
      ),
    );

    setState(() {
      _submitting = false;
      _success = true;
    });
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

  Widget _title(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style:
      const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
  );
}