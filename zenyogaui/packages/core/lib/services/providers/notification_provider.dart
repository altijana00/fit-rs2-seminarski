import 'dart:async';
import 'package:flutter/material.dart';
import 'package:core/services/signalr_service.dart';

class NotificationProvider extends ChangeNotifier {
  final SignalRService _signalRService;
  StreamSubscription<AppNotification>? _subscription;

  // Čuva zadnju notifikaciju – korisno za display
  AppNotification? _latest;
  AppNotification? get latest => _latest;

  NotificationProvider(this._signalRService);

  /// Pozovi nakon login-a kada imaš token
  Future<void> connect(String accessToken) async {
    await _signalRService.connect(accessToken);

    _subscription = _signalRService.notifications.listen((notification) {
      _latest = notification;
      notifyListeners(); // UI reaguje
    });
  }

  /// Pozovi na logout
  Future<void> disconnect() async {
    await _subscription?.cancel();
    await _signalRService.disconnect();
    _latest = null;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _signalRService.dispose();
    super.dispose();
  }
}