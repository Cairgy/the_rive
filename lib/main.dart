// Copyright 2022 Cairgy. All rights reserved.
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'subject.dart';
import 'upload.dart';
import 'note.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

// #docregion MyApp
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DRIVE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      )),
      home: StandardList(),
    );
  }
}

class StandardList extends StatelessWidget {
  StandardList({Key? key}) : super(key: key);

  final List<Note> _noteList = [
    Note(
      title: 'Standard 1',
      content: 'Breakthrough, STD 1',
      subj: "",
      rate: "1",
    ),
    Note(
      title: 'Standard 2',
      content: 'STD 2 Lower',
      subj: "",
      rate: "2",
    ),
    Note(
      title: 'Standard 3',
      content: 'STD 3 Lower',
      subj: "",
      rate: "3",
    ),
    Note(
      title: 'Standard 4',
      content: 'Attainment, STD 4',
      subj: "",
      rate: "4",
    ),
    Note(
      title: 'Standard 5',
      content: 'STD 5 Upper',
      subj: "",
      rate: "5",
    ),
    Note(
      title: 'Standard 6',
      content: 'STD 6 Upper',
      subj: "",
      rate: "6",
    ),
    Note(
      title: 'Standard 7',
      content: 'includes Mock, PSLE',
      subj: "",
      rate: "7",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: [
        //sliver app bar
        SliverAppBar(
            backgroundColor: Colors.transparent,
            //leading:Image.asset('assets/riveicon.png', width: 10, height: 10,color: Colors.teal[400],), //Icon(Icons.data_usage_rounded,color: Colors.tealAccent,),
            title: Text('THE RIVE', style: const TextStyle(fontFamily:'Raleway', fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 20)),
            expandedHeight: 170,
            //elevation: 0,
            //floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                'assets/rwe.jpg',
                fit: BoxFit.cover,
              ),
              /*Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.teal, Colors.green.shade300],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        stops: const [0.2,0.9],
                      )
                  )
              ),*/
              /*title: Text('T H E   R I V E',
                  style: const TextStyle(
                      fontFamily: 'GilroyBlack',
                      color: Colors.white60,
                      fontSize: 30)),*/
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.info,
                  color: Colors.teal,
                ),
                onPressed: () {
                  showAboutDialog(
                      context: context,
                      applicationVersion: '1.0',
                      //applicationIcon: MyAppIcon('assets/drop.png'),
                      applicationLegalese: 'Developed by Kago Mmapetla, for the Ministry of Basic Education, under'
                          ' Universal Access and Service Fund, Botswana Communications Regulatory Authority (BOCRA) '
                          'and The Ministry of Transport and Communications.',
                  );
                },
              ),
            ]),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: Container(
                height: 35,
                color: Colors.teal[300],
                alignment: Alignment.center,
                child: Text("Select A Class",
                    style: TextStyle(color: Colors.white, fontSize: 17, fontFamily: "Raleway", fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ),

        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => ListTile(
              title: Text(
                _noteList[index].title,
                style: const TextStyle(color: Colors.teal, fontSize: 22, ),
              ),
              subtitle: Text(_noteList[index].content),
              leading: const Icon(Icons.home_work_outlined,
                  color: Colors.teal, size: 36.0),
              trailing:
                  const Icon(Icons.arrow_right_rounded, color: Colors.green),
              //isThreeLine: true,
              //tileColor: Colors.deepPurple[300],
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => Subject(),
                    settings: RouteSettings(arguments: _noteList[index]),
                  ),
                );
              },
            ),
            childCount: _noteList.length,
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 150,
                color: Colors.teal[400],
                padding: EdgeInsets.all(35),
                alignment: Alignment.center,
                child: Text("Select a Class above to see its test papers. If you like a test Paper please support by liking it",
                    style: TextStyle(color: Colors.white, fontSize: 18,fontFamily: "Raleway")),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 150,
                color: Colors.teal[400],
                padding: EdgeInsets.all(35),
                alignment: Alignment.center,
                child: Text("You can contribute by adding your own test papers. Use the Upload button on the right to add a Test Paper and share with others",
                    style: TextStyle(color: Colors.white, fontSize: 18,fontFamily: "Raleway")),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 150,
                color: Colors.teal[400],
                padding: EdgeInsets.all(35),
                alignment: Alignment.center,
                child: Text("Only PDF formats are allowed, so before you upload, please make sure you save a word document as PDF",
                    style: TextStyle(color: Colors.white, fontSize: 18,fontFamily: "Raleway")),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(120, 20, 0, 0),
                    //height: 100,
                    //color: Colors.teal[400],
                    //padding: EdgeInsets.all(35),
                    alignment: Alignment.center,
                    child: Text("Cairgy",
                        style: TextStyle(
                            fontFamily: 'Raleway',
                            //color: Colors.teal[400],
                            fontSize: 30,foreground: Paint()..color=Colors.grey.shade300 ..strokeWidth=1.0 ..style=PaintingStyle.stroke)),
                  ),
                ],
              ),
            ),
          ),
        ),

      ]),


      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Upload()),
          );
        },
        label: const Text('Upload'),
        backgroundColor: Colors.green,
        icon: const Icon(Icons.navigation_rounded),
      ),
    );
  } //build widget
} //standardList class
