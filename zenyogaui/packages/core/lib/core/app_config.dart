class AppConfig {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080/api/',
  );

  static const String notificationUrl = String.fromEnvironment(
    'NOTIF_URL',
    defaultValue: 'http://localhost:8080/hubs/notifications',
  );

  static const String mobileApiBaseUrl = String.fromEnvironment(
    'MOBILE_API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8080/api/',
  );

  static const String stripeKey = String.fromEnvironment(
    'STRIPE_PUBLISHABLE_KEY',
    defaultValue: 'pk_test_51SpIJSC1su3FW6hZoRVTn94GOdTOrwYPRzLhy5ZnOnv4xZkaswNIVLusUPOVdFBY2evOKgVzaiEQEqth6UPkzLpy00OPRis5LH',
  );
}