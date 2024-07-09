import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'home_page.dart';

final routes = <RouteBase>[
  GoRoute(
    path: '/',
    redirect: (_, __) {
      return '/${HomePage.name}';
    },
  ),
  GoRoute(
    path: HomePage.path,
    name: HomePage.name,
    pageBuilder: (_, __) => const MaterialPage(
      name: HomePage.name,
      fullscreenDialog: true,
      child: HomePage(),
    ),
  ),
];

class MaterialPage<T> extends Page<T> {
  /// Creates a material page.
  const MaterialPage({
    required this.child,
    this.maintainState = true,
    this.fullscreenDialog = false,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  });

  /// The content to be shown in the [Route] created by this page.
  final Widget child;

  /// {@macro flutter.widgets.ModalRoute.maintainState}
  final bool maintainState;

  /// {@macro flutter.widgets.PageRoute.fullscreenDialog}
  final bool fullscreenDialog;

  @override
  Route<T> createRoute(BuildContext context) {
    return _PageBasedMaterialPageRoute<T>(page: this);
  }
}

// A page-based version of MaterialPageRoute.
//
// This route uses the builder from the page to build its content. This ensures
// the content is up to date after page updates.
class _PageBasedMaterialPageRoute<T> extends PageRoute<T>
    with MaterialRouteTransitionMixin<T> {
  _PageBasedMaterialPageRoute({
    required MaterialPage<T> page,
  }) : super(settings: page) {
    assert(opaque);
  }

  MaterialPage<T> get _page => settings as MaterialPage<T>;

  @override
  Widget buildContent(BuildContext context) {
    return _page.child;
  }

  @override
  bool get maintainState => _page.maintainState;

  @override
  bool get fullscreenDialog => _page.fullscreenDialog;

  @override
  String get debugLabel => '${super.debugLabel}(${_page.name})';

  @override
  Duration get transitionDuration => const Duration(milliseconds: 400);
}
