import 'dart:convert';
import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tharawatseas/gaardresult/gaardcell.dart';
import 'package:tharawatseas/generated/locale_keys.g.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:barcode_scan_fix/barcode_scan.dart';

import '../constant.dart';
import '../gResultModel.dart';
import '../navigationDrawer.dart';
import '../sGaardModel.dart';

import 'package:http/http.dart' as http;

class GaardResults extends StatefulWidget {
  final String selectedLocation;
  final String selectedLagna;
  final String locationsId;
  final String committeeId;
  final String gaardNotes;

  const GaardResults(
      {Key key,
      this.selectedLocation,
      this.selectedLagna,
      this.locationsId,
      this.committeeId,
      this.gaardNotes})
      : super(key: key);

  @override
  _GaardResultsState createState() => _GaardResultsState();
}

// ignore: unused_element
Future<SGModel> _futGSModel;

class _GaardResultsState extends State<GaardResults> {
  List<TextEditingController> _controllers = new List();
  final ItemScrollController _itemScrollController = ItemScrollController();

  void _scrollToIndex(int index) {
    _itemScrollController.scrollTo(
        index: index,
        duration: Duration(seconds: 2),
        curve: Curves.easeInOutCubic);
  }

  String barcode;

  String recievedIdFromQr;

  int indexOfQr;

  var recievedAssetsId = [];

  Future<void> scan() async {
    try {
      // final qrResult = await FlutterBarcodeScanner.scanBarcode(
      //     '#ff6666', 'Cancel', true, ScanMode.QR);

      String qrResult;

      String codeSanner = await BarcodeScanner.scan(); //barcode scanner
      setState(() {
        qrResult = codeSanner;

        print(qrResult);
      });

      var asset7alataid = qrResult.substring(11, 47);

      if (qrResult.isEmpty || qrResult == null) {
        Navigator.of(context).pop();
      } else {
        // recievedIdFromQr = " " + asset7alataid;

        if (!mounted) return;

        setState(() {
          // print("oooooooooooooooooo" + recievedAssetsId.length.toString());
          // print("------" + asset7alataid);
          // print("++++++" + recievedIdFromQr);
          // print("kjkkk" + asset7alataid);

          indexOfQr = recievedAssetsId.indexOf(asset7alataid);
          // print(indexOfQr);
          this.barcode = qrResult;
        });

        if (indexOfQr == -1) {
          showToast("asset not found");
          return;
        }
        // print(recievedAssetsId);

        _scrollToIndex(indexOfQr + 1);
      }
    } on PlatformException {
      barcode = 'Failed';
    }
  }

  bool activeValue = false;

  DateTime selectedDate = DateTime.now();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  bool loading = true;

  GRModel gaardResultFuture;

  List<bool> isact = new List<bool>();
  List<Map<String, dynamic>> assetMap = [];

  String url =
      "http://faragmosa-001-site16.itempurl.com/api/InventoryApi/SaveInventory";

  @override
  void initState() {
    print("---------------befor");
    getAssetsByLocation(widget.locationsId);

    super.initState();
  }

  TextEditingController seco = TextEditingController();
  void dispose() {
    // Clean up the focus node when the Form is disposed.

    for (TextEditingController c in _controllers) {
      c.dispose();
    }

    super.dispose();
  }

  List<ResponseData> filtterlist = new List<ResponseData>();
  // ignore: non_constant_identifier_names

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mPrimaryTextColor,
          title: Text(LocaleKeys.Gaard.tr()),
        ),
        drawer: NavigationDrawer(),
        body: loading
            ? Center(child: CircularProgressIndicator())
            : gaardResultFuture.responseData.isEmpty
                ? noDataFound()
                : GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      // FocusScope.of(context).requestFocus(new FocusNode());
                    },
                    child: SingleChildScrollView(
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  alignment: Alignment.center,
                                  child: Text(
                                    LocaleKeys.ScanToSeeAsset.tr(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * .9,
                              margin: EdgeInsets.symmetric(vertical: 20),
                              child: TextField(
                                controller: seco,
                                onChanged: (String val) {
                                  print(
                                      "------------------------------------------");

                                  filtterlist.clear();
                                  setState(() {
                                    for (int i = 0;
                                        i <
                                            gaardResultFuture
                                                .responseData.length;
                                        i++) {
                                      if (gaardResultFuture
                                          .responseData[i].assetNameAr
                                          .contains(seco.text)) {
                                        filtterlist.add(
                                            gaardResultFuture.responseData[i]);
                                        print("--------------added----------");
                                      }
                                    }
                                  });
                                },
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    prefixIcon: Icon(Icons.search_rounded),
                                    // suffixIcon: InkWell(
                                    //     onTap: () {
                                    //       // filtterlist.clear();
                                    //       // setState(() {
                                    //       //   for (int i = 0;
                                    //       //       i <
                                    //       //           gaardResultFuture
                                    //       //               .responseData.length;
                                    //       //       i++) {
                                    //       //     if (gaardResultFuture
                                    //       //         .responseData[i].assetNameAr
                                    //       //         .contains(seco.text)) {
                                    //       //       filtterlist.add(gaardResultFuture
                                    //       //           .responseData[i]);
                                    //       //       print(
                                    //       //           "--------------added----------");
                                    //       //     }
                                    //       //   }
                                    //       // });
                                    //     },
                                    //     child: Icon(Icons.search)),
                                    filled: true,
                                    hintStyle:
                                        TextStyle(color: Colors.grey[800]),
                                    hintText: "search",
                                    fillColor: Colors.white70),
                              ),
                            ),
                            filtterlist.length != 0
                                ? listViewcells(filtterlist)
                                : listViewcells(gaardResultFuture.responseData),
                            savechanges()
                          ],
                        ),
                      ),
                    ),
                  ));
  }

  Widget listViewcells(List<ResponseData> items) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        child: ScrollablePositionedList.builder(
            itemScrollController: _itemScrollController,
            itemCount: items.length,
            addRepaintBoundaries: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              return GardCell(
                barCode: items[index].assetBarcode,
                controller: _controllers[index],
                name: items[index].assetNameAr,
                state: items[index].isActive,
              );
            }),
      ),
    );
  }

  Widget savechanges() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40.0, 5, 40.0, 5),
      child: Container(
        child: FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(36),
          ),
          color: mPrimaryTextColor,
          onPressed: () {
            for (var i = 0; i < gaardResultFuture.responseData.length; i++) {
              assetMap.add({
                "AssetId": gaardResultFuture.responseData[i].assetId.toString(),
                "IsExists": gaardResultFuture.responseData[i].isActive,
                "AssetNote": _controllers[i].text.toString()
              });
            }

            print(assetMap);
            setState(() {
              _futGSModel = saveGData(assetMap);
            });

            assetMap.clear();
          },
          child: Container(
            width: double.infinity,
            alignment: Alignment.center,
            child: Text(
              LocaleKeys.Save.tr(),
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }

  getAssetsByLocation(String locationsID) async {
    print("here in getassetbylocation");
    print(widget.locationsId);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('bearer');
    var headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            'http://faragmosa-001-site16.itempurl.com/api/InventoryApi/GetAssetsBylocation'));
    request.body = json.encode({"LocationId": "$locationsID"});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print("hi");
      // // var body = await response.stream.bytesToString();

      // // print("Show Response : " + body);

      gaardResultFuture =
          GRModel.fromJson(json.decode(await response.stream.bytesToString()));

      print("respone lenght : " +
          gaardResultFuture.responseData.length.toString());

      for (var i = 0; i < gaardResultFuture.responseData.length; i++) {
        _controllers.add(new TextEditingController());
        isact.add(
            gaardResultFuture.responseData[i].isActive == true ? true : false);
        recievedAssetsId
            .add(gaardResultFuture.responseData[i].assetId.toString().trim());
      }

      print(assetMap);

      setState(() {
        loading = false;
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<SGModel> saveGData(List<Map<String, dynamic>> map) async {
    final assetsData = {
      "InventoryId": "00000000-0000-0000-0000-000000000000",
      "InventoryCode": 0,
      "InventoryDate": formatter.format(selectedDate).toString(),
      "CommitteeId": widget.committeeId,
      "LocationId": widget.locationsId,
      "Notes": widget.gaardNotes,
      "TbInventoryAssets": map
    };

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('bearer');

    final response = await http.post(Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token'
        },
        body: json.encode(assetsData));

    print("Save Response : " + response.body);

    if (response.statusCode == 200) {
      print("Success");
      showToast(LocaleKeys.SavedSuccessfully.tr());
      return SGModel.fromJson(jsonDecode(response.body));
    } else {
      showToast("Failed");
      throw Exception('Failed to create album.');
    }
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

  Widget noDataFound() {
    return Center(
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
                  style: ElevatedButton.styleFrom(primary: mSecondTextColor),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
