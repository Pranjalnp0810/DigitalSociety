import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_society/controllers/user_controller.dart';
import 'package:digital_society/routes/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:digital_society/models/user_role.dart';

class MyDashboard extends StatefulWidget {
  MyDashboard({Key? key}) : super(key: key);

  @override
  State<MyDashboard> createState() => _MyDashboardState();
}

class _MyDashboardState extends State<MyDashboard> {
  UserRole? userRoleEnum;
  String? name;
  String? houseNo;
  final UserController userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    _fetchUserRole();
  }

  Future<void> _fetchUserRole() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

      final roleString = userDoc['role'] as String;

      setState(() {
        userRoleEnum =
            roleString == 'chairman' ? UserRole.chairman : UserRole.member;
        name = userDoc['name'];
        houseNo = userDoc['houseNo'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (userController.role.value == null) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }

      final isChairman = userController.role.value == UserRole.chairman;

      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple.withOpacity(.3),

          actions: [
            PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'logout') {
                  Get.defaultDialog(
                    title: "Logout",
                    middleText: "Are you sure you want to logout?",
                    textCancel: "Cancel",
                    textConfirm: "Logout",
                    confirmTextColor: Colors.white,
                    onConfirm: () async {
                      Get.back();
                      await userController.signOut();
                    },
                  );
                }
              },
              itemBuilder:
                  (context) => [
                    PopupMenuItem(
                      value: 'logout',
                      child: Row(
                        children: [
                          Icon(Icons.logout_outlined, color: Colors.red),
                          SizedBox(width: 8),
                          Text("Logout"),
                        ],
                      ),
                    ),
                  ],
            ),
          ],
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.deepPurple.withOpacity(.3),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 150,
                    width: double.maxFinite,
                    child: Card(
                      color: Colors.purple,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
                          left: 10,
                          right: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Column(
                                children: [
                                  Text(
                                    isChairman
                                        ? "Welcome Chairman!"
                                        : "Welcome Member!",
                                    style: GoogleFonts.lexendTera(
                                      fontSize: 20,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.visible,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    userController.name.value,
                                    style: GoogleFonts.lexendTera(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    userController.houseNo.value,
                                    style: GoogleFonts.lexendTera(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        dashboardTile(
                          imageUrl:
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcThhWEShMbZrz08uB1l1dVZG2rZPhZA_vEB3Q&usqp=CAU",
                          onTap: () {
                            Get.toNamed(AppRoutes.notice);
                          },
                        ),
                        dashboardTile(
                          imageUrl:
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQSl4luaPz0kCi_Wc5kD5Cq4ll1k4XrWR-P-A&usqp=CAU",
                          onTap: () {
                            Get.toNamed(AppRoutes.event);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        dashboardTile(
                          imageUrl:
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTolroadGI8LPtZpQYDWmpmw3y8D86Lovyoeg&usqp=CAU",
                          onTap: () {
                            Get.toNamed(AppRoutes.complaint);
                          },
                        ),

                        if (isChairman)
                          dashboardTile(
                            imageUrl:
                                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT5cqYW-UqXKuWWMwWtFndvPBaDla4Ct4w9fNc_zTZozFpK5p4cGpgpC90rhihK3z3k9Ao&usqp=CAU",
                            onTap: () {
                              Get.toNamed(AppRoutes.members);
                            },
                          ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget dashboardTile({
    required String imageUrl,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 150,
        width: 150,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(40),
          image: DecorationImage(
            fit: BoxFit.fill,
            image: NetworkImage(imageUrl),
          ),
        ),
      ),
    );
  }
}
