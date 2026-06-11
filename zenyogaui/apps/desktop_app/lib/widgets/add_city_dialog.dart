import 'package:core/dto/requests/add_city_dto.dart';
import 'package:flutter/material.dart';

class AddCityDialog extends StatefulWidget {
  final Function(AddCityDto) onAddDto;

  const AddCityDialog({super.key, required this.onAddDto});

  @override
  State<AddCityDialog> createState() => _AddCityDialogState();
}

class _AddCityDialogState extends State<AddCityDialog> {
  final _formKey = GlobalKey<FormState>();

  String _name="";


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add City"),
      content: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          child: Column(
            spacing: 12.0,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "City Name"),
                onSaved: (val) => _name = val ?? "",
                validator: (val) => val!.isEmpty ? "Enter a name" : null,
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
              widget.onAddDto(AddCityDto(
                name: _name,
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
