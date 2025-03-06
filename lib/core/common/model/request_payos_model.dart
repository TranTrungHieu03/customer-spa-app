
class RequestPayOsModel {
  final String returnUrl;
  final String cancelUrl;

  RequestPayOsModel({
    required this.returnUrl,
    required this.cancelUrl,
  });
  factory RequestPayOsModel.fromJson(Map<String, dynamic> json) => RequestPayOsModel(
    returnUrl: json["returnUrl"],
    cancelUrl: json["cancelUrl"],
  );

  Map<String, dynamic> toJson() => {
    "returnUrl": returnUrl,
    "cancelUrl": cancelUrl,
  };
}
