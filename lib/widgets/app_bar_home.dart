import 'package:chat_app/variables/colors.dart';
import 'package:chat_app/variables/text.dart';
import 'package:flutter/material.dart';

Widget appBarHome({required Function() onTap}) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      toolbarHeight: 90,
      elevation: 0,
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
            MyText.chat,
            style: TextStyle(color: Colors.black, fontSize: 25),
          ),
        ],
      ),
      actions: [
        PopupMenuButton(
          icon: Icon(
            Icons.more_vert,
            color: MyColors.blue,
            size: 25,
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          color: MyColors.white,
          itemBuilder: (context) => [
            PopupMenuItem(
              child: Row(
                children: [
                  Icon(
                    Icons.people,
                    color: MyColors.blue,
                    size: 25,
                  ),
                  SizedBox(width: 10),
                  Text(
                    MyText.profile,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              value: 1,
            ),
            PopupMenuItem(
              child: Row(
                children: [
                  Icon(
                    Icons.logout_outlined,
                    color: MyColors.red,
                    size: 25,
                  ),
                  SizedBox(width: 10),
                  Text(
                    MyText.logOut,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              onTap: onTap,
              value: 2,
            ),
          ],
        ),
      ],
    ),
  );
}
