import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysql_flutter_crud/core/presentations/my_app.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}