import 'package:flutter/foundation.dart';

class ValueCounter with ChangeNotifier {

  ValueCounter({required this.startCountingFrom});
  late final int startCountingFrom;

  late ValueNotifier<int> counterValue = ValueNotifier(startCountingFrom);

  int get value => counterValue.value;

  void increment() {
    counterValue.value += 1;
    notifyListeners();
  }

  void decrement() {
    counterValue.value -= 1;
    notifyListeners();
  }

}
