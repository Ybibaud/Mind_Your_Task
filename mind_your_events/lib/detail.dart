import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mind_your_events/Classes.dart';

class detailPage extends StatefulWidget{
  final String event;
  detailPage({Key? key, required this.event}) : super(key: key);

  @override
  _detailPageState createState() => _detailPageState();
}

class _detailPageState extends State<detailPage>{

  @override
  void initState() {
    GetEvent();

  }



  final nameController = TextEditingController();
  final typeController = TextEditingController();
  final stagesController = TextEditingController();
  final dateController = TextEditingController();
  List<dynamic> stages = [];
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail" ),
        backgroundColor: Colors.green,
      ),
      body: Form(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 15.0, right: 15.0),
              child: Row(
                children: [
                  Expanded(child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                        labelText: "Name"
                    ),
                  ))
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 15.0, right: 15.0),
              child: Row(
                children: [
                  Expanded(child: TextField(
                    enabled: false,
                    controller: typeController,
                    decoration: InputDecoration(
                        labelText: "Type"
                    ),

                  ))
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 15.0, right: 15.0),
              child: TextField(
                controller: dateController,
                decoration: InputDecoration(
                    labelText: "deadline"
                ),
                readOnly: true,
                onTap: () async{
                  DateTime? pickedDate = await showDatePicker(context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101)
                  );
                  if(pickedDate != null){
                    String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);

                    setState(() {
                      dateController.text = formattedDate;
                    });
                  }
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Text("Stages"),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 15.0, right: 15.0),
                child: ListView(
                  children: this.stages.map<Widget>(
                          (e){
                        return Row(
                          children: [
                            Expanded(child: Card(
                              child: CheckboxListTile(
                                title: Text(e["name"]),
                                value: e["isComplete"],
                                onChanged: (v) {
                                  setState(() {
                                    e["isComplete"] = v;
                                  });
                                },
                              ),
                            ))
                          ],
                        );
                      }
                  ).toList(),
                ),
              ),
            ),
            ElevatedButton(onPressed: () async {
              User? user = FirebaseAuth.instance.currentUser;
              await FirebaseFirestore.instance
                  .collection("users")
                  .doc(user!.uid)
                  .collection("Events")
                  .doc(widget.event)
              .set(
                {'stages' : this.stages, 'name' : this.nameController.text, 'Type' : this.typeController.text, 'deadline' : this.dateController.text },
                SetOptions(merge: true)
              ).then((value) => print("Modification complete"))
              .catchError((error) => print("Modification échouer"));


              Navigator.pop(context);
            }, child: Text("Submit"))
          ],
        ),
      ),
    );
  }

  void GetEvent() async{
    User? user = FirebaseAuth.instance.currentUser;
    DocumentReference refListEvent = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("Events")
        .doc(widget.event);

    DocumentSnapshot? r = await refListEvent.get();
    this.nameController.text = r["name"];
    this.typeController.text = r["type"];
    this.dateController.text = r["deadline"];
    this.stages = await r["stages"].toList();
    setState(() {});
  }

}

