import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Others/colors.dart';
import '../Others/loading.dart';
import '../auth/login.dart';
import '../main.dart';
import '../translations/locale_keys.g.dart';
import 'user.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.Profile.tr(),
          style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
              fontFamily: 'Kine'),
        ),
        //TODO: ADD EDIT PROFILE
        // actions: [
        //   TextButton(
        //     onPressed: () {},
        //     child: Text(
        //       "Edit",
        //       style: TextStyle(
        //           color: Colors.black,
        //           fontFamily: 'Kine',
        //           fontWeight: FontWeight.bold),
        //     ),
        //   )
        // ],
        centerTitle: true,
        elevation: 0,

        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[800]
            : primaryColor,
      ),
      body: Column(
        children: [
          Consumer(
            builder: ((context, ref, child) {
              final userID = ref.watch(userIDProvider);
              final userData =
                  ref.watch(userProviderID(testID == null ? userID : testID));
              return userData.when(
                data: (data) => UserInfo(
                  name: data.username,
                  email: data.email,

                  image: 'assets/images/profile/default.png',
                  // ),, )
                ),
                error: (e, s) {
                  print('$e\n$s');
                  return kDebugMode ? Text(e.toString()) : Loading();
                },
                loading: () => Loading(),
              );
            }),
          ),
          ProfileMenu(
            name: LocaleKeys.Settings.tr().toString(),
            icon: Icons.settings,
            press: () => context.push('/settings'),
          ),
          ProfileMenu(
            name: LocaleKeys.choose_content.tr().toString(),
            icon: Icons.grass_rounded,
            press: () => context.pushNamed('Content'),
          ),
          Consumer(builder: (context, ref, child) {
            return ProfileMenu(
              name: LocaleKeys.Logout.tr().toString(),
              icon: Icons.logout,
              press: () async {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                await prefs.clear();
                context.go('/login');
              },
            );
          }),
        ],
      ),
    );
  }
}

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key? key,
    required this.name,
    required this.icon,
    required this.press,
  }) : super(key: key);
  final String name;
  final IconData icon;
  final void Function() press;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
            ),
            SizedBox(
              width: 20.0,
            ),
            Text(
              name,
              style: TextStyle(fontFamily: 'Kine', fontSize: 17.0),
            ),
            Spacer(),
            Icon(
              context.locale.languageCode == "en"
                  ? FontAwesomeIcons.chevronRight
                  : FontAwesomeIcons.chevronLeft,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class UserInfo extends StatelessWidget {
  const UserInfo({
    Key? key,
    required this.name,
    required this.email,
    required this.image,
  }) : super(key: key);
  final String name, email, image;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: Stack(children: [
        ClipPath(
          clipper: CustomShape(),
          child: Container(
            height: 150,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[800]
                : primaryColor,
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 10),
                height: 140,
                width: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 8,
                  ),
                  image: DecorationImage(
                    image: AssetImage(image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Text(
                name,
                style: TextStyle(fontSize: 22, fontFamily: 'Kine'),
              ),
              SizedBox(height: 5),
              Text(
                email,
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Color(0xFF8492A2),
                    fontFamily: 'Kine'),
              )
            ],
          ),
        ),
      ]),
    );
  }
}

class CustomShape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    double height = size.height;
    double width = size.width;
    path.lineTo(0, height - 100);
    path.quadraticBezierTo(width / 2, height, width, height - 100);
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
