import 'package:flutter/material.dart';
import 'package:locale_chat/model/async_change_notifier.dart';
import 'package:locale_chat/model/error_model.dart';

mixin ErrorHolder on AsyncChangeNotifier {
  @protected
  List<ErrorModel> errors = [];

  addError(ErrorModel errorModel) {
    errors.add(errorModel);
  }

  removeError(String id) {
    for (ErrorModel error in errors) {
      if (error.id == id) {
        errors.remove(error);
      }
    }
  }

  wrap(Function toWrapped, ErrorModel error) {
    try {
      toWrapped();
    } catch (e) {
      addError(error);
      notifyListeners();
    }
  }

  Future<T> wrapAsync<T>(
      Future<T> Function() toWrapped, ErrorModel error) async {
    try {
      state = AsyncChangeNotifierState.busy;
      notifyListeners();
      final result = await toWrapped();
      return result;
    } catch (e) {
      addError(error);
      notifyListeners();
      rethrow;
    } finally {
      state = AsyncChangeNotifierState.idle;
      notifyListeners();
    }
  }
}
