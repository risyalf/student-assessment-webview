import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StartForm extends StatefulWidget {
  const StartForm({super.key});

  @override
  State<StartForm> createState() => _StartFormState();
}

class _StartFormState extends State<StartForm> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController(
    text: 'https://assessment.smkswadaya.sch.id',
  );

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  String? _validateUrl(String? raw) {
    final value = (raw ?? '').trim();
    if (value.isEmpty) return 'URL tidak boleh kosong';

    final withScheme = value.contains('://') ? value : 'https://$value';
    final uri = Uri.tryParse(withScheme);
    if (uri == null || uri.host.isEmpty) return 'URL tidak valid';

    return null;
  }

  void _goToMainPage() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final value = _urlController.text.trim();
    final withScheme = value.contains('://') ? value : 'https://$value';
    final uri = Uri.parse(withScheme);
    context.goNamed('main', queryParameters: {'url': uri.toString()});
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // TextFormField(
          //   controller: _urlController,
          //   keyboardType: TextInputType.url,
          //   textInputAction: TextInputAction.go,
          //   onFieldSubmitted: (_) => _goToMainPage(),
          //   validator: _validateUrl,
          //   decoration: const InputDecoration(
          //     labelText: 'URL',
          //     hintText: 'contoh: https://example.com',
          //     border: OutlineInputBorder(),
          //   ),
          // ),
          // const SizedBox(height: 12),
          OutlinedButton(
            onPressed: _goToMainPage,
            child: const SizedBox(
              height: 52,
              child: Center(child: Text('Buka Ujian')),
            ),
          ),
        ],
      ),
    );
  }
}
