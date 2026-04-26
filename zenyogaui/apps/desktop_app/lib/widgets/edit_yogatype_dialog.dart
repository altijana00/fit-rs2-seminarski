import 'package:core/dto/requests/edit_city_dto.dart';
import 'package:core/dto/requests/edit_yoga_type_dto.dart';
import 'package:core/dto/responses/city_response_dto.dart';
import 'package:core/dto/responses/yoga_type_response_dto.dart';
import 'package:flutter/material.dart';


class EditYogaTypeDialog extends StatefulWidget {
  final YogaTypeResponseDto yogaTypeToEdit;
  final Function(EditYogaTypeDto) onEdit;

  const EditYogaTypeDialog({super.key, required this.yogaTypeToEdit, required this.onEdit});

  @override
  State<EditYogaTypeDialog> createState() => _EditYogaTypeDialogState();
}

class _EditYogaTypeDialogState extends State<EditYogaTypeDialog> {
  final _formKey = GlobalKey<FormState>();

  String _name="";
  String _description="";


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Edit Yoga type"),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            spacing: 12.0,
            children: [
              TextFormField(
                controller: TextEditingController(text: widget.yogaTypeToEdit.name),
                decoration: InputDecoration(labelText: "Yoga Type Name"),
                onSaved: (val) => _name = val ?? "",
                validator: (val) => val!.isEmpty ? "Enter a name" : null,
              ),
              TextFormField(
                controller: TextEditingController(text: widget.yogaTypeToEdit.description),
                decoration: InputDecoration(labelText: "Yoga Type Description"),
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
              widget.onEdit(EditYogaTypeDto(
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
