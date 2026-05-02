// import 'dart:io';
//
// import 'package:core/dto/requests/edit_user_dto.dart';
// import 'package:core/dto/responses/user_response_dto.dart';
// import 'package:core/services/providers/user_service.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
//
// import '../core/theme.dart';
//
//
// class EditUserDialog extends StatefulWidget {
//   final UserResponseDto userToEdit;
//   final Function(EditUserDto) onEdit;
//
//
//   const EditUserDialog({super.key, required this.userToEdit, required this.onEdit});
//
//   @override
//   State<EditUserDialog> createState() => _EditUserDialogState();
// }
//
// class _EditUserDialogState extends State<EditUserDialog> {
//   final _formKey = GlobalKey<FormState>();
//
//   String _firstName="";
//   String _lastName="";
//   String? _gender="";
//   String _email="";
//   String? _profileImageUrl;
//
//
//   @override
//   void initState() {
//     super.initState();
//     _profileImageUrl = widget.userToEdit.profileImageUrl;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     final userProvider = context.read<UserProvider>();
//
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Stack(
//           alignment: Alignment.bottomRight,
//           children: [
//             CircleAvatar(
//               radius: 60,
//               backgroundImage:
//               _profileImageUrl != null ? NetworkImage(_profileImageUrl!) : null,
//               child: _profileImageUrl == null
//                   ? const Icon(Icons.person, size: 60)
//                   : null,
//             ),
//             IconButton(
//               icon: const Icon(Icons.edit, color: Colors.white),
//               style: IconButton.styleFrom(backgroundColor: AppColors.lavender),
//               onPressed: () async {
//                 final picked = await ImagePicker().pickImage(
//                   source: ImageSource.gallery,
//                   imageQuality: 85,
//                 );
//
//                 if (picked == null) return;
//
//                 final file = File(picked.path);
//
//                 final newPhotoUrl = await userProvider.repository.uploadUserPhoto(file);
//
//                 await userProvider.repository.editUserPhoto(newPhotoUrl, widget.userToEdit.id);
//
//                 setState(() {
//                   _profileImageUrl = newPhotoUrl;
//                 });
//
//                 if (!context.mounted) return;
//
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     content: Text("Profile photo updated successfully!"),
//                     backgroundColor: AppColors.deepGreen,
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//
//         const SizedBox(height: 24),
//         AlertDialog(
//           title: Text("Profile Details"),
//           content: Form(
//             key: _formKey,
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//
//                   TextFormField(
//                     controller: TextEditingController(text: widget.userToEdit.firstName),
//                     decoration: InputDecoration(labelText: "First Name"),
//                     onSaved: (val) => _firstName = val ?? "",
//                     validator: (val) => val!.isEmpty ? "Enter first name" : null,
//                   ),
//                   TextFormField(
//                     controller: TextEditingController(text: widget.userToEdit.lastName),
//                     decoration: InputDecoration(labelText: "Last Name"),
//                     onSaved: (val) => _lastName = val ?? "",
//                     validator: (val) => val!.isEmpty ? "Enter last name" : null,
//                   ),
//                   TextFormField(
//                     controller: TextEditingController(text: widget.userToEdit.gender.toString()),
//                     decoration: InputDecoration(labelText: "Gender"),
//                     onSaved: (val) => _gender = val ?? "",
//                     validator: (val) => val!.isEmpty ? "Enter gender" : null,
//                   ),
//                   TextFormField(
//                     controller: TextEditingController(text: widget.userToEdit.email),
//                     decoration: InputDecoration(labelText: "Email"),
//                     onSaved: (val) => _email = val ?? "",
//                     validator: (val) => val!.isEmpty ? "Enter email" : null,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           actions: [
//             TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
//             ElevatedButton(
//               onPressed: () {
//                 if (_formKey.currentState!.validate()) {
//                   _formKey.currentState!.save();
//                   widget.onEdit(EditUserDto(
//                     firstName: _firstName,
//                     lastName: _lastName,
//                     email: _email,
//                     gender: _gender
//                   ));
//                   Navigator.pop(context);
//
//                 }
//               },
//               child: Text("Edit"),
//             ),
//           ],
//         )
//       ],
//
//     );
//
//
//   }
// }
import 'dart:io';

import 'package:core/dto/requests/edit_user_dto.dart';
import 'package:core/dto/requests/update_user_password_dto.dart';
import 'package:core/dto/responses/user_response_dto.dart';
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

    final dto = UpdateUserPasswordDto(
      id: widget.userToEdit.id,
      oldPassword: null,
      newPassword: _newPasswordCtrl.text.trim(),
    );

    await userProvider.repository.updateUserPassword(dto);

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
            TextField(
              controller: _lastNameCtrl,
              decoration: const InputDecoration(labelText: "Last Name"),
            ),
            TextField(
              controller: _genderCtrl,
              decoration: const InputDecoration(labelText: "Gender"),
            ),
            TextField(
              controller: _emailCtrl,
              decoration: const InputDecoration(labelText: "Email"),
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