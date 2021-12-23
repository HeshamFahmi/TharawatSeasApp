class DetailsModel {
  String responseCode;
  String responseStatus;
  String responseMessage;
  ResponseData responseData;
  String responseToken;
  String responseCount;
  String responseAdditionalData;

  DetailsModel(
      {this.responseCode,
      this.responseStatus,
      this.responseMessage,
      this.responseData,
      this.responseToken,
      this.responseCount,
      this.responseAdditionalData});

  DetailsModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    responseStatus = json['response_status'];
    responseMessage = json['response_message'];
    responseData = json['response_data'] != null
        ? new ResponseData.fromJson(json['response_data'])
        : null;
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
      data['response_data'] = this.responseData.toJson();
    }
    data['response_token'] = this.responseToken;
    data['response_count'] = this.responseCount;
    data['response_additional_data'] = this.responseAdditionalData;
    return data;
  }
}

class ResponseData {
  String assetId;
  int assetCode;
  String assetNameAr;
  String assetNameEn;
  String classificationId;
  String assetBarcode;
  String supplierId;
  String purchaseDate;
  double purchasePrice;
  String notes;
  String data1;
  String data2;
  String data3;
  String data4;
  String data5;
  String data6;
  String assetDescription;
  bool isActive;
  bool isDeleted;
  String createdBy;
  String createdDate;
  String updatedBy;
  String updatedDate;
  int classificationCode;
  String classificationNameAr;
  String classificationNameEn;
  int supplierCode;
  String supplierNameAr;
  String supplierNameEn;
  int mobile;
  String supplierAddress;
  double latitude;
  double longitude;
  String qrcode;
  String assetStatusId;
  String locationId;
  String assetStatusCode;
  String assetStatusNameAr;
  String assetStatusNameEn;
  int locationCode;
  String locationNameEn;
  String locationNameAr;
  String deletedBy;
  String deletedDate;
  String assetImage;
  String assetSearch;

  ResponseData(
      {this.assetId,
      this.assetCode,
      this.assetNameAr,
      this.assetNameEn,
      this.classificationId,
      this.assetBarcode,
      this.supplierId,
      this.purchaseDate,
      this.purchasePrice,
      this.notes,
      this.data1,
      this.data2,
      this.data3,
      this.data4,
      this.data5,
      this.data6,
      this.assetDescription,
      this.isActive,
      this.isDeleted,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate,
      this.classificationCode,
      this.classificationNameAr,
      this.classificationNameEn,
      this.supplierCode,
      this.supplierNameAr,
      this.supplierNameEn,
      this.mobile,
      this.supplierAddress,
      this.latitude,
      this.longitude,
      this.qrcode,
      this.assetStatusId,
      this.locationId,
      this.assetStatusCode,
      this.assetStatusNameAr,
      this.assetStatusNameEn,
      this.locationCode,
      this.locationNameEn,
      this.locationNameAr,
      this.deletedBy,
      this.deletedDate,
      this.assetImage,
      this.assetSearch});

  ResponseData.fromJson(Map<String, dynamic> json) {
    assetId = json['assetId'];
    assetCode = json['assetCode'];
    assetNameAr = json['assetNameAr'];
    assetNameEn = json['assetNameEn'];
    classificationId = json['classificationId'];
    assetBarcode = json['assetBarcode'];
    supplierId = json['supplierId'];
    purchaseDate = json['purchaseDate'];
    purchasePrice = json['purchasePrice'];
    notes = json['notes'];
    data1 = json['data1'];
    data2 = json['data2'];
    data3 = json['data3'];
    data4 = json['data4'];
    data5 = json['data5'];
    data6 = json['data6'];
    assetDescription = json['assetDescription'];
    isActive = json['isActive'];
    isDeleted = json['isDeleted'];
    createdBy = json['createdBy'];
    createdDate = json['createdDate'];
    updatedBy = json['updatedBy'];
    updatedDate = json['updatedDate'];
    classificationCode = json['classificationCode'];
    classificationNameAr = json['classificationNameAr'];
    classificationNameEn = json['classificationNameEn'];
    supplierCode = json['supplierCode'];
    supplierNameAr = json['supplierNameAr'];
    supplierNameEn = json['supplierNameEn'];
    mobile = json['mobile'];
    supplierAddress = json['supplierAddress'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    qrcode = json['qrcode'];
    assetStatusId = json['assetStatusId'];
    locationId = json['locationId'];
    assetStatusCode = json['assetStatusCode'];
    assetStatusNameAr = json['assetStatusNameAr'];
    assetStatusNameEn = json['assetStatusNameEn'];
    locationCode = json['locationCode'];
    locationNameEn = json['locationNameEn'];
    locationNameAr = json['locationNameAr'];
    deletedBy = json['deletedBy'];
    deletedDate = json['deletedDate'];
    assetImage = json['assetImage'];
    assetSearch = json['assetSearch'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['assetId'] = this.assetId;
    data['assetCode'] = this.assetCode;
    data['assetNameAr'] = this.assetNameAr;
    data['assetNameEn'] = this.assetNameEn;
    data['classificationId'] = this.classificationId;
    data['assetBarcode'] = this.assetBarcode;
    data['supplierId'] = this.supplierId;
    data['purchaseDate'] = this.purchaseDate;
    data['purchasePrice'] = this.purchasePrice;
    data['notes'] = this.notes;
    data['data1'] = this.data1;
    data['data2'] = this.data2;
    data['data3'] = this.data3;
    data['data4'] = this.data4;
    data['data5'] = this.data5;
    data['data6'] = this.data6;
    data['assetDescription'] = this.assetDescription;
    data['isActive'] = this.isActive;
    data['isDeleted'] = this.isDeleted;
    data['createdBy'] = this.createdBy;
    data['createdDate'] = this.createdDate;
    data['updatedBy'] = this.updatedBy;
    data['updatedDate'] = this.updatedDate;
    data['classificationCode'] = this.classificationCode;
    data['classificationNameAr'] = this.classificationNameAr;
    data['classificationNameEn'] = this.classificationNameEn;
    data['supplierCode'] = this.supplierCode;
    data['supplierNameAr'] = this.supplierNameAr;
    data['supplierNameEn'] = this.supplierNameEn;
    data['mobile'] = this.mobile;
    data['supplierAddress'] = this.supplierAddress;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['qrcode'] = this.qrcode;
    data['assetStatusId'] = this.assetStatusId;
    data['locationId'] = this.locationId;
    data['assetStatusCode'] = this.assetStatusCode;
    data['assetStatusNameAr'] = this.assetStatusNameAr;
    data['assetStatusNameEn'] = this.assetStatusNameEn;
    data['locationCode'] = this.locationCode;
    data['locationNameEn'] = this.locationNameEn;
    data['locationNameAr'] = this.locationNameAr;
    data['deletedBy'] = this.deletedBy;
    data['deletedDate'] = this.deletedDate;
    data['assetImage'] = this.assetImage;
    data['assetSearch'] = this.assetSearch;
    return data;
  }
}
