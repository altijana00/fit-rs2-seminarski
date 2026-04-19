import 'dart:async';
import 'package:core/core/constants.dart';
import 'package:signalr_netcore/signalr_client.dart';

class AppNotification {
  final String title;
  final String message;
  final String type;

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

class SignalRService {
  static const _hubUrl = Constants.notifUrl;

  HubConnection? _connection;
  final _controller = StreamController<AppNotification>.broadcast();

  Stream<AppNotification> get notifications => _controller.stream;

  bool get isConnected =>
      _connection?.state == HubConnectionState.Connected;

  Future<void> connect(String accessToken) async {
    if (isConnected) return;

    _connection = HubConnectionBuilder()
        .withUrl(
      _hubUrl,
      options: HttpConnectionOptions(
        accessTokenFactory: () async => accessToken,
      ),
    )
        .withAutomaticReconnect()
        .build();

    _connection!.on('ReceiveNotification', (args) {
      if (args != null && args.isNotEmpty) {
        final map = Map<String, dynamic>.from(args[0] as Map);
        _controller.add(AppNotification.fromMap(map));
      }
    });

    await _connection!.start();
  }

  Future<void> disconnect() async {
    await _connection?.stop();
    _connection = null;
  }

  void dispose() {
    _controller.close();
  }
}