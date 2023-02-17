import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Document.dart';
import 'note.dart';

class Subject extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final note = ModalRoute.of(context)!.settings.arguments as Note;

    final List<Note> _noteList = [
      Note(
        title: 'Science',
        content: note.content,
        subj: 'Science',
        rate: note.rate,
      ),
      Note(
        title: 'Mathematics',
        content: note.content,
        subj: 'Mathematics',
        rate: note.rate,
      ),
      Note(
        title: 'Agriculture',
        content: note.content,
        subj: 'Agriculture',
        rate: note.rate,
      ),
      Note(
        title: 'Setswana',
        content: note.content,
        subj: 'Setswana',
        rate: note.rate,
      ),
      Note(
        title: 'RME',
        content: note.content,
        subj: 'RME',
        rate: note.rate,
      ),
      Note(
        title: 'English',
        content: note.content,
        subj: 'English',
        rate: note.rate,
      ),
      Note(
        title: 'Social Studies',
        content: note.content,
        subj: 'Social Studies',
        rate: note.rate,
      ),
      Note(
        title: 'Capa',
        content: note.content,
        subj: 'Capa',
        rate:note.rate,
      ),
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal, Colors.green.shade300],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: const [0.2,0.9],
              )
          ),
        ),
        title: const Text('Subjects'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed:(){},
          ),
        ],
      ),
      body: ListView.separated(
          itemCount: _noteList.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_noteList[index].title,style: const TextStyle(color: Colors.teal, fontSize: 20)),
              subtitle: Text(_noteList[index].content),
              leading: Image.asset('assets/paper.png', width: 40,), //const Icon(Icons.account_balance_wallet_rounded,color: Colors.teal),
              trailing: const Icon(Icons.arrow_right_rounded, color: Colors.green),
              onTap: () {
                Navigator.push(
                  context,
                  //MaterialPageRoute
                  CupertinoPageRoute(
                    builder: (context) => Document(),
                    settings: RouteSettings(arguments: _noteList[index]),
                  ),
                );
              },
            );
          },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );


  }   //widget build
}  //subject class
