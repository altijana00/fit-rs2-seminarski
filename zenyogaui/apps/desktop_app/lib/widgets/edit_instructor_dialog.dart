// import 'dart:io';
//
// import 'package:core/dto/requests/edit_instructor_dto.dart';
// import 'package:core/dto/requests/edit_user_dto.dart';
// import 'package:core/dto/responses/instructor_response_dto.dart';
// import 'package:core/dto/responses/user_response_dto.dart';
// import 'package:core/repositories/user_repository.dart';
// import 'package:core/services/providers/user_service.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
//
// import '../core/theme.dart';
//
//
// class EditInstructorDialog extends StatefulWidget {
//   final InstructorResponseDto instructorToEdit;
//   final Function(EditInstructorDto) onEdit;
//
//
//   const EditInstructorDialog({super.key, required this.instructorToEdit, required this.onEdit});
//
//   @override
//   State<EditInstructorDialog> createState() => _EditInstructorDialogState();
// }
//
// class _EditInstructorDialogState extends State<EditInstructorDialog> {
//   final _formKey = GlobalKey<FormState>();
//
//   String _firstName="";
//   String _lastName="";
//   String _email="";
//   String _diplomas="";
//   String _certificates="";
//   String _biography="";
//
//
//   @override
//   Widget build(BuildContext context) {
//     final userProvider = context.read<UserProvider>();
//     return Column (
//       children: [
//         Stack(
//           alignment: Alignment.bottomRight,
//           children: [
//             CircleAvatar(
//               radius: 60,
//               backgroundImage: widget.instructorToEdit.profileImageUrl != null
//                   ? NetworkImage(widget.instructorToEdit.profileImageUrl!)
//                   : null,
//               child: widget.instructorToEdit.profileImageUrl == null
//                   ? const Icon(Icons.person, size: 60)
//                   : null,
//             ),
//             Positioned(
//               child: IconButton(
//                 icon: const Icon(Icons.edit),
//                 onPressed: () async {
//                   final picked = await ImagePicker().pickImage(
//                     source: ImageSource.gallery,
//                     imageQuality: 85,
//                   );
//                     if (picked != null) {
//                       final file = await File(picked.path);
//                       final newPhotoUrl = await userProvider.repository.uploadUserPhoto(file);
//                       await userProvider.repository.editUserPhoto(newPhotoUrl, widget.instructorToEdit.id);
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text("Profile photo updated successfully!"),
//                           backgroundColor: AppColors.deepGreen,
//                         ),
//                       );
//                       userProvider.notifyListeners();
//                     }
//
//
//                 },
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 24),
//         AlertDialog(
//         title: Text("Edit Instructor"),
//         content: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//         child: Column(
//         children: [
//
//         TextFormField(
//         controller: TextEditingController(text: widget.instructorToEdit.firstName),
//         decoration: InputDecoration(labelText: "First Name"),
//         onSaved: (val) => _firstName = val ?? "",
//         validator: (val) => val!.isEmpty ? "Enter first name" : null,
//         ),
//         TextFormField(
//         controller: TextEditingController(text: widget.instructorToEdit.lastName),
//     decoration: InputDecoration(labelText: "Last Name"),
//     onSaved: (val) => _lastName = val ?? "",
//     validator: (val) => val!.isEmpty ? "Enter last name" : null,
//     ),
//     TextFormField(
//     controller: TextEditingController(text: widget.instructorToEdit.email),
//     decoration: InputDecoration(labelText: "Email"),
//     onSaved: (val) => _email = val ?? "",
//     validator: (val) => val!.isEmpty ? "Enter email" : null,
//     ),
//     TextFormField(
//     controller: TextEditingController(text: widget.instructorToEdit.biography.toString()),
//     decoration: InputDecoration(labelText: "Biography"),
//     onSaved: (val) => _biography = val ?? "",
//     validator: (val) => val!.isEmpty ? "Add biography" : null,
//     ),
//     TextFormField(
//     controller: TextEditingController(text: widget.instructorToEdit.certificates.toString()),
//     decoration: InputDecoration(labelText: "Certificates"),
//     onSaved: (val) => _certificates = val ?? "",
//     validator: (val) => val!.isEmpty ? "Add certificates" : null,
//     ),
//     TextFormField(
//     controller: TextEditingController(text: widget.instructorToEdit.diplomas.toString()),
//     decoration: InputDecoration(labelText: "Diplomas"),
//     onSaved: (val) => _diplomas = val ?? "",
//     validator: (val) => val!.isEmpty ? "Add diplomas" : null,
//     ),
//
//     ],
//     ),
//     ),
//     ),
//     actions: [
//     TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
//     ElevatedButton(
//     onPressed: () {
//     if (_formKey.currentState!.validate()) {
//     _formKey.currentState!.save();
//     widget.onEdit(EditInstructorDto(
//     firstName: _firstName,
//     lastName: _lastName,
//     email: _email,
//     biography: _biography,
//     diplomas: _diplomas,
//     certificates: _certificates
//
//     ));
//     Navigator.pop(context);
//
//     }
//     },
//     child: Text("Edit"),
//     ),
//     ],
//     )],
//     );
//   }
// }

import 'dart:io';

import 'package:core/dto/requests/edit_instructor_dto.dart';
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

  String _firstName = "";
  String _lastName = "";
  String _email = "";
  String _diplomas = "";
  String _certificates = "";
  String _biography = "";

  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _profileImageUrl = widget.instructorToEdit.profileImageUrl;
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
              icon: const Icon(Icons.edit),
              onPressed: () async {
                final picked = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 85,
                );

                if (picked == null) return;

                final file = File(picked.path);

                final newPhotoUrl =
                await userProvider.repository.uploadUserPhoto(file);

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
          title: const Text("Edit Instructor"),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    initialValue: widget.instructorToEdit.firstName,
                    decoration: const InputDecoration(labelText: "First Name"),
                    onSaved: (val) => _firstName = val ?? "",
                    validator: (val) =>
                    val == null || val.isEmpty ? "Enter first name" : null,
                  ),
                  TextFormField(
                    initialValue: widget.instructorToEdit.lastName,
                    decoration: const InputDecoration(labelText: "Last Name"),
                    onSaved: (val) => _lastName = val ?? "",
                    validator: (val) =>
                    val == null || val.isEmpty ? "Enter last name" : null,
                  ),
                  TextFormField(
                    initialValue: widget.instructorToEdit.email,
                    decoration: const InputDecoration(labelText: "Email"),
                    onSaved: (val) => _email = val ?? "",
                    validator: (val) =>
                    val == null || val.isEmpty ? "Enter email" : null,
                  ),
                  TextFormField(
                    initialValue: widget.instructorToEdit.biography ?? "",
                    decoration: const InputDecoration(labelText: "Biography"),
                    onSaved: (val) => _biography = val ?? "",
                    validator: (val) =>
                    val == null || val.isEmpty ? "Add biography" : null,
                  ),
                  TextFormField(
                    initialValue: widget.instructorToEdit.certificates ?? "",
                    decoration: const InputDecoration(labelText: "Certificates"),
                    onSaved: (val) => _certificates = val ?? "",
                    validator: (val) =>
                    val == null || val.isEmpty ? "Add certificates" : null,
                  ),
                  TextFormField(
                    initialValue: widget.instructorToEdit.diplomas ?? "",
                    decoration: const InputDecoration(labelText: "Diplomas"),
                    onSaved: (val) => _diplomas = val ?? "",
                    validator: (val) =>
                    val == null || val.isEmpty ? "Add diplomas" : null,
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

                _formKey.currentState!.save();

                widget.onEdit(
                  EditInstructorDto(
                    firstName: _firstName,
                    lastName: _lastName,
                    email: _email,
                    biography: _biography,
                    diplomas: _diplomas,
                    certificates: _certificates,
                  ),
                );

                Navigator.pop(context);
              },
              child: const Text("Edit"),
            ),
          ],
        ),
      ],
    );
  }
}
