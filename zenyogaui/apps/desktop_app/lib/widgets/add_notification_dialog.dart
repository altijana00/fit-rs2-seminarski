import 'package:core/dto/requests/add_notification_dto.dart';
import 'package:flutter/material.dart';
import 'package:core/dto/notification_type_enum.dart';


class AddNotificationDialog extends StatefulWidget {
  final Function(AddNotificationDto) onAddDto;
  final int userId;

  const AddNotificationDialog({super.key, required this.onAddDto, required this.userId});

  @override
  State<AddNotificationDialog> createState() => _AddNotificationDialogState();
}

class _AddNotificationDialogState extends State<AddNotificationDialog> {
  final _formKey = GlobalKey<FormState>();

  String _title="";
  String? _content="";

  final List<NotificationType> _types = NotificationType.values;
  NotificationType? _selectedType;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Send Notification"),
      content: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          child: Column(
            spacing: 12.0,
            children: [

              TextFormField(
                decoration: const InputDecoration(labelText: "Notification Title"),
                onSaved: (val) => _title = val ?? "",
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return "Enter a title";
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Content"),
                onSaved: (val) => _content = val ?? "",
              ),
              DropdownButtonFormField<NotificationType>(
                value: _selectedType,
                items: _types.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedType = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return "Please select notification type";
                  }
                  return null;
                },
                onSaved: (value) {
                  _selectedType = value;
                },
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
              widget.onAddDto(AddNotificationDto(
                userId: widget.userId,
                title: _title,
                content: _content,
                type: _selectedType?.name ?? "",

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
