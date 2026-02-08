import 'package:core/services/providers/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginFormMobile extends StatefulWidget {
  final VoidCallback? onLoginSuccess;

  const LoginFormMobile({this.onLoginSuccess, super.key});

  @override
  State<LoginFormMobile> createState() => _LoginFormMobileState();
}

class _LoginFormMobileState extends State<LoginFormMobile> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final provider = Provider.of<AuthProvider>(context, listen: false);
    if (!_formKey.currentState!.validate()) return;

    final success = await provider.login(
      _emailCtrl.text.trim(),
      _passwordCtrl.text.trim(),
    );

    if (success) {
      widget.onLoginSuccess?.call();
    } else {
      final snackMsg = provider.error ?? 'Login failed';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(snackMsg)),
      );
    }
  }

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email required';
    if (!v.contains('@')) return 'Invalid email';
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Password required';
    if (v.length < 4) return 'Password too short';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png', height: 100),
            const SizedBox(height: 24),
            Text(
              'Log in',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter your email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: _validateEmail,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                    validator: _validatePassword,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: provider.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                      onPressed: _submit,
                      child: const Text('Log in'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed('/signup');
                    },
                    child: const Text(
                      'Not a member? Sign up.',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
