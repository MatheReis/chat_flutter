import 'package:chat_app/Auth/auth.dart';
import 'package:chat_app/Groups/group_chat_screen.dart';
import 'package:chat_app/Screens/chat_room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  bool isLoading = false;
  Map<String, dynamic>? userMap;
  List<String> filterUsers = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    setStatus("Online");
  }

  void setStatus(String status) async {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      "status": status,
    });
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

  // onSearchTextChanged(String text) async {
  //   filterUsers.clear();
  //   if (text.isEmpty) {
  //     setState(() {});
  //     return;
  //   }

  //   _firestore.collection('users').get().then((value) {
  //     value.docs.forEach((doc) {
  //       if (doc.data()['name'].toLowerCase().contains(text.toLowerCase())) {
  //         filterUsers.add(doc.id);
  //       }
  //     });
  //   });

  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Procure por um amigo"),
        actions: [
          IconButton(icon: Icon(Icons.logout), onPressed: () => logOut(context))
        ],
      ),
      body: Column(
        children: [
          // Container(
          //   color: Theme.of(context).primaryColor,
          //   child: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: Card(
          //       child: ListTile(
          //         leading: Icon(Icons.search),
          //         title: TextField(
          //           controller: searchController,
          //           decoration: InputDecoration(
          //               hintText: 'Search', border: InputBorder.none),
          //           onChanged: onSearchTextChanged,
          //         ),
          //         trailing: IconButton(
          //           icon: Icon(Icons.cancel),
          //           onPressed: () {
          //             searchController.clear();
          //             onSearchTextChanged('');
          //           },
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('users').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Ocorreu um erro');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (!snapshot.hasData) {
                  return Center(
                    child: Text("SEM DADOS"),
                  );
                }
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext ctx, int i) {
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue,
                          ),
                          title: Text((snapshot.data!.docs[i].data()
                              as dynamic)['name']),
                          onTap: () {
                            print((snapshot.data!.docs[i].data()
                                as dynamic)['name']);
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
                        ),
                      );
                    });
              },
            ),
          ),
        ],
      ),
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
}
