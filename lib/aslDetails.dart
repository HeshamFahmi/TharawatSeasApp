import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'constant.dart';
import 'editAsset.dart';
import 'generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl.dart';
import 'HBmodel.dart' as hp;
import 'mainScreen.dart';

class AslDetails extends StatefulWidget {
  final hp.ResponseData astDetails;
  AslDetails({@required this.astDetails});

  @override
  _AslDetailsState createState() => _AslDetailsState();
}

class _AslDetailsState extends State<AslDetails> {
  var myFormat = DateFormat('d-MM-yyyy');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 40.0, left: 20, right: 20),
        decoration: BoxDecoration(
          color: Colors.blue[100],
          border: Border.all(
            color: Colors.grey[300],
            // width: 0,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 10,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(80),
                child: widget.astDetails.assetImage == null
                    ? Image.asset(
                        "assets/logo.jpg",
                        width: 150,
                        height: 150,
                      )
                    : Image.network(
                        "http://faragmosa-001-site16.itempurl.com/AssetImages/" +
                            widget.astDetails.assetImage,
                        width: 150,
                        height: 150,
                      ),
              ),
              cellText(LocaleKeys.AssetnameAr.tr(),
                  widget.astDetails.assetNameAr.toString()),
              cellText(LocaleKeys.AssetnameEn.tr(),
                  widget.astDetails.assetNameEn.toString()),
              cellText(LocaleKeys.BarCode.tr(),
                  widget.astDetails.assetBarcode.toString()),
              cellText(LocaleKeys.Location.tr(),
                  widget.astDetails.locationNameAr.toString()),
              cellText(LocaleKeys.Status.tr(),
                  widget.astDetails.assetStatusNameAr.toString()),
              widget.astDetails.assetDescription == null
                  ? Container()
                  : cellText(LocaleKeys.AssetDescription.tr(),
                      widget.astDetails.assetDescription.toString()),
              cellText(LocaleKeys.Price.tr(),
                  widget.astDetails.purchasePrice.toString()),
              cellText(
                  LocaleKeys.Date.tr(),
                  myFormat.format(DateTime.parse(
                      widget.astDetails.purchaseDate.toString()))),
              cellText(LocaleKeys.Classification.tr(),
                  widget.astDetails.classificationNameAr.toString()),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return EditAsset(
                              astDetails: widget.astDetails,
                            );
                          },
                        ),
                      );
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: mPrimaryTextColor),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.edit_rounded,
                            color: Colors.white,
                          ),
                          Ctxt("Edit", mBackgroundColor)
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      AlertDialog alert = AlertDialog(
                        title: Text("Delete Result"),
                        content: Text("Do You Want To Delete This Asset.."),
                        actions: [
                          FlatButton(
                            child: Text("Yes"),
                            onPressed: () {
                              setState(() {
                                deleteAsset(
                                    widget.astDetails.assetId.toString());
                              });
                            },
                          ),
                          FlatButton(
                            child: Text("No"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return alert;
                        },
                      );
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: mSecondTextColor,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                          Ctxt("Delete", mBackgroundColor)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
      appBar: buildAppBar(context),
    );
  }

  Widget cellText(String lable, String txt) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Ctxt("$lable : ", mPrimaryTextColor),
        Ctxt(txt, mSecondTextColor)
      ],
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

  deleteAsset(String assetId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('bearer');
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.Request(
        'GET',
        Uri.parse(
            'http://faragmosa-001-site16.itempurl.com/api/AssetApi/DeleteAsset/$assetId'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      showToast("Asset Deleted Successfully");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return MainScreen();
          },
        ),
      );
    } else {
      print(response.reasonPhrase);
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
}
