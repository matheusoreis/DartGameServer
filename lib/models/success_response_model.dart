class SuccessResponseModel<T> {
  SuccessResponseModel.successResponseModel({
    required this.status,
    required this.data,
  });

  factory SuccessResponseModel.fromJson(Map<String, dynamic> json, T Function(dynamic) fromJsonT) {
    return SuccessResponseModel<T>.successResponseModel(
      status: json['status'],
      data: fromJsonT(json['data']),
    );
  }

  final int status;

  final T data;

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'data': data,
    };
  }
}
