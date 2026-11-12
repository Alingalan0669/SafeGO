import 'package:url_launcher/url_launcher.dart';

import '../core/utils/app_utils.dart';

/// Result of trying to open the device dialer.
class CallResult {
  const CallResult._({required this.launched, this.error});

  const CallResult.success() : this._(launched: true);
  const CallResult.failure(String message) : this._(launched: false, error: message);

  final bool launched;
  final String? error;
}

/// Opens the phone dialer with a `tel:` URI.
///
/// One tap on a contact calls [placeCall]. The app never requests the
/// CALL_PHONE permission: opening the dialer lets the user confirm the call,
/// which is safer for demo/emergency numbers.
class PhoneService {
  Future<CallResult> placeCall(String rawNumber) async {
    final number = sanitisePhoneNumber(rawNumber);
    if (number.isEmpty) {
      return const CallResult.failure(
        'This contact has no saved phone number.',
      );
    }

    final uri = Uri(scheme: 'tel', path: number);
    try {
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (opened) return const CallResult.success();
      return CallResult.failure(
        'No calling app could open $number on this device.',
      );
    } catch (_) {
      // Emulators and desktop/web builds may not have a dialer.
      return CallResult.failure(
        'Calling is not available on this device. The number is $number.',
      );
    }
  }
}
