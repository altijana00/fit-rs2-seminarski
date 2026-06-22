import 'dart:io';
import 'package:core/dto/requests/edit_user_dto.dart';
import 'package:core/dto/requests/update_your_user_password_dto.dart';
import 'package:core/dto/responses/user_response_dto.dart';
import 'package:core/services/providers/auth_service.dart';
import 'package:core/services/providers/user_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';

class EditUserDialog extends StatefulWidget {
  final UserResponseDto userToEdit;
  final Function(EditUserDto) onEdit;

  const EditUserDialog({
    super.key,
    required this.userToEdit,
    required this.onEdit,
  });

  @override
  State<EditUserDialog> createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<EditUserDialog> {
  late TextEditingController _firstNameCtrl;
  late TextEditingController _lastNameCtrl;
  late TextEditingController _genderCtrl;
  late TextEditingController _emailCtrl;

  final TextEditingController _oldPasswordCtrl = TextEditingController();
  final TextEditingController _newPasswordCtrl = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String? _profileImageUrl;
  bool _isChangingPassword = false;

  @override
  void initState() {
    super.initState();

    _profileImageUrl = widget.userToEdit.profileImageUrl;

    _firstNameCtrl =
        TextEditingController(text: widget.userToEdit.firstName);
    _lastNameCtrl =
        TextEditingController(text: widget.userToEdit.lastName);
    _genderCtrl =
        TextEditingController(text: widget.userToEdit.gender.toString());
    _emailCtrl =
        TextEditingController(text: widget.userToEdit.email);
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _genderCtrl.dispose();
    _emailCtrl.dispose();
    _newPasswordCtrl.dispose();
    _oldPasswordCtrl.dispose();
    super.dispose();
  }

  Future _changePassword(BuildContext context) async {
    final userProvider = context.read<UserProvider>();

    if (_oldPasswordCtrl.text.trim().isEmpty || _newPasswordCtrl.text.trim().isEmpty) return;

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

    }catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: AppColors.darkRed,
        ),
      );
    }

    if (!context.mounted) return;

    Navigator.of(context).pop();

    await context.read<AuthProvider>().logout();

    if (!context.mounted) return;

    Navigator.of(context).pushNamedAndRemoveUntil(
      '/',
          (_) => false,
    );


  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.read<UserProvider>();

    return AlertDialog(
      title: const Text("Edit User Profile"),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: _firstNameCtrl,
                decoration:
                const InputDecoration(labelText: "First Name"),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'First name is required!';
                  }
                  if (v.trim().length > 30) {
                    return "Must be less than 30 characters.";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: _lastNameCtrl,
                decoration:
                const InputDecoration(labelText: "Last Name"),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Last name is required!';
                  }
                  if (v.trim().length > 30) {
                    return "Must be less than 30 characters.";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: _emailCtrl,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Email is required!';
                  }

                  final emailRegex = RegExp(
                    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                  );

                  if (!emailRegex.hasMatch(v.trim())) {
                    return 'Please enter a valid email format.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 10),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Text("Gender", style: TextStyle(fontSize: 12)),
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

              ExpansionTile(
                title: const Text("Change Password"),
                initiallyExpanded: _isChangingPassword,
                onExpansionChanged: (val) {
                  setState(() => _isChangingPassword = val);
                },
                children: [
                  TextFormField(
                    controller: _oldPasswordCtrl,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Current Password",
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Current password is required!';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _newPasswordCtrl,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "New Password",
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'New password is required!';
                      }
                      return null;
                    },
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
      ),

      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),

        ElevatedButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;

            widget.onEdit(
              EditUserDto(
                firstName: _firstNameCtrl.text.trim(),
                lastName: _lastNameCtrl.text.trim(),
                email: _emailCtrl.text.trim(),
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