
import 'package:cubit_avadhesh/cubit/base/enum_data_state.dart';

abstract class ConditionalResponse<F, S> {
  F? f;
  S? s;
  Function(S)? successFunction;
  Function(F)? failedFunction;

  ConditionalResponse(this.f, this.s);

  listenSuccess(Function(S) function) {
    successFunction = function;
    if (s != null) {
      successFunction?.call(s!);
    }
  }

  listenFailed(Function(F) function) {
    failedFunction = function;
    if (f != null) {
      failedFunction?.call(f!);
    }
  }

  listenData({Function(S)? onSuccess, Function(F)? onFailed}) {
    successFunction = onSuccess;
    failedFunction = onFailed;
    if (s != null) {
      successFunction?.call(s!);
    }
    if (f != null) {
      failedFunction?.call(f!);
    }
  }
}

abstract class RepoResponse<S> extends ConditionalResponse<DataErrorState, S> {
  RepoResponse(DataErrorState? f, S? s) : super(f, s);
}

class SuccessResponse<S> extends RepoResponse<S> {
  SuccessResponse(S s) : super(null, s) {
    if (successFunction != null) {
      successFunction?.call(s);
    }
  }
}

class FailedResponse<S> extends RepoResponse<S> {
  FailedResponse(DataErrorState f) : super(f, null) {
    if (failedFunction != null) {
      failedFunction?.call(f);
    }
  }
}
