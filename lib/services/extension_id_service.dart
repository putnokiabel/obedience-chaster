import 'package:cloud_functions/cloud_functions.dart';

class ExtensionIdService {
  const ExtensionIdService({required FirebaseFunctions functions})
      : _functions = functions;

  final FirebaseFunctions _functions;

  Future<String> get(String configToken) async {
    final result = await _functions.httpsCallable('get_extension_id')({
      'partnerConfigurationToken': configToken,
    });

    return result.data as String;
  }
}
