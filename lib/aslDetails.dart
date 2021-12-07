import 'package:flutter/material.dart';

import 'HBmodel.dart';
import 'constant.dart';
import 'generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl.dart';
import 'HBmodel.dart' as hp;

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
                myFormat.format(
                    DateTime.parse(widget.astDetails.purchaseDate.toString()))),
            cellText(LocaleKeys.Classification.tr(),
                widget.astDetails.classificationNameAr.toString()),
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
}
