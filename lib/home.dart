import 'dart:async';

import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:quicktask/main.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final taskController = TextEditingController();

  void addtask() async {
    if (taskController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Empty title"),
        duration: Duration(seconds: 2),
      ));
      return;
    }
    await savetask(taskController.text);
    setState(() {
      taskController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task List", style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => MyApp()));
            },
          )
        ],
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 126, 101, 218),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
              padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      autocorrect: true,
                      textCapitalization: TextCapitalization.sentences,
                      controller: taskController,
                      decoration: InputDecoration(
                          labelText: "New task",
                          labelStyle: TextStyle(
                            color: Color.fromARGB(255, 126, 101, 218),
                          )),
                    ),
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color.fromARGB(255, 126, 101, 218),
                      ),
                      onPressed: addtask,
                      child: Text("ADD")),
                ],
              )),
          Expanded(
              child: FutureBuilder<List<ParseObject>>(
                  future: gettask(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return Center(
                          child: Container(
                              width: 100,
                              height: 100,
                              child: CircularProgressIndicator()),
                        );
                      default:
                        if (snapshot.hasError) {
                          return Center(
                            child: Text("Error..."),
                          );
                        }
                        if (!snapshot.hasData) {
                          return Center(
                            child: Text("No Data..."),
                          );
                        } else {
                          return ListView.builder(
                              padding: EdgeInsets.only(top: 10.0),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                //*************************************
                                //Get Parse Object Values
                                final vartask = snapshot.data![index];
                                final varTitle = vartask.get<String>('title')!;
                                final varDone = vartask.get<bool>('done')!;
                                //*************************************

                                return ListTile(
                                  title: Text(varTitle),
                                  leading: CircleAvatar(
                                    child: Icon(
                                        varDone ? Icons.check : Icons.error),
                                    backgroundColor: varDone
                                        ? Colors.green
                                        : Color.fromARGB(255, 126, 101, 218),
                                    foregroundColor: Colors.white,
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Checkbox(
                                          value: varDone,
                                          onChanged: (value) async {
                                            await updatetask(
                                                vartask.objectId!, value!);
                                            setState(() {
                                              //Refresh UI
                                            });
                                          }),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Color.fromARGB(
                                              255, 126, 101, 218),
                                        ),
                                        onPressed: () async {
                                          await deletetask(vartask.objectId!);
                                          setState(() {
                                            final snackBar = SnackBar(
                                              content: Text("task deleted!"),
                                              duration: Duration(seconds: 2),
                                            );
                                            ScaffoldMessenger.of(context)
                                              ..removeCurrentSnackBar()
                                              ..showSnackBar(snackBar);
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                );
                              });
                        }
                    }
                  }))
        ],
      ),
    );
  }

  Future<void> savetask(String title) async {
    final task = ParseObject('task')
      ..set('title', title)
      ..set('done', false);
    await task.save();
  }

  Future<List<ParseObject>> gettask() async {
    QueryBuilder<ParseObject> querytask =
        QueryBuilder<ParseObject>(ParseObject('task'));
    final ParseResponse apiResponse = await querytask.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }

  Future<void> updatetask(String id, bool done) async {
    var task = ParseObject('task')
      ..objectId = id
      ..set('done', done);
    await task.save();
  }

  Future<void> deletetask(String id) async {
    var task = ParseObject('task')..objectId = id;
    await task.delete();
  }
}
