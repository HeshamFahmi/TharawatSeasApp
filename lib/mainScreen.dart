import 'dart:convert';

import 'package:barcode_scan_fix/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:search_choices/search_choices.dart';
import 'package:tharawatseas/DetailsModel.dart' as asde;
import 'HBmodel.dart' as ashm;

import 'aslDetailsfromQrcode.dart';
import 'locationModel.dart';
import 'navigationDrawer.dart';

import 'aslDetails.dart';
import 'constant.dart';

import 'package:http/http.dart' as http;

import 'generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'homePage.dart';

class MainScreen extends StatefulWidget {
  static const String routeName = '/MainScreen';

  @override
  _MainScreenState createState() => _MainScreenState();
}

//text over flow
// padding
// scan cancel

class Assets {
  final String assetNameAr;
  final String assetNameEn;
  final int purchasePrice;
  final String purchaseDate;

  Assets(this.assetNameAr, this.assetNameEn, this.purchasePrice,
      this.purchaseDate);
}

class _MainScreenState extends State<MainScreen> {
  bool loading = true;
  ashm.HBmodel data;
  String barcode;
  int pageNum = 1;
  String qrCodeResult;

  var myFormat = DateFormat('d-MM-yyyy');

  int itemCount;
  int flag = 0;
  getDataFromApisearch(int pageNo, String searchtxt, String locationId) async {
    setState(() {
      loading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('bearer');
    var headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'POST',
        Uri.parse(
            'http://faragmosa-001-site16.itempurl.com/api/AssetApi/GetAssetsForList'));
    request.body = json.encode({
      "PageNo": pageNo,
      "PageSize": 10,
      "SearchText": searchtxt,
      "LocationId": locationId
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      data = ashm.HBmodel.fromJson(
          json.decode(await response.stream.bytesToString()));
      setState(() {
        print(data.responseData.length);
        itemCount = data.responseData.length;
        loading = false;
        flag = 1;
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  getDataFromApi(int pageNo) async {
    loading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('bearer');
    var headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'POST',
        Uri.parse(
            'http://faragmosa-001-site16.itempurl.com/api/AssetApi/GetAssetsForList'));
    request.body = json.encode({"PageNo": pageNo, "PageSize": 10});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      data = ashm.HBmodel.fromJson(
          json.decode(await response.stream.bytesToString()));
      setState(() {
        print(data.responseData.length);
        itemCount = data.responseData.length;
        loading = false;
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  asde.DetailsModel detalisModel;
  var detailsresult;

  Future<void> scan() async {
    try {
      // final qrResult = await FlutterBarcodeScanner.scanBarcode(
      //     '#ff6666', 'Cancel', true, ScanMode.QR);

      String codeSanner = await BarcodeScanner.scan(); //barcode scanner
      setState(() {
        qrCodeResult = codeSanner;

        print(qrCodeResult);
      });

      var asset7alataid = qrCodeResult.substring(11, 47);
      AlertDialog alert = AlertDialog(
        title: Text("Qr Code Result"),
        content: Text(qrCodeResult),
        actions: [
          FlatButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text("show more details"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return AslDetailsFromQrCodes(
                      assetId: asset7alataid,
                    );
                  },
                ),
              );
            },
          ),
        ],
      );

      if (qrCodeResult.isEmpty || qrCodeResult == null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return HomePage();
            },
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          },
        );
      }

      // // if (qrResult == "-1") {
      // //   Navigator.push(
      // //     context,
      // //     MaterialPageRoute(
      // //       builder: (context) {
      // //         return HomePage();
      // //       },
      // //     ),
      // //   );
      // // } else {
      // //   var result = json.decode(qrResult);

      // //   Navigator.push(context, MaterialPageRoute(builder: (context) {
      // //     return AslDetailsFromQr(
      // //       assetNameAr: result["assetNameAr"].toString(),
      // //       assetNameEn: result["assetNameEn"].toString(),
      // //       classificationNameAr: result["classificationNameAr"].toString(),
      // //       classificationNameEn: result["classificationNameEn"].toString(),
      // //       purchaseDate: result["purchaseDate"].toString(),
      // //       purchasePrice: result["purchasePrice"].toString(),
      // //       assetDescription: result["assetDescription"].toString(),
      // //     );
      // //   }));

      // //   if (!mounted) return;

      // //   setState(() {
      // //     this.barcode = qrResult;
      // //     print(result);
      // //   });
      // }
    } on PlatformException {
      barcode = 'Failed';
    }
  }

  Future<LocationModel> assetsLocationDataFuture;

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    getDataFromApi(pageNum);
    assetsLocationDataFuture = getAssetLocationData();
    super.initState();
  }

  String _myAssetLocationSelection;
  List<String> locationData = [];
  List<String> locationDataId = [];
  var indexOfAssetLocation;
  Future<LocationModel> getAssetLocationData() async {
    loading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('bearer');
    var response = await http.get(
        Uri.http(
            'faragmosa-001-site16.itempurl.com', 'api/assetapi/GetLocations'),
        headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      LocationModel strings =
          LocationModel.fromJson(json.decode(response.body));

      for (var i = 0; i < strings.responseData.length; i++) {
        locationData.add(strings.responseData[i].locationNameAr);
        locationDataId.add(strings.responseData[i].locationId);
      }

      print(locationData.toString());
      print(locationDataId.toString());

      setState(() {
        loading = false;
      });

      return LocationModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load');
    }
  }

  TextEditingController searchedcontr = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: mPrimaryTextColor,
          title: Text(LocaleKeys.ShowAssets.tr()),
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
          : data.responseData.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.cyanAccent.withOpacity(0.5),
                        border: Border.all(
                          color: Colors.transparent,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Text(
                              "نأســف لا يـوجد اصــول مرتبطه بهــذا المــوقـع",
                              style: TextStyle(
                                  color: mPrimaryTextColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'عــوده',
                                style: TextStyle(fontSize: 20),
                              ),
                              style: ElevatedButton.styleFrom(
                                  primary: mSecondTextColor),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        // Text(
                        //   LocaleKeys.Welcome.tr(),
                        //   style: TextStyle(
                        //       color: mPrimaryTextColor,
                        //       fontSize: 20,
                        //       fontWeight: FontWeight.bold),
                        // ),
                        // SizedBox(
                        //   height: 20,
                        // ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(36),
                            ),
                            color: mSecondTextColor,
                            onPressed: () {
                              scan();
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              alignment: Alignment.center,
                              child: Text(
                                LocaleKeys.Scan_To_See_Your_Aasl_Details.tr(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                          ),
                        ),
/////////////
                        Container(
                          width: MediaQuery.of(context).size.width * .9,
                          margin: EdgeInsets.symmetric(vertical: 20),
                          child: TextField(
                            controller: searchedcontr,
                            onChanged: (String val) {},
                            decoration: InputDecoration(
                                suffix: InkWell(
                                  onTap: () {
                                    searchedcontr.clear();
                                  },
                                  child: Icon(
                                    Icons.close_rounded,
                                    size: 20,
                                    color: Colors.black,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                filled: true,
                                hintStyle: TextStyle(color: Colors.grey[800]),
                                hintText: "search",
                                fillColor: Colors.white70),
                          ),
                        ),
                        ///////////////////
                        ///
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width * .9,
                            padding: const EdgeInsets.only(right: 10, left: 10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(10)),
                            child: SearchChoices.single(
                              items: locationData.map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: new Text(value),
                                  ),
                                );
                              }).toList(),
                              value: _myAssetLocationSelection,
                              hint: LocaleKeys.Location.tr(),
                              searchHint: "Select one",
                              onChanged: (String newValue) {
                                setState(() {
                                  _myAssetLocationSelection = newValue;

                                  indexOfAssetLocation =
                                      locationData.indexOf(newValue);
                                });
                              },
                              isExpanded: true,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              pageNum = 1;
                            });
                            if (searchedcontr.text.isEmpty &&
                                locationDataId == null)
                              showToast("Plz choose search type");
                            getDataFromApisearch(
                                pageNum,
                                searchedcontr.text.isEmpty
                                    ? null
                                    : searchedcontr.text,
                                indexOfAssetLocation == null
                                    ? locationDataId[indexOfAssetLocation]
                                    : null);
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * .5,
                            margin: EdgeInsets.only(top: 10),
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 30),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(36),
                              color: mSecondTextColor,
                            ),
                            child: Text(
                              "Search",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                        ),

                        ///
                        //////////////

                        Wrap(
                          // mainAxisAlignment: ,
                          children: List.generate(
                              data.responseData.length,
                              (index) => GestureDetector(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return AslDetails(
                                          astDetails: data.responseData[index],
                                        );
                                      }));
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.all(10.0),
                                      padding: const EdgeInsets.all(10.0),

                                      // margin: all,
                                      width: MediaQuery.of(context).size.width *
                                          .4,
                                      decoration: BoxDecoration(
                                        color: Colors.blue[100],
                                        border: Border.all(
                                          color: Colors.grey[400],
                                          // width: 0,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        // mainAxisAlignment: Main,
                                        children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Ctxt(data
                                              .responseData[index].assetNameAr),
                                          Ctxt(data
                                              .responseData[index].assetNameEn),
                                          Ctxt(data
                                              .responseData[index].purchasePrice
                                              .toString()),
                                          Ctxt(myFormat
                                              .format(DateTime.parse(data
                                                  .responseData[index]
                                                  .purchaseDate))
                                              .toString())
                                        ],
                                      ),
                                    ),
                                  )),
                        ),
                        pageNum == 1 && itemCount < 10
                            ? Container()
                            : itemCount < 10
                                ? IconButton(
                                    onPressed: () {
                                      setState(() {
                                        pageNum--;
                                        flag != 0
                                            ? getDataFromApisearch(
                                                pageNum,
                                                searchedcontr.text.isEmpty
                                                    ? null
                                                    : searchedcontr.text,
                                                locationDataId[
                                                        indexOfAssetLocation] ??
                                                    null)
                                            : getDataFromApi(pageNum);
                                      });
                                    },
                                    icon: Icon(Icons.arrow_back_ios),
                                    color: mPrimaryTextColor,
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      pageNum <= 1
                                          ? Container()
                                          : IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  pageNum--;
                                                  flag != 0
                                                      ? getDataFromApisearch(
                                                          pageNum,
                                                          searchedcontr
                                                                  .text.isEmpty
                                                              ? null
                                                              : searchedcontr
                                                                  .text,
                                                          locationDataId[
                                                                  indexOfAssetLocation] ??
                                                              null)
                                                      : getDataFromApi(pageNum);
                                                });
                                              },
                                              icon: Icon(Icons.arrow_back_ios),
                                              color: mPrimaryTextColor,
                                            ),
                                      Text(
                                        "Page : " + pageNum.toString(),
                                        style:
                                            TextStyle(color: mPrimaryTextColor),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            pageNum++;
                                            flag != 0
                                                ? getDataFromApisearch(
                                                    pageNum,
                                                    searchedcontr.text.isEmpty
                                                        ? null
                                                        : searchedcontr.text,
                                                    locationDataId[
                                                            indexOfAssetLocation] ??
                                                        null)
                                                : getDataFromApi(pageNum);
                                          });
                                        },
                                        icon: Icon(Icons.arrow_forward_ios),
                                        color: mPrimaryTextColor,
                                      ),
                                    ],
                                  )
                      ],
                    ),
                  ),
                ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget Ctxt(String txt) {
    return FittedBox(
      fit: BoxFit.cover,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          txt,
          style: TextStyle(
            color: mPrimaryTextColor,
            height: 1,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.cyan.withOpacity(0.2),
      elevation: 0,
      centerTitle: true,
      title: Text(
        LocaleKeys.AppName.tr(),
        style: TextStyle(
            color: mPrimaryTextColor,
            fontSize: 30,
            fontWeight: FontWeight.bold),
      ),
    );
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
}
