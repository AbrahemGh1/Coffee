import 'package:brew_crew/models/brew.dart';
import 'package:brew_crew/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  //Collection reference
  final CollectionReference brewCollection =
      Firestore.instance.collection('brews');

  Future updateUserData(String sugars, String name, int strength) async {
    return await brewCollection.document(uid).setData({
      'sugars': sugars,
      'name': name,
      'strength': strength,
    });
  }

  //get brews stream
  Stream<List<Brew>> get brews {
    return brewCollection.snapshots().map(_brewListFromSnapshot);
  }

  // brews list from a snapshots
  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents
        .map((e) => Brew(
            name: e.data['name'] ?? '',
            strength: e.data['strength'] ?? 0,
            sugars: e.data['sugars'] ?? '0'))
        .toList();
  }

  // get user doc stream form firebase.
  Stream<UserData> get userData {
    return brewCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }

  //user data from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: snapshot.data[uid],
        name: snapshot.data['name'],
        strength: snapshot.data['strength'],
        sugars: snapshot.data['sugars']);
  }
}
// return snapshot.documents.map((e) {
//       return Brew(
//           name: e.data['name'] ?? '',
//           strength: e.data['strength'] ?? 0,
//           sugars: e.data['sugars'] ?? '0');
//     });
