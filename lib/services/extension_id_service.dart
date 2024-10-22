import 'package:cloud_functions/cloud_functions.dart';
import 'package:collection/collection.dart';

class ExtensionIdService {
  const ExtensionIdService({required FirebaseFunctions functions})
      : _functions = functions;

  final FirebaseFunctions _functions;

  Future<ExtensionSession> get({
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

    return ExtensionSession(
      extensionId: result.data['extensionId'] as String,
      sessionId: result.data['sessionId'] as String?,
      role: Role.of(result.data['role'] as String?),
    );
  }
}

class ExtensionSession {
  const ExtensionSession({
    required this.extensionId,
    required this.sessionId,
    required this.role,
  });

  final String extensionId;
  final String? sessionId;
  final Role? role;
}

enum Role {
  wearer,
  keyholder;

  static Role? of(String? value) {
    return Role.values.firstWhereOrNull((r) => r.name == value);
  }
}
