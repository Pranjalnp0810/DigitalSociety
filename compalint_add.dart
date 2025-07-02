import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyComplaintAdd extends StatefulWidget {
  const MyComplaintAdd({super.key});

  @override
  State<MyComplaintAdd> createState() => _MyComplaintAddState();
}

class _MyComplaintAddState extends State<MyComplaintAdd> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _topicCController = TextEditingController();
  TextEditingController _descriptionCController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    _topicCController.dispose();
    _descriptionCController.dispose();
    super.dispose();
  }

  Future<void> _submitComplaint() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Get.snackbar(
          "Error",
          "You must be logged in to submit a complaint",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

      final userName = userDoc.data()?['name'] ?? 'Unknown';

      await FirebaseFirestore.instance.collection('complaints').add({
        'topic': _topicCController.text.trim(),
        'description': _descriptionCController.text.trim(),
        'userId': user.uid,
        'username': userName,
        'createdAt': Timestamp.now(),
      });

      Get.snackbar(
        "Success",
        "Complaint added successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      Navigator.pop(context);
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to submit complaint",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Complaint",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
              child: Column(
                children: [
                  TextFormField(
                    controller: _topicCController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Input Topic";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Topic",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _descriptionCController,
                    textInputAction: TextInputAction.newline,
                    keyboardType: TextInputType.multiline,
                    maxLines: 10,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Input Description";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Description",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      elevation: 8,
                    ),
                    onPressed: isLoading ? null : _submitComplaint,
                    child:
                        isLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Text(
                              "Add",
                              style: TextStyle(
                                color: Colors.white,
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
