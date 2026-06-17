import 'dart:io';
import 'package:core/core/app_config.dart';
import 'package:mobile_app/screens/settings_screen.dart';
import 'core/theme.dart';
import 'package:core/repositories/app_analytics_repository.dart';
import 'package:core/repositories/auth_repository.dart';
import 'package:core/repositories/city_repository.dart';
import 'package:core/repositories/class_repository.dart';
import 'package:core/repositories/notification_repository.dart';
import 'package:core/repositories/payment_repository.dart';
import 'package:core/repositories/user_class_repository.dart';
import 'package:core/repositories/instructor_repository.dart';
import 'package:core/repositories/role_repository.dart';
import 'package:core/repositories/studio_repository.dart';
import 'package:core/repositories/user_repository.dart';
import 'package:core/repositories/yoga-type_repository.dart';
import 'package:core/services/app_analytics_api_service.dart';
import 'package:core/services/auth_api_service.dart';
import 'package:core/services/city_api_service.dart';
import 'package:core/services/class_api_service.dart';
import 'package:core/services/instructor_api_service.dart';
import 'package:core/services/notification_api_service.dart';
import 'package:core/services/payment_api_service.dart';
import 'package:core/services/providers/app_analytics_service.dart';
import 'package:core/services/providers/auth_service.dart';
import 'package:core/services/providers/city_service.dart';
import 'package:core/services/providers/class_service.dart';
import 'package:core/services/providers/instructor_service.dart';
import 'package:core/services/providers/notification_service.dart';
import 'package:core/services/providers/payment_service.dart';
import 'package:core/services/providers/role_service.dart';
import 'package:core/services/providers/studio_service.dart';
import 'package:core/services/providers/user_class_service.dart';
import 'package:core/services/providers/user_service.dart';
import 'package:core/services/providers/yoga-type_service.dart';
import 'package:core/services/role_api_service.dart';
import 'package:core/services/user_class_api_service.dart';
import 'package:core/services/studio_api_service.dart';
import 'package:core/services/user_api_service.dart';
import 'package:core/services/yoga-type_api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:mobile_app/screens/mobile_home_screen.dart';
import 'package:mobile_app/screens/mobile_login_screen.dart';
import 'package:mobile_app/screens/mobile_signup_screen.dart';
import 'package:mobile_app/screens/user_notification_center.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';



final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final RouteObserver<ModalRoute<dynamic>> routeObserver =
RouteObserver<ModalRoute<dynamic>>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = AppConfig.stripeKey;

  final dio = Dio(BaseOptions(
      baseUrl: AppConfig.mobileApiBaseUrl,
      validateStatus: (status) => true));
  final secureStorage = const FlutterSecureStorage();

  (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
    final client = HttpClient();
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return client;
  };

  // services
  final authApiService = AuthApiService(dio);
  final userApiService = UserApiService(dio);
  final studioApiService = StudioApiService(dio);
  final classApiService = ClassApiService(dio);
  final instructorApiService = InstructorApiService(dio);
  final cityApiService = CityApiService(dio);
  final roleApiService = RoleApiService(dio);
  final yogaTypeApiService = YogaTypeApiService(dio);
  final appAnalyticsApiService = AppAnalyticsApiService(dio);
  final userClassApiService = UserClassApiService(dio);
  final paymentApiService = PaymentApiService(dio);
  final notificationApiService = NotificationApiService(dio);

  // repositories
  final authRepository = AuthRepository(authApiService);
  final userRepository = UserRepository(userApiService);
  final studioRepository = StudioRepository(studioApiService);
  final classRepository = ClassRepository(classApiService);
  final instructorRepository = InstructorRepository(instructorApiService);
  final cityRepository = CityRepository(cityApiService);
  final roleRepository = RoleRepository(roleApiService);
  final yogaTypeRepository = YogaTypeRepository(yogaTypeApiService);
  final appAnalyticsRepository = AppAnalyticsRepository(appAnalyticsApiService);
  final userClassRepository = UserClassRepository(userClassApiService);
  final paymentRepository = PaymentRepository(paymentApiService);
  final notificationRepository = NotificationRepository(notificationApiService);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
              repository: authRepository,
              dio: dio,
              storage: secureStorage,
              userRepository: userRepository),
        ),
        ChangeNotifierProvider(
            create: (_) =>
                UserProvider(repository: userRepository, dio: dio, storage: secureStorage)),
        ChangeNotifierProvider(
            create: (_) => InstructorProvider(
                repository: instructorRepository, dio: dio, storage: secureStorage)),
        ChangeNotifierProvider(
            create: (_) => StudioProvider(
                repository: studioRepository, dio: dio, storage: secureStorage)),
        ChangeNotifierProvider(
            create: (_) => ClassProvider(
                repository: classRepository, dio: dio, storage: secureStorage)),
        ChangeNotifierProvider(
            create: (_) => CityProvider(
                repository: cityRepository, dio: dio, storage: secureStorage)),
        ChangeNotifierProvider(
            create: (_) => RoleProvider(
                repository: roleRepository, dio: dio, storage: secureStorage)),
        ChangeNotifierProvider(
            create: (_) => YogaTypeProvider(
                repository: yogaTypeRepository, dio: dio, storage: secureStorage)),
        ChangeNotifierProvider(
            create: (_) => AppAnalyticsProvider(
                repository: appAnalyticsRepository, dio: dio, storage: secureStorage)),
        ChangeNotifierProvider(
            create: (_) => UserClassProvider(
                repository: userClassRepository, dio: dio, storage: secureStorage)),
        ChangeNotifierProvider(
            create: (_) => PaymentProvider(
                repository: paymentRepository, dio: dio, storage: secureStorage)),
        ChangeNotifierProvider(
            create: (_) => NotificationProvider(
                repository: notificationRepository, dio: dio, storage: secureStorage)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode') ?? false;
    if (!mounted) return;
    setState(() {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  Future<void> _toggleTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDark);
    if (!mounted) return;
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      navigatorObservers: [routeObserver],
      title: 'Zen&Yoga',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
     darkTheme: darkAppTheme,
     themeMode: _themeMode,
      initialRoute: '/',
      routes: {
        '/': (_) => MobileLoginScreen(),
        '/signup': (_) => MobileSignupScreen(),
        '/home': (_) => AppShell(onThemeChanged: _toggleTheme),
        '/notifications': (_) => const UserNotificationCenter(),
        '/settings' : (_) => SettingsScreen(onThemeChanged: _toggleTheme),
      },
    );
  }
}
