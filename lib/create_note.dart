import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateNotePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CreateNotePageState();
}

class _CreateNotePageState extends State<CreateNotePage> {
  final user = FirebaseAuth.instance.currentUser!;
  GlobalKey<FormState> _key = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  bool isObscure = true;
  bool _isValid = true;

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _notes = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('notes')
        .snapshots();

    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Добавление заметки",
            style: TextStyle(fontSize: 35),
          ),
          Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //title
                Padding(
                  padding: EdgeInsets.only(left: 100, right: 100, top: 15),
                  child: TextFormField(
                    controller: _titleController,
                    validator: (value) {
                      if (!_isValid) {
                        return null;
                      }
                      if (value!.isEmpty) {
                        return 'Поле пустое';
                      }
                      if (value.length < 1) {
                        return 'Заголовок должнен содержать не менее 1 символа';
                      }
                      return null;
                    },
                    maxLength: 255,
                    decoration: const InputDecoration(
                      labelText: 'Заголовок',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                //description
                Padding(
                  padding: EdgeInsets.only(left: 100, right: 100, top: 15),
                  child: TextFormField(
                    controller: _descriptionController,
                    validator: (value) {
                      if (!_isValid) {
                        return null;
                      }
                      if (value!.isEmpty) {
                        return 'Поле пустое';
                      }
                      if (value.length < 1) {
                        return 'Описание должно содержать не менее 1 символа';
                      }
                      return null;
                    },
                    maxLength: 255,
                    decoration: const InputDecoration(
                      labelText: 'Описание',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
              padding: EdgeInsets.only(left: 350, right: 350, top: 50),
              child: Container(
                width: 180,
                child: ElevatedButton(
                  child: Text("Добавить заметку"),
                  onPressed: () => {
                    _isValid = true,
                    if (_key.currentState!.validate()) {addNote()}
                  },
                ),
              )),
          Padding(
              padding: EdgeInsets.only(left: 350, right: 350, top: 50),
              child: ElevatedButton(
                child: Text("Главная"),
                onPressed: () => {
                  _isValid = false,
                  _key.currentState!.validate(),
                  Navigator.pushNamed(context, 'home'),
                },
              )),
          SizedBox(
            height: 25,
          ),
          Text(
            "Все заметки",
            style: TextStyle(fontSize: 35),
          ),
          SizedBox(
            height: 25,
          ),
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
            stream: _notes,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: Text('Пока нет записок'));
              }
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Загрузка");
              }

              if (snapshot.hasData) {
                return ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot documentSnapshot =
                          snapshot.data!.docs[index];
                      return Column(
                        children: [
                          Text('Заметка: ' + documentSnapshot['title'],
                              style: TextStyle(fontSize: 30)),
                          SizedBox(
                            height: 15,
                          ),
                          Text('Описание: ' + documentSnapshot['description'],
                              style: TextStyle(fontSize: 22)),
                          Row(
                            // ignore: sort_child_properties_last
                            children: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white),
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(user.uid)
                                        .collection('notes')
                                        .doc(documentSnapshot.id)
                                        .delete();
                                  },
                                  child: Text(
                                    "Удалить",
                                    style: TextStyle(color: Colors.red),
                                  )),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white),
                                  onPressed: () {
                                    Map<String, dynamic> values = {
                                      'NOTE': documentSnapshot
                                    };
                                    Navigator.pushNamed(context, 'editNote',
                                        arguments: values);
                                  },
                                  child: Text(
                                    "Изменить",
                                    style: TextStyle(color: Colors.black),
                                  )),
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      );
                    });
              }

              return Container();
            },
          ))
        ],
      )),
    );
  }

  Future addNote() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('notes')
        .add({
          'title': _titleController.text.trim(),
          'description': _descriptionController.text.trim()
        });
        
  }
}
