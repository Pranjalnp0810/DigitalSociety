import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_society/controllers/user_controller.dart';
import 'package:digital_society/dashboard.dart';
import 'package:digital_society/routes/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:digital_society/models/user_role.dart';

class MyLoginScreen extends StatefulWidget {
  final UserRole? role;
  const MyLoginScreen({this.role, Key? key}) : super(key: key);

  @override
  State<MyLoginScreen> createState() => _MyLoginScreenState();
}

class _MyLoginScreenState extends State<MyLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.withOpacity(.3),
        title: Text(
          widget.role == UserRole.member ? "Login" : "Chairman Login",
          style: GoogleFonts.lexendTera(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.deepPurple.withOpacity(.3),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
            child: Column(
              children: [
                SizedBox(height: 30),
                _buildInputField(
                  controller: _emailController,
                  icon: Icons.email,
                  hint: "Email",
                  validator: (value) {
                    if (value!.isEmpty) return "Email required";
                    if (!RegExp(
                      r"^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                    ).hasMatch(value))
                      return "Enter a valid Email Address";
                    return null;
                  },
                ),
                SizedBox(height: 30),
                _buildInputField(
                  controller: _passwordController,
                  icon: Icons.lock,
                  hint: "Password",
                  isPassword: true,
                  obscureText: _obscureText,
                  suffix: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() => _obscureText = !_obscureText);
                    },
                  ),
                  validator: (value) {
                    if (value!.isEmpty) return "Password required";
                    if (value.length < 7)
                      return "Password must be at least 7 characters";
                    return null;
                  },
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 8,
                    shadowColor: Colors.deepPurple,
                  ),
                  onPressed: _handleLogin,
                  child: Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                if (widget.role == UserRole.member)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "New to the Application? ",
                        style: TextStyle(color: Colors.black),
                      ),
                      GestureDetector(
                        onTap:
                            () => Get.toNamed(
                              AppRoutes.signup,
                              arguments: UserRole.member,
                            ),
                        child: Text(
                          "Sign Up",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    String? Function(String?)? validator,
    bool isPassword = false,
    bool obscureText = false,
    Widget? suffix,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.purple.withOpacity(.8),
      ),
      child: TextFormField(
        controller: controller,
        cursorColor: Colors.black,
        keyboardType: TextInputType.emailAddress,
        obscureText: isPassword ? obscureText : false,
        validator: validator,
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(icon, color: Colors.black),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white),
          suffixIcon: suffix,
        ),
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      try {
        final userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            );

        final user = userCredential.user;
        if (user != null) {
          final doc =
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .get();

          if (doc.exists) {
            final userController = Get.find<UserController>();
            userController.name.value = doc['name'];
            userController.houseNo.value = doc['houseNo'];
            userController.role.value =
                doc['role'] == 'chairman' ? UserRole.chairman : UserRole.member;
            Get.offAll(() => MyDashboard());
          } else {
            Get.snackbar(
              "Error",
              "User data not found",
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        }
      } on FirebaseAuthException catch (e) {
        Get.snackbar(
          "Login Error",
          e.message ?? "Something went wrong",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    }
  }
}
