import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_tracker/models/investment_model.dart';
import 'package:get/get.dart';

class InvestmentCollection extends GetxController {
  static InvestmentCollection get instance => Get.find();
  final activityRef = FirebaseFirestore.instance.collection('Investments');

  @override
  void onInit() {
    super.onInit();
    getAllInvestment();
  }

  Future<void> addPersonal(InvestmentModel event) async {
    final newPersonalData = {
      'events': FieldValue.arrayUnion([event.toJson()])
    };
    return activityRef
        .doc("test")
        .set(newPersonalData, SetOptions(merge: true));
  }

  Future<List<InvestmentModel>> getAllInvestment() async {
    final snapshot = await activityRef.doc("test").get();
    final result = snapshot.data() as Map<String, dynamic>;
    List<InvestmentModel> activityData = result['events']
        .map<InvestmentModel>((item) => InvestmentModel.fromJson(item))
        .toList();
    return activityData;
  }
}
