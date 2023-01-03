import 'dart:async';

import 'package:cubit_avadhesh/base/enum_data_state.dart';
import 'package:cubit_avadhesh/repo/repo_response.dart';

extension ExtFuture<S> on Future<RepoResponse<S>> {
  Future<R> thenListenData<R>(
      {FutureOr<R> Function(S)? onSuccess,
        FutureOr<R> Function(DataErrorState)? onFailed}) {
    return then((value) {
      if (onSuccess != null) {
        if (value.s != null) {
          return onSuccess.call(value.s!);
        } else {
          return Future.value(null);
        }
      }

      if (onFailed != null) {
        if (value.f != null) {
          return onFailed.call(value.f!);
        } else {
          return Future.value(null);
        }
      }
      return Future.value(null);
    });
  }

  Future<R> thenSuccessData<R>(FutureOr<R> Function(S) data) {
    return then((value) {
      if (value.s != null) {
        return data.call(value.s!);
      } else {
        return Future.value(null);
      }
    });
  }

  Future<R> thenFailedData<R>(FutureOr<R> Function(DataErrorState) data) {
    return then<R>((value) {
      if (value.f != null) {
        return data.call(value.f!);
      } else {
        return Future.value(null);
      }
    });
  }
}
