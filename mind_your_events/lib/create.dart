
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mind_your_events/Classes.dart';





class CreatePage extends StatefulWidget{
  CreatePage({Key? key}) : super(key:key);

  @override
  _CreatePageState createState() => _CreatePageState();

}



class _CreatePageState extends State<CreatePage>{
  final nameController = TextEditingController();
  final typeController = TextEditingController();
  final stagesController = TextEditingController();
  final dateController = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
  List<Stage> stages = [];
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create a event"),
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
              child: Row(
                children: [
                  Expanded(child: TextField(
                    controller: stagesController,
                    decoration: InputDecoration(
                        labelText: "Stage"
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
            ElevatedButton(onPressed: () {
              setState(() {
                Stage stage = Stage(this.stagesController.text, false);
                this.stages.add(stage);
                stagesController.clear();
              });
            }, child: Text("Add stage")),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 15.0, right: 15.0),
                child: ListView(
                  children: this.stages.map<Widget>(
                      (e){
                        return Row(
                          children: [
                            Expanded(child: Card(
                              child: ListTile(
                                title: Text(e.name),
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
              CollectionReference refListEvent = await FirebaseFirestore.instance
                  .collection("users")
                  .doc(user!.uid)
                  .collection("Events");

              refListEvent.add({
                'name': nameController.text,
                'type': typeController.text,
                'deadline' : dateController.text,
                'created' : DateTime.now(),
                'stages' : [
                  for(var i = 0; i < stages.length; i++){
                    'name' : stages[i].name,
                    'isComplete' : stages[i].isComplete
                  }
                ]
              }).then((value) {
                print("Event add!!");
              });
              Navigator.pop(context);
            }, child: Text("Submit"))
          ],
        ),
      ),
    );
  }



}


