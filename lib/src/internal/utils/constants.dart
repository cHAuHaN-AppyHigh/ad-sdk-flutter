import 'package:adsdk/adsdk.dart';

abstract class AdSdkConstants {
  static final baseUrl = AdSdk.isDebug
      ? "https://admob-automation-qa-cdn.apyhi.com"
      : "https://admob-automation.apyhi.com";
  static const endpoint = "/api/v2/app/info";
  static const tag = "AdSdk Flutter";
  static const jwtPrivateKey = """-----BEGIN RSA PRIVATE KEY-----
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
-----END RSA PRIVATE KEY-----""";
}
