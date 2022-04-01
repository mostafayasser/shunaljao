//@dart=2.9
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shnuljoe/Model/Location.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

class FacebookAPI with ChangeNotifier {
  bool isSignIn = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  final Future<bool> _isAvailableFuture = TheAppleSignIn.isAvailable();
  final _firebaseAuth = FirebaseAuth.instance;
  String errorMessage;
  void setState(state) {
    isSignIn = state;
    notifyListeners();
  }

  Future loginWithFacebook(context, result) async {
    var accessToken = result.accessToken;
    AuthCredential credential =
        FacebookAuthProvider.credential(accessToken.token);

    var a = await _auth.signInWithCredential(credential);

    var user = a.additionalUserInfo.profile;
    String uPic = user["picture"]["data"]["url"];
    String uName = user["name"];

    isSignIn = true;
    if (/*Provider.of<FacebookAPI>(context, listen: false).*/ isSignIn) {
      var pref = await SharedPreferences.getInstance();
      pref.setString("uPic", uPic.toString());
      pref.setString("uName", uName.toString());
      String v = pref.getString('isFirstTimeIn');

      if (v == null) {
        Navigator.pushReplacementNamed(context, "/IntroSlider");
        pref.setString('isFirstTimeIn', "false");
        pref.setString('isLogInA', "isLogIn");
        print('First Time &&&&&&' + v.toString());
      } else {
        pref.setString('isLogInA', "isLogIn");
        Navigator.pushReplacementNamed(context, "/HomeScreen");
        print('First Time &&&&&& ELSE' + v.toString());
      }
    }
    notifyListeners();
  }

  Future handleLogin(BuildContext context) async {
    try {
      await FacebookAuth.instance.logOut();
    } catch (e) {
      print("###################FB Logout Error");
    }
    final LoginResult result = await FacebookAuth.instance
        .login(); // by default we request the email and the public profile
    if (result.status == LoginStatus.success) {
      print('Login success' + result.toString());
      await loginWithFacebook(context, result);
    } else {
      print('FB Mess:' + result.status.toString());
      print('FB Mess:' + result.message);
    }
  }

  Future<void> fbSignOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('done', false);
    await FacebookAuth.instance.logOut();
    await _auth.signOut().then((onValue) {
      isSignIn = false;
      notifyListeners();
    });
  }

  var name;

  Future<User> signInWithApple({List<Scope> scopes = const [], context}) async {
    // 1. perform the sign-in request
    /*    Position position =  await getLocation().getGeoLocationPosition();
    print(position.latitude);
    print(position.longitude); */

    final result = await TheAppleSignIn.performRequests(
        [AppleIdRequest(requestedScopes: scopes)]);
    // 2. check the result
    switch (result.status) {
      case AuthorizationStatus.authorized:
        final appleIdCredential = result.credential;
        final oAuthProvider = OAuthProvider('apple.com');
        final credential = oAuthProvider.credential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken),
          accessToken:
              String.fromCharCodes(appleIdCredential.authorizationCode),
        );
        final userCredential =
            await _firebaseAuth.signInWithCredential(credential);
        final firebaseUser = userCredential.user;
        var email = userCredential.additionalUserInfo.profile["email"];

        if (scopes.contains(Scope.fullName)) {
          final fullName = appleIdCredential.fullName;

          var pref = await SharedPreferences.getInstance();
          name = firebaseUser.displayName.toString();
          pref.setString("uName",
              (appleIdCredential.fullName.givenName ?? "مستخدم").toString());
          pref.setString("uPic", "apple".toString());
          await firebaseUser
              .updateDisplayName(firebaseUser.displayName.toString());
          String v = pref.getString('isFirstTimeIn');
          if (v == null) {
            Navigator.pushReplacementNamed(context, "/IntroSlider");
            pref.setString('isFirstTimeIn', "false");
            pref.setString('isLogInA', "isLogIn");
            print('First Time &&&&&&' + v.toString());
          } else {
            pref.setString('isLogInA', "isLogIn");
            Navigator.pushReplacementNamed(context, "/HomeScreen");
            print('First Time &&&&&& ELSE' + v.toString());
          }

          /* if (fullName != null &&
              fullName.givenName != null &&
              fullName.familyName != null) {
            final displayName = '${fullName.givenName} ${fullName.familyName}';
            print(fullName.givenName.toString()+'Name');
            var pref = await SharedPreferences.getInstance();

            pref.setString("uName", fullName.givenName.toString());
            await firebaseUser.updateDisplayName(displayName);
            bool v = pref.getBool('isFirstTime');
            if (v == null) v = true;
            if (v) {
              Navigator.pushReplacementNamed(context, "/IntroSlider");
              pref.setBool('isFirstTime', !v);
              pref.setBool('isLogIn', true);
              print('First Time &&&&&&' + v.toString());
            } else {
              Navigator.pushReplacementNamed(context, "/HomeScreen");
              print('First Time &&&&&& ELSE' + v.toString());
            }
          }*/
        }
        return firebaseUser;
      case AuthorizationStatus.error:
        throw PlatformException(
          code: 'ERROR_AUTHORIZATION_DENIED',
          message: result.error.toString(),
        );

      case AuthorizationStatus.cancelled:
        throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
      default:
        throw UnimplementedError();
    }
  }

  showAlertDialog(BuildContext context, n) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("My title"),
      content: Text("This is my message $n"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
