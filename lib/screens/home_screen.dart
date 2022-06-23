import 'package:chat_app/Groups/group_chat_screen.dart';
import 'package:chat_app/Screens/chat_room.dart';
import 'package:chat_app/auth/Methods.dart';
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
  String? result;
  TextEditingController _searchCtrl = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        bottomOpacity: 0.0,
        elevation: 0.0,
        toolbarHeight: 60,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                "assets/icon.png",
                height: 50,
                width: 50,
              ),
            ),
            SizedBox(width: 10),
            Text(
              "Chats",
              style: TextStyle(color: Colors.black, fontSize: 25),
            ),
          ],
        ),
        actions: [
          // IconButton(
          //   onPressed: () {},
          //   icon: Icon(
          //     Icons.search,
          //     size: 26,
          //     color: Colors.blue,
          //   ),
          // ),
          PopupMenuButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.blue,
              size: 25,
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            color: Colors.white,
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(Icons.people, color: Colors.blue, size: 25),
                    SizedBox(width: 10),
                    Text(
                      'Perfil',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                value: 1,
              ),
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(Icons.logout_outlined, color: Colors.red, size: 25),
                    SizedBox(width: 10),
                    Text(
                      'Sair',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                onTap: () => logOut(context),
                value: 2,
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: ListTile(
              title: TextField(
                controller: _searchCtrl,
                onChanged: (value) {
                  filterSearch(value);
                },
                decoration: InputDecoration(
                  hintText: "Procurar...",
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
          ),
          SizedBox(height: 10),
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
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue,
                      ),
                      title: Text(
                          (snapshot.data!.docs[i].data() as dynamic)['name']),
                      onTap: () {
                        print(
                            (snapshot.data!.docs[i].data() as dynamic)['name']);
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
}
