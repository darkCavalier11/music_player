import 'package:async_redux/async_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:music_player/redux/models/app_state.dart';
import 'package:music_player/redux/redux_exception.dart';

class ReduxExceptionWrapper extends WrapError<AppState> {
  @override
  Object? wrap(Object error, StackTrace stackTrace, ReduxAction action) {
    if (error.runtimeType == ReduxException) {
      if ((error as ReduxException).userErrorToastMessage != null) {
        Fluttertoast.showToast(msg: error.userErrorToastMessage!);
      }
    } else {
        Fluttertoast.showToast(msg: 'Some error occured.');
    }
    return null;
  }
}