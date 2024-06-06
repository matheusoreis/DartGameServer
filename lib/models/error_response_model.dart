class ErrorResponseModel {
  ErrorResponseModel({
    required this.status,
    required this.title,
    this.details,
  });

  factory ErrorResponseModel.fromJson(Map<String, dynamic> json) {
    return ErrorResponseModel(
      status: json['status'],
      title: json['title'],
      details: json['details'],
    );
  }

  final int status;

  final String title;

  final String? details;

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'title': title,
      'details': details,
    };
  }
}
