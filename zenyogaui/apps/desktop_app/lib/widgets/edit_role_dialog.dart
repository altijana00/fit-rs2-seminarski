
import 'package:core/dto/requests/edit_role_dto.dart';
import 'package:core/dto/responses/role_response_dto.dart';
import 'package:flutter/material.dart';


class EditRoleDialog extends StatefulWidget {
  final RoleResponseDto roleToEdit;
  final Function(EditRoleDto) onEdit;

  const EditRoleDialog({super.key, required this.roleToEdit, required this.onEdit});

  @override
  State<EditRoleDialog> createState() => _EditRoleDialogState();
}

class _EditRoleDialogState extends State<EditRoleDialog> {
  final _formKey = GlobalKey<FormState>();

  String _name="";
  String _description="";


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Edit Role"),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            spacing: 12.0,
            children: [
              TextFormField(
                controller: TextEditingController(text: widget.roleToEdit.name),
                decoration: InputDecoration(labelText: "Role Name"),
                onSaved: (val) => _name = val ?? "",
                validator: (val) => val!.isEmpty ? "Enter a name" : null,
              ),
              TextFormField(
                controller: TextEditingController(text: widget.roleToEdit.description),
                decoration: InputDecoration(labelText: "Role Description"),
                onSaved: (val) => _description = val ?? "",
                validator: (val) => val!.isEmpty ? "Enter a description" : null,
              )
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
              widget.onEdit(EditRoleDto(
                name: _name,
                description: _description
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
