import 'package:flutter/material.dart';

import '../../core/config/app_config.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
    required this.initialConfig,
    required this.onSave,
  });

  final AppConfig initialConfig;
  final ValueChanged<AppConfig> onSave;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final TextEditingController _hostController;
  late final TextEditingController _tokenController;
  late bool _previewMode;

  @override
  void initState() {
    super.initState();
    _hostController = TextEditingController(text: widget.initialConfig.baseUrl);
    _tokenController = TextEditingController(text: widget.initialConfig.token);
    _previewMode = widget.initialConfig.previewMode;
  }

  @override
  void dispose() {
    _hostController.dispose();
    _tokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _hostController,
            decoration: const InputDecoration(
              labelText: 'Host de Jarvis Core',
              hintText: 'http://10.0.0.46:18789',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _tokenController,
            decoration: const InputDecoration(
              labelText: 'Bearer token',
            ),
          ),
          SwitchListTile(
            value: _previewMode,
            onChanged: (value) => setState(() => _previewMode = value),
            title: const Text('Modo preview sin sesión real'),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () {
              final cfg = AppConfig(
                baseUrl: _hostController.text.trim(),
                token: _tokenController.text.trim(),
                previewMode: _previewMode,
              );
              widget.onSave(cfg);
              Navigator.pop(context);
            },
            child: const Text('Guardar configuración'),
          ),
        ],
      ),
    );
  }
}
