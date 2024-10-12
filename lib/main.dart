import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ValueNotifierExample(),
    );
  }
}

class ValueNotifierExample extends StatelessWidget {
  ValueNotifierExample({super.key});

  final ValueNotifier<int> valueNotifier1 = ValueNotifier<int>(11);
  final ValueNotifier<int> valueNotifier2 = ValueNotifier<int>(11);
  late final CombinedNotifier<int> combinedNotifier = CombinedNotifier<int>(
    valueNotifier1,
    valueNotifier2,
    (a, b) => a + b,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ValueNotifier Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ValueListenableBuilder<int>(
              valueListenable: valueNotifier1,
              builder: (context, value, child) {
                return Text('ValueNotifier 1: $value');
              },
            ),
            ValueListenableBuilder<int>(
              valueListenable: valueNotifier2,
              builder: (context, value, child) {
                return Text('ValueNotifier 2: $value');
              },
            ),
            ValueListenableBuilder<int>(
              valueListenable: combinedNotifier,
              builder: (context, value, child) {
                return Text('Combined Notifier (Sum): $value');
              },
            ),
          ],
        ),
      ),
    );
  }

  void dispose() {
    valueNotifier1.dispose();
    valueNotifier2.dispose();
    combinedNotifier.dispose();
  }
}

class CombinedNotifier<T> extends ValueNotifier<T> {
  final ValueNotifier<T> notifier1;
  final ValueNotifier<T> notifier2;
  final T Function(T, T) combineFunction;

  CombinedNotifier(this.notifier1, this.notifier2, this.combineFunction)
      : super(combineFunction(notifier1.value, notifier2.value)) {
    notifier1.addListener(_updateValue);
    notifier2.addListener(_updateValue);
  }

  void _updateValue() {
    value = combineFunction(notifier1.value, notifier2.value);
  }

  @override
  void dispose() {
    notifier1.removeListener(_updateValue);
    notifier2.removeListener(_updateValue);
    super.dispose();
  }
}
