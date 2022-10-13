import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'create.dart';
import 'detail.dart';

class ListPage extends StatefulWidget{
  ListPage({Key? key}): super(key: key);

  @override
  _listPageState createState() => _listPageState();

}

class _listPageState extends State<ListPage>{

  @override
  void initState(){

    
  }


  var listEvent = [];
  User? user = FirebaseAuth.instance.currentUser;
  QuerySnapshot? currentCollection = null;
  @override
  Widget build(BuildContext context) {
    GetEvents();
    return Scaffold(
      appBar: AppBar(

        title: Text(this.user!.email.toString()),
        actions: <Widget>[
          TextButton(onPressed: (){
            GetEvents();
          }, child: Icon(Icons.refresh, color: Colors.white,)
          ),
          TextButton(onPressed: () async{
            await GoogleSignIn().signOut();
            //await FirebaseAuth.instance.signOut();
            Navigator.pop(context);
          }, child: Icon(Icons.exit_to_app, color: Colors.white,)
          )
        ],
      ),
      body: Center(
        child: ListView(
          children: this.listEvent.map<Widget>(
                  (e){
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Card(
                          child: ListTile(
                            title: Text(e['name'].toString()),
                            subtitle: Text("Event"),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () async{
                                DeleteEvent(e.id);
                                GetEvents();
                              },
                            ),
                            leading: GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => detailPage(event: e.id,)));
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.indigo,
                                child: Text(e['name'][0]),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
          ).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: NavigateCreate ,
        tooltip: "Add Event",
        child: Icon(Icons.add),
      ),
    );
  }
  void NavigateCreate() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => CreatePage()));
  }

  void GetEvents() async {
    User? user = FirebaseAuth.instance.currentUser;
    CollectionReference refListEvent = await FirebaseFirestore.instance
    .collection("users")
    .doc(user!.uid)
    .collection("Events");

    this.currentCollection = await refListEvent.get();
    this.listEvent = currentCollection!.docs;
    setState(() {});
  }

  void DeleteEvent(String id) async{
    User? user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("Events")
    .doc(id).delete();
  }

}