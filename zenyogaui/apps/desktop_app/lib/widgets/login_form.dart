import 'package:core/services/providers/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class LoginForm extends StatefulWidget {
  final void Function(String role)? onLoginSuccess; // callback to navigate by role

  const LoginForm({this.onLoginSuccess, super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
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

    final success = await provider.login(_emailCtrl.text.trim(), _passwordCtrl.text.trim());



    if(success){
      final user = provider.user;
      if(user != null) {
        switch(user.roleId) {
          case 1:
            Navigator.pushReplacementNamed(context, '/adminDashboard', arguments: user);
            break;
          case 2:
            Navigator.pushReplacementNamed(context, '/ownerDashboard', arguments: user);
            break;
          case 3:
          Navigator.pushReplacementNamed(context, '/instructorDashboard', arguments: user);
          break;
          default:
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Unknown role!")),
            );

        }
      }
    } else {
      final snackMsg = provider.error ?? 'Login failed';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(snackMsg)));
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('assets/logo.png', height: 84),
        SizedBox(height: 12),
        Text('Log in',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        SizedBox(height: 14),
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailCtrl,
                decoration: InputDecoration(labelText: 'Email:', hintText: 'Email'),
                validator: _validateEmail,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _passwordCtrl,
                decoration: InputDecoration(labelText: 'Password:', hintText: 'Password'),
                obscureText: true,
                validator: _validatePassword,
              ),
              SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: provider.isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                  onPressed: _submit,
                  child: Text('Log in'),
                ),
              ),
              SizedBox(height: 12),
              GestureDetector(
                onTap: () {

                  Navigator.of(context).pushNamed('/signup');
                },
                child: Text('Not a member? Sign up.', style: TextStyle(decoration: TextDecoration.underline)),
              )
            ],
          ),
        ),
      ],
    );
  }
}