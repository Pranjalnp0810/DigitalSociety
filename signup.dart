import 'package:digital_society/controllers/user_controller.dart';
import 'package:digital_society/models/user_role.dart';
import 'package:digital_society/routes/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class MySignUp extends StatefulWidget {
  const MySignUp({super.key});

  @override
  State<MySignUp> createState() => _MySignUpState();
}

class _MySignUpState extends State<MySignUp> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _housenoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cpasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    _housenoController.dispose();
    _passwordController.dispose();
    _cpasswordController.dispose();
    super.dispose();
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    String? Function(String?)? validator,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? toggleVisibility,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.purple.withOpacity(.8),
      ),
      child: TextFormField(
        controller: controller,
        cursorColor: Colors.black,
        keyboardType: isPassword ? TextInputType.visiblePassword : null,
        obscureText: obscureText,
        validator: validator,
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(icon, color: Colors.black),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white),
          suffixIcon:
              isPassword
                  ? IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.black,
                    ),
                    onPressed: toggleVisibility,
                  )
                  : null,
        ),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Future<void> _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            );

        String uid = userCredential.user!.uid;

        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'contact': _contactController.text.trim(),
          'houseNo': _housenoController.text.trim(),
          'role': UserRole.member.name,
        });

        final userController = Get.find<UserController>();
        userController.name.value = _nameController.text.trim();
        userController.houseNo.value = _housenoController.text.trim();
        userController.role.value = UserRole.member;

        Get.snackbar(
          "Success",
          "Account Created!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Get.offAllNamed(AppRoutes.dashboard);
      } on FirebaseAuthException catch (e) {
        Get.snackbar(
          "Signup Error",
          e.message ?? "Something went wrong",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } catch (e) {
        Get.snackbar(
          "Error",
          e.toString(),
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.withOpacity(.3),
        title: Text(
          "SignUp",
          style: GoogleFonts.lexendTera(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.deepPurple.withOpacity(.3),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(top: 60, left: 30, right: 30),
              child: Column(
                children: [
                  _buildInputField(
                    controller: _nameController,
                    icon: Icons.person,
                    hint: "Name",
                    validator:
                        (value) => value!.isEmpty ? "Name required" : null,
                  ),
                  const SizedBox(height: 30),
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
                  const SizedBox(height: 30),
                  _buildInputField(
                    controller: _contactController,
                    icon: Icons.phone_android_outlined,
                    hint: "Contact no.",
                    validator: (value) {
                      if (value!.isEmpty) return "Contact required";
                      if (value.length < 10)
                        return "Contact no. should have at least 10 digits";
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  _buildInputField(
                    controller: _housenoController,
                    icon: Icons.house,
                    hint: "House no.",
                    validator:
                        (value) => value!.isEmpty ? "House no. required" : null,
                  ),
                  const SizedBox(height: 30),
                  _buildInputField(
                    controller: _passwordController,
                    icon: Icons.lock,
                    hint: "Password",
                    isPassword: true,
                    obscureText: _obscurePassword,
                    toggleVisibility: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    validator: (value) {
                      if (value!.isEmpty) return "Password required";
                      if (value.length < 7)
                        return "Password should have at least 7 characters";
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  _buildInputField(
                    controller: _cpasswordController,
                    icon: Icons.lock,
                    hint: "Confirm Password",
                    isPassword: true,
                    obscureText: _obscureConfirmPassword,
                    toggleVisibility: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                    validator: (value) {
                      if (value!.isEmpty) return "Confirm password required";
                      if (value != _passwordController.text)
                        return "Passwords do not match";
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 8,
                      shadowColor: const Color.fromARGB(255, 67, 1, 78),
                    ),
                    onPressed: _handleSignUp,
                    child: const Text(
                      "Sign up",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
