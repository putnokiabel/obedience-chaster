import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import 'package:obedience_chaster/widgets/buttons.dart';
import 'package:obedience_chaster/widgets/custom_snack_bar.dart';

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
    final colorScheme = Theme.of(context).colorScheme;

    return ChangeNotifierProvider(
      create: (context) =>
          ConfigurePageScope.of(context)..initialize(widget.hash),
      builder: (context, _) {
        final scope = context.watch<ConfigurePageScope>();

        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: SelectionArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!scope.hasGivenAccess && !scope.isMainPage) ...[
                      const Text(
                        'To get started, first connect to your Obedience account.',
                        style: TextStyle(fontSize: 15),
                      ),
                      const SizedBox(height: 16),
                      LargePrimaryPillButton(
                        onPressed: scope.giveAccess,
                        child: scope.didLoadExtension
                            ? const Text('Connect to Obedience')
                            : SizedBox.square(
                                dimension: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  valueColor: AlwaysStoppedAnimation(
                                    colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                      ),
                    ] else ...[
                      const Text(
                        'Punishments',
                        style: TextStyle(fontSize: 24),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Pick an Obedience punishment to connect to this lock.',
                        style: TextStyle(fontSize: 15),
                      ),
                      DropdownButton(
                        value: scope.currentPunishment,
                        items: scope.punishments
                            .map(
                              (p) => DropdownMenuItem(
                                value: p.id,
                                child: Text(p.name),
                              ),
                            )
                            .toList(),
                        onChanged: (p) => scope.currentPunishment = p,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'How much lock time should this punishment add?',
                        style: TextStyle(fontSize: 15),
                      ),
                      TextField(
                        controller: scope.punishmentMinutesController,
                        onChanged: (value) {
                          final minutes = int.tryParse(value);
                          if (minutes != null) {
                            scope.punishmentMinutes = minutes;
                          }
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: const InputDecoration(
                          suffixText: 'minutes',
                        ),
                      ),
                      const SizedBox(height: 48),
                      const Text(
                        'Rewards',
                        style: TextStyle(fontSize: 24),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Pick an Obedience reward to connect to this lock.',
                        style: TextStyle(fontSize: 15),
                      ),
                      DropdownButton(
                        value: scope.currentReward,
                        items: scope.rewards
                            .map(
                              (r) => DropdownMenuItem(
                                value: r.id,
                                child: Text(r.name),
                              ),
                            )
                            .toList(),
                        onChanged: (r) => scope.currentReward = r,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'How much lock time should this reward remove?',
                        style: TextStyle(fontSize: 15),
                      ),
                      TextField(
                        controller: scope.rewardMinutesController,
                        onChanged: (value) {
                          final minutes = int.tryParse(value);
                          if (minutes != null) scope.rewardMinutes = minutes;
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: const InputDecoration(
                          suffixText: 'minutes',
                        ),
                      ),
                      if (scope.isMainPage) ...[
                        const SizedBox(height: 32),
                        LargePrimaryPillButton(
                          enabled: !scope.isSaving,
                          onPressed: () async {
                            await scope.save();

                            if (!mounted) return;

                            showTopSnackBar(
                              Overlay.of(this.context),
                              const CustomSnackBar.success(
                                message: 'Your changes have been saved!',
                              ),
                            );
                          },
                          child: const Text('Save'),
                        ),
                      ]
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
