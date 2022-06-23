import 'package:flutter/cupertino.dart';

class PopUpLogout extends StatefulWidget {
  PopUpLogout({Key? key}) : super(key: key);

  @override
  State<PopUpLogout> createState() => _PopUpLogoutState();
}

class _PopUpLogoutState extends State<PopUpLogout> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  void _showActionSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Title'),
        message: const Text('Message'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Default Action'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Action'),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Destructive Action'),
          )
        ],
      ),
    );
  }
}
