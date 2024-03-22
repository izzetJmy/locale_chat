import 'package:flutter/material.dart';

enum AsyncChangeNotifierState{
  idle,
  busy
}

abstract class AsyncChangeNotifier extends ChangeNotifier{
  AsyncChangeNotifierState get state;
  set state(AsyncChangeNotifierState state);
}