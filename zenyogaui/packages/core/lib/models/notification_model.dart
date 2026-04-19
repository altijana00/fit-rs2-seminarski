class AppNotification {
  final String title;
  final String message;
  final String type; // info | success | warning | error

  AppNotification({
    required this.title,
    required this.message,
    this.type = 'info',
  });

  factory AppNotification.fromMap(Map<String, dynamic> map) => AppNotification(
    title: map['title'] ?? '',
    message: map['message'] ?? '',
    type: map['type'] ?? 'info',
  );
}