// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

class TimeSelector {
  final StreamController _scheduleTimeStream = StreamController.broadcast();

  Stream get getTime => _scheduleTimeStream.stream;

  // ignore: prefer_final_fields
  late TimeSelectorModel _timeChangeModel;

  void init() {
    _scheduleTimeStream.stream.listen((final e) {});
    _timeChangeModel = TimeSelectorModel(hours: 1, minutes: 1, meridiem: 'AM');
    Future.delayed(Duration.zero, () {
      _scheduleTimeStream.sink
          .add(TimeSelectorModel(hours: 1, minutes: 1, meridiem: 'AM'));
    });
  }

  void increaseHour() {
    if (_timeChangeModel.hours < 12) {
      _timeChangeModel =
          _timeChangeModel.copyWith(hours: ++_timeChangeModel.hours);
      //  _timeChangeMode.hours = ++_scheduleTime['hours'];
    }
    _scheduleTimeStream.sink.add(_timeChangeModel);
  }

  void decreaseHour() {
    if (_timeChangeModel.hours > 1) {
      _timeChangeModel =
          _timeChangeModel.copyWith(hours: --_timeChangeModel.hours);
    }

    _scheduleTimeStream.sink.add(_timeChangeModel);
  }

  void increaseMinutes() {
    if (_timeChangeModel.minutes < 60) {
      _timeChangeModel =
          _timeChangeModel.copyWith(minutes: ++_timeChangeModel.minutes);
      //  _timeChangeMode.hours = ++_scheduleTime['hours'];
    }
    _scheduleTimeStream.sink.add(_timeChangeModel);
  }

  void decreaseMinutes() {
    if (_timeChangeModel.minutes > 1) {
      _timeChangeModel =
          _timeChangeModel.copyWith(minutes: --_timeChangeModel.minutes);
    }

    _scheduleTimeStream.sink.add(_timeChangeModel);
  }

  void dispose() {
    _scheduleTimeStream.close();

  }
}

class TimeSelectorModel {
  late int hours;
  late int minutes;
  late String meridiem;

  TimeSelectorModel({
    required this.hours,
    required this.minutes,
    required this.meridiem,
  });

  TimeSelectorModel copyWith({
    final int? hours,
    final int? minutes,
    final String? meridiem,
  }) => TimeSelectorModel(
      hours: hours ?? this.hours,
      minutes: minutes ?? this.minutes,
      meridiem: meridiem ?? this.meridiem,
    );

  // @override
  // int get hashCode => hours.hashCode ^ minutes.hashCode ^ meridiem.hashCode;
  


}
