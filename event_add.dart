import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MyEventAdd extends StatefulWidget {
  const MyEventAdd({super.key});

  @override
  State<MyEventAdd> createState() => _MyEventAddState();
}

class _MyEventAddState extends State<MyEventAdd> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleEController = TextEditingController();
  TextEditingController _descriptionEController = TextEditingController();
  TextEditingController _dateEController = TextEditingController();
  DateTime? selectedDate;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Event", style: TextStyle(fontWeight: FontWeight.bold)),
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
                    controller: _titleEController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Input Title";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Title",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _descriptionEController,
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
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _dateEController,
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        _dateEController.text = DateFormat(
                          'dd MMM yyyy',
                        ).format(pickedDate);
                        selectedDate = pickedDate;
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Select date";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Date",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: Icon(
                        Icons.calendar_month,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      elevation: 8,
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                        });

                        try {
                          await FirebaseFirestore.instance
                              .collection('events')
                              .add({
                                'title': _titleEController.text.trim(),
                                'description':
                                    _descriptionEController.text.trim(),
                                'date': Timestamp.fromDate(selectedDate!),
                                'createdAt': Timestamp.now(),
                              });
                          Get.snackbar(
                            "Success",
                            "Event Added Successfully",
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.BOTTOM,
                          );
                          await Future.delayed(Duration(milliseconds: 300));
                          print(
                            "Current route before back: ${Get.currentRoute}",
                          );
                          print("Can pop: ${Get.key.currentState?.canPop()}");
                          Navigator.of(context).pop(true);
                        } catch (e) {
                          Get.snackbar(
                            "Error",
                            "Failed to add event",
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        } finally {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      }
                    },
                    child:
                        isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
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
