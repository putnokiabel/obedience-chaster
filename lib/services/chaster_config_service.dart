import 'package:cloud_firestore/cloud_firestore.dart';

class ChasterConfigService {
  const ChasterConfigService({required FirebaseFirestore firestore})
      : _firestore = firestore;

  final FirebaseFirestore _firestore;

  Stream<ChasterConfig> listen(String extensionId) {
    return _firestore
        .collection('config')
        .doc(extensionId)
        .snapshots()
        .map(
          (snapshot) {
            if (!snapshot.exists) return null;

            return ChasterConfig.fromMap(snapshot.data()!);
          },
        )
        .where((config) => config != null)
        .map((config) => config!);
  }

  Future<void> set(String extensionId, ChasterConfig config) async {
    await _firestore.collection('config').doc(extensionId).set(config.toMap());
  }
}

class ChasterConfig {
  ChasterConfig({
    required this.userId,
    required this.extensionSecret,
    required this.rewardId,
    required this.rewardMinutes,
    required this.punishmentId,
    required this.punishmentMinutes,
  });

  factory ChasterConfig.fromMap(Map<String, dynamic> map) {
    return ChasterConfig(
      userId: map['userId'] as String?,
      extensionSecret: map['extensionSecret'] as String?,
      rewardId: map['rewardId'] as String?,
      rewardMinutes: (map['rewardMinutes'] as num?)?.toInt(),
      punishmentId: map['punishmentId'] as String?,
      punishmentMinutes: (map['punishmentMinutes'] as num?)?.toInt(),
    );
  }

  final String? userId;
  final String? extensionSecret;
  final String? rewardId;
  final int? rewardMinutes;
  final String? punishmentId;
  final int? punishmentMinutes;

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'extensionSecret': extensionSecret,
      'rewardId': rewardId,
      'rewardMinutes': rewardMinutes,
      'punishmentId': punishmentId,
      'punishmentMinutes': punishmentMinutes,
    };
  }

  ChasterConfig copyWith({
    String? userId,
    String? extensionSecret,
    String? rewardId,
    int? rewardMinutes,
    String? punishmentId,
    int? punishmentMinutes,
  }) {
    return ChasterConfig(
      userId: userId ?? this.userId,
      extensionSecret: extensionSecret ?? this.extensionSecret,
      rewardId: rewardId ?? this.rewardId,
      rewardMinutes: rewardMinutes ?? this.rewardMinutes,
      punishmentId: punishmentId ?? this.punishmentId,
      punishmentMinutes: punishmentMinutes ?? this.punishmentMinutes,
    );
  }
}
