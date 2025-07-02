import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyMembers extends StatefulWidget {
  const MyMembers({super.key});

  @override
  State<MyMembers> createState() => _MyMembersState();
}

class _MyMembersState extends State<MyMembers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Members List",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('users')
                .where('role', isEqualTo: 'member')
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No members found"));
          }
          return ListView(
            padding: EdgeInsets.all(12),
            children:
                snapshot.data!.docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return Card(
                    color: Colors.purple,
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(
                        data['name'] ?? 'No name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Email: ${data['email']}",
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            "Contact: ${data['contact']}",
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            "House no: ${data['houseNo']}",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
          );
        },
      ),
    );
  }
}
