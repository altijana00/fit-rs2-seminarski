import 'dart:io';

import 'package:core/dto/requests/edit_user_dto.dart';
import 'package:core/dto/responses/user_response_dto.dart';
import 'package:core/services/providers/user_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../core/theme.dart';


class EditUserDialog extends StatefulWidget {
  final UserResponseDto userToEdit;
  final Function(EditUserDto) onEdit;


  const EditUserDialog({super.key, required this.userToEdit, required this.onEdit});

  @override
  State<EditUserDialog> createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<EditUserDialog> {
  final _formKey = GlobalKey<FormState>();

  String _firstName="";
  String _lastName="";
  String? _gender="";
  String _email="";
  String? _profileImageUrl;


  @override
  void initState() {
    super.initState();
    _profileImageUrl = widget.userToEdit.profileImageUrl;
  }

  @override
  Widget build(BuildContext context) {

    final userProvider = context.read<UserProvider>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage:
              _profileImageUrl != null ? NetworkImage(_profileImageUrl!) : null,
              child: _profileImageUrl == null
                  ? const Icon(Icons.person, size: 60)
                  : null,
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              style: IconButton.styleFrom(backgroundColor: AppColors.lavender),
              onPressed: () async {
                final picked = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 85,
                );

                if (picked == null) return;

                final file = File(picked.path);

                final newPhotoUrl = await userProvider.repository.uploadUserPhoto(file);

                await userProvider.repository.editUserPhoto(newPhotoUrl, widget.userToEdit.id);

                setState(() {
                  _profileImageUrl = newPhotoUrl;
                });

                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Profile photo updated successfully!"),
                    backgroundColor: AppColors.deepGreen,
                  ),
                );
              },
            ),
          ],
        ),

        const SizedBox(height: 24),
        AlertDialog(
          title: Text("Profile Details"),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [

                  TextFormField(
                    controller: TextEditingController(text: widget.userToEdit.firstName),
                    decoration: InputDecoration(labelText: "First Name"),
                    onSaved: (val) => _firstName = val ?? "",
                    validator: (val) => val!.isEmpty ? "Enter first name" : null,
                  ),
                  TextFormField(
                    controller: TextEditingController(text: widget.userToEdit.lastName),
                    decoration: InputDecoration(labelText: "Last Name"),
                    onSaved: (val) => _lastName = val ?? "",
                    validator: (val) => val!.isEmpty ? "Enter last name" : null,
                  ),
                  TextFormField(
                    controller: TextEditingController(text: widget.userToEdit.gender.toString()),
                    decoration: InputDecoration(labelText: "Gender"),
                    onSaved: (val) => _gender = val ?? "",
                    validator: (val) => val!.isEmpty ? "Enter gender" : null,
                  ),
                  TextFormField(
                    controller: TextEditingController(text: widget.userToEdit.email),
                    decoration: InputDecoration(labelText: "Email"),
                    onSaved: (val) => _email = val ?? "",
                    validator: (val) => val!.isEmpty ? "Enter email" : null,
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
                  widget.onEdit(EditUserDto(
                    firstName: _firstName,
                    lastName: _lastName,
                    email: _email,
                    gender: _gender
                  ));
                  Navigator.pop(context);

                }
              },
              child: Text("Edit"),
            ),
          ],
        )
      ],

    );


  }
}
