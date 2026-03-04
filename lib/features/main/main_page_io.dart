import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:student_assessment_fe/services/kiosk_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.initialUrl});

  final String initialUrl;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with WidgetsBindingObserver {
  late final WebViewController _controller;
  late final String _title;
  bool _hasLoadedInitialUrl = false;
  double _progress = 0;

  void _goToStartPage() {
    if (!mounted) return;
    unawaited(KioskService.stopPinningIfNeeded());
    context.goNamed('start');
  }

  void _handleWebEvent(String message) {
    final trimmed = message.trim();
    if (trimmed.isEmpty) return;

    if (trimmed == 'goStart' || trimmed == 'start' || trimmed == 'route:/start') {
      _goToStartPage();
      return;
    }

    try {
      final decoded = jsonDecode(trimmed);
      if (decoded is Map) {
        final type = decoded['type']?.toString();
        final route = decoded['route']?.toString();
        if (type == 'go_start' || route == '/start') {
          _goToStartPage();
        }
      }
    } catch (_) {
      // Ignore unknown payloads.
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    final uri = Uri.tryParse(widget.initialUrl);
    _title = uri?.host.isNotEmpty == true ? uri!.host : 'WebView';

    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..addJavaScriptChannel(
            'StudentAssessment',
            onMessageReceived: (message) => _handleWebEvent(message.message),
          )
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (progress) {
                if (!mounted) return;
                setState(() => _progress = progress / 100);
              },
              onPageStarted: (_) {
                if (!mounted) return;
                setState(() => _progress = 0);
              },
              onNavigationRequest: (request) {
                final url = request.url;
                if (url.startsWith('student-assessment://go-start') ||
                    url.startsWith('student_assessment://go-start')) {
                  _goToStartPage();
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
              onWebResourceError: (error) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(error.description)),
                );
              },
            ),
          );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_ensurePinnedAndLoaded());
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_ensurePinnedAndLoaded());
    }
  }

  Future<void> _ensurePinnedAndLoaded() async {
    await KioskService.startPinningIfNeeded();

    if (_hasLoadedInitialUrl) return;
    final uri = Uri.tryParse(widget.initialUrl);
    if (uri == null) return;

    _hasLoadedInitialUrl = true;
    await _controller.loadRequest(uri);
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
            onPressed: () => _controller.reload(),
            icon: const Icon(Icons.refresh),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child:
              _progress < 1
                  ? LinearProgressIndicator(value: _progress)
                  : const SizedBox(height: 3),
        ),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
