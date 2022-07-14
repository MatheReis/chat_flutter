import 'package:chat_app/Groups/group_chat_screen.dart';
import 'package:chat_app/Screens/chat_room.dart';
import 'package:chat_app/auth/Methods.dart';
import 'package:chat_app/variables/text.dart';
import 'package:chat_app/widgets/app_bar_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  String? result;
  bool isLoading = false;
  Map<String, dynamic>? userMap;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _searchCtrl = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    setStatus("Online");
  }

  void setStatus(String status) async {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update(
      {
        "status": status,
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    state == AppLifecycleState.resumed
        ? setStatus("Online")
        : setStatus("Offline");
  }

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  void filterSearch(String text) {
    List<String> dummySearchList = [];
    dummySearchList.addAll(userMap?['name']);
    if (text.isNotEmpty) {
      List<String> dummyListData = [];
      dummyListData.forEach((item) {
        if (item.contains(item)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        userMap?.clear();
        userMap?.addAll(dummyListData as dynamic);
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: appBarHome(
          onTap: () {
            logOut(context);
          },
        ),
      ),
      body: buildBody(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.group),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => GroupChatHomeScreen(),
          ),
        ),
      ),
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        ListTile(
          title: TextField(
            controller: _searchCtrl,
            onChanged: (value) {
              filterSearch(value);
            },
            decoration: InputDecoration(
              hintText: MyText.searchUser,
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey.shade500,
                size: 23,
              ),
              filled: true,
              fillColor: Colors.grey.shade200,
              contentPadding: EdgeInsets.all(15),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.grey.shade100),
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('users').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text(MyText.error);
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (!snapshot.hasData) {
                return Center(
                  child: Text(MyText.noData),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext ctx, int i) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                    ),
                    title: Text(
                        (snapshot.data!.docs[i].data() as dynamic)['name']),
                    onTap: () {
                      print((snapshot.data!.docs[i].data() as dynamic)['name']);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatRoom(
                            chatRoomId: chatRoomId(_auth.currentUser!.uid,
                                snapshot.data!.docs[i].id),
                            userMap: {
                              "name": (snapshot.data!.docs[i].data()
                                  as dynamic)['name'],
                              "email": (snapshot.data!.docs[i].data()
                                  as dynamic)['email'],
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
