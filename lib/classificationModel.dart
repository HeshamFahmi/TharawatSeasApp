class ClassificationModel {
  String responseCode;
  String responseStatus;
  String responseMessage;
  List<ResponseData> responseData;
  String responseToken;
  String responseCount;
  String responseAdditionalData;

  ClassificationModel(
      {this.responseCode,
      this.responseStatus,
      this.responseMessage,
      this.responseData,
      this.responseToken,
      this.responseCount,
      this.responseAdditionalData});

  ClassificationModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    responseStatus = json['response_status'];
    responseMessage = json['response_message'];
    if (json['response_data'] != null) {
      responseData = <ResponseData>[];
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
  String classificationId;
  int classificationCode;
  String classificationNameAr;
  String classificationNameEn;
  bool isLast;
  bool isActive;
  String createdBy;
  String createdDate;
  String updatedBy;
  String updatedDate;
  String parentClassificationId;
  bool isDeleted;
  String deletedBy;
  String deletedDate;
  String classficationImage;
  String baseBarcode;

  ResponseData({
    this.classificationId,
    this.classificationCode,
    this.classificationNameAr,
    this.classificationNameEn,
    this.isLast,
    this.isActive,
    this.createdBy,
    this.createdDate,
    this.updatedBy,
    this.updatedDate,
    this.parentClassificationId,
    this.isDeleted,
    this.deletedBy,
    this.deletedDate,
    this.classficationImage,
    this.baseBarcode,
  });

  ResponseData.fromJson(Map<String, dynamic> json) {
    classificationId = json['classificationId'];
    classificationCode = json['classificationCode'];
    classificationNameAr = json['classificationNameAr'];
    classificationNameEn = json['classificationNameEn'];
    isLast = json['isLast'];
    isActive = json['isActive'];
    createdBy = json['createdBy'];
    createdDate = json['createdDate'];
    updatedBy = json['updatedBy'];
    updatedDate = json['updatedDate'];
    parentClassificationId = json['parentClassificationId'];
    isDeleted = json['isDeleted'];
    deletedBy = json['deletedBy'];
    deletedDate = json['deletedDate'];
    classficationImage = json['classficationImage'];
    baseBarcode = json['baseBarcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['classificationId'] = this.classificationId;
    data['classificationCode'] = this.classificationCode;
    data['classificationNameAr'] = this.classificationNameAr;
    data['classificationNameEn'] = this.classificationNameEn;
    data['isLast'] = this.isLast;
    data['isActive'] = this.isActive;
    data['createdBy'] = this.createdBy;
    data['createdDate'] = this.createdDate;
    data['updatedBy'] = this.updatedBy;
    data['updatedDate'] = this.updatedDate;
    data['parentClassificationId'] = this.parentClassificationId;
    data['isDeleted'] = this.isDeleted;
    data['deletedBy'] = this.deletedBy;
    data['deletedDate'] = this.deletedDate;
    data['classficationImage'] = this.classficationImage;
    data['baseBarcode'] = this.baseBarcode;

    return data;
  }
}
