import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

class Upload extends StatefulWidget {
  const Upload({Key? key}) : super(key: key);

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  var fileName, std, subject, year;
  String url = "";
  int? number;
  int rating = 0;
  var pickedFile;
  final pickedCon = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  pickFile() async {
    // pick pdf file
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    File pick = File(result!.files.single.path.toString());
    var file = pick.readAsBytesSync();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
            height: 50,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.cyan,borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Text("Test Paper picked",style: TextStyle(fontSize: 18,color: Colors.white))),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
    pickedFile = file;
  }

  Future<String> uploadAPdf(var file) async {
    //Create Reference
    Reference reference = FirebaseStorage.instance
        .ref()
        .child(subject + " " + std + " " + fileName)
        .child(subject + " " + std + " " + fileName + ".pdf");

    //Now We have to check the status of UploadTask
    UploadTask uploadTask = reference.putData(file);

    // Listen for state changes, errors, and completion of the upload.
    uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
      switch (taskSnapshot.state) {

        case TaskState.running:
          final progress =
              100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
          print("Upload is $progress% complete.");
            //show dialog*/
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Container(
                  height: 50,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.redAccent,borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Text("Sending: $progress% ", style: TextStyle(fontSize: 16,color: Colors.white))),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
          );
          break;
        case TaskState.paused:
          print("Upload is paused.");
          break;
        case TaskState.canceled:
          print("Upload was canceled");
          break;
        case TaskState.error:
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Container(
                  height: 50,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.redAccent,borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Text("Check Internet ...",style: TextStyle(fontSize: 18,color: Colors.white))),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
          );
          break;
        case TaskState.success:
          //print("Successful: $url");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Container(
                  height: 50,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.redAccent,borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Text("Continue",style: TextStyle(fontSize: 18,color: Colors.white))),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
          );
          break;
      }
    });
    await uploadTask.whenComplete(() async {
      url = await uploadTask.snapshot.ref.getDownloadURL();
    });
    return url;
  }

  create() async {
    DocumentReference documentReference = await FirebaseFirestore.instance
        .collection("Document")
        .doc(subject + " " + std + " " + fileName);
    documentReference.set({
      'Name': subject + " " + std + " " + fileName,
      'Subject': subject,
      'Standard': std,
      'Year': year,
      'fileUrl': url,
      "rate": rating
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
            height: 50,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.green,borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Text("D O N E :)",style: TextStyle(fontSize: 18,color: Colors.white))),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }

  update() async {
    DocumentReference documentReference = await FirebaseFirestore.instance
        .collection("Document")
        .doc(subject + " " + std + " " + fileName);
    documentReference.update({
      'Name': subject + " " + std + " " + fileName,
      'Subject': subject,
      'Standard': std,
      'Year': year
    });
  }

  delete() async {
    DocumentReference documentReference = await FirebaseFirestore.instance
        .collection("Document")
        .doc(subject + " " + std + " " + fileName);
    documentReference.delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [Colors.teal, Colors.green.shade300],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: const [0.2, 0.9],
          )),
        ),
        title: const Text('Add a Test Paper'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: TextFormField(
                    onChanged: (v) {
                      setState(() {
                        fileName = v;
                      });
                    },
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'e.g Term 3/February',
                        hintText: "Term or Month"),
                    validator: (value){
                      if (value!.isNotEmpty){
                        return null;
                      }else{return "Please enter a Term or a full month";
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: TextFormField(
                    onChanged: (v) {
                      setState(() {
                        std = v;
                      });
                    },
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'e.g 5',
                        hintText: "Standard"),
                      validator: (value){
                      if (value!.isNotEmpty && value.length<2){
                        return null;
                      }else if(value.length>1){
                        return "ao, Grade is 1 digit ..one";
                      }else{
                        return "Don't forget the Grade";
                      }
                      },
                  ),
                ),
                Container(
                  height: 23,
                  //color: Colors.teal[400],
                  padding: EdgeInsets.fromLTRB(16,0,0,0),
                  alignment: Alignment.topLeft,
                  child: Text("Use RME only as shortcut, other subjects write in full. \nUse Social Studies instead of Cultural.",
                      style: TextStyle(color: Colors.grey[600], fontSize: 13,fontFamily: "Raleway")),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: TextFormField(
                    onChanged: (v) {
                      setState(() {
                        subject = v;
                      });
                    },
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'e.g Social Studies',
                        hintText: "Subject Name"),
                    validator: (value){
                      if (value!.isNotEmpty){
                        return null;
                      }else{
                        return "You did not write the Subject";
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: TextFormField(
                    onChanged: (v) {
                      setState(() {
                        year = v;
                      });
                    },
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'e.g 2022',
                        hintText: "Year"),
                    validator: (value){
                      if (value!.isNotEmpty && value.length == 4){
                        return null;
                      }else if(value.length != 4){
                        return "A year is 4 digits";
                      }else{
                        return "Fill in the year";
                      }
                    },
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18,0,0,0),
                      child: ElevatedButton(
                          style: ButtonStyle(
                            alignment: Alignment.bottomRight,
                              backgroundColor: MaterialStateProperty.all(Colors.green),
                              padding:
                                  MaterialStateProperty.all(const EdgeInsets.all(8)),
                              textStyle: MaterialStateProperty.all(const TextStyle(
                                  fontSize: 18,
                                  //fontWeight: FontWeight.bold,
                                  fontFamily: "Raleway",
                                  color: Colors.white))),
                          onPressed: () {
                              setState(() {
                              pickFile();
                              pickedFile = pickedCon.text;
                            });
                          },
                          child: const Text('1. Pick Test')),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15,0,0,0),
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all(Colors.green),
                              padding:
                              MaterialStateProperty.all(const EdgeInsets.all(8)),
                              textStyle: MaterialStateProperty.all(const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: "Raleway",
                                  color: Colors.white))),
                          onPressed: () {
                            setState(() {
                              if (!_formKey.currentState!.validate()){
                                return;
                              }
                              uploadAPdf(pickedFile);
                            });
                          },
                          child: const Text('2. Upload')),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15,0,0,0),
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all(Colors.green),
                              padding:
                              MaterialStateProperty.all(const EdgeInsets.all(8)),
                              textStyle: MaterialStateProperty.all(const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: "Raleway",
                                  color: Colors.white))),
                          onPressed: () {
                            setState(() {
                              if (!_formKey.currentState!.validate()){
                                return;
                              }
                              create();
                            });
                          },
                          child: const Text('3. Save All')),
                    ),
                  ],
                ),
                Container(
                  height: 100,
                  //color: Colors.teal[400],
                  padding: EdgeInsets.fromLTRB(12,10,0,0),
                  alignment: Alignment.topLeft,
                  child: Text("* fill all spaces above \n* pick a test \n* upload and wait for 100% \n* then SAVE.",
                      style: TextStyle(color: Colors.teal, fontSize: 14,fontFamily: "Raleway")),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
