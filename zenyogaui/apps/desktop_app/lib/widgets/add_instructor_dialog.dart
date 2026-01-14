import 'package:core/dto/requests/add_instructor_dto.dart';
import 'package:flutter/material.dart';

class AddInstructorDialog extends StatefulWidget {
  final Future<void> Function(AddInstructorDto, String) onAdd;

  const AddInstructorDialog({super.key, required this.onAdd});

  @override
  State<AddInstructorDialog> createState() => _AddInstructorDialogState();
}

class _AddInstructorDialogState extends State<AddInstructorDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  String? _emailError;
  String? _biography;
  String? _certificates;
  String? _diplomas;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _emailError = null; // reset previous backend error
    });

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        // Await the API call
        await widget.onAdd(
          AddInstructorDto(
            biography: _biography,
            diplomas: _diplomas,
            certificates: _certificates,
          ),
          _emailController.text,
        );

        // Only close the dialog if successful
        if (mounted) Navigator.pop(context);
      } catch (e) {
        // Display backend exception as field error inside the form
        setState(() {
          _emailError = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add Instructor"),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email address",
                  errorText: _emailError,
                  suffixIcon: const Tooltip(
                    message:
                    "Instructors must already have an account registered with this email.",
                    waitDuration: Duration(milliseconds: 300),
                    showDuration: Duration(seconds: 4),
                    child: Icon(Icons.info_outline),
                  ),
                ),
                validator: (val) =>
                val == null || val.isEmpty ? "Enter an email address" : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Biography"),
                onSaved: (val) => _biography = val,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Diplomas"),
                onSaved: (val) => _diplomas = val,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Certificates"),
                onSaved: (val) => _certificates = val,
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
          onPressed: _submit,
          child: const Text("Add"),
        ),
      ],
    );
  }
}
