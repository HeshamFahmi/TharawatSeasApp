import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tharawatseas/constant.dart';
import 'package:tharawatseas/login.dart';
import 'generated/locale_keys.g.dart';
import 'pageRoutes.dart';
import 'package:easy_localization/easy_localization.dart';

class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          createDrawerHeader(),
          createDrawerBodyItem(
            icon: Icons.home_filled,
            text: LocaleKeys.Home.tr(),
            onTap: () =>
                Navigator.pushReplacementNamed(context, PageRoutes.homepage),
          ),
          createDrawerBodyItem(
            icon: Icons.slideshow_rounded,
            text: LocaleKeys.ShowAssets.tr(),
            onTap: () =>
                Navigator.pushReplacementNamed(context, PageRoutes.home),
          ),
          createDrawerBodyItem(
            icon: Icons.account_circle_rounded,
            text: LocaleKeys.Profile.tr(),
            onTap: () =>
                Navigator.pushReplacementNamed(context, PageRoutes.profile),
          ),
          createDrawerBodyItem(
            icon: Icons.event_note,
            text: LocaleKeys.Gaard.tr(),
            onTap: () =>
                Navigator.pushReplacementNamed(context, PageRoutes.gaard),
          ),
          Divider(),
          createDrawerBodyItem(
            icon: Icons.add_circle,
            text: LocaleKeys.Add_Aasl.tr(),
            onTap: () =>
                Navigator.pushReplacementNamed(context, PageRoutes.addAsal),
          ),
          // createDrawerBodyItem(
          //   icon: Icons.scanner,
          //   text: LocaleKeys.scanQrCode.tr(),
          //   onTap: () =>
          //       Navigator.pushReplacementNamed(context, PageRoutes.scanqr),
          // ),
          createDrawerBodyItem(
              icon: Icons.language_rounded,
              text: LocaleKeys.ChangeLanguage.tr(),
              onTap: () {
                EasyLocalization.of(context).locale == Locale("ar")
                    ? EasyLocalization.of(context).setLocale(Locale("en"))
                    : EasyLocalization.of(context).setLocale(Locale("ar"));
              }),
          createDrawerBodyItem(
              icon: Icons.exit_to_app_rounded,
              iconColor: Colors.red,
              text: LocaleKeys.Logout.tr(),
              onTap: () async {
                SharedPreferences pre = await SharedPreferences.getInstance();
                pre.clear();
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (context) {
                  return LoginScreen();
                }), (route) => false);
              }),
          // ListTile(
          //   title: Text(f
          //     LocaleKeys.Logout.tr(),
          //     style: TextStyle(color: Colors.red),
          //   ),
          //   onTap: () async {
          //     SharedPreferences pre = await SharedPreferences.getInstance();
          //     pre.clear();
          //     Navigator.pushAndRemoveUntil(context,
          //         MaterialPageRoute(builder: (context) {
          //       return LoginScreen();
          //     }), (route) => false);
          //   },
          // ),
        ],
      ),
    );
  }

  Widget createDrawerBodyItem(
      {IconData icon, String text, GestureTapCallback onTap, Color iconColor}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(
            icon,
            color: iconColor ?? mPrimaryTextColor,
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              text,
              style: TextStyle(
                  fontSize: 15, color: iconColor ?? mPrimaryTextColor),
            ),
          )
        ],
      ),
      onTap: onTap,
    );
  }

  Widget createDrawerHeader() {
    return DrawerHeader(
        margin: EdgeInsets.fromLTRB(0, 40.0, 0, 0),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover, image: AssetImage('assets/logo.jpg'))),
        child: Stack(children: <Widget>[
          Text("",
              style: TextStyle(
                  color: Colors.blue[900],
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500)),
        ]));
  }
}
