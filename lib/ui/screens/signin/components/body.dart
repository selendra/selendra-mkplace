import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:selendra_marketplace_app/all_export.dart';
import 'package:selendra_marketplace_app/core/services/app_services.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  final PageController _pageController = PageController(initialPage: 0);
  TabController _tabController;
  bool isPageCanChanged = true;

  onGoogleSignIn() async {
    setState(() {
      _isLoading = true;
    });
    await AuthProvider().signInWithGoogle(context).then((value) {
      if (value == null) {
        setState(() {
          _isLoading = false;
        });
      } else {
        Provider.of<AuthProvider>(context, listen: false)
            .getTokenForGoogle(value, context);
      }
    }).catchError((onError) {
      setState(() {
        _isLoading = false;
      });
      ReuseAlertDialog().successDialog(context, onError);
    });
  }

  onFacebookSignIn() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await AuthProvider().signInFacebook(context).then((value) {
        if (value == null) {
          stopLoading();
        } else {
          Provider.of<AuthProvider>(context, listen: false)
              .getTokenForFb(value, context);
        }
      });
    } on PlatformException catch (e) {
      stopLoading();
    }
  }

  onApiSignInByEmail(String _email, String _password) async {
    setState(() {
      _isLoading = true;
    });
    try {
      await AuthProvider()
          .signInByEmail(_email, _password, context)
          .then((onValue) {
        if (onValue != null) {
          ReuseAlertDialog().successDialog(context, onValue);
        }
      }).catchError((onError) {});
    } on SocketException catch (e) {
      await Components.dialog(
          context,
          Text(e.message.toString(), textAlign: TextAlign.center),
          Text("Message"));
    } on FormatException catch (e) {
      await Components.dialog(
          context,
          Text(e.message.toString(), textAlign: TextAlign.center),
          Text("Message"));
    } finally {
      setInitialTab();
      stopLoading();
    }
  }

  onApiSignInByPhone(String _phone, String _password) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await AuthProvider()
          .signInByPhone(
              "+855" + AppServices.removeZero(_phone), _password, context)
          .then((value) {
        if (value != null) {
          ReuseAlertDialog().successDialog(context, value);
        }
      });
    } on SocketException catch (e) {
      await Components.dialog(
          context,
          Text(e.message.toString(), textAlign: TextAlign.center),
          Text("Message"));
    } on FormatException catch (e) {
      await Components.dialog(
          context,
          Text(e.message.toString(), textAlign: TextAlign.center),
          Text("Message"));
    } finally {
      stopLoading();
    }
  }

  onTabChange() {
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          onPageChange(_tabController.index, p: _pageController);
        });
      }
    });
  }

  onPageChange(int index, {PageController p, TabController t}) async {
    if (p != null) {
      isPageCanChanged = false;
      await _pageController.animateToPage(index,
          duration: Duration(milliseconds: 400), curve: Curves.easeOut);
      isPageCanChanged = true;
    } else {
      _tabController.animateTo(index);
    }
  }

  //This function is use to set initial tab when setstate
  void setInitialTab() {
    setState(() {
      _tabController.index = 0;
    });
  }

  //This function is use to stop loading circle indicator
  void stopLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    onTabChange();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _lang = AppLocalizeService.of(context);
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Column(
          children: <Widget>[
            Container(
                child: Image.asset(
              'images/logo.png',
              height: 80,
              width: 80,
            )),
            SizedBox(
              height: 40,
            ),
            ReuseAuthTab(
              _tabController,
              _lang.translate('phone'),
              _lang.translate('email'),
            ),
            // tabs(context),
            SizedBox(
              height: 40,
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  if (isPageCanChanged) {
                    onPageChange(index);
                  }
                },
                children: [
                  SignInPhoneForm(
                    onApiSignInByPhone,
                    onFacebookSignIn,
                    onGoogleSignIn,
                  ),
                  SignInEmailForm(
                    onApiSignInByEmail,
                    onFacebookSignIn,
                    onGoogleSignIn,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
