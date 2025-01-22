class ApiRequest {
  ApiBody apiBody;
  String apiAction;
  String companyCode;
  ApiRequest(
      {required this.apiBody,
      required this.apiAction,
      required this.companyCode});
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['API_Body'] = apiBody.toJson();
    map['Api_Action'] = apiAction;
    map['Company_Code'] = companyCode;
    return map;
  }
}

class ApiBody {
  String uniqueId;
  String password;
  ApiBody({required this.uniqueId, required this.password});
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Unique_Id'] = uniqueId;
    map['Pw'] = password;
    return map;
  }
}
