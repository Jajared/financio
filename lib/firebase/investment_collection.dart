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

    // Calculate new event value
    double eventValue = event.sharePrice * event.quantity;

    // Check if the event ticker is present in the current holdings
    Map<String, dynamic>? existingHolding = currentData['holdings'].firstWhere(
      (holding) => holding['ticker'] == event.ticker,
      orElse: () => null,
    );
    if (existingHolding != null) {
      // If the event ticker is present in the current holdings, update the value, quantity, and average price
      double currentValue = existingHolding['sharePrice'].toDouble() *
          existingHolding['quantity'];
      int currentQuantity = existingHolding['quantity'];
      double newValue = currentValue + eventValue;
      int newQuantity = currentQuantity + event.quantity;
      existingHolding['quantity'] = newQuantity;
      existingHolding['sharePrice'] = newValue / newQuantity;
    } else {
      // If the event ticker is not present, add a new holding
      currentData['holdings'].add(event.toJson());
    }

    // Get current date and convert the Timestamp to a DateTime object
    Timestamp currentTimestamp = Timestamp.now();
    DateTime currentDate = currentTimestamp.toDate();
    DateTime midnightDate = DateTime(
        currentDate.year, currentDate.month, currentDate.day, 0, 0, 0, 0, 0);

    List<dynamic> currentGraphData = currentData['summary']['graphData'];
    double newTotalValue =
        currentData['summary']['graphData'].last['value'].toDouble() +
            eventValue;

    if (currentGraphData.isNotEmpty) {
      Map<String, dynamic> lastEntry = currentGraphData.last;
      final lastDate = lastEntry['date'].toDate();
      // Check if the last date entry is the same as the current date
      if (lastDate.year == midnightDate.year &&
          lastDate.month == midnightDate.month &&
          lastDate.day == midnightDate.day) {
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
      'holdings': currentData['holdings'],
      'summary': currentData['summary'],
    };

    return investmentRef
        .doc("test")
        .set(newInvestmentData, SetOptions(merge: true));
  }

  Future<void> sellInvestment(InvestmentModel event) async {
    DocumentSnapshot snapshot = await investmentRef.doc("test").get();
    Map<String, dynamic> currentData = snapshot.data() as Map<String, dynamic>;
    List<dynamic> currentGraphData = currentData['summary']['graphData'];
    double eventValue = event.sharePrice * event.quantity;

    // Check if the event ticker is present in the current holdings
    bool isTickerPresent = false;
    List<dynamic> currentHoldings = currentData['holdings'];
    for (int i = 0; i < currentHoldings.length; i++) {
      if (currentHoldings[i]['ticker'] == event.ticker) {
        isTickerPresent = true;
        double currentHoldingsValue = currentHoldings[i]['value'].toDouble();
        double newHoldingsValue = currentHoldingsValue - eventValue;
        currentHoldings[i]['value'] = newHoldingsValue;
        break;
      }
    }

    if (!isTickerPresent) {
      // Handle the case where the event ticker is not present in the current holdings
      // (e.g., show an error message or take appropriate action)
      return;
    }

    // Calculate new total value
    double newTotalValue =
        currentData['summary']['total_value'].toDouble() - eventValue;

    // Update graph data with new total value
    Map<String, dynamic> lastEntry = currentGraphData.last;
    lastEntry['value'] = newTotalValue;
    currentGraphData[currentGraphData.length - 1] = lastEntry;

    // Update the new investment data
    Map<String, dynamic> newInvestmentData = {
      'holdings': currentHoldings,
      'summary': {
        'profit': 0,
        'graphData': currentGraphData,
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
    List<InvestmentModel> activityData = result['holdings']
        .map<InvestmentModel>((item) => InvestmentModel.fromJson(item))
        .toList();
    return activityData;
  }
}
