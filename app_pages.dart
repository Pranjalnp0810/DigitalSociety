import 'package:digital_society/compalint_add.dart';
import 'package:digital_society/complaint.dart';
import 'package:digital_society/dashboard.dart';
import 'package:digital_society/event.dart';
import 'package:digital_society/event_add.dart';
import 'package:digital_society/first_screen.dart';
import 'package:digital_society/login.dart';
import 'package:digital_society/members.dart';
import 'package:digital_society/models/user_role.dart';
import 'package:digital_society/notice.dart';
import 'package:digital_society/notice_add.dart';
import 'package:digital_society/routes/app_routes.dart';
import 'package:digital_society/signup.dart';
import 'package:get/get.dart';

class AppPages {
  static final routes = [
    GetPage(name: AppRoutes.first, page: () => const MyFirstScreen()),

    GetPage(
      name: AppRoutes.login,
      page: () {
        final role = Get.arguments as UserRole;
        return MyLoginScreen(role: role);
      },
    ),
    GetPage(name: AppRoutes.signup, page: () => MySignUp()),
    GetPage(name: AppRoutes.dashboard, page: () => MyDashboard()),
    GetPage(name: AppRoutes.notice, page: () => MyNotice()),
    GetPage(name: AppRoutes.event, page: () => MyEvent()),
    GetPage(name: AppRoutes.complaint, page: () => MyComplaint()),
    GetPage(name: AppRoutes.addNotice, page: () => MyNoticeAdd()),
    GetPage(name: AppRoutes.addEvent, page: () => MyEventAdd()),
    GetPage(name: AppRoutes.addComplaint, page: () => MyComplaintAdd()),
    GetPage(name: AppRoutes.members, page: () => MyMembers()),
  ];
}
