import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/helper/helperfunctions.dart';
import 'package:chatapp/models/user.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/views/chat.dart';
import 'package:chatapp/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowProfile extends StatefulWidget {
  @override
  _ShowProfileState createState() => _ShowProfileState();
}

class _ShowProfileState extends State<ShowProfile> {
  //Stream userProfile;
  QuerySnapshot email;

  DatabaseMethods databaseMethods = new DatabaseMethods();
  bool isLoading = false;



  setEmail() async{
    Constants.myEmail = await HelperFunctions.getUserEmailSharedPreference();
    await databaseMethods.getProfileInfo(Constants.myEmail)
          .then((snapshot){
        setState(() {
          email=snapshot;
        });
        print(snapshot);
        print(email.documents[0].data['email']);

      });
  }

  @override
  void initState()  {
    setEmail();


    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
          elevation: 0.0,
          centerTitle: false,
          actions: [],
        ),
        body: Container(
          child: Center(
            child:Column(
              children: [
                Row(
                  children: [
                    Text("Full Name:",style: simpleTextStyle(),),
                    SizedBox(width: 10,),
                    Text(email.documents[0].data['fullName'],style: simpleTextStyle(),),
                  ],
                ),
                Row(
                  children: [
                    Text("Email:",style: simpleTextStyle(),),
                    SizedBox(width: 10,),
                    Text(email.documents[0].data['email'],style: simpleTextStyle(),),
                  ],
                ),
                Row(
                  children: [
                    Text("source:",style: simpleTextStyle(),),
                    SizedBox(width: 10,),
                    Text(email.documents[0].data['source'],style: simpleTextStyle(),),
                  ],
                ),
                Row(
                  children: [
                    Text("destination:",style: simpleTextStyle(),),
                    SizedBox(width: 10,),
                    Text(email.documents[0].data['destination'],style: simpleTextStyle(),),
                  ],
                ),
              ],
            ),
          ),
        )
        // body: Container(
        //     child: StreamBuilder(
        //       stream: userProfile,
        //       builder: (context, snapshot){
        //         return Container(
        //           child: Column(
        //             children: [
        //               Text(snapshot.data["email"], style: TextStyle(color: Colors.white)),
        //               Text(snapshot.data["fullName"], style: simpleTextStyle()),
        //               Text(snapshot.data["source"], style: simpleTextStyle()),
        //               Text(snapshot.data["destination"], style: simpleTextStyle()),
        //               Text(snapshot.data["sourceTime"], style: simpleTextStyle()),
        //               Text(snapshot.data["destinationTime"], style: simpleTextStyle()),
        //             ],
        //           ),
        //         );
        //       },
        //     )
        // )
    );
  }
}


