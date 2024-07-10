import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:obedience_chaster/widgets/buttons.dart';

import 'configure_page_scope.dart';

class ConfigurePage extends StatefulWidget {
  const ConfigurePage({
    super.key,
    required this.hash,
  });

  static const path = '/configure';
  static const name = 'configure';

  final String hash;

  @override
  State<ConfigurePage> createState() => _ConfigurePageState();
}

class _ConfigurePageState extends State<ConfigurePage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          ConfigurePageScope.of(context)..initialize(widget.hash),
      builder: (context, _) {
        final scope = context.watch<ConfigurePageScope>();

        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: SelectionArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!scope.hasGivenAccess) ...[
                      const Text(
                        'To get started, first connect to your Obedience account.',
                        style: TextStyle(fontSize: 15),
                      ),
                      const SizedBox(height: 16),
                      LargePrimaryPillButton(
                        onPressed: scope.giveAccess,
                        child: const Text('Connect to Obedience'),
                      ),
                    ] else ...[
                      const Text(
                        'Punishments',
                        style: TextStyle(fontSize: 24),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Pick an Obedience punishment to connect to this lock. '
                        '${scope.punishments.map((p) => p.name).join(', ')}',
                        style: const TextStyle(fontSize: 15),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Rewards',
                        style: TextStyle(fontSize: 24),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Pick an Obedience reward to connect to this lock. '
                        '${scope.rewards.map((r) => r.name).join(', ')}',
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
