import 'dart:convert';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:search_choices/search_choices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tharawatseas/basebarcodemodel.dart';
import 'package:tharawatseas/editAssetModel.dart';
import 'SDAssetModel.dart';
import 'branchModel.dart';
import 'homePage.dart';
import 'locationModel.dart';
import 'classificationModel.dart';
import 'constant.dart';
import 'generated/locale_keys.g.dart';
import 'navigationDrawer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'supplierModel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'HBmodel.dart' as hp;

class EditAsset extends StatefulWidget {
  static const String routeName = '/EditAsset';
  final hp.ResponseData astDetails;

  const EditAsset({Key key, this.astDetails}) : super(key: key);

  @override
  _EditAssetState createState() => _EditAssetState();
}

// ignore: unused_element
Future<SDModel> _futHSModel;
double lat, long;

class _EditAssetState extends State<EditAsset> {
  PickedFile uploadImage;
  final _nameArabicController = TextEditingController();
  final _nameEnglishController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _report1Controller = TextEditingController();
  final _report2Controller = TextEditingController();
  final _barCodeController = TextEditingController();
  final _assetbarCodeController = TextEditingController();
  //static final kInitialPosition = LatLng(-33.8567844, 151.213108);
  String _myAssetSupplierSelection;
  List<String> supplierData = [];
  List<String> supplierDataId = [];
  var indexOfAssetSupplier;

  BasebarcodeModel basebarcodeModel;

  String _myAssetClassificationSelection;
  List<String> classificationData = [];
  List<String> classificationBaseBarcode = [];
  List<String> classificationDataId = [];
  var indexOfAssetClassification;

  String _myAssetLocationsSelection;
  List<String> locationsData = [];
  List<String> locationsDataId = [];
  var indexOfAssetLocations;

  String _mybrancheSelection;
  List<String> branchesData = [];
  List<String> branchesDataID = [];
  var indexOfbranches;

  String url =
      "http://faragmosa-001-site16.itempurl.com/api/assetapi/SaveAsset";

  String uploadImageUrl =
      "http://faragmosa-001-site16.itempurl.com/api/Uploader/upload/AssetImages";

  DateTime selectedDate = DateTime.now();
  bool imageloaded = false;
  Future<void> uploadImagefun() async {
    setState(() {
      imageloaded = true;
    });
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'http://faragmosa-001-site16.itempurl.com/api/Uploader/upload/AssetImages'));
    request.files
        .add(await http.MultipartFile.fromPath('file', '${uploadImage.path}'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString() + "----------------------");
    } else {
      print(
          "ssssssssssssssssssssss response.reasonPhrase:${response.reasonPhrase}");
    }
    setState(() {
      imageloaded = false;
    });
  }

  Future<void> chooseImage(BuildContext context) async {
    // var choosedImage =
    //     await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    // print(choosedImage!.path);
    // setState(() {
    //   uploadImage = choosedImage as XFile?;
    //   print(uploadImage!.path);
    // });
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final PickedFile image =
        (await _picker.getImage(source: ImageSource.gallery));
    print("sssssssssssssssssssssssImagePath: ${image.path}");
    // Capture a photo
    setState(() {
      uploadImage = image;
      print(
          "ssssssssssssssssssssssssssssssss UploadImagePath: ${uploadImage.path}");
    });
    Navigator.pop(context);
  }

  Future<void> takeAPhoto(BuildContext context) async {
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
    );
    setState(() {
      uploadImage = pickedFile;
    });
    Navigator.pop(context);
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Choose option",
              style: TextStyle(color: Colors.blue),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  ListTile(
                    onTap: () {
                      chooseImage(context).then((value) {
                        showToast(LocaleKeys.ImageChosen.tr());
                      });
                    },
                    title: Text("Gallery"),
                    leading: Icon(
                      Icons.account_box_rounded,
                      color: Colors.blue,
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  ListTile(
                    onTap: () {
                      takeAPhoto(context).then((value) {
                        showToast(LocaleKeys.ImageChosen.tr());
                      });
                    },
                    title: Text("Camera"),
                    leading: Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue[900],
        textColor: Colors.white,
        fontSize: 16.0);
  }

  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));

    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Future<LocationModel> getLocationsbyBranchIdData(String branchId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('bearer');
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'POST',
        Uri.parse(
            'http://faragmosa-001-site16.itempurl.com/api/LocationApi/GetLocationsByBranch'));
    request.body = json.encode({"BranchId": branchId});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      LocationModel strings = LocationModel.fromJson(
          json.decode(await response.stream.bytesToString()));

      for (var i = 0; i < strings.responseData.length; i++) {
        locationsData.add(strings.responseData[i].locationNameAr);
        locationsDataId.add(strings.responseData[i].locationId);
      }

      print(locationsData.toString());
      print(locationsDataId.toString());

      setState(() {
        loading = false;
      });

      // return LocationModel.fromJson(
      //     json.decode(await response.stream.bytesToString()));
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<BranchModel> getLocationsData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('bearer');
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.Request(
        'GET',
        Uri.parse(
            'http://faragmosa-001-site16.itempurl.com/api/LocationApi/GetAllLocations'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      BranchModel strings = BranchModel.fromJson(
          json.decode(await response.stream.bytesToString()));

      for (var i = 0; i < strings.responseData.length; i++) {
        if (strings.responseData[i].branchId == null) {
          print("null");
        } else {
          branchesData.add(strings.responseData[i].branchNameAr);
          branchesDataID.add(strings.responseData[i].branchId);
        }
      }

      print(branchesData.toString());
      print(branchesDataID.toString());

      setState(() {
        loading = false;
      });

      // return BranchModel.fromJson(
      //     json.decode(await response.stream.bytesToString()));
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<SDModel> saveData(
      String assetId,
      String assetNameAr,
      String assetNameEn,
      String classificationId,
      String assetBarcode,
      String baseBarcode,
      String purchaseDate,
      double purchasePrice,
      double latitude,
      double longitude,
      String assetDescription,
      String qrcode,
      String supplierId,
      String locationId,
      String branchId) async {
    final assetsData = {
      "AssetId": assetId,
      "AssetNameAr": assetNameAr,
      "AssetNameEn": assetNameEn,
      "ClassificationId": classificationId,
      "AssetBarcode": assetBarcode,
      "BaseBarcode": baseBarcode,
      "PurchaseDate": purchaseDate,
      "PurchasePrice": purchasePrice,
      "Latitude": latitude,
      "Longitude": longitude,
      "AssetDescription": assetDescription,
      "Qrcode": qrcode,
      "SupplierId": supplierId,
      "LocationId": locationId,
      "BranchId": branchId,
      "isActive": true,
    };

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('bearer');

    print(token);

    final response = await http.post(Uri.parse(url),
        headers: <String, String>{
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(assetsData));

    print(response.body);

    //showLoadingDialog(context, _LoaderDialog);

    if (response.statusCode == 200) {
      print(jsonEncode(assetsData));
      //Navigator.of(_LoaderDialog.currentContext, rootNavigator: true).pop();

      if (jsonDecode(response.body)["response_code"] == "500") {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Error"),
                content: Text(jsonDecode(response.body)["response_message"]),
                actions: [
                  FlatButton(
                    child: Text("Ok"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      } else {
        print("Success");
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Success"),
                content: Text("Asset Edited Successfully"),
                actions: [
                  FlatButton(
                    child: Text("Ok"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
        return SDModel.fromJson(jsonDecode(response.body));
      }
      return SDModel.fromJson(jsonDecode(response.body));
    } else {
      showToast("Failed");
      throw Exception('Failed to create album.');
    }
  }

  Future<ClassificationModel> getAssetClassificationData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('bearer');
    var response = await http.get(
        Uri.http('faragmosa-001-site16.itempurl.com',
            'api/assetapi/GetAssetClassifications'),
        headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      ClassificationModel strings =
          ClassificationModel.fromJson(json.decode(response.body));

      for (var i = 0; i < strings.responseData.length; i++) {
        classificationData.add(strings.responseData[i].classificationNameAr);
        classificationBaseBarcode.add(strings.responseData[i].baseBarcode);
        classificationDataId.add(strings.responseData[i].classificationId);
      }

      print(classificationData.toString());
      print(classificationDataId.toString());

      setState(() {
        loading = false;
      });

      return ClassificationModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<SupplierModel> getAssetSupplierData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('bearer');
    var response = await http.get(
        Uri.http('faragmosa-001-site16.itempurl.com',
            'api/assetapi/GetAssetSuppliers'),
        headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      SupplierModel strings =
          SupplierModel.fromJson(json.decode(response.body));

      print(response.body);

      for (var i = 0; i < strings.responseData.length; i++) {
        supplierData.add(strings.responseData[i].supplierNameAr);
        supplierDataId.add(strings.responseData[i].supplierId);
      }

      print(supplierData.toString());
      print(supplierDataId.toString());

      setState(() {
        loading = false;
      });

      return SupplierModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load');
    }
  }

  getbasebarcodebylocationid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('bearer');
    var response = await http.get(
        Uri.http('faragmosa-001-site16.itempurl.com',
            'api/ClassificationApi/getBasebarcode/${widget.astDetails.classificationId}'),
        headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      //basebarcodeModel = jsonDecode(response.body);
      basebarcodeModel = BasebarcodeModel.fromJson(jsonDecode(response.body));
      print(basebarcodeModel.responseData);
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<ClassificationModel> assetsClassificationDataFuture;
  Future<SupplierModel> assetsSupplierDataFuture;
  Future<BranchModel> assetsLocationDataFuture;

  EditAssetModel editAssetModel;

  bool loading = true;

  getAssetDtailsByAssetId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('bearer');
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'POST',
        Uri.parse(
            'http://faragmosa-001-site16.itempurl.com/api/AssetApi/FindAssetDetails'));
    request.body = json.encode({"Param1": widget.astDetails.assetId});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      editAssetModel = EditAssetModel.fromJson(
          jsonDecode(await response.stream.bytesToString()));

      Future.delayed(Duration(seconds: 3));

      getLocationsbyBranchIdData(editAssetModel.responseData.branchId);
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  void initState() {
    assetsClassificationDataFuture = getAssetClassificationData();
    assetsLocationDataFuture = getLocationsData();
    assetsSupplierDataFuture = getAssetSupplierData();
    getbasebarcodebylocationid();
    getAssetDtailsByAssetId();
    super.initState();
  }

  bool _validate = false;

  Widget cTextField(String hint, final controller, bool validator) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          labelStyle: TextStyle(
            color: mPrimaryTextColor,
            fontWeight: FontWeight.bold,
          ),
          labelText: hint,
          errorText: validator ? LocaleKeys.ValueEmpty.tr() : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
            backgroundColor: mPrimaryTextColor,
            title: Text("Edit Asset"),
            actions: [
              IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: mBackgroundColor,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
            ]),
        drawer: NavigationDrawer(),
        body: loading
            ? Center(child: CircularProgressIndicator())
            : Container(
                margin: const EdgeInsets.all(10.0),
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.withOpacity(0.7),
                  border: Border.all(
                    color: Colors.transparent,
                    width: 0,
                  ),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: SingleChildScrollView(
                  child: Center(
                      child: Column(
                    children: <Widget>[
                      cTextField(
                        LocaleKeys.AssetnameAr.tr(),
                        _nameArabicController
                          ..text = widget.astDetails.assetNameAr,
                        _validate,
                      ),
                      cTextField(
                          LocaleKeys.AssetnameEn.tr(),
                          _nameEnglishController
                            ..text = widget.astDetails.assetNameEn,
                          _validate),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextField(
                          controller: _priceController
                            ..text = widget.astDetails.purchasePrice.toString(),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            labelStyle: TextStyle(
                              color: mPrimaryTextColor,
                              fontWeight: FontWeight.bold,
                            ),
                            labelText: LocaleKeys.Price.tr(),
                            errorText:
                                _validate ? LocaleKeys.ValueEmpty.tr() : null,
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextField(
                          readOnly: true,
                          controller: _assetbarCodeController
                            ..text = widget.astDetails.assetBarcode,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            labelStyle: TextStyle(
                              color: mPrimaryTextColor,
                              fontWeight: FontWeight.bold,
                            ),
                            labelText: LocaleKeys.BarCode.tr(),
                            errorText:
                                _validate ? LocaleKeys.ValueEmpty.tr() : null,
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: mSecondTextColor,
                          onPressed: () async {
                            LocationResult result = await showLocationPicker(
                              context,
                              "AIzaSyBU6YNVxesC2-qRF2yDgCk7be8QaQz56kQ",
                              initialCenter: LatLng(31.1975844, 29.9598339),
                              automaticallyAnimateToCurrentLocation: true,
                              myLocationButtonEnabled: true,
                              layersButtonEnabled: true,
                            );
                            setState(() {
                              lat = result.latLng.latitude;
                              long = result.latLng.longitude;
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            alignment: Alignment.center,
                            child: Text(
                              LocaleKeys.Location.tr(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    LocaleKeys.ChooseImage.tr(),
                                    style: TextStyle(
                                        color: mBackgroundColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () {
                                    _showChoiceDialog(context);
                                  },
                                  color: Colors.green,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: imageloaded
                                    ? CircularProgressIndicator()
                                    : Container(
                                        width: 0,
                                        height: 0,
                                      ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: RaisedButton(
                                  child: Text(
                                    LocaleKeys.UploadImage.tr(),
                                    style: TextStyle(
                                        color: mBackgroundColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  color: Colors.green,
                                  onPressed: () {
                                    uploadImage == null
                                        ? showToast("Please choose your Image")
                                        : uploadImagefun().then((value) {
                                            showToast(
                                                LocaleKeys.ImageUploaded.tr());
                                          });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: mPrimaryTextColor,
                          onPressed: () {
                            _selectDate(context);
                            print(selectedDate.toString());
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(
                                  Icons.calendar_today_rounded,
                                  color: Colors.white,
                                ),
                                Text(
                                  selectedDate != null
                                      ? formatter
                                          .format(DateTime.parse(
                                              widget.astDetails.purchaseDate))
                                          .toString()
                                      : LocaleKeys.EnterDate.tr(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(right: 10, left: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(20.0)),
                          child: DropdownButton<String>(
                            hint: Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Text(LocaleKeys.Classification.tr()),
                            ),
                            isExpanded: true,
                            items: classificationData.map((String value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: new Text(value),
                                ),
                              );
                            }).toList(),
                            value: widget.astDetails.classificationNameAr,
                            onChanged: null,
                          ),
                        ),
                      ),
                      basebarcodeModel == null
                          ? Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextField(
                                readOnly: true,
                                enabled: false,
                                controller: _barCodeController..text = "",
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  labelStyle: TextStyle(
                                    color: mPrimaryTextColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  labelText: LocaleKeys.BarCode.tr(),
                                  errorText: _validate
                                      ? LocaleKeys.ValueEmpty.tr()
                                      : null,
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextField(
                                readOnly: true,
                                enabled: false,
                                controller: _barCodeController
                                  ..text = basebarcodeModel.responseData,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  labelStyle: TextStyle(
                                    color: mPrimaryTextColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  labelText: LocaleKeys.BarCode.tr(),
                                  errorText: _validate
                                      ? LocaleKeys.ValueEmpty.tr()
                                      : null,
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                              ),
                            ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(right: 10, left: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(20.0)),
                          child: DropdownButton<String>(
                            hint: Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Text(LocaleKeys.Supplier.tr()),
                            ),
                            isExpanded: true,
                            items: supplierData.map((String value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: new Text(value),
                                ),
                              );
                            }).toList(),
                            value: widget.astDetails.supplierNameAr,
                            onChanged: (String newValue) {
                              setState(() {
                                widget.astDetails.supplierNameAr = newValue;

                                indexOfAssetSupplier =
                                    supplierData.indexOf(newValue);
                              });
                            },
                          ),
                        ),
                      ),
                      editAssetModel.responseData.branchNameAr == null
                          ? Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.only(right: 10, left: 10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: SearchChoices.single(
                                  items: branchesData.map((String value) {
                                    return new DropdownMenuItem<String>(
                                      value: value,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10.0),
                                        child: new Text(value),
                                      ),
                                    );
                                  }).toList(),
                                  value: _mybrancheSelection,
                                  hint: EasyLocalization.of(context).locale ==
                                          Locale("en")
                                      ? "Branch"
                                      : "الفرع",
                                  searchHint: "Select one",
                                  onChanged: (String newValue) {
                                    setState(() {
                                      _mybrancheSelection = newValue;

                                      print(_mybrancheSelection);

                                      indexOfbranches =
                                          branchesData.indexOf(newValue);

                                      print(branchesDataID[indexOfbranches]);

                                      setState(() {
                                        loading = true;
                                        locationsData.clear();
                                        locationsDataId.clear();
                                        getLocationsbyBranchIdData(
                                            branchesDataID[indexOfbranches]);
                                        loading = false;
                                      });
                                    });
                                  },
                                  isExpanded: true,
                                ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.only(right: 10, left: 10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: SearchChoices.single(
                                  items: branchesData.map((String value) {
                                    return new DropdownMenuItem<String>(
                                      value: value,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10.0),
                                        child: new Text(value),
                                      ),
                                    );
                                  }).toList(),
                                  value:
                                      editAssetModel.responseData.branchNameAr,
                                  hint: EasyLocalization.of(context).locale ==
                                          Locale("en")
                                      ? "Branch"
                                      : "الفرع",
                                  searchHint: "Select one",
                                  onChanged: (String newValue) {
                                    setState(() {
                                      editAssetModel.responseData.branchNameAr =
                                          newValue;

                                      print(editAssetModel
                                          .responseData.branchNameAr);

                                      indexOfbranches =
                                          branchesData.indexOf(newValue);

                                      print(branchesDataID[indexOfbranches]);

                                      setState(() {
                                        loading = true;
                                        locationsData.clear();
                                        locationsDataId.clear();
                                        getLocationsbyBranchIdData(
                                            branchesDataID[indexOfbranches]);
                                        loading = false;
                                      });
                                    });
                                  },
                                  isExpanded: true,
                                ),
                              ),
                            ),
                      locationsData.isEmpty
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.only(right: 10, left: 10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: SearchChoices.single(
                                  items: locationsData.map((String value) {
                                    return new DropdownMenuItem<String>(
                                      value: value,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10.0),
                                        child: new Text(value),
                                      ),
                                    );
                                  }).toList(),
                                  value: editAssetModel
                                      .responseData.locationNameAr,
                                  hint: LocaleKeys.Location.tr(),
                                  searchHint: "Select one",
                                  onChanged: (String newValue) {
                                    setState(() {
                                      editAssetModel.responseData
                                          .locationNameAr = newValue;

                                      print(editAssetModel
                                          .responseData.locationNameAr);

                                      indexOfAssetLocations =
                                          locationsData.indexOf(newValue);
                                    });
                                  },
                                  isExpanded: true,
                                ),
                              ),
                            ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextField(
                          controller: _descriptionController
                            ..text = widget.astDetails.assetDescription,
                          minLines: 5,
                          maxLines: 5,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            labelStyle: TextStyle(
                              color: mPrimaryTextColor,
                              fontWeight: FontWeight.bold,
                            ),
                            labelText: LocaleKeys.AssetDescription.tr(),
                            errorText:
                                _validate ? LocaleKeys.ValueEmpty.tr() : null,
                          ),
                        ),
                      ),
                      cTextField(
                        LocaleKeys.DeclarationOne.tr(),
                        _report1Controller..text = "",
                        _validate,
                      ),
                      cTextField(
                        LocaleKeys.DeclarationTwo.tr(),
                        _report2Controller..text = "",
                        _validate,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _futHSModel = saveData(
                                widget.astDetails.assetId,
                                _nameArabicController.text.toString(),
                                _nameEnglishController.text.toString(),
                                widget.astDetails.classificationId.toString(),
                                widget.astDetails.assetBarcode,
                                basebarcodeModel.responseData,
                                formatter.format(selectedDate).toString(),
                                double.parse(_priceController.text),
                                lat ?? 20.332232,
                                long ?? 2.23332,
                                _descriptionController.text,
                                "",
                                indexOfAssetSupplier == null
                                    ? widget.astDetails.supplierId
                                    : supplierDataId.isNotEmpty
                                        ? supplierDataId[indexOfAssetSupplier]
                                            .toString()
                                        : null,
                                indexOfAssetLocations == null
                                    ? widget.astDetails.locationId.toString()
                                    : locationsDataId[indexOfAssetLocations]
                                        .toString(),
                                indexOfbranches == null
                                    ? editAssetModel.responseData.branchId
                                        .toString()
                                    : branchesDataID[indexOfbranches]
                                        .toString());
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(
                            left: 40,
                            right: 40,
                          ),
                          padding: EdgeInsets.all(10),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: mPrimaryTextColor),
                          child: Text(
                            "Save Edit",
                            style: TextStyle(
                                color: mBackgroundColor, fontSize: 15),
                          ),
                        ),
                      )
                    ],
                  )),
                ),
              ));
  }
}
