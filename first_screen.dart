import 'package:digital_society/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:digital_society/models/user_role.dart';

class MyFirstScreen extends StatefulWidget {
  const MyFirstScreen({super.key});

  @override
  State<MyFirstScreen> createState() => _MyFirstScreenState();
}

class _MyFirstScreenState extends State<MyFirstScreen> {
  Widget roleButton({
    required String label,
    required VoidCallback onTap,
    required Alignment begin,
    required Alignment end,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        splashColor: Colors.white24,
        highlightColor: Colors.white10,
        child: Container(
          height: 50,
          width: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 60, 1, 63),
                Color.fromARGB(255, 85, 7, 99),
                Color.fromARGB(255, 169, 26, 194),
                Color.fromARGB(255, 230, 127, 248),
              ],
              begin: begin,
              end: end,
              tileMode: TileMode.mirror,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 6,
                spreadRadius: 2,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              // image: DecorationImage(
              //   opacity: 0.3,
              //   fit: BoxFit.fill,
              //   image: NetworkImage(
              //     "https://i.pinimg.com/474x/d3/b9/6b/d3b96b5244bdfa0001a95168686e469a.jpg",
              //   ),
              // ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  roleButton(
                    label: "Chairman",
                    onTap: () {
                      Get.toNamed(
                        AppRoutes.login,
                        arguments: UserRole.chairman,
                      );
                    },
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  const SizedBox(height: 40),

                  roleButton(
                    label: "Member",
                    onTap: () {
                      Get.toNamed(AppRoutes.login, arguments: UserRole.member);
                    },
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
