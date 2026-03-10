import 'package:flutter/material.dart';

import '../../core/config/app_config.dart';
import 'chat_api.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.config,
    required this.onOpenSettings,
  });

  final AppConfig config;
  final VoidCallback onOpenSettings;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _inputController = TextEditingController();
  final _messages = <_UiMessage>[];
  final _api = ChatApi();
  bool _sending = false;

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _inputController.text.trim();
    if (text.isEmpty || _sending) return;

    setState(() {
      _sending = true;
      _messages.add(_UiMessage(role: 'user', text: text));
      _inputController.clear();
    });

    try {
      if (!widget.config.isConfigured) {
        throw Exception('Configura el host antes de chatear.');
      }

      final response = await _api.send(
        baseUrl: widget.config.baseUrl,
        token: widget.config.token,
        model: 'openclaw:main',
        messages: _messages
            .map((m) => {'role': m.role, 'content': m.text})
            .toList(growable: false),
      );

      setState(() {
        _messages.add(_UiMessage(role: 'assistant', text: response));
      });
    } catch (e) {
      setState(() {
        _messages.add(_UiMessage(role: 'system', text: 'Error: $e'));
      });
    } finally {
      setState(() {
        _sending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jarvis'),
        actions: [
          IconButton(
            onPressed: widget.onOpenSettings,
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Column(
        children: [
          MaterialBanner(
            content: Text(widget.config.isConfigured
                ? 'Host: ${widget.config.baseUrl}'
                : 'Host sin configurar'),
            actions: [
              TextButton(
                onPressed: widget.onOpenSettings,
                child: const Text('Configurar'),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message.role == 'user';
                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isUser
                          ? Colors.blue.shade600
                          : Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(message.text),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _inputController,
                    onSubmitted: (_) => _send(),
                    decoration: const InputDecoration(
                      hintText: 'Escribe a Jarvis...',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: _sending ? null : _send,
                  child: _sending
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.send),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _UiMessage {
  _UiMessage({required this.role, required this.text});

  final String role;
  final String text;
}
