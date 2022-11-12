import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  //collection reference
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference groupCollection = FirebaseFirestore.instance.collection('groups');

  //saving the userdata
  Future savingUserData (String fullName, String email) async{
    return await userCollection.doc(uid).set({
      'fullName': fullName,
      'email': email,
      'groups': [],
      'profilePic': '',
      'uid': uid,
    });
  }

  //getting user data
  Future gettingUserData(String email) async{
    QuerySnapshot snapshot = await userCollection.where('email', isEqualTo: email).get();
    return snapshot;
  }

  //get user group
  getUserGroups() async{
    return userCollection.doc(uid).snapshots();
  }

  //Creating Group
  Future createGroup(String userName, String id, String groupName) async{
    DocumentReference documentReference = await groupCollection.add({
      'groupName': groupName,
      'groupIcon': '',
      'admin': '${id}_$userName',
      'members': [],
      'groupId': '',
      'recentMessage': '',
      'recentMessageSender': '',
    });
    
    //update the members
    await documentReference.update({
      'members': FieldValue.arrayUnion(['${uid}_$userName']),
      'groupId': documentReference.id,
    });

    DocumentReference userDocumentReference = userCollection.doc(uid);
    return await userDocumentReference.update({
      
      'groups': FieldValue.arrayUnion([documentReference.id]),
      //'groups': FieldValue.arrayUnion(['${groupDocumentReference.id}_$groupName']),
    
    });
  }

  //getting the chats
  getChats(String groupId) async{
    return groupCollection.doc(groupId).collection('messages').orderBy('time').snapshots();
  }

  Future getGroupAdmin(String groupId) async{
    DocumentReference d = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['admin'];
  }

  //get group members
  getGroupMembers(String groupId) async{
    return groupCollection.doc(groupId).snapshots();
  }

  // Searcj
  searchByName(String groupName){
    return groupCollection.where('groupName', isEqualTo: groupName).get();
  }

}
