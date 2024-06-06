typedef ResultUtils<Failure, Success> = (Failure? exception, Success? data);

extension ResultExtension<Failure, Success> on ResultUtils<Failure, Success> {
  ResultUtils? fold({
    Function(Success)? success,
    Function(Failure)? failure,
  }) {
    if (this.$1 != null) {
      failure?.call(this.$1 as Failure);
    } else if (this.$2 != null) {
      success?.call(this.$2 as Success);
    }
    return this;
  }

  bool get isSuccess => this.$2 != null;

  bool get isFailure => this.$1 != null;

  Success? get getSuccess => this.$2;

  Failure? get getFailure => this.$1;
}
