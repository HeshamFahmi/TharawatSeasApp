import 'package:flutter/material.dart';
import 'package:tharawatseas/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import '../constant.dart';

// ignore: must_be_immutable
class GardCell extends StatefulWidget {
  String name;

  String barCode;

  bool state;

  TextEditingController controller;
  GardCell({this.barCode, this.controller, this.name, this.state});
  @override
  _GardCellState createState() => _GardCellState();
}

class _GardCellState extends State<GardCell> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              IntrinsicHeight(
                  child: Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color:
                        Colors.blue[100], //Colors.cyanAccent.withOpacity(0.5),
                    border: Border.all(
                      color: Colors.grey[600],
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      cellText(LocaleKeys.AssetName.tr(), widget.name),
                      cellText(
                          LocaleKeys.BarCode.tr(), widget.barCode.toString()),
                      Row(
                        children: <Widget>[
                          Ctxt("IsExist : ", mPrimaryTextColor),
                          Checkbox(
                            value: widget.state,
                            onChanged: (bool value) {
                              setState(() {
                                widget.state = value;
                                print(value.toString());
                                print("recieved value : " +
                                    widget.state.toString());
                              });
                            },
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextField(
                          controller: widget.controller,
                          minLines: 2,
                          maxLines: 5,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: LocaleKeys.AddNotes.tr(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ))
            ],
          )
        ],
      ),
    );
  }

  Widget cellText(String lable, String txt) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Ctxt(lable, mPrimaryTextColor),
        Ctxt(":", Colors.black),
        Ctxt(txt, mSecondTextColor)
      ],
    );
  }

  // ignore: non_constant_identifier_names
  Widget Ctxt(String txt, Color color) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          txt,
          style: TextStyle(
            color: color,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
