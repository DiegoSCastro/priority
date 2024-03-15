import 'package:flutter/material.dart';

const kAlertHeight = 80.0;

enum AlertPriority {
  error(2),
  warning(1),
  info(0);

  const AlertPriority(this.value);
  final int value;
}

class Alert extends StatefulWidget {
  const Alert({
    super.key,
    required this.backgroundColor,
    required this.child,
    required this.leading,
    required this.priority,
    required this.animationController,
  });

  final Color backgroundColor;
  final Widget child;
  final Widget leading;
  final AlertPriority priority;
  final AnimationController animationController;

  @override
  State<Alert> createState() => _AlertState();
}

class _AlertState extends State<Alert> with TickerProviderStateMixin {
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    /// Precisei alterar "begin: -alertHeight" para uma transiçao mais suave
    _animation = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusbarHeight = MediaQuery.of(context).padding.top;
    return AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0.0, kAlertHeight * (_animation.value - 1)),
            child: Material(
              child: Ink(
                color: widget.backgroundColor,
                height: kAlertHeight + statusbarHeight,
                child: Column(
                  children: [
                    SizedBox(height: statusbarHeight),
                    Expanded(
                      child: Row(
                        children: [
                          const SizedBox(width: 28.0),
                          IconTheme(
                            data: const IconThemeData(
                              color: Colors.white,
                              size: 36,
                            ),
                            child: widget.leading,
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: DefaultTextStyle(
                              style: const TextStyle(color: Colors.white),
                              child: widget.child,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 28.0),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class AlertMessenger extends StatefulWidget {
  const AlertMessenger({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<AlertMessenger> createState() => AlertMessengerState();

  static AlertMessengerState of(BuildContext context) {
    try {
      final scope = _AlertMessengerScope.of(context);
      return scope.state;
    } catch (error) {
      throw FlutterError.fromParts(
        [
          ErrorSummary('No AlertMessenger was found in the Element tree'),
          ErrorDescription(
              'AlertMessenger is required in order to show and hide alerts.'),
          ...context.describeMissingAncestor(
              expectedAncestorType: AlertMessenger),
        ],
      );
    }
  }
}

class AlertMessengerState extends State<AlertMessenger>
    with TickerProviderStateMixin {
  String? get message {
    if (alertQueue.isNotEmpty) {
      return (alertQueue.first.child as Text).data ?? '';
    }
    return '';
  }

  List<Alert> alertQueue = [];

  List<Alert> get priorityList =>
      alertQueue..sort((a, b) => b.priority.value.compareTo(a.priority.value));

  Future<void> showAlert({required Alert alert}) async {
    bool containsSameColor = alertQueue.any((existingAlert) =>
    existingAlert.backgroundColor == alert.backgroundColor);
    if (!containsSameColor) {
      alertQueue.add(alert);
      await alert.animationController.forward();
    }
  }

  Future<void> hideAlert() async {
    if (priorityList.isNotEmpty) {
      alertQueue = priorityList;

      await alertQueue.first.animationController.reverse();
      await alertQueue.first.animationController.forward(from: 1.0);

      alertQueue.removeAt(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      children: [
        Positioned.fill(
          top: 0,
          child: _AlertMessengerScope(
            state: this,
            child: widget.child,
          ),
        ),
        if (priorityList.isNotEmpty)
          Stack(
            children: priorityList.reversed
                .map((e) => Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: e,
            ))
                .toList(),
          ),
      ],
    );
  }
}

class _AlertMessengerScope extends InheritedWidget {
  const _AlertMessengerScope({
    required this.state,
    required super.child,
  });

  final AlertMessengerState state;

  @override
  bool updateShouldNotify(_AlertMessengerScope oldWidget) =>
      state != oldWidget.state;

  static _AlertMessengerScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_AlertMessengerScope>();
  }

  static _AlertMessengerScope of(BuildContext context) {
    final scope = maybeOf(context);
    assert(scope != null, 'No _AlertMessengerScope found in context');
    return scope!;
  }
}
