import 'dart:convert';

import 'package:http/http.dart' as http;

class ObedienceApi {
  Future<List<ObjectData>> getRewards(
    String extensionId,
    String extensionSecret,
  ) async {
    final result = await http.get(
      Uri.parse(
        'https://app.obedienceapp.com/extensions/rewards?'
        'extensionId=$extensionId&'
        'secret=$extensionSecret',
      ),
    );

    // Parse the JSON response
    final json = jsonDecode(result.body);

    return (json as List).map((e) => ObjectData.fromMap(e)).toList();
  }

  Future<List<ObjectData>> getPunishments(
    String extensionId,
    String extensionSecret,
  ) async {
    final result = await http.get(
      Uri.parse(
        'https://app.obedienceapp.com/extensions/punishments?'
        'extensionId=$extensionId&'
        'secret=$extensionSecret',
      ),
    );

    // Parse the JSON response
    final json = jsonDecode(result.body);

    return (json as List).map((e) => ObjectData.fromMap(e)).toList();
  }

  Future<void> setupWebhooks({
    required String extensionId,
    required String extensionSecret,
    required String url,
    required bool habits,
    required bool rewards,
    required bool punishments,
  }) async {
    await http.post(
      Uri.parse(
        'https://app.obedienceapp.com/extensions/webhook?'
        'extensionId=$extensionId&'
        'secret=$extensionSecret',
      ),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'url': url,
        'habits': habits,
        'rewards': rewards,
        'punishments': punishments,
      }),
    );
  }
}

class ObjectData {
  const ObjectData({
    required this.id,
    required this.owner,
    required this.partner,
    required this.name,
    required this.description,
    required this.amount,
    required this.cost,
  });

  factory ObjectData.fromMap(Map map) {
    return ObjectData(
      id: map['id'] as String,
      owner: map['owner'] as String,
      partner: map['partner'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      amount: map['amount'] as int,
      cost: map['cost'] as int?,
    );
  }

  final String id;
  final String owner;
  final String partner;
  final String name;
  final String description;
  final int amount;
  final int? cost;
}
