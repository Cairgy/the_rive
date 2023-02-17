import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'note.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'package:path_provider/path_provider.dart';

class Document extends StatelessWidget {
  const Document({super.key});

  @override
  Widget build(BuildContext context) {
    final note = ModalRoute.of(context)!.settings.arguments as Note;

    String std = note.rate;
    String subj = note.subj;
    //int rating = 0;

    Future downloadFile(final ref) async{
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/${ref.name}');

      await ref.writeToFile(file);
      ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Container(
                    height: 50,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.redAccent,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Text("Saved: ${ref.name}",
                        style: TextStyle(fontSize: 16, color: Colors.white))),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
            );
    }

    return Scaffold(
        extendBodyBehindAppBar: true,
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
          title: const Text('Test Papers'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
            ),
          ],
        ),
        body: StreamBuilder(
            stream:
            //FirebaseFirestore.instance.enablePersistence(true);
            FirebaseFirestore.instance.collection("Document").where("Subject", isEqualTo: subj).where("Standard", isEqualTo: std).snapshots(),builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return ListView.separated(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, i) {
                    QueryDocumentSnapshot x = snapshot.data!.docs[i];
                    return ListTile(
                      title: Text(x['Name'], style: const TextStyle(color: Colors.teal, fontSize: 18, fontWeight: FontWeight.bold)),
                      subtitle: Text("YEAR: "+x['Year']),
                      leading: Image.asset('assets/pdf.png', width: 40,), //const Icon(Icons.file_copy_outlined,color: Colors.teal),
                      trailing: IconButton(
                          icon: const Icon(Icons.cloud_download_outlined, color: Colors.green),
                        onPressed: (){
                          //downloadFile(x['fileUrl']);
                        },
                      ),
                       onTap: () {
                        //download
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => View(
                                      url: x['fileUrl'],
                                    )));
                      },
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                );
              }
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.teal,
                ),

              );
            })


        );



  } //widget build
} //doc class

class View extends StatelessWidget {
  //const View({Key? key}) : super(key: key);
  PdfViewerController? _pdfViewerController;
  final url;
  View({this.url});

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
        title: const Text('DRIVE View Paper'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border_rounded, color: Colors.redAccent,),
            onPressed: () {},
          ),
        ],
      ),
      body: SfPdfViewer.network(
        url,
        controller: _pdfViewerController,
      ),
    );
  }
}  //view class
