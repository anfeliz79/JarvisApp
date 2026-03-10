import 'package:flutter/material.dart';

import 'core/config/app_config.dart';
import 'core/config/app_config_storage.dart';
import 'core/config/dev_gateway_local.dart';
import 'features/chat/chat_screen.dart';
import 'features/settings/settings_screen.dart';

class JarvisApp extends StatefulWidget {
  const JarvisApp({super.key});

  @override
  State<JarvisApp> createState() => _JarvisAppState();
}

class _JarvisAppState extends State<JarvisApp> {
  final _storage = AppConfigStorage();
  AppConfig? _config;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    final loaded = await _storage.load();
    setState(() {
      _config = loaded.token.isEmpty && devGatewayToken.isNotEmpty
          ? loaded.copyWith(token: devGatewayToken)
          : loaded;
    });
  }

  Future<void> _saveConfig(AppConfig config) async {
    await _storage.save(config);
    setState(() {
      _config = config;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: _config == null
          ? const Scaffold(body: Center(child: CircularProgressIndicator()))
          : ChatScreen(
              config: _config!,
              onOpenSettings: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => SettingsScreen(
                      initialConfig: _config!,
                      onSave: _saveConfig,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
