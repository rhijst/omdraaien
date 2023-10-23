// ignore_for_file: unnecessary_getters_setters
import 'package:omdraaien/models/Bed.dart';

class Draai {
  late int _draai;
  late DateTime _moment;
  late String _kant;
  late Bed _bed;

  int get draai => _draai;
  set draai(int value) {
    _draai = value;
  }

  DateTime get moment => _moment;
  set moment(DateTime value) {
    _moment = value;
  }

  // give back a better readably string of the date
  get displayMoment{
    return "${_moment.year}-${_moment.month}-${_moment.day} ${_moment.hour}:${_moment.minute}";
  }

  String get kant => _kant;
  set kant(String value) {
    _kant = value;
  }

  Bed get bed => _bed;
  set bed(Bed value) {
    _bed = value;
  }
}
