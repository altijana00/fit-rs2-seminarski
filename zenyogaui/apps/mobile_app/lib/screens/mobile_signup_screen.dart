import 'package:core/dto/responses/city_response_dto.dart';
import 'package:core/models/city_model.dart';
import 'package:core/services/providers/city_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/signup_form.dart';


class MobileSignupScreen extends StatelessWidget {
  const MobileSignupScreen({super.key});



  Future<List<CityModel>> _loadCities(BuildContext context) async {
    final cityProvider = context.read<CityProvider>();
    return await cityProvider.repository.getAllCities();
  }

  void _navigateToHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<CityModel>>( // ✅ FIX
        future: _loadCities(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                textAlign: TextAlign.center,
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No cities found'));
          }

          final cities = snapshot.data!;

          return Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/login-back.png',
                  fit: BoxFit.cover,
                ),
              ),
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 420),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 12,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: SignupFormMobile(
                        cities: cities,
                        onSignupSuccess: () => _navigateToHome(context),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
