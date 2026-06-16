
import 'dart:io';

import 'package:core/dto/requests/edit_user_dto.dart';
import 'package:core/dto/requests/update_user_password_as_admin_dto.dart';
import 'package:core/dto/requests/update_your_user_password_dto.dart';
import 'package:core/dto/responses/user_response_dto.dart';
import 'package:core/services/providers/user_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../core/theme.dart';

class EditUserAsAdminDialog extends StatefulWidget {
  final UserResponseDto userToEdit;
  final Function(EditUserDto) onEdit;

  const EditUserAsAdminDialog({
    super.key,
    required this.userToEdit,
    required this.onEdit,
  });

  @override
  State<EditUserAsAdminDialog> createState() => _EditUserAsAdminDialogState();
}

class _EditUserAsAdminDialogState extends State<EditUserAsAdminDialog> {


  late TextEditingController _firstNameCtrl;
  late TextEditingController _lastNameCtrl;
  late TextEditingController _genderCtrl;
  late TextEditingController _emailCtrl;

  final TextEditingController _newPasswordCtrl = TextEditingController();

  String? _profileImageUrl;

  bool _isChangingPassword = false;

  @override
  void initState() {
    super.initState();

    _profileImageUrl = widget.userToEdit.profileImageUrl;

    _firstNameCtrl = TextEditingController(text: widget.userToEdit.firstName);
    _lastNameCtrl = TextEditingController(text: widget.userToEdit.lastName);
    _genderCtrl = TextEditingController(text: widget.userToEdit.gender.toString());
    _emailCtrl = TextEditingController(text: widget.userToEdit.email);
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _genderCtrl.dispose();
    _emailCtrl.dispose();
    _newPasswordCtrl.dispose();
    super.dispose();
  }

  Future<void> _changePassword(BuildContext context) async {
    final userProvider = context.read<UserProvider>();

    if (_newPasswordCtrl.text.trim().isEmpty) return;

    final dto = UpdateUserPasswordAsAdminDto(
      id: widget.userToEdit.id,
      newPassword: _newPasswordCtrl.text.trim(),
    );

    try
    {
      await userProvider.repository.updateUserPasswordAsAdmin(dto);

      if (!context.mounted) return;

      setState(() {
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
      title: const Text("Edit User Profile"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            /// PROFILE IMAGE
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 55,
                  backgroundImage: _profileImageUrl != null
                      ? NetworkImage(_profileImageUrl!)
                      : null,
                  child: _profileImageUrl == null
                      ? const Icon(Icons.person, size: 50)
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
                      widget.userToEdit.id,
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

            /// PROFILE FIELDS
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Text(
                    "Gender",
                    style: TextStyle(
                      fontSize: 12,

                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text("M"),
                        value: "M",
                        groupValue: _genderCtrl.text,
                        onChanged: (val) {
                          setState(() {
                            _genderCtrl.text = val!;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text("F"),
                        value: "F",
                        groupValue: _genderCtrl.text,
                        onChanged: (val) {
                          setState(() {
                            _genderCtrl.text = val!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            /// PASSWORD SECTION
            ExpansionTile(
              title: const Text("Change Password"),
              initiallyExpanded: _isChangingPassword,
              onExpansionChanged: (val) {
                setState(() => _isChangingPassword = val);
              },
              children: [
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
              EditUserDto(
                firstName: _firstNameCtrl.text,
                lastName: _lastNameCtrl.text,
                email: _emailCtrl.text,
                gender: _genderCtrl.text,
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