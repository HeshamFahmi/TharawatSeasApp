import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'HBmodel.dart';
import 'constant.dart';
import 'generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl.dart';
import 'DetailsModel.dart' as det;
import 'package:http/http.dart' as http;

class AslDetailsFromQrCodes extends StatefulWidget {
  final String assetId;
  AslDetailsFromQrCodes({@required this.assetId});

  @override
  _AslDetailsFromQrCodesState createState() => _AslDetailsFromQrCodesState();
}

class _AslDetailsFromQrCodesState extends State<AslDetailsFromQrCodes> {
  var myFormat = DateFormat('d-MM-yyyy');

  bool loading = true;

  @override
  void initState() {
    // TODO: implement initState
    getAssetsById(widget.assetId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              margin: const EdgeInsets.only(top: 40.0, left: 20, right: 20),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                border: Border.all(
                  color: Colors.grey[300],
                  // width: 0,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  cellText(LocaleKeys.AssetnameAr.tr(),
                      detalisModel.responseData.assetNameAr.toString()),
                  cellText(LocaleKeys.AssetnameEn.tr(),
                      detalisModel.responseData.assetNameEn.toString()),
                  cellText(LocaleKeys.BarCode.tr(),
                      detalisModel.responseData.assetBarcode.toString()),
                  cellText(LocaleKeys.Location.tr(),
                      detalisModel.responseData.locationNameAr.toString()),
                  cellText(LocaleKeys.Status.tr(),
                      detalisModel.responseData.assetStatusNameAr.toString()),
                  detalisModel.responseData.assetDescription == null
                      ? Container()
                      : cellText(
                          LocaleKeys.AssetDescription.tr(),
                          detalisModel.responseData.assetDescription
                              .toString()),
                  cellText(LocaleKeys.Price.tr(),
                      detalisModel.responseData.purchasePrice.toString()),
                  cellText(
                      LocaleKeys.Date.tr(),
                      myFormat.format(DateTime.parse(
                          detalisModel.responseData.purchaseDate.toString()))),
                  cellText(
                      LocaleKeys.Classification.tr(),
                      detalisModel.responseData.classificationNameAr
                          .toString()),
                ],
              ),
            ),
      appBar: buildAppBar(context),
    );
  }

  Widget cellText(String lable, String txt) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Ctxt("$lable : ", mPrimaryTextColor),
          Ctxt(txt, mSecondTextColor)
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget Ctxt(String txt, Color colors) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          txt,
          style: TextStyle(
            color: colors,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: mPrimaryTextColor,
      elevation: 0,
      centerTitle: true,
      title: Text(
        LocaleKeys.AppName.tr(),
        style: TextStyle(
            color: mBackgroundColor, fontSize: 30, fontWeight: FontWeight.bold),
      ),
    );
  }

  det.DetailsModel detalisModel;

  getAssetsById(String assetId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('bearer');
    print(token);
    var headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'POST',
        Uri.parse(
            'http://faragmosa-001-site16.itempurl.com/api/assetapi/FindAssetDetails'));
    request.body = json.encode({"Param1": "$assetId"});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      detalisModel = det.DetailsModel.fromJson(
          json.decode(await response.stream.bytesToString()));

      setState(() {
        loading = false;
      });
    } else {
      print(response.reasonPhrase);
    }
  }
}
