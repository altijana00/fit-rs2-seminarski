import 'package:core/dto/requests/edit_class_dto.dart';
import 'package:core/dto/responses/class_response_dto.dart';
import 'package:flutter/material.dart';


class EditClassDialog extends StatefulWidget {
  final ClassResponseDto classToEdit;
  final Function(EditClassDto) onAdd;


  const EditClassDialog({super.key, required this.classToEdit, required this.onAdd});

  @override
  State<EditClassDialog> createState() => _EditClassDialogState();
}

class _EditClassDialogState extends State<EditClassDialog> {
  final _formKey = GlobalKey<FormState>();

   String _name="";
   String? _description="";
   final DateTime _startDate=DateTime.now();
   final DateTime _endDate=DateTime.now();
   int _maxParticipants=50;
   String? _location="";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Edit Class"),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            spacing: 12.0,
            children: [
              TextFormField(
                controller: TextEditingController(text: widget.classToEdit.name),
                decoration: InputDecoration(labelText: "Class Name"),
                onSaved: (val) => _name = val ?? "",
                validator: (val) => val!.isEmpty ? "Enter a name" : null,
              ),
              TextFormField(
                controller: TextEditingController(text: widget.classToEdit.description),
                decoration: InputDecoration(labelText: "Description"),
                onSaved: (val) => _description = val ?? "",

               ),
              TextFormField(
                controller: TextEditingController(text: widget.classToEdit.maxParticipants.toString()),
                decoration: InputDecoration(labelText: "Max Participants"),
                keyboardType: TextInputType.number,
                onSaved: (val) => _maxParticipants = int.tryParse(val ?? "0") ?? 0,
              ),
              TextFormField(
                controller: TextEditingController(text: widget.classToEdit.location),
                decoration: InputDecoration(labelText: "Location"),
                onSaved: (val) => _location = val ?? "",
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
              widget.onAdd(EditClassDto(
                name: _name,
                description: _description,
                location: _location,
                startDate: _startDate,
                endDate: _endDate,
                maxParticipants: _maxParticipants,
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
