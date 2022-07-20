import 'dart:async';
import 'dart:convert';
import 'package:chat_app/models/user_details.dart';
import 'package:chat_app/variables/colors.dart';
import 'package:chat_app/variables/text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ContactScreen extends StatefulWidget {
  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  TextEditingController controller = TextEditingController();
  List<UserDetails> _searchResult = [];
  List<UserDetails> _userDetails = [];

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _userDetails.forEach((userDetail) {
      if (userDetail.firstName!.contains(text) ||
          userDetail.lastName!.contains(text)) _searchResult.add(userDetail);
    });

    setState(() {});
  }

  Future getUserDetails() async {
    final response = await http.get(Uri.parse(''));
    final responseJson = json.decode(response.body);

    setState(() {
      for (Map user in responseJson) {
        _userDetails.add(UserDetails.fromJson(user as Map<String, dynamic>));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MyText.home),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      children: <Widget>[
        Container(
          color: Theme.of(context).primaryColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: ListTile(
                leading: Icon(Icons.search),
                title: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: MyText.search,
                    border: InputBorder.none,
                  ),
                  onChanged: onSearchTextChanged,
                ),
                trailing: IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    controller.clear();
                    onSearchTextChanged('');
                  },
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: _searchResult.length != 0 || controller.text.isNotEmpty
              ? ListView.builder(
                  itemCount: _searchResult.length,
                  itemBuilder: (ctx, i) {
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: MyColors.blue,
                        ),
                        title: Text(
                          _searchResult[i].firstName! +
                              ' ' +
                              _searchResult[i].lastName.toString(),
                        ),
                      ),
                      margin: const EdgeInsets.all(0.0),
                    );
                  },
                )
              : ListView.builder(
                  itemCount: _userDetails.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: MyColors.blue,
                        ),
                        title: Text(
                          _userDetails[index].firstName! +
                              ' ' +
                              _userDetails[index].lastName.toString(),
                        ),
                      ),
                      margin: const EdgeInsets.all(0.0),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
