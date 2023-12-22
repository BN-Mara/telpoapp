import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:telpoapp/controller/auth_controller.dart';

/// Flutter code sample for [AppLifecycleListener].

class AppLifecycleDisplay extends StatefulWidget {
  final Widget child;
  const AppLifecycleDisplay({super.key, required this.child});

  @override
  State<AppLifecycleDisplay> createState() => _AppLifecycleDisplayState();
}

class _AppLifecycleDisplayState extends State<AppLifecycleDisplay> {
  late final AppLifecycleListener _listener;
  final ScrollController _scrollController = ScrollController();
  final List<String> _states = <String>[];
  var auth = Get.find<AuthController>();
  late AppLifecycleState? _state;

  @override
  void initState() {
    super.initState();
    _state = SchedulerBinding.instance.lifecycleState;
    _listener = AppLifecycleListener(
      onShow: () => _handleTransition('show'),
      onResume: () => _handleTransition('resume'),
      onHide: () => _handleTransition('hide'),
      onInactive: () => _handleTransition('inactive'),
      onPause: () => _handleTransition('pause'),
      onDetach: () => _handleTransition('detach'),
      onRestart: () => _handleTransition('restart'),
      // This fires for each state change. Callbacks above fire only for
      // specific state transitions.
      onStateChange: _handleStateChange,
    );
    if (_state != null) {
      _states.add(_state!.name);
    }
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  void _handleTransition(String name) {
    print('app state name:$name');

    if (name == 'detach') {
      auth.sendAlert("App closed",
          "App has been closed at ${DateTime.now().toIso8601String()}");
    } else if (name == 'hide') {
      auth.sendAlert("App closed",
          "App has been hidden at ${DateTime.now().toIso8601String()}");
    } else if (name == 'resume') {
      auth.resumeAlert();
    }

    /* setState(() {
      _states.add(name);
    });
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );*/
  }

  void _handleStateChange(AppLifecycleState state) {
    setState(() {
      _state = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
