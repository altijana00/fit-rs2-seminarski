import 'package:core/dto/requests/edit_user_dto.dart';
import 'package:core/dto/requests/update_your_user_password_dto.dart';
import 'package:core/dto/responses/user_response_dto.dart';
import 'package:core/services/providers/auth_service.dart';
import 'package:core/services/providers/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';


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

    try
    {
      await context.read<UserProvider>().repository.editUser(editDto, userId);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profile updated"),
          backgroundColor: AppColors.deepGreen,
        ),
      );


      final updatedUser = await context.read<UserProvider>().repository.getUser(userId);
      context.read<AuthProvider>().user = updatedUser;
      _loadUser();
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

                ],
              ),
              const SizedBox(height: 24),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _firstNameController,
                          decoration: const InputDecoration(labelText: "First Name"),
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
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _lastNameController,
                          decoration: const InputDecoration(labelText: "Last Name"),
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
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _emailController,
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
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () => _openUpdatePasswordModal(context),
                          style: ElevatedButton.styleFrom(fixedSize: const Size(130, 50)),
                          child: const Text("Update password"),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () => _saveChanges(user.id),
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.deepGreen, fixedSize: const Size(110, 50)),
                          child: const Text("Save Changes"),

                        ),
                        const SizedBox(height: 24),

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
    final formKey = GlobalKey<FormState>();

    String oldPassword = '';
    String newPassword = '';


    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Update password"),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Old password",
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Old password is required!';
                    }
                    return null;
                  },
                  onSaved: (v) => oldPassword = v ?? '',
                ),
                const SizedBox(height: 12),

                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "New password",
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'New password is required!';
                    }
                    return null;
                  },
                  onSaved: (v) => newPassword = v ?? '',
                ),
                const SizedBox(height: 12),


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

                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();

                  final updto = UpdateYourUserPasswordDto(
                    oldPassword: oldPassword,
                    newPassword: newPassword,
                  );


                  try
                  {
                    await context
                        .read<UserProvider>()
                        .repository
                        .updateYourUserPassword(updto);


                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Password updated successfully!"),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );


                    await Future.delayed(const Duration(seconds: 2));
                    Navigator.pop(context);

                    await context.read<AuthProvider>().logout();

                    if (!context.mounted) return;

                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/',
                          (_) => false,
                    );
                  }catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString().replaceFirst('Exception: ', '')),
                        backgroundColor: AppColors.darkRed,
                      ),
                    );
                  }

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

