import 'package:adsdk/src/internal/utils/app_info.dart';
import 'package:corsac_jwt/corsac_jwt.dart';
import '../models/user_model.dart';
import 'constants.dart';

class RSATokenGenerator {
  Future<String> getJWTToken() async {
    AppInfo appInfo = await AppInfo.fromPlatform();

    JWTRsaSha256Signer jwtRsaSha256Signer =
        _getPrivateKey(AdSdkConstants.jwtPrivateKey);

    Duration validDuration = const Duration(hours: 1);
    DateTime nowDateTime = DateTime.now();
    DateTime validTill = nowDateTime.add(validDuration);

    final jwt = JWTBuilder()
      ..setClaim('user_id', currentUser.id)
      ..setClaim('app_version', appInfo.versionName)
      ..setClaim('app_version_code', appInfo.versionCode)
      ..setClaim('app_id', appInfo.packageId)
      ..audience = 'adutils'
      ..issuedAt = nowDateTime
      ..expiresAt = validTill;

    final token = jwt.getSignedToken(jwtRsaSha256Signer);
    return token.toString();
  }

  JWTRsaSha256Signer _getPrivateKey(String privateKey) {
    JWTRsaSha256Signer jwtRsaSha256Signer;
    jwtRsaSha256Signer = JWTRsaSha256Signer(privateKey: privateKey);
    return jwtRsaSha256Signer;
  }
}
