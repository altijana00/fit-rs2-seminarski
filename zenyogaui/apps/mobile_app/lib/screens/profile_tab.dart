import 'package:core/dto/requests/edit_user_dto.dart';
import 'package:core/dto/requests/update_user_password_dto.dart';
import 'package:core/dto/responses/user_response_dto.dart';
import 'package:core/services/providers/auth_service.dart';
import 'package:core/services/providers/user_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../firebase_options.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  late Future<UserResponseDto> _userFuture;
  final _formKey = GlobalKey<FormState>();


  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUser();



    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final title = message.notification?.title ?? "Bez naslova";
      final body = message.notification?.body ?? "Bez poruke";

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("$title\n$body"),
          duration: const Duration(seconds: 4),
        ),
      );
    });
  }

  void _loadUser() {
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.user!;
    setState(() {
      _userFuture = Future.value(user);
    });
  }

  Future<void> _saveChanges(int userId) async {
    if (!_formKey.currentState!.validate()) return;

    final editDto = EditUserDto(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
    );

    await context.read<UserProvider>().repository.editUser(editDto, userId);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Profile updated"),
        backgroundColor: AppColors.deepGreen,
      ),
    );

    // Refresh user from backend
    final updatedUser = await context.read<UserProvider>().repository.getUser(userId);
    // Update AuthProvider.user as well so other tabs get new data
    context.read<AuthProvider>().user = updatedUser;

    _loadUser(); // rebuild FutureBuilder
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();

    return FutureBuilder<UserResponseDto>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final user = snapshot.data!;
          _firstNameController.text = user.firstName;
          _lastNameController.text = user.lastName;
          _emailController.text = user.email;

          return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                // ================= PROFILE PICTURE =================
                Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: user.profileImageUrl != null
                        ? NetworkImage(user.profileImageUrl!)
                        : null,
                    child: user.profileImageUrl == null
                        ? const Icon(Icons.person, size: 60)
                        : null,
                  ),
                  Positioned(
                    child: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        // TODO: implement profile image edit
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ================= USER FORM =================
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _firstNameController,
                          decoration: const InputDecoration(labelText: "First Name"),
                          validator: (v) => v == null || v.isEmpty ? "Required" : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _lastNameController,
                          decoration: const InputDecoration(labelText: "Last Name"),
                          validator: (v) => v == null || v.isEmpty ? "Required" : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(labelText: "Email"),
                          validator: (v) =>
                          v == null || !v.contains("@") ? "Enter valid email" : null,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () => _openUpdatePasswordModal(context),
                          child: const Text("Update password"),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () => _saveChanges(user.id),
                          child: const Text("Save Changes"),
                        ),
                        const SizedBox(height: 24),


                        // ================= LOGOUT =================
                        OutlinedButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            await context.read<AuthProvider>().logout();

                            if (!context.mounted) return;

                            Navigator.of(context).pushNamedAndRemoveUntil(
                              '/',
                                  (_) => false,
                            );
                          },
                          child: const Text("Logout"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          );
        },
    );
  }

  void _openUpdatePasswordModal(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    String _oldPassword = '';
    String _newPassword = '';
    String _confirmPassword = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Update password"),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Old password",
                  ),
                  onSaved: (v) => _oldPassword = v ?? '',
                ),
                const SizedBox(height: 12),

                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "New password",
                  ),
                  onSaved: (v) => _newPassword = v ?? '',
                ),
                const SizedBox(height: 12),

                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Confirm new password",
                  ),

                  onSaved: (v) => _confirmPassword = v ?? '',
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
              onPressed: () async {

                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  final updto = UpdateUserPasswordDto(
                    id: context.read<AuthProvider>().user!.id,
                    oldPassword: _oldPassword,
                    newPassword: _newPassword,
                  );


                  await FirebaseMessaging.instance.requestPermission();
                  final token = await FirebaseMessaging.instance.getToken();

                  await context
                      .read<UserProvider>()
                      .repository
                      .updateUserPassword(updto, token!);

                  Navigator.pop(context);
                  await context.read<AuthProvider>().logout();

                  if (!context.mounted) return;

                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/',
                        (_) => false,
                  );
                }

                },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

}

