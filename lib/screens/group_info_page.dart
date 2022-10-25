import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tt_group_chat/service/database_service.dart';

class GroupInfo extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String adminName;
  const GroupInfo(
      {super.key,
      required this.groupId,
      required this.groupName,
      required this.adminName});

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  Stream? members;
  @override
  void initState() {
    getMembers();
    super.initState();
  }

  getMembers() async {
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getGroupMembers(widget.groupId)
        .then((value) {
      setState(() {
        members = value;
      });
    });
  }

  getName(String r) {
    return r.substring(r.indexOf('_') + 1);
  }

  String getId(String res) {
    String id = '';
    for (int i = 0; i < res.length; i++) {
      if (res[i] == '@') {
        break;
      } else {
        id += res[i];
      }
    }
    return id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text('Group Info'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.blue.withOpacity(0.2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.blue,
                    child: Text(
                      widget.groupName[0].toUpperCase(),
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.groupName,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.black),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Admin: ${getName(widget.adminName)}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            memberList(),
          ],
        ),
      ),
    );
  }

  memberList() {
    return StreamBuilder(
        stream: members,
        builder: ((context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data['members'] != null) {
              if (snapshot.data['members'].length != 0) {
                return ListView.builder(
                    itemCount: snapshot.data['members'].length,
                    shrinkWrap: true,
                    itemBuilder: ((context, index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 10),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.blue,
                            child: Text(
                                getName(snapshot.data['members'][index])
                                    .substring(0, 1)
                                    .toUpperCase(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white)),
                          ),
                          title: Text(getName(snapshot.data['members'][index]),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black)),
                          subtitle:
                              Text(getId(snapshot.data['members'][index])),
                        ),
                      );
                    }));
              } else {
                return const Center(child: Text('No members in this group'));
              }
            } else {
              return const Center(child: Text('No members'));
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        }));
  }
}
