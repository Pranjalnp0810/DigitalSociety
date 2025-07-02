import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_society/compalint_add.dart';
import 'package:digital_society/controllers/user_controller.dart';
import 'package:digital_society/models/user_role.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MyComplaint extends StatefulWidget {
  const MyComplaint({super.key});

  @override
  State<MyComplaint> createState() => _MyComplaintState();
}

class _MyComplaintState extends State<MyComplaint> {
  late final UserController userController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    userController = Get.find<UserController>();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isMember = userController.role.value == UserRole.member;

      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Complaint",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream:
              _firestore
                  .collection('complaints')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text("No Complaints found."));
            }
            return ListView(
              children:
                  snapshot.data!.docs.map((doc) {
                    Map<String, dynamic> data =
                        doc.data()! as Map<String, dynamic>;

                    DateTime dateTime =
                        (data['createdAt'] as Timestamp).toDate();
                    String FormattedDate = DateFormat(
                      'dd MMM yyyy',
                    ).format(dateTime);

                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        onTap: () {
                          Get.bottomSheet(
                            Container(
                              height: MediaQuery.of(context).size.height * 0.5,
                              padding: EdgeInsets.all(16),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Text(
                                        "${data['topic'] ?? "No topic"}",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Divider(height: 30, thickness: 2),
                                    Text(
                                      "${data['description'] ?? ''}",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Divider(height: 30, thickness: 1),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${data['username'] ?? 'Unknown'}",
                                          style: TextStyle(
                                            color: Colors.purple,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                        Text(
                                          "$FormattedDate",
                                          style: TextStyle(
                                            color: Colors.purple,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            backgroundColor: Colors.white,
                            isDismissible: true,
                            enableDrag: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                          );
                        },
                        title: Text(
                          data['topic'] ?? "No Topic",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        leading: CircleAvatar(
                          backgroundColor: Colors.deepPurple.withOpacity(0.3),
                          child: Icon(
                            Icons.feedback_outlined,
                            color: Colors.purple,
                            size: 28,
                          ),
                        ),
                        trailing:
                            userController.role.value == UserRole.chairman
                                ? PopupMenuButton<String>(
                                  onSelected: (value) async {
                                    if (value == 'delete') {
                                      Get.defaultDialog(
                                        title: "Delete Complaint",
                                        middleText:
                                            "Are you sure you want to delete complaint?",
                                        actions: [
                                          TextButton(
                                            onPressed: () => Get.back(),
                                            child: Text(
                                              "Cancel",
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 20),
                                          TextButton(
                                            onPressed: () async {
                                              await _firestore
                                                  .collection('complaints')
                                                  .doc(doc.id)
                                                  .delete();
                                              Get.back();
                                              Get.snackbar(
                                                "Deleted",
                                                "Complaint has been deleted!",
                                                snackPosition:
                                                    SnackPosition.BOTTOM,
                                                backgroundColor:
                                                    Colors.redAccent,
                                                colorText: Colors.white,
                                              );
                                            },
                                            child: Text(
                                              "Delete",
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                  },
                                  itemBuilder:
                                      (context) => [
                                        PopupMenuItem(
                                          value: 'delete',
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              SizedBox(width: 8),
                                              Text("Delete"),
                                            ],
                                          ),
                                        ),
                                      ],
                                )
                                : null,
                      ),
                    );
                  }).toList(),
            );
          },
        ),
        floatingActionButton:
            isMember
                ? FloatingActionButton(
                  onPressed: () {
                    Get.to(() => MyComplaintAdd());
                  },
                  child: Icon(Icons.add, color: Colors.white),
                  backgroundColor: Colors.purple,
                  shape: CircleBorder(),
                )
                : null,
      );
    });
  }
}
