
import 'package:core/dto/requests/edit_notification_dto.dart';
import 'package:core/dto/requests/edit_role_dto.dart';
import 'package:core/dto/responses/notification_response_dto.dart';
import 'package:core/dto/responses/role_response_dto.dart';
import 'package:flutter/material.dart';


class EditNotificationDialog extends StatefulWidget {
  final NotificationResponseDto notificationToEdit;
  final Function(EditNotificationDto) onEdit;

  const EditNotificationDialog({super.key, required this.notificationToEdit, required this.onEdit});

  @override
  State<EditNotificationDialog> createState() => _EditNotificationDialogState();
}

class _EditNotificationDialogState extends State<EditNotificationDialog> {
  final _formKey = GlobalKey<FormState>();

  String _title="";
  String _content="";
  String _type="";


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Edit Notification"),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            spacing: 12.0,
            children: [
              TextFormField(
                controller: TextEditingController(text: widget.notificationToEdit.title),
                decoration: InputDecoration(labelText: "Notification Title"),
                onSaved: (val) => _title = val ?? "",
                validator: (val) => val!.isEmpty ? "Enter a title" : null,
              ),
              TextFormField(
                controller: TextEditingController(text: widget.notificationToEdit.content),
                decoration: InputDecoration(labelText: "Notification Content"),
                onSaved: (val) => _content = val ?? "",
                validator: (val) => val!.isEmpty ? "Enter content" : null,
              ),
              TextFormField(
                controller: TextEditingController(text: widget.notificationToEdit.type),
                decoration: InputDecoration(labelText: "Notification Type"),
                onSaved: (val) => _type = val ?? "",
                validator: (val) => val!.isEmpty ? "Enter a type" : null,
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
              widget.onEdit(EditNotificationDto(
                  title: _title,
                  content: _content,
                  type: _type
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
