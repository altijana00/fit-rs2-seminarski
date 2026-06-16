import 'dart:io';

import 'package:core/dto/requests/edit_instructor_dto.dart';
import 'package:core/dto/requests/update_your_user_password_dto.dart';
import 'package:core/dto/responses/instructor_response_dto.dart';
import 'package:core/services/providers/user_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../core/theme.dart';

class EditInstructorDialog extends StatefulWidget {
  final InstructorResponseDto instructorToEdit;
  final Function(EditInstructorDto) onEdit;

  const EditInstructorDialog({
    super.key,
    required this.instructorToEdit,
    required this.onEdit,
  });

  @override
  State<EditInstructorDialog> createState() => _EditInstructorDialogState();
}

class _EditInstructorDialogState extends State<EditInstructorDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _firstNameCtrl;
  late TextEditingController _lastNameCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _diplomasCtrl;
  late TextEditingController _certificatesCtrl;
  late TextEditingController _biographyCtrl;

  final TextEditingController _oldPasswordCtrl = TextEditingController();
  final TextEditingController _newPasswordCtrl = TextEditingController();

  String? _profileImageUrl;
  String? _gender;

  bool _isChangingPassword = false;

  @override
  void initState() {
    super.initState();

    _profileImageUrl = widget.instructorToEdit.profileImageUrl;
    _gender = widget.instructorToEdit.gender;

    _firstNameCtrl =
        TextEditingController(text: widget.instructorToEdit.firstName);
    _lastNameCtrl =
        TextEditingController(text: widget.instructorToEdit.lastName);
    _emailCtrl =
        TextEditingController(text: widget.instructorToEdit.email);
    _diplomasCtrl =
        TextEditingController(text: widget.instructorToEdit.diplomas ?? "");
    _certificatesCtrl =
        TextEditingController(text: widget.instructorToEdit.certificates ?? "");
    _biographyCtrl =
        TextEditingController(text: widget.instructorToEdit.biography ?? "");
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _diplomasCtrl.dispose();
    _certificatesCtrl.dispose();
    _biographyCtrl.dispose();
    _oldPasswordCtrl.dispose();
    _newPasswordCtrl.dispose();
    super.dispose();
  }

  Future<void> _changePassword(BuildContext context) async {
    final userProvider = context.read<UserProvider>();

    if (_oldPasswordCtrl.text.trim().isEmpty ||
        _newPasswordCtrl.text.trim().isEmpty) {
      return;
    }

    final dto = UpdateYourUserPasswordDto(
      oldPassword: _oldPasswordCtrl.text.trim(),
      newPassword: _newPasswordCtrl.text.trim(),
    );

    try
    {

      await userProvider.repository.updateYourUserPassword(dto);

      if (!context.mounted) return;

      setState(() {
        _oldPasswordCtrl.clear();
        _newPasswordCtrl.clear();
        _isChangingPassword = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password updated successfully"),
          backgroundColor: AppColors.deepGreen,
        ),
      );
    }
    catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: AppColors.darkRed,
        ),
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.read<UserProvider>();

    return AlertDialog(
      title: const Text("Edit Instructor"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// PROFILE IMAGE
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: _profileImageUrl != null
                      ? NetworkImage(_profileImageUrl!)
                      : null,
                  child: _profileImageUrl == null
                      ? const Icon(Icons.person, size: 60)
                      : null,
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.lavender,
                  ),
                  onPressed: () async {
                    final picked = await ImagePicker().pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 85,
                    );

                    if (picked == null) return;

                    final file = File(picked.path);

                    final newPhotoUrl = await userProvider.repository
                        .uploadUserPhoto(file);

                    await userProvider.repository.editUserPhoto(
                      newPhotoUrl,
                      widget.instructorToEdit.id,
                    );

                    setState(() {
                      _profileImageUrl = newPhotoUrl;
                    });

                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Profile photo updated"),
                        backgroundColor: AppColors.deepGreen,
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// FIELDS
            TextField(
              controller: _firstNameCtrl,
              decoration: const InputDecoration(labelText: "First Name"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _lastNameCtrl,
              decoration: const InputDecoration(labelText: "Last Name"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailCtrl,
              decoration: const InputDecoration(labelText: "Email"),
            ),

            const SizedBox(height: 10),

            /// GENDER
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    "Gender",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text("M"),
                        value: "M",
                        groupValue: _gender,
                        onChanged: (val) {
                          setState(() {
                            _gender = val;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text("F"),
                        value: "F",
                        groupValue: _gender,
                        onChanged: (val) {
                          setState(() {
                            _gender = val;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),

            TextField(
              controller: _biographyCtrl,
              decoration: const InputDecoration(labelText: "Biography"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _certificatesCtrl,
              decoration: const InputDecoration(labelText: "Certificates"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _diplomasCtrl,
              decoration: const InputDecoration(labelText: "Diplomas"),
            ),

            const SizedBox(height: 20),

            /// PASSWORD
            ExpansionTile(
              title: const Text("Change Password"),
              initiallyExpanded: _isChangingPassword,
              onExpansionChanged: (val) {
                setState(() => _isChangingPassword = val);
              },
              children: [
                TextField(
                  controller: _oldPasswordCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Current Password",
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _newPasswordCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "New Password",
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => _changePassword(context),
                  child: const Text("Update Password"),
                ),
              ],
            ),
          ],
        ),
      ),

      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onEdit(
              EditInstructorDto(
                firstName: _firstNameCtrl.text,
                lastName: _lastNameCtrl.text,
                email: _emailCtrl.text,
                gender: _gender,
                biography: _biographyCtrl.text,
                certificates: _certificatesCtrl.text,
                diplomas: _diplomasCtrl.text,
              ),
            );
            Navigator.pop(context);
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}