class AppConfig {
  const AppConfig({
    required this.baseUrl,
    required this.token,
    required this.previewMode,
  });

  final String baseUrl;
  final String token;
  final bool previewMode;

  bool get isConfigured => baseUrl.isNotEmpty;
  bool get hasAuth => token.isNotEmpty;

  AppConfig copyWith({
    String? baseUrl,
    String? token,
    bool? previewMode,
  }) {
    return AppConfig(
      baseUrl: baseUrl ?? this.baseUrl,
      token: token ?? this.token,
      previewMode: previewMode ?? this.previewMode,
    );
  }

  static const empty = AppConfig(baseUrl: '', token: '', previewMode: true);
}
