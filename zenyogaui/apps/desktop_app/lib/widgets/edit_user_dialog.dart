import 'package:core/dto/requests/edit_user_dto.dart';
import 'package:core/dto/responses/user_response_dto.dart';
import 'package:flutter/material.dart';


class EditUserDialog extends StatefulWidget {
  final UserResponseDto userToEdit;
  final Function(EditUserDto) onAdd;


  const EditUserDialog({super.key, required this.userToEdit, required this.onAdd});

  @override
  State<EditUserDialog> createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<EditUserDialog> {
  final _formKey = GlobalKey<FormState>();

  String _firstName="";
  String _lastName="";
  String? _gender="";
  String _email="";


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Edit User"),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [

              TextFormField(
                controller: TextEditingController(text: widget.userToEdit.firstName),
                decoration: InputDecoration(labelText: "First Name"),
                onSaved: (val) => _firstName = val ?? "",
                validator: (val) => val!.isEmpty ? "Enter first name" : null,
              ),
              TextFormField(
                controller: TextEditingController(text: widget.userToEdit.lastName),
                decoration: InputDecoration(labelText: "Last Name"),
                onSaved: (val) => _lastName = val ?? "",
                validator: (val) => val!.isEmpty ? "Enter last name" : null,
              ),
              TextFormField(
                controller: TextEditingController(text: widget.userToEdit.gender.toString()),
                decoration: InputDecoration(labelText: "Gender"),
                onSaved: (val) => _gender = val ?? "",
                validator: (val) => val!.isEmpty ? "Enter gender" : null,
              ),
              TextFormField(
                controller: TextEditingController(text: widget.userToEdit.email),
                decoration: InputDecoration(labelText: "Email"),
                onSaved: (val) => _email = val ?? "",
                validator: (val) => val!.isEmpty ? "Enter email" : null,
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
              widget.onAdd(EditUserDto(
                firstName: _firstName,
                lastName: _lastName,
                email: _email,
                gender: _gender,

              ));
              Navigator.pop(context);

            }
          },
          child: Text("Edit"),
        ),
      ],
    );
  }
}
