import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financio/models/personal_model.dart';
import 'package:get/get.dart';

class PersonalCollection extends GetxController {
  static PersonalCollection get instance => Get.find();
  final activityRef = FirebaseFirestore.instance.collection('Personal');

  @override
  void onInit() {
    super.onInit();
    getAllPersonal();
  }

  Future<void> addPersonal(PersonalModel event) async {
    final newPersonalData = {
      'events': FieldValue.arrayUnion([event.toJson()])
    };
    return activityRef
        .doc("test")
        .set(newPersonalData, SetOptions(merge: true));
  }

  Future<List<PersonalModel>> getAllPersonal() async {
    final snapshot = await activityRef.doc("test").get();
    final result = snapshot.data() as Map<String, dynamic>;
    List<PersonalModel> activityData = result['events']
        .map<PersonalModel>((item) => PersonalModel.fromJson(item))
        .toList();
    return activityData;
  }

  Future<void> deletePersonal(PersonalModel event) async {
    final newPersonalData = {
      'events': FieldValue.arrayRemove([event.toJson()])
    };
    return activityRef
        .doc("test")
        .set(newPersonalData, SetOptions(merge: true));
  }
}
