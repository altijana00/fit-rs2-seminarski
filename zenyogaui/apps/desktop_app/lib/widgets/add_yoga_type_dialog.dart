import 'package:core/dto/requests/add_yoga_type_dto.dart';
import 'package:flutter/material.dart';

class AddYogaTypeDialog extends StatefulWidget {
  final Function(AddYogaTypeDto) onAddDto;

  const AddYogaTypeDialog({super.key, required this.onAddDto});

  @override
  State<AddYogaTypeDialog> createState() => _AddYogaTypeDialogState();
}

class _AddYogaTypeDialogState extends State<AddYogaTypeDialog> {
  final _formKey = GlobalKey<FormState>();

  String _name="";
  String? _description="";


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add Yoga Type"),
      content: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          child: Column(
            spacing: 12.0,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Yoga Type Name"),
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
              widget.onAddDto(AddYogaTypeDto(
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
