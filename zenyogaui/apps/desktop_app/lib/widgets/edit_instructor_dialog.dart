import 'package:core/dto/requests/edit_instructor_dto.dart';
import 'package:core/dto/requests/edit_user_dto.dart';
import 'package:core/dto/responses/instructor_response_dto.dart';
import 'package:core/dto/responses/user_response_dto.dart';
import 'package:flutter/material.dart';


class EditInstructorDialog extends StatefulWidget {
  final InstructorResponseDto instructorToEdit;
  final Function(EditInstructorDto) onEdit;


  const EditInstructorDialog({super.key, required this.instructorToEdit, required this.onEdit});

  @override
  State<EditInstructorDialog> createState() => _EditInstructorDialogState();
}

class _EditInstructorDialogState extends State<EditInstructorDialog> {
  final _formKey = GlobalKey<FormState>();

  String _firstName="";
  String _lastName="";
  String _email="";
  String _diplomas="";
  String _certificates="";
  String _biography="";


  @override
  Widget build(BuildContext context) {
    return Column (
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: widget.instructorToEdit.profileImageUrl != null
                  ? NetworkImage(widget.instructorToEdit.profileImageUrl!)
                  : null,
              child: widget.instructorToEdit.profileImageUrl == null
                  ? const Icon(Icons.person, size: 60)
                  : null,
            ),
            Positioned(
              child: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // TODO: implement profile image edit
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        AlertDialog(
        title: Text("Edit Instructor"),
        content: Form(
        key: _formKey,
        child: SingleChildScrollView(
        child: Column(
        children: [

        TextFormField(
        controller: TextEditingController(text: widget.instructorToEdit.firstName),
        decoration: InputDecoration(labelText: "First Name"),
        onSaved: (val) => _firstName = val ?? "",
        validator: (val) => val!.isEmpty ? "Enter first name" : null,
        ),
        TextFormField(
        controller: TextEditingController(text: widget.instructorToEdit.lastName),
    decoration: InputDecoration(labelText: "Last Name"),
    onSaved: (val) => _lastName = val ?? "",
    validator: (val) => val!.isEmpty ? "Enter last name" : null,
    ),
    TextFormField(
    controller: TextEditingController(text: widget.instructorToEdit.email),
    decoration: InputDecoration(labelText: "Email"),
    onSaved: (val) => _email = val ?? "",
    validator: (val) => val!.isEmpty ? "Enter email" : null,
    ),
    TextFormField(
    controller: TextEditingController(text: widget.instructorToEdit.biography.toString()),
    decoration: InputDecoration(labelText: "Biography"),
    onSaved: (val) => _biography = val ?? "",
    validator: (val) => val!.isEmpty ? "Add biography" : null,
    ),
    TextFormField(
    controller: TextEditingController(text: widget.instructorToEdit.certificates.toString()),
    decoration: InputDecoration(labelText: "Certificates"),
    onSaved: (val) => _certificates = val ?? "",
    validator: (val) => val!.isEmpty ? "Add certificates" : null,
    ),
    TextFormField(
    controller: TextEditingController(text: widget.instructorToEdit.diplomas.toString()),
    decoration: InputDecoration(labelText: "Diplomas"),
    onSaved: (val) => _diplomas = val ?? "",
    validator: (val) => val!.isEmpty ? "Add diplomas" : null,
    ),

    ],
    ),
    ),
    ),
    actions: [
    TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
    ElevatedButton(
    onPressed: () {
    if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();
    widget.onEdit(EditInstructorDto(
    firstName: _firstName,
    lastName: _lastName,
    email: _email,
    biography: _biography,
    diplomas: _diplomas,
    certificates: _certificates

    ));
    Navigator.pop(context);

    }
    },
    child: Text("Edit"),
    ),
    ],
    )],
    );
  }
}
