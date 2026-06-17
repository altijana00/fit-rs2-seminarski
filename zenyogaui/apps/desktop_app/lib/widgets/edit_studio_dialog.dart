import 'package:core/dto/requests/edit_studio_dto.dart';
import 'package:core/dto/responses/studio_response_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


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
  double? _membershipPrice;


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Edit Studio"),
      content: Form(
        key: _formKey,

        child: SingleChildScrollView(
          child: Column(
            spacing: 12.0,
            children: [

              TextFormField(
                controller: TextEditingController(text: widget.studioToEdit.name),
                decoration: InputDecoration(labelText: "Studio Name"),
                onSaved: (val) => _name = val ?? "",
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Studio name is required!";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: TextEditingController(text: widget.studioToEdit.description),
                decoration: InputDecoration(labelText: "Description"),
                maxLines: 3,
                onSaved: (val) => _description = val ?? "",
                validator: (value) {
                  if (value != null && value.length > 300) {
                    return "Description can't have more than 300 characters.";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: TextEditingController(text: widget.studioToEdit.address),
                decoration: InputDecoration(labelText: "Address"),
                onSaved: (val) => _address = val ?? "",
                validator: (value) {
                  if (value != null && value.length > 100) {
                    return "Address can't have more than 100 characters.";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: TextEditingController(text: widget.studioToEdit.contactEmail),
                decoration: InputDecoration(labelText: "Contact Email"),
                onSaved: (val) => _contactEmail = val ?? "",
                validator: (value) {
                  if (value == null || value.isEmpty) return null;

                  final emailRegex =
                  RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

                  if (!emailRegex.hasMatch(value)) {
                    return "Please enter a valid email format (studio@example.com)";
                  }

                  return null;
                },
              ),
              TextFormField(
                controller: TextEditingController(text: widget.studioToEdit.contactPhone),
                decoration: InputDecoration(labelText: "Contact Phone"),
                onSaved: (val) => _contactPhone = val ?? "",
                validator: (value) {
                  if (value == null || value.isEmpty) return null;

                  if (value.length < 6) {
                    return "Please enter a valid phone format.";
                  }

                  return null;
                },
              ),

              TextFormField(
                initialValue: widget.studioToEdit.membershipPrice.toString(),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                decoration: const InputDecoration(labelText: "Membership Price", hintText: "e.g. 49.99"),
                onSaved: (value) => _membershipPrice = double.tryParse(value ?? '')!,

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
                membershipPrice: _membershipPrice
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
