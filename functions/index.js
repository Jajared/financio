const { Timestamp } = require("firebase-admin/firestore");
const admin = require("firebase-admin");
const { debug, error } = require("firebase-functions/logger");

const { onSchedule } = require("firebase-functions/v2/scheduler");
admin.initializeApp();

const firestore = admin.firestore();

exports.updateDailyGraphData = onSchedule("00 16 * * *", async () => {
  function updateGraphData(currentGraphData) {
    var temp = [...currentGraphData];
    var lastValue = currentGraphData[currentGraphData.length - 1].value ? currentGraphData[currentGraphData.length - 1].value : 0;
    temp.push({ date: Timestamp.now(), value: lastValue });
    return temp;
  }

  try {
    firestore
      .collection("Investments")
      .get()
      .then((snapshot) => {
        snapshot.forEach((doc) => {
          const summary = doc.data().summary;
          const currentGraphData = summary.graphData;
          const updatedSummaryData = { ...summary, graphData: updateGraphData(currentGraphData) };
          doc.ref.update({ summary: updatedSummaryData });
        });
      });
    return null;
  } catch (e) {
    error(e);
    return null;
  }
});
