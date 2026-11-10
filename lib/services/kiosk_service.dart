import 'package:flutter/services.dart';

class KioskService {
  static const MethodChannel _channel =
      MethodChannel('student_assessment_fe');
  static const Duration _pinningAttemptWindow = Duration(seconds: 3);
  static const int _maxPinningAttemptsInWindow = 3;
  static final List<DateTime> _pinningAttemptTimestamps = <DateTime>[];
  static bool _isHandlingPinningLimit = false;
  static bool? _isSupported;
  static Future<void> Function()? _onPinningLimitReached;

  static void setPinningLimitHandler(Future<void> Function() handler) {
    _onPinningLimitReached = handler;
  }

  static Future<void> preventScreenshot() async {
    try {
      await _channel.invokeMethod('preventScreenshot');
      _isSupported = true;
    } catch (e) {
      if (e is MissingPluginException) {
        _isSupported = false;
      }
    }
  }

  static Future<void> keepScreenOn([bool enabled = true]) async {
    try {
      await _channel.invokeMethod('keepScreenOn', {'enabled': enabled});
    } catch (_) {}
  }

  static Future<void> startPinning() async {
    try {
      await _channel.invokeMethod('startPinning');
      _isSupported = true;
    } catch (e) {
      if (e is MissingPluginException) {
        _isSupported = false;
      }
    }
  }

  static Future<bool> isPinned() async {
    try {
      final result = await _channel.invokeMethod<bool>('isPinned');
      _isSupported = true;
      return result ?? false;
    } catch (e) {
      if (e is MissingPluginException) {
        _isSupported = false;
      }
      return false;
    }
  }

  static Future<void> startPinningIfNeeded() async {
    final pinned = await isPinned();
    if (_isSupported == false) return;
    if (pinned) return;
    _registerPinningAttempt();

    if (_hasExceededPinningAttemptLimit()) {
      if (_isHandlingPinningLimit) return;

      _isHandlingPinningLimit = true;
      try {
        _pinningAttemptTimestamps.clear();
        await stopPinningIfNeeded();
        final handler = _onPinningLimitReached;
        if (handler != null) {
          await handler();
        }
      } finally {
        _isHandlingPinningLimit = false;
      }
      return;
    }

    await startPinning();
  }

  static Future<void> stopPinning() async {
    try {
      await _channel.invokeMethod('stopPinning');
      _isSupported = true;
    } catch (e) {
      if (e is MissingPluginException) {
        _isSupported = false;
      }
    }
  }

  static Future<void> stopPinningIfNeeded() async {
    final pinned = await isPinned();
    if (_isSupported == false) return;
    if (!pinned) return;
    await stopPinning();
  }

  static void _registerPinningAttempt() {
    final now = DateTime.now();
    _pinningAttemptTimestamps.removeWhere(
      (ts) => now.difference(ts) > _pinningAttemptWindow,
    );
    _pinningAttemptTimestamps.add(now);
  }

  static bool _hasExceededPinningAttemptLimit() {
    return _pinningAttemptTimestamps.length >= _maxPinningAttemptsInWindow;
  }
}
