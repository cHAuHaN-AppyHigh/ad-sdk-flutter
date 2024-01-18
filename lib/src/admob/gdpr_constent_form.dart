import 'dart:async';
import 'package:adsdk/src/internal/utils/adsdk_logger.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobConsentForm {
  ConsentForm? _consentForm;

  Completer _formLoadCompleter = Completer();

  Future<void> fetchConsentInfo() async {
    _formLoadCompleter = Completer();
    ConsentInformation.instance.requestConsentInfoUpdate(
      ConsentRequestParameters(),
      () async {
        if (await _formAvailable && await _consentRequired) await _loadForm();
        _formLoadCompleter.complete();
      },
      (FormError error) => _formLoadCompleter.complete(),
    );
    await _formLoadCompleter.future;
  }

  Future<void> _loadForm() async {
    final completer = Completer();
    ConsentForm.loadConsentForm(
      (ConsentForm consentForm) async {
        _consentForm = consentForm;
        completer.complete();
      },
      (FormError formError) => completer.complete(),
    );
    await completer.future;
  }

  Future<bool> show({retry = false}) async {
    try {
      if (await _consentRequired) {
        await _formLoadCompleter.future;
        if (_consentForm != null) {
          final completer = Completer<bool>();
          _consentForm!
              .show((formError) => completer.complete(formError == null));
          return await completer.future;
        } else if (!retry) {
          await fetchConsentInfo();
          return show(retry: true);
        }
      }
    } catch (e) {
      AdSdkLogger.error(e.toString());
    }
    return false;
  }

  Future<bool> get _consentRequired async =>
      await ConsentInformation.instance.getConsentStatus() ==
      ConsentStatus.required;

  Future<bool> get _formAvailable =>
      ConsentInformation.instance.isConsentFormAvailable();
}
