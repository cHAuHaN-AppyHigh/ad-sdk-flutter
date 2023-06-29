import 'ad_sdk_app_config.dart';

class AdSdkApiResponse {
  final String? status;
  final String? message;
  final AdSdkAppConfig app;

  AdSdkApiResponse({
    required this.status,
    required this.message,
    required this.app,
  });

  factory AdSdkApiResponse.fromMap(Map<String, dynamic> map) {
    return AdSdkApiResponse(
      status: map['status'],
      message: map['message'],
      app: AdSdkAppConfig.fromMap(map['app'] as Map<String, dynamic>),
    );
  }
}
