import 'package:get/get.dart';
import '../modules/archive/binding/archive_binding.dart';
import '../modules/archive/view/archive_view.dart';
import '../modules/auth/bindings/login_binding.dart';
import '../modules/auth/bindings/signup_binding.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/auth/views/signup_view.dart';
import '../modules/home/bindings/google_map_binding.dart';
import '../modules/home/views/google_map.dart';
import '../modules/home/views/home_drawer.dart';
import '../modules/leadBoard/bindings/lead_board_binding.dart';
import '../modules/leadBoard/views/lead_board_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/reportation/bindings/reportation_binding.dart';
import '../modules/reportation/views/reportation_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/settings_view.dart';
part 'app_routes.dart';

class AppPages {
  AppPages._();
  static const INITIAL = Routes.LOGIN;
  static final routes = [
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.SIGNUP,
      page: () => SignUpView(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: Routes.MAP,
      page: () => GoogleMapView(),
      binding: GoogleMapBinding(),
    ),
    GetPage(
      name: Routes.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.REPORTATION,
      page: () => ReportationView(),
      binding: ReportationBinding(),
    ),
    GetPage(
      name: Routes.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: Routes.MY_DRAWER,
      page: () => MyDrawer(),
    ),
    GetPage(
      name: Routes.ARCHIVE,
      page: () => ArchiveView(),
      binding: ArchiveBinding(),
    ),
    GetPage(
      name: Routes.LEAD_BOARD,
      page: () =>  LeadBoardView(),
      binding: LeadBoardBinding(),
    ),
  ];
}
