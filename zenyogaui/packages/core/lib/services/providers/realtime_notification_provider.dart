import 'dart:async';
import 'package:flutter/material.dart';
import 'package:core/services/signalr_service.dart';

class RealtimeNotificationProvider extends ChangeNotifier {
  final SignalRService _signalRService;
  StreamSubscription<AppNotification>? _subscription;

  AppNotification? _latest;
  AppNotification? get latest => _latest;

  RealtimeNotificationProvider(this._signalRService);

  Future<void> connect(String accessToken) async {
    await _signalRService.connect(accessToken);

    _subscription = _signalRService.notifications.listen((notification) {
      _latest = notification;
      notifyListeners();
    });
  }

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