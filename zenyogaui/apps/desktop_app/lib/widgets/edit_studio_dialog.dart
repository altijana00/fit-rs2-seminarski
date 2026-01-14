import 'package:core/dto/requests/edit_studio_dto.dart';
import 'package:core/dto/responses/studio_response_dto.dart';
import 'package:flutter/material.dart';


class EditStudioDialog extends StatefulWidget {
  final StudioResponseDto studioToEdit;
  final Function(EditStudioDto) onAdd;

  const EditStudioDialog({super.key, required this.studioToEdit, required this.onAdd});

  @override
  State<EditStudioDialog> createState() => _EditStudioDialogState();
}

class _EditStudioDialogState extends State<EditStudioDialog> {
  final _formKey = GlobalKey<FormState>();

  String _name="";
  String? _description="";
  String? _address="";
  String? _contactEmail="";
  String? _contactPhone="";


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Edit Studio"),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [

              TextFormField(
                controller: TextEditingController(text: widget.studioToEdit.name),
                decoration: InputDecoration(labelText: "Studio Name"),
                onSaved: (val) => _name = val ?? "",
                validator: (val) => val!.isEmpty ? "Enter a name" : null,
              ),
              TextFormField(
                controller: TextEditingController(text: widget.studioToEdit.description),
                decoration: InputDecoration(labelText: "Description"),
                onSaved: (val) => _description = val ?? "",
                validator: (val) => val!.isEmpty ? "Enter a description" : null,
              ),
              TextFormField(
                controller: TextEditingController(text: widget.studioToEdit.address),
                decoration: InputDecoration(labelText: "Address"),
                onSaved: (val) => _address = val ?? "",
                validator: (val) => val!.isEmpty ? "Enter an address" : null,
              ),
              TextFormField(
                controller: TextEditingController(text: widget.studioToEdit.contactEmail),
                decoration: InputDecoration(labelText: "Contact Email"),
                onSaved: (val) => _contactEmail = val ?? "",
                validator: (val) => val!.isEmpty ? "Enter an email" : null,
              ),
              TextFormField(
                controller: TextEditingController(text: widget.studioToEdit.contactPhone),
                decoration: InputDecoration(labelText: "Contact Phone"),
                onSaved: (val) => _contactPhone = val ?? "",
                validator: (val) => val!.isEmpty ? "Enter phone" : null,
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
              widget.onAdd(EditStudioDto(
                name: _name,
                description: _description,
                address: _address,
                contactEmail: _contactEmail,
                contactPhone: _contactPhone,
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
