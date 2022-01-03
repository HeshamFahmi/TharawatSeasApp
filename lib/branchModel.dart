class BranchModel {
  String responseCode;
  String responseStatus;
  String responseMessage;
  List<ResponseData> responseData;
  String responseToken;
  int responseCount;
  String responseAdditionalData;

  BranchModel(
      {this.responseCode,
      this.responseStatus,
      this.responseMessage,
      this.responseData,
      this.responseToken,
      this.responseCount,
      this.responseAdditionalData});

  BranchModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    responseStatus = json['response_status'];
    responseMessage = json['response_message'];
    if (json['response_data'] != null) {
      responseData = new List<ResponseData>();
      json['response_data'].forEach((v) {
        responseData.add(new ResponseData.fromJson(v));
      });
    }
    responseToken = json['response_token'];
    responseCount = json['response_count'];
    responseAdditionalData = json['response_additional_data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_code'] = this.responseCode;
    data['response_status'] = this.responseStatus;
    data['response_message'] = this.responseMessage;
    if (this.responseData != null) {
      data['response_data'] = this.responseData.map((v) => v.toJson()).toList();
    }
    data['response_token'] = this.responseToken;
    data['response_count'] = this.responseCount;
    data['response_additional_data'] = this.responseAdditionalData;
    return data;
  }
}

class ResponseData {
  String locationId;
  String branchId;
  int locationCode;
  String locationNameAr;
  String locationNameEn;
  bool isActive;
  bool isDeleted;
  String createdBy;
  String createdDate;
  String updatedBy;
  String updatedDate;
  String branchNameAr;
  String branchNameEn;

  ResponseData(
      {this.locationId,
      this.branchId,
      this.locationCode,
      this.locationNameAr,
      this.locationNameEn,
      this.isActive,
      this.isDeleted,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate,
      this.branchNameAr,
      this.branchNameEn});

  ResponseData.fromJson(Map<String, dynamic> json) {
    locationId = json['locationId'];
    branchId = json['branchId'];
    locationCode = json['locationCode'];
    locationNameAr = json['locationNameAr'];
    locationNameEn = json['locationNameEn'];
    isActive = json['isActive'];
    isDeleted = json['isDeleted'];
    createdBy = json['createdBy'];
    createdDate = json['createdDate'];
    updatedBy = json['updatedBy'];
    updatedDate = json['updatedDate'];
    branchNameAr = json['branchNameAr'];
    branchNameEn = json['branchNameEn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['locationId'] = this.locationId;
    data['branchId'] = this.branchId;
    data['locationCode'] = this.locationCode;
    data['locationNameAr'] = this.locationNameAr;
    data['locationNameEn'] = this.locationNameEn;
    data['isActive'] = this.isActive;
    data['isDeleted'] = this.isDeleted;
    data['createdBy'] = this.createdBy;
    data['createdDate'] = this.createdDate;
    data['updatedBy'] = this.updatedBy;
    data['updatedDate'] = this.updatedDate;
    data['branchNameAr'] = this.branchNameAr;
    data['branchNameEn'] = this.branchNameEn;
    return data;
  }
}
