import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:selendra_marketplace_app/screens/welcome/welcome_screen.dart';



  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FacebookLogin facebookLogin = FacebookLogin();

  String name="";
  String email="";
  String imageUrl="";

  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    // Checking if email and name is null
    /*assert(user.email != null);
    assert(user.displayName != null);
    assert(user.photoUrl != null);*/

    name = user.displayName;
    email = user.email;
    imageUrl = user.photoUrl;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    return 'signInWithGoogle succeeded: $user';
  }




  Future<FirebaseUser> signInFacebook(BuildContext context) async {
  FirebaseUser currentUser;
  // fbLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
  // if you remove above comment then facebook login will take username and pasword for login in Webview
  try {
    final FacebookLoginResult facebookLoginResult =
    await facebookLogin.logIn(['email', 'public_profile']);
    if (facebookLoginResult.status == FacebookLoginStatus.loggedIn) {
      FacebookAccessToken facebookAccessToken =
          facebookLoginResult.accessToken;
      final AuthCredential credential = FacebookAuthProvider.getCredential(
          accessToken: facebookAccessToken.token);
      final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
      assert(user.email != null);
      assert(user.displayName != null);
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);
      email = user.email;
      name = user.displayName;
      imageUrl = user.photoUrl;
      currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);
      return currentUser;
    }
  } catch (e) {
    print(e);
  }
  return currentUser;
}

  void signOut(context) async {
    FirebaseUser user = await _auth.currentUser();
    for(UserInfo profile in user.providerData){
      switch (profile.providerId){
        case 'facebook.com':
          facebookLogin.logOut().whenComplete(() => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>WelcomeScreen())));
          break;
        case 'google.com':
          googleSignIn.signOut().whenComplete(() => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>WelcomeScreen())));
          break;
        default:
          await _auth.signOut().whenComplete(() => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>WelcomeScreen())));
          print("User Sign Out");
      }
    }
  }
