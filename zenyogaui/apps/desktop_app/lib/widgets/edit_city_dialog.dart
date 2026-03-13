import 'package:core/dto/requests/edit_city_dto.dart';
import 'package:core/dto/requests/edit_studio_dto.dart';
import 'package:core/dto/responses/city_response_dto.dart';
import 'package:core/dto/responses/studio_response_dto.dart';
import 'package:flutter/material.dart';


class EditCityDialog extends StatefulWidget {
  final CityResponseDto cityToEdit;
  final Function(EditCityDto) onEdit;

  const EditCityDialog({super.key, required this.cityToEdit, required this.onEdit});

  @override
  State<EditCityDialog> createState() => _EditCityDialogState();
}

class _EditCityDialogState extends State<EditCityDialog> {
  final _formKey = GlobalKey<FormState>();

  String _name="";


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Edit City"),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            spacing: 12.0,
            children: [
              TextFormField(
                controller: TextEditingController(text: widget.cityToEdit.name),
                decoration: InputDecoration(labelText: "City Name"),
                onSaved: (val) => _name = val ?? "",
                validator: (val) => val!.isEmpty ? "Enter a name" : null,
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
              widget.onEdit(EditCityDto(
                name: _name,
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
