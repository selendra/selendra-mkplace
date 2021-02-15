import 'package:selendra_marketplace_app/all_export.dart';

class SignInModel {
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  FocusNode phoneNode = FocusNode();
  FocusNode emailNode = FocusNode();
  FocusNode passwordNode = FocusNode();

  final PageController pageController = PageController(initialPage: 0);

  bool isLoading = false;

  TabController tabController;

  bool isPageCanChanged = true;

  final phoneFormKey = GlobalKey<FormState>();

  final emailFormKey = GlobalKey<FormState>();
}