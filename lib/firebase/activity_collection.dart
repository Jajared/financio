import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_tracker/models/activity_model.dart';
import 'package:get/get.dart';

class ActivityCollection extends GetxController {
  static ActivityCollection get instance => Get.find();
  final activityRef = FirebaseFirestore.instance.collection('Events');

  @override
  void onInit() {
    super.onInit();
    getAllActivity();
  }

  Future<void> addActivity(ActivityModel activity) async {
    final newActivityData = {
      'activity': FieldValue.arrayUnion([activity.toJson()])
    };
    return activityRef
        .doc("test")
        .set(newActivityData, SetOptions(merge: true));
  }

  Future<List<ActivityModel>> getAllActivity() async {
    final snapshot = await activityRef.doc("test").get();
    final result = snapshot.data() as Map<String, dynamic>;
    List<ActivityModel> activityData = result['activity']
        .map<ActivityModel>((item) => ActivityModel.fromJson(item))
        .toList();
    return activityData;
  }
}
