import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_tracker/models/investment_model.dart';
import 'package:get/get.dart';

class InvestmentCollection extends GetxController {
  static InvestmentCollection get instance => Get.find();
  final investmentRef = FirebaseFirestore.instance.collection('Investments');

  @override
  void onInit() {
    super.onInit();
    getAllInvestment();
  }

  Future<void> addInvestment(InvestmentModel event) async {
    DocumentSnapshot snapshot = await investmentRef.doc("test").get();
    Map<String, dynamic> currentData = snapshot.data() as Map<String, dynamic>;

    // Calculate new summary
    double eventValue = event.sharePrice * event.quantity;
    double newTotalValue = currentData['summary']['total_value'] + eventValue;

    Map<String, dynamic> newInvestmentData = {
      'events': FieldValue.arrayUnion([event.toJson()]),
      'summary': {
        'total_value': newTotalValue,
      }
    };
    return investmentRef
        .doc("test")
        .set(newInvestmentData, SetOptions(merge: true));
  }

  Future<void> sellInvestment(InvestmentModel event) async {
    DocumentSnapshot snapshot = await investmentRef.doc("test").get();
    Map<String, dynamic> currentData = snapshot.data() as Map<String, dynamic>;

    // Calculate new summary
    double eventValue = event.sharePrice * event.quantity;
    double newTotalValue = currentData['summary']['total_value'] - eventValue;

    // Check again
    Map<String, dynamic> newInvestmentData = {
      'events': FieldValue.arrayRemove([event.toJson()]),
      'summary': {
        'total_value': newTotalValue,
      }
    };
    return investmentRef
        .doc("test")
        .set(newInvestmentData, SetOptions(merge: true));
  }

  getSummary() async {
    final snapshot = await investmentRef.doc("test").get();
    final result = snapshot.data() as Map<String, dynamic>;
    return result['summary'];
  }

  Future<List<InvestmentModel>> getAllInvestment() async {
    final snapshot = await investmentRef.doc("test").get();
    final result = snapshot.data() as Map<String, dynamic>;
    List<InvestmentModel> activityData = result['events']
        .map<InvestmentModel>((item) => InvestmentModel.fromJson(item))
        .toList();
    return activityData;
  }
}
