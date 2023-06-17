import 'package:flutter/material.dart';

const Color primaryColor = Color.fromRGBO(209, 36, 42, 1);
const Color secondaryColor = Color.fromRGBO(29, 22, 23, 1);
const List<Color> colorList = [
  Color(0xFFB2EBF2),
  Color(0xFF4DD0E1),
  Color(0xFF26C6DA),
  Color(0xFF00ACC1),
  Color(0xFF0097A7),
  Color(0xFF00838F),
  Color(0xFF006064),
];
const MaterialColor any = MaterialColor(
  _anyPrimaryValue,
  <int, Color>{
    50: Color(0xFFE0F7FA),
    100: Color(0xFFB2EBF2),
    200: Color(0xFF80DEEA),
    300: Color(0xFF4DD0E1),
    400: Color(0xFF26C6DA),
    600: Color(0xFF00ACC1),
    700: Color(0xFF0097A7),
    800: Color(0xFF00838F),
    900: Color(0xFF006064),
  },
);
const int _anyPrimaryValue = 0xffeccbcc;
const MaterialColor many = MaterialColor(
  _manyPrimaryValue,
  <int, Color>{
    50: Color(0xFFE0F7FA),
    100: Color(0xFFB2EBF2),
    200: Color(0xFF80DEEA),
    300: Color(0xFF4DD0E1),
    400: Color(0xFF26C6DA),
    600: Color(0xFF00ACC1),
    700: Color(0xFF0097A7),
    800: Color(0xFF00838F),
    900: Color(0xFF006064),
  },
);
const int _manyPrimaryValue = 0xfff5cce9;
const MaterialColor tany = MaterialColor(
  _tanyPrimaryValue,
  <int, Color>{
    50: Color(0xFFE0F7FA),
    100: Color(0xFFB2EBF2),
    200: Color(0xFF80DEEA),
    300: Color(0xFF4DD0E1),
    400: Color(0xFF26C6DA),
    600: Color(0xFF00ACC1),
    700: Color(0xFF0097A7),
    800: Color(0xFF00838F),
    900: Color(0xFF006064),
  },
);
const int _tanyPrimaryValue = 0xffdbcee8;

const List<MaterialColor> colr = <MaterialColor>[
  any,
  many,
  tany,
];
