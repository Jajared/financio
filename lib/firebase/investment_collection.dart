import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financio/models/investment_model.dart';
import 'package:financio/models/watchlist_model.dart';
import 'package:get/get.dart';

class InvestmentCollection extends GetxController {
  static InvestmentCollection get instance => Get.find();
  final investmentRef = FirebaseFirestore.instance.collection('Investments');

  @override
  void onInit() {
    super.onInit();
    getAllInvestment();
  }

  Future<List<InvestmentModel>> addInvestment(InvestmentModel event) async {
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

    investmentRef.doc("test").set(newInvestmentData, SetOptions(merge: true));

    return currentData['holdings']
        .map<InvestmentModel>((item) => InvestmentModel.fromJson(item))
        .toList();
  }

  Future<List<InvestmentModel>> sellInvestment(InvestmentModel event) async {
    DocumentSnapshot snapshot = await investmentRef.doc("test").get();
    Map<String, dynamic> currentData = snapshot.data() as Map<String, dynamic>;

    // Convert currentData['holdings'] to List<InvestmentModel>
    List<dynamic> currentHoldingsData = currentData['holdings'];
    List<InvestmentModel> currentHoldings = currentHoldingsData
        .map<InvestmentModel>((item) => InvestmentModel.fromJson(item))
        .toList();
    List<dynamic> currentHoldingsJson =
        currentHoldings.map((item) => item.toJson()).toList();
    List<dynamic> currentGraphData = currentData['summary']['graphData'];
    double currentProfit = currentData['summary']['profit'].toDouble();
    double totalValue = currentGraphData.last['value'].toDouble();
    // Check if the event ticker is present in the current holdings
    for (int i = 0; i < currentHoldings.length; i++) {
      InvestmentModel currentHolding = currentHoldings[i];
      if (currentHolding.ticker == event.ticker) {
        int currentQuantity = currentHolding.quantity;
        int newQuantity = currentQuantity - event.quantity;
        if (newQuantity == 0) {
          currentHoldings.removeAt(i);
        } else {
          double currentPrice = currentHolding.sharePrice.toDouble();
          InvestmentModel updatedHolding = InvestmentModel(
            ticker: currentHolding.ticker,
            quantity: newQuantity,
            sharePrice: currentPrice,
            timestamp: currentHolding.timestamp,
          );
          currentHoldings[i] = updatedHolding;
          currentProfit += (event.sharePrice - currentPrice) * event.quantity;
        }
        totalValue = totalValue - (currentHolding.sharePrice * event.quantity);
        break;
      }
    }

    // Update graph data with new total value
    Map<String, dynamic> lastEntry = currentGraphData.last;
    lastEntry['value'] = totalValue;
    currentGraphData[currentGraphData.length - 1] = lastEntry;

    // Update the new investment data
    currentHoldingsJson = currentHoldings.map((item) => item.toJson()).toList();
    Map<String, dynamic> newInvestmentData = {
      'holdings': currentHoldingsJson,
      'summary': {
        'profit': currentProfit,
        'graphData': currentGraphData,
      }
    };

    investmentRef.doc("test").set(newInvestmentData, SetOptions(merge: true));

    return currentHoldings;
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

  Future<List<WatchListModel>> getAllWatchList() async {
    final snapshot = await investmentRef.doc("test").get();
    final result = snapshot.data() as Map<String, dynamic>;
    List<WatchListModel> watchlistData = result['watchlist']
        .map<WatchListModel>((item) => WatchListModel.fromJson(item))
        .toList();
    return watchlistData;
  }

  Future<void> addToWatchList(WatchListModel newWatchListItem) async {
    DocumentSnapshot snapshot = await investmentRef.doc("test").get();
    Map<String, dynamic> currentData = snapshot.data() as Map<String, dynamic>;
    List<dynamic> currentWatchListData = currentData['watchlist'];
    List<WatchListModel> currentWatchList = currentWatchListData
        .map<WatchListModel>((item) => WatchListModel.fromJson(item))
        .toList();
    List<dynamic> newWatchListData =
        currentWatchList.map((item) => item.toJson()).toList();
    newWatchListData.add(newWatchListItem.toJson());
    Map<String, dynamic> newInvestmentData = {
      'watchlist': newWatchListData,
    };
    investmentRef.doc("test").set(newInvestmentData, SetOptions(merge: true));
  }

  Future<void> deleteFromWatchList(WatchListModel watchListItem) async {
    investmentRef.doc("test").update({
      'watchlist': FieldValue.arrayRemove([watchListItem.toJson()])
    });
  }

  Future<void> updateWatchListItem(WatchListModel prevWatchListItem,
      WatchListModel updatedWatchListItem) async {
    investmentRef.doc("test").update({
      'watchlist': FieldValue.arrayRemove([prevWatchListItem.toJson()])
    });
    investmentRef.doc("test").update({
      'watchlist': FieldValue.arrayUnion([updatedWatchListItem.toJson()])
    });
  }
}
