class ApiResponse {
  int statusCode;
  String? syncTime;
  String? message;
  List<ResponseBody>? responseBody;

  ApiResponse({
    required this.statusCode,
    required this.syncTime,
    required this.message,
    required this.responseBody,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      statusCode: json['Status_Code'],
      syncTime: json['Sync_Time'],
      message: json['Message'],
      responseBody: (json['Response_Body'] as List?)
              ?.map((item) => ResponseBody.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class ResponseBody {
  String? userCode;
  String? userDisplayName;
  String? email;
  String? userEmployeeCode;
  String? companyCode;

  ResponseBody({
    required this.userCode,
    required this.userDisplayName,
    required this.email,
    required this.userEmployeeCode,
    required this.companyCode,
  });

  factory ResponseBody.fromJson(Map<String, dynamic> json) {
    return ResponseBody(
      userCode: json['User_Code'],
      userDisplayName: json['User_Display_Name'],
      email: json['Email'],
      userEmployeeCode: json['User_Employee_Code'],
      companyCode: json['Company_Code'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'User_Code': userCode,
      'User_Display_Name': userDisplayName,
      'Email': email,
      'User_Employee_Code': userEmployeeCode,
      'Company_Code': companyCode,
    };
  }
}
