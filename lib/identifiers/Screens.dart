import 'package:flutter/material.dart';
import 'package:trans/base/screen/BaseScreen.dart';
import 'package:trans/screens/comingsoon/ComingSoonScreen.dart';
import 'package:trans/screens/earnmoney/EarnMoneyScreen.dart';
import 'package:trans/screens/earnmoney/screens/daily/DailyScreen.dart';
import 'package:trans/screens/earnmoney/screens/videoad/VideoAdScreen.dart';
import 'package:trans/screens/home/HomeScreen.dart';
import 'package:trans/screens/jobs/JobsScreen.dart';
import 'package:trans/screens/jobs/screens/jobdetail/JobDetailScreen.dart';
import 'package:trans/screens/landlord/LandlordScreen.dart';
import 'package:trans/screens/login/screens/confirmpassword/ConfirmPasswordScreen.dart';
import 'package:trans/screens/login/screens/newpassword/NewPasswordScreen.dart';
import 'package:trans/screens/login/screens/newphone/NewPhoneScreen.dart';
import 'package:trans/screens/login/screens/password/PasswordScreen.dart';
import 'package:trans/screens/login/screens/phone/PhoneScreen.dart';
import 'package:trans/screens/login/screens/receiveotp/ReceiveOTPScreen.dart';
import 'package:trans/screens/login/screens/updatename/UpdateNameScreen.dart';
import 'package:trans/screens/main/MainScreen.dart';
import 'package:trans/screens/personal/PersonalScreen.dart';
import 'package:trans/screens/personal/screens/about/AboutScreen.dart';
import 'package:trans/screens/personal/screens/changeinfo/ChangeInfoScreen.dart';
import 'package:trans/screens/personal/screens/changepassword/ChangePasswordScreen.dart';
import 'package:trans/screens/product/ProductScreen.dart';
import 'package:trans/screens/product/cart/CartScreen.dart';
import 'package:trans/screens/product/productdetail/ProductDetailScreen.dart';
import 'package:trans/screens/product/search/SearchScreen.dart';
import 'package:trans/screens/shopping/ShoppingScreen.dart';
import 'package:trans/screens/shopping/screens/vcsweb/VCSWebScreen.dart';
import 'package:trans/screens/transport/TransportScreen.dart';
import 'package:trans/screens/transport/screens/addorder/AddOrderScreen.dart';
import 'package:trans/screens/transport/screens/confirmorder/ConfirmOrderScreen.dart';
import 'package:trans/screens/transport/screens/followorder/FollowOrderScreen.dart';
import 'package:trans/screens/transport/screens/managesorder/ManagesOrderScreen.dart';
import 'package:trans/screens/transport/screens/managesorder/screens/orderdraft/OrderDraftScreen.dart';
import 'package:trans/screens/transport/screens/managesorder/screens/orderhanded/OrderHandedScreen.dart';
import 'package:trans/screens/transport/screens/managesorder/screens/orderunhanded/OrderUnhandedScreen.dart';
import 'package:trans/screens/transport/screens/ordercompleted/OrderCompeletedScreen.dart';
import 'package:trans/screens/transport/screens/prepareorder/PrepareOrderScreen.dart';
import 'package:trans/screens/transport/screens/terms/TermsScreen.dart';
import 'package:trans/screens/transport/screens/updateaddress/UpdateAddressScreen.dart';

/// Factory pattern
class Screens {
  static const String FORGOT_PASSWORD = "forgot password";
  static const String RESET_PASSWORD = "reset password";
  static const String RECEIVE_OTP = "receive otp";
  static const String PHONE = 'phone';
  static const String NEW_PHONE = 'new phone';
  static const String PASSWORD = 'password';
  static const String NEW_PASSWORD = 'new password';
  static const String CONFIRM_PASSWORD = 'confirm password';
  static const String UPDATE_NAME = 'update name';
  static const String COMING_SOON = 'coming soon';
  static const String ABOUT = "about";
  static const String MAIN = 'main';
  static const String HOME = 'home';
  static const String TRANSPORT = 'transportation';
  static const String MANAGES_ORDER = 'manages order';
  static const String ORDER_COMPLETED = 'order completed';
  static const String ORDER_HANDED = 'order handed';
  static const String ORDER_UNHANDED = 'order unhanded';
  static const String ORDER_DRAFT = 'order draft';
  static const String TERMS = 'terms';
  static const String PREPARE_ORDER = 'prepare order';
  static const String UPDATE_ADDRESS = 'update address';
  static const String ADD_ORDER = 'add order';
  static const String CONFIRM_ORDER = 'confirm order';
  static const String FOLLOW_ORDER = 'follow order';
  static const String JOBS = 'jobs';
  static const String JOB_DETAIL = 'job detail';
  static const String PERSONAL = 'personal';
  static const String CHANGE_PASSWORD = 'change password';
  static const String CHANGE_INFO = 'change info';
  static const String SHOPPING = 'shopping';
  static const String VCS_WEB = 'vcs web';
  static const String EARN_MONEY = 'earn money';
  static const String DAILY = 'daily';
  static const String VIDEO_AD = 'video ad';
  static const String LANDLORD = 'landlord';
  static const String SOCIAL = 'social';
  static const String PRODUCT = 'product';
  static const String SEARCH = 'search';
  static const String CART = 'cart';
  static const String PRODUCT_DETAIL = 'product detail';

  /// Singleton pattern
  Screens._privateConstructor();

  static final Screens _instance = Screens._privateConstructor();

  static Screens get instance {
    return _instance;
  }

  /// Init screen
  State<BaseWidget> initScreen({@required String screen}) {
    State<BaseWidget> state;
    switch (screen) {
      case PHONE:
        state = PhoneScreen();
        break;
      case NEW_PHONE:
        state = NewPhoneScreen();
        break;
      case PASSWORD:
        state = PasswordScreen();
        break;
      case RECEIVE_OTP:
        state = ReceiveOTPScreen();
        break;
      case NEW_PASSWORD:
        state = NewPasswordScreen();
        break;
      case CONFIRM_PASSWORD:
        state = ConfirmPasswordScreen();
        break;
      case UPDATE_NAME:
        state = UpdateNameScreen();
        break;
      case MAIN:
        state = MainScreen();
        break;
      case HOME:
        state = HomeScreen();
        break;
      case TRANSPORT:
        state = TransportScreen();
        break;
      case MANAGES_ORDER:
        state = ManagesOrderScreen();
        break;
      case ORDER_COMPLETED:
        state = OrderCompletedScreen();
        break;
      case ORDER_HANDED:
        state = OrderHandedScreen();
        break;
      case ORDER_UNHANDED:
        state = OrderUnhandedScreen();
        break;
      case ORDER_DRAFT:
        state = OrderDraftScreen();
        break;
      case TERMS:
        state = TermsScreen();
        break;
      case PREPARE_ORDER:
        state = PrepareOrderScreen();
        break;
      case UPDATE_ADDRESS:
        state = UpdateAddressScreen();
        break;
      case ADD_ORDER:
        state = AddOrderScreen();
        break;
      case CONFIRM_ORDER:
        state = ConfirmOrderScreen();
        break;
      case FOLLOW_ORDER:
        state = FollowOrderScreen();
        break;
      case JOBS:
        state = JobsScreen();
        break;
      case JOB_DETAIL:
        state = JobDetailScreen();
        break;
      case PERSONAL:
        state = PersonalScreen();
        break;
      case CHANGE_INFO:
        state = ChangeInfoScreen();
        break;
      case CHANGE_PASSWORD:
        state = ChangePasswordScreen();
        break;
      case SHOPPING:
        state = ShoppingScreen();
        break;
      case VCS_WEB:
        state = VCSWebScreen();
        break;
      case ABOUT:
        state = AboutScreen();
        break;
      case COMING_SOON:
        state = ComingSoonScreen();
        break;
      case EARN_MONEY:
        state = EarnMoneyScreen();
        break;
      case DAILY:
        state = DailyScreen();
        break;
      case VIDEO_AD:
        state = VideoAdScreen();
        break;
      case LANDLORD:
        state = LandlordScreen();
        break;
      case PRODUCT:
        state = ProductScreen();
        break;
      case SEARCH:
        state = SearchScreen();
        break;
      case CART:
        state = CartScreen();
        break;
      case PRODUCT_DETAIL:
        state = ProductDetailScreen();
        break;
    }
    return state;
  }
}
