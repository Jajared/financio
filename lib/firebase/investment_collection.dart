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
    double newTotalValue =
        currentData['summary']['graphData'].last['value'].toDouble() +
            eventValue;

    // Get current date and convert the Timestamp to a DateTime object
    Timestamp currentTimestamp = Timestamp.now();
    DateTime currentDate = currentTimestamp.toDate();
    DateTime midnightDate = DateTime(
        currentDate.year, currentDate.month, currentDate.day, 0, 0, 0, 0, 0);

    List<dynamic> currentGraphData = currentData['summary']['graphData'];
    // Check if the last date entry is the same as the current date
    if (currentGraphData.isNotEmpty) {
      Map<String, dynamic> lastEntry = currentGraphData.last;
      if (lastEntry['date'].toDate() == midnightDate) {
        lastEntry['value'] = newTotalValue;
      } else {
        Map<String, dynamic> newGraphEntry = {
          'date': Timestamp.fromDate(midnightDate),
          'value': newTotalValue,
        };
        currentData['summary']['graphData'].add(newGraphEntry);
      }
    } else {
      // If there is no entry, add a new entry
      Map<String, dynamic> newGraphEntry = {
        'date': Timestamp.fromDate(midnightDate),
        'value': newTotalValue,
      };
      currentData['summary']['graphData'].add(newGraphEntry);
    }

    Map<String, dynamic> newInvestmentData = {
      'events': FieldValue.arrayUnion([event.toJson()]),
      'summary': currentData['summary'],
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
