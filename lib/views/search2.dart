import 'dart:math';

import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/models/user.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/views/chat.dart';
import 'package:chatapp/views/team.dart';
import 'package:chatapp/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Search2 extends StatefulWidget {
  @override
  _Search2State createState() => _Search2State();
}

class _Search2State extends State<Search2> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchEditingController = new TextEditingController();
  QuerySnapshot searchResultSnapshot;

  bool isLoading = false;
  bool haveUserSearched = false;
  bool isAdded = false;

  initiateSearch() async {
    if (searchEditingController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await databaseMethods
          .searchByName(searchEditingController.text)
          .then((snapshot) {
        searchResultSnapshot = snapshot;
        print("$searchResultSnapshot");
        setState(() {
          isLoading = false;
          haveUserSearched = true;
        });
      });
    }
  }

  Widget userList() {
    return haveUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchResultSnapshot.documents.length,
            itemBuilder: (context, index) {
              return userTile(
                searchResultSnapshot.documents[index].data["userName"],
                searchResultSnapshot.documents[index].data["userEmail"],
              );
            })
        : Container();
  }

  List<String> users = [Constants.myName];

  addToList(String userName) {
    setState(() {
      if (!users.contains(userName)) {
        users.add(userName);
      }
    });
  }

  addUser() {
    setState(() {
      isAdded = false;
    });
  }

  createProject() {
    if (users.length != 1) {
      String projectId = getProjectId();

      //List<String> users = [Constants.myName,userName];

      Map<String, dynamic> projectRoom = {
        "users": users,
        "projectId": projectId,
        "admin": Constants.myName,
      };

      databaseMethods.addChatRoom2(projectRoom, projectId);

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Team(
                    projectId: projectId,
                  )));
    }
  }

  Widget userTile(String userName, String userEmail) {
    //addUser();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              Text(
                userEmail,
                style: TextStyle(color: Colors.white, fontSize: 16),
              )
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              addToList(userName);
              setState(() {
                isAdded = true;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                  color: isAdded ? Colors.brown : Colors.orange,
                  borderRadius: BorderRadius.circular(24)),
              child: isAdded
                  ? Text(
                      "Added",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    )
                  : Text(
                      "Add",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  String getProjectId() {
    var random = Random.secure();
    var value = random.nextInt(1000000);
    return "Pool " + value.toString();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Pool'),
        actions: [
          GestureDetector(
            key: new Key('createProjectKey'),
            onTap: () {
              createProject();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
      body: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    color: Color(0x54FFFFFF),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: searchEditingController,
                            style: simpleTextStyle(),
                            decoration: InputDecoration(
                                hintText: "Add User ...",
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                border: InputBorder.none),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            initiateSearch();
                            addUser();
                          },
                          child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                        const Color(0x36FFFFFF),
                                        const Color(0x0FFFFFFF)
                                      ],
                                      begin: FractionalOffset.topLeft,
                                      end: FractionalOffset.bottomRight),
                                  borderRadius: BorderRadius.circular(40)),
                              padding: EdgeInsets.all(12),
                              child: Image.asset(
                                "assets/images/search_white.png",
                                height: 25,
                                width: 25,
                              )),
                        ),
                      ],
                    ),
                  ),
                  userList()
                ],
              ),
            ),
    );
  }
}
