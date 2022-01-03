class BasebarcodeModel {
  String responseCode;
  String responseStatus;
  String responseMessage;
  String responseData;
  String responseToken;
  String responseCount;
  String responseAdditionalData;

  BasebarcodeModel(
      {this.responseCode,
      this.responseStatus,
      this.responseMessage,
      this.responseData,
      this.responseToken,
      this.responseCount,
      this.responseAdditionalData});

  BasebarcodeModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    responseStatus = json['response_status'];
    responseMessage = json['response_message'];
    responseData = json['response_data'];
    responseToken = json['response_token'];
    responseCount = json['response_count'];
    responseAdditionalData = json['response_additional_data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_code'] = this.responseCode;
    data['response_status'] = this.responseStatus;
    data['response_message'] = this.responseMessage;
    data['response_data'] = this.responseData;
    data['response_token'] = this.responseToken;
    data['response_count'] = this.responseCount;
    data['response_additional_data'] = this.responseAdditionalData;
    return data;
  }
}
