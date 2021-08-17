import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import 'package:canim/provider/providerClass.dart';
import 'package:canim/screens/onePostNotifi.dart';
//translation
import 'package:get/get.dart';

class ShowNotificatopnsDialog extends StatelessWidget {
  // const ShowNotificatopnsDialog({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final myMedia = MediaQuery.of(context).size;
    final myProvider = Provider.of<MyData>(context);
    //myProvider.changeNewNotification(false);

    return Container(
      margin: EdgeInsets.only(
        bottom: myMedia.height * 0.24,
        right: myMedia.width * 0.09,
      ),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(35.0),
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
          ),
        ), //this right here
        child: Container(
          height: myMedia.height * 0.6,
          width: myMedia.width * 0.6,
          child: Column(
            children: [
              FutureBuilder(
                future: FirebaseDatabase()
                    .reference()
                    .child('Users')
                    .child(myProvider.uid)
                    .child('Notification')
                    .once(),
                builder: (context, snapshot) {
                  List<NotificationWidg> myNotificationList = [];

                  var response;
                  if (snapshot.hasData) response = snapshot.data;
                  if (snapshot.hasData &&
                      response != null &&
                      response.value != null) {
                    //print(response.value.keys);
                    for (var key in response.value.keys) {
                      var postWidget = NotificationWidg(
                        resps: response.value[key],
                        time: DateTime.parse(response.value[key]['time']),
                      );
                      myNotificationList.add(postWidget);
                      myNotificationList
                          .sort((b, a) => a.time.compareTo(b.time));
                    }
                    return Container(
                      margin: EdgeInsets.only(top: 15),
                      height: myMedia.height * 0.57,
                      child: ListView(
                        padding: EdgeInsets.only(top: 15.0),
                        //physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        //reverse: true,
                        children: myNotificationList,
                      ),
                    );
                  } else {
                    return Padding(
                      padding: EdgeInsets.only(top: myMedia.height * 0.18),
                      child: Center(child: Text('No Notification!'.tr)),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationWidg extends StatefulWidget {
  //const NotificationWidg({ Key key }) : super(key: key);
  final resps;
  final time;
  NotificationWidg({this.resps, this.time});

  @override
  _NotificationWidgState createState() => _NotificationWidgState();
}

class _NotificationWidgState extends State<NotificationWidg> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            radius: 30.0,
            backgroundImage: NetworkImage(
              widget.resps['user_imgURL'],
            ),
          ),
          title:
              Text('${widget.resps['firstName']} need a blood like your type'),
          subtitle: Text('${widget.resps['email']}'),
          onTap: () {
            Navigator.of(context).pushNamed(OnePostNotifi.id,
                arguments: '${widget.resps['key']}');
          },
        ),
        Divider()
      ],
    );
  }
}
