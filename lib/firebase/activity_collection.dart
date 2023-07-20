import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_tracker/models/activity_model.dart';
import 'package:get/get.dart';

class ActivityCollection extends GetxController {
  static ActivityCollection get instance => Get.find();
  final activityRef = FirebaseFirestore.instance.collection('Events');

  Future<void> addActivity(ActivityModel activity) async {
    await activityRef.doc("test").set(activity.toJson());
  }

  Future<List<ActivityModel>> getAllActivity() async {
    final snapshot = await activityRef.doc("test").get();
    final activityData = snapshot.data() as List<ActivityModel>;
    return activityData;
  }
}
