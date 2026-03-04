// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:student_assessment_fe/services/kiosk_service.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.initialUrl});

  final String initialUrl;

  @override
  State<MainPage> createState() => _MainPageWebState();
}

class _MainPageWebState extends State<MainPage> with WidgetsBindingObserver {
  late final String _title;
  late final String _viewType;
  late final html.IFrameElement _iframe;
  bool _hasLoadedInitialUrl = false;
  StreamSubscription<html.MessageEvent>? _messageSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    final uri = Uri.tryParse(widget.initialUrl);
    _title = uri?.host.isNotEmpty == true ? uri!.host : 'WebView';
    _viewType = 'main-webview-${DateTime.now().microsecondsSinceEpoch}';
    _iframe =
        html.IFrameElement()
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%';

    ui_web.platformViewRegistry.registerViewFactory(_viewType, (viewId) {
      return _iframe;
    });

    _messageSubscription = html.window.onMessage.listen((event) {
      _handleWebEvent(event.data);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_ensurePinnedAndLoaded());
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_messageSubscription?.cancel());
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_ensurePinnedAndLoaded());
    }
  }

  void _goToStartPage() {
    if (!mounted) return;
    unawaited(KioskService.stopPinningIfNeeded());
    context.goNamed('start');
  }

  void _handleWebEvent(dynamic data) {
    if (data == null) return;

    if (data is String) {
      final message = data.trim();
      if (message.isEmpty) return;
      if (message == 'goStart' || message == 'start' || message == 'route:/start') {
        _goToStartPage();
        return;
      }

      try {
        final decoded = jsonDecode(message);
        _handleWebEvent(decoded);
      } catch (_) {
        // Ignore unknown payloads.
      }
      return;
    }

    if (data is Map) {
      final type = data['type']?.toString();
      final route = data['route']?.toString();
      if (type == 'go_start' || route == '/start') {
        _goToStartPage();
      }
    }
  }

  Future<void> _ensurePinnedAndLoaded() async {
    await KioskService.startPinningIfNeeded();

    if (_hasLoadedInitialUrl) return;
    _hasLoadedInitialUrl = true;
    _iframe.src = widget.initialUrl;
  }

  void _reload() {
    _iframe.src = _iframe.src ?? widget.initialUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          tooltip: 'Back',
          onPressed: _goToStartPage,
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(_title),
        actions: [
          IconButton(
            tooltip: 'Reload',
            onPressed: _reload,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: HtmlElementView(viewType: _viewType),
    );
  }
}
