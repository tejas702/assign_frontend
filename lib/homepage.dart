import 'dart:convert';
import 'dart:html';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _userController = TextEditingController();
  final _taskController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 1000,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                "Instructions to use:\nThere are two users 1 and 2\nRun get-tasks - fetches tasks of the user\nadd task - userId as input\ndelete task - taskId as input\nupdate task- userId and taskId as input"),
            Row(
              children: [
                Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width / 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        controller: _userController,
                        decoration: InputDecoration(
                          hintText: 'Enter userId',
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: MaterialButton(
                          onPressed: () {
                            getTasks(_userController.text);
                          },
                          color: Colors.blue,
                          child: Text(
                            'Get Tasks',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width / 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        controller: _taskController,
                        decoration: InputDecoration(
                          hintText: 'Enter taskId',
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MaterialButton(
                                onPressed: () {
                                  // add api
                                  addTasks(_userController.text);
                                },
                                color: Colors.blue,
                                child: Text(
                                  'Add',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              MaterialButton(
                                onPressed: () {
                                  // delete api
                                  deleteTasks(_taskController.text);
                                },
                                color: Colors.blue,
                                child: Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              MaterialButton(
                                onPressed: () {
                                  // update api
                                  updateTasks(_taskController.text,
                                      _userController.text);
                                },
                                color: Colors.blue,
                                child: Text(
                                  'Update',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ]),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Container(
              height: 500,
              child: ListView(
                children: [
                  for (int i = 0; i < tasks.length; i++)
                    ListTile(title: Text("Task " + tasks[i]))
                ],
              ),
            ),
            if (delete.length > 0) Text(delete)
          ],
        ),
      ),
    );
  }

  List<dynamic> tasks = [];
  String delete = "";
  Future getTasks(String userId) async {
    setState(() {
      tasks = [];
      delete = "";
    });
    if (num.tryParse(userId) == null) return; // if input string is not a number
    print('fetchTasks called');
    String url =
        'https://assignment-production-d366.up.railway.app/users/get-tasks';
    final requestBody = jsonEncode({'userId': userId});
    final headers = {'Content-Type': 'application/json'};
    final uri = Uri.parse(url);
    try {
      http.Response response =
          await http.post(uri, headers: headers, body: requestBody);
      final body = response.body;
      final json = jsonDecode(body);
      print(json);
      if (response.statusCode == 200) {
        setState(() {
          tasks = json;
        });
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  Future addTasks(String userId) async {
    setState(() {
      tasks = [];
      delete = "";
    });
    if (num.tryParse(userId) == null) return; // if input string is not a number
    print('addTasks called');
    String url = 'https://assignment-production-d366.up.railway.app/tasks/add';
    final requestBody = jsonEncode({"userId": userId});
    final headers = {'Content-Type': 'application/json'};
    final uri = Uri.parse(url);
    try {
      http.Response response =
          await http.post(uri, headers: headers, body: requestBody);
      final body = response.body;
      final json = jsonDecode(body);
      print(json);
      if (response.statusCode == 200) {
        setState(() {
          tasks = json;
        });
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  Future deleteTasks(String taskId) async {
    setState(() {
      delete = "";
    });
    if (num.tryParse(taskId) == null) return; // if input string is not a number
    print('deleteTasks called');
    String url =
        'https://assignment-production-d366.up.railway.app/tasks/delete';
    final requestBody = jsonEncode({"taskId": taskId});
    final headers = {'Content-Type': 'application/json'};
    final uri = Uri.parse(url);
    try {
      http.Response response =
          await http.delete(uri, headers: headers, body: requestBody);
      String body = response.body;
      print(body);
      if (response.statusCode == 200) {
        setState(() {
          delete = body;
        });
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  Future updateTasks(String taskId, String userId) async {
    setState(() {
      tasks = [];
      delete = "";
    });
    if (num.tryParse(userId) == null || num.tryParse(taskId) == null) {
      return; // if input string is not a number
    }
    print('updateTasks called');
    String url =
        'https://assignment-production-d366.up.railway.app/tasks/update';
    final requestBody = jsonEncode({"taskId": taskId, "userId": userId});
    final uri = Uri.parse(url);
    final headers = {'Content-Type': 'application/json'};
    try {
      http.Response response =
          await http.put(uri, headers: headers, body: requestBody);
      final body = response.body;
      final json = jsonDecode(body);
      print(json);
      if (response.statusCode == 200) {
        setState(() {
          tasks = json;
        });
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }
}
