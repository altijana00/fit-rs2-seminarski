import 'package:core/dto/requests/add_role_dto.dart';
import 'package:flutter/material.dart';

class AddRoleDialog extends StatefulWidget {
  final Function(AddRoleDto) onAddDto;

  const AddRoleDialog({super.key, required this.onAddDto});

  @override
  State<AddRoleDialog> createState() => _AddRoleDialogState();
}

class _AddRoleDialogState extends State<AddRoleDialog> {
  final _formKey = GlobalKey<FormState>();

  String _name="";
  String? _description="";


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add Role"),
      content: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          child: Column(
            spacing: 12.0,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Role Name"),
                onSaved: (val) => _name = val ?? "",
                validator: (val) => val!.isEmpty ? "Enter a name" : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Description"),
                onSaved: (val) => _description = val ?? "",
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
              widget.onAddDto(AddRoleDto(
                name: _name,
                description: _description,
              ));
              Navigator.pop(context);
            }
          },
          child: Text("Add"),
        ),
      ],
    );
  }
}
