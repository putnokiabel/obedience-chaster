import 'package:cloud_functions/cloud_functions.dart';

class ExtensionIdService {
  const ExtensionIdService({required FirebaseFunctions functions})
      : _functions = functions;

  final FirebaseFunctions _functions;

  Future<({String extensionId, String? sessionId})> get({
    String? configToken,
    String? mainToken,
  }) async {
    if (configToken == null && mainToken == null) {
      throw ArgumentError('configToken or mainToken must be provided');
    }

    final result = await _functions.httpsCallable('get_extension_id')({
      if (configToken != null) 'partnerConfigurationToken': configToken,
      if (mainToken != null) 'mainToken': mainToken,
    });

    return (
      extensionId: result.data['extensionId'] as String,
      sessionId: result.data['sessionId'] as String?,
    );
  }
}
