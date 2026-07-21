import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../utils/app_config.dart';

class CustomerProductTrendScreen extends StatefulWidget {
  final String customerId;
  final String productId;
  final String productName;

  const CustomerProductTrendScreen({
    super.key,
    required this.customerId,
    required this.productId,
    required this.productName,
  });

  @override
  State<CustomerProductTrendScreen> createState() =>
      _CustomerProductTrendScreenState();
}

class _CustomerProductTrendScreenState
    extends State<CustomerProductTrendScreen> {

  bool loading = true;

  List<dynamic> trend = [];

  @override
  void initState() {
    super.initState();
    loadTrend();
  }

  Future<void> loadTrend() async {

    try {

      trend = await ApiService.getCustomerProductTrend(
        databaseName: AppConfig.databaseName,
        userId: AppConfig.userId,
        customerId: widget.customerId,
        productId: widget.productId,
      );

    } catch (e) {

      debugPrint(e.toString());

    }

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  double _number(dynamic value) {
    return double.tryParse(value.toString()) ?? 0;
  }

  String amount(double value) {

    if (value >= 10000000) {
      return "₹ ${(value / 10000000).toStringAsFixed(2)} Cr";
    }

    if (value >= 100000) {
      return "₹ ${(value / 100000).toStringAsFixed(2)} L";
    }

    return "₹ ${value.toStringAsFixed(0)}";
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xffF5F7FA),

      appBar: AppBar(
        title: Text(widget.productName),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),

      body: loading

          ? const Center(
              child: CircularProgressIndicator(),
            )

          : trend.isEmpty

              ? const Center(
                  child: Text("No Monthly Trend Found"),
                )

              : SingleChildScrollView(

                  padding: const EdgeInsets.all(16),

                  child: Column(

                    children: [

                      /// CHART

                      Container(

                        height: 280,

                        padding: const EdgeInsets.all(15),

                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                        ),

                        child: LineChart(

                          LineChartData(

                            borderData: FlBorderData(show: false),

                            gridData: const FlGridData(show: true),

                            titlesData: FlTitlesData(

                              topTitles: const AxisTitles(),

                              rightTitles: const AxisTitles(),

                              leftTitles: AxisTitles(

                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                ),

                              ),

                              bottomTitles: AxisTitles(

                                sideTitles: SideTitles(

                                  showTitles: true,

                                  getTitlesWidget: (value, meta) {

                                    if (value.toInt() >= trend.length) {
                                      return const SizedBox();
                                    }

                                    return Text(
                                      trend[value.toInt()]["MonthName"],
                                      style: const TextStyle(fontSize: 10),
                                    );

                                  },

                                ),

                              ),

                            ),

                            lineBarsData: [

                              LineChartBarData(

                                isCurved: true,

                                spots: List.generate(

                                  trend.length,

                                  (index) => FlSpot(

                                    index.toDouble(),

                                    _number(
                                      trend[index]["Qty"],
                                    ),

                                  ),

                                ),

                              ),

                            ],

                          ),

                        ),

                      ),

                      const SizedBox(height: 20),

                      ListView.builder(

                        shrinkWrap: true,

                        physics:
                            const NeverScrollableScrollPhysics(),

                        itemCount: trend.length,

                        itemBuilder: (context, index) {

                          final row = trend[index];

                          final qty =
                              _number(row["Qty"]);

                          final amt =
                              _number(row["Amount"]);

                          final purchased =
                              row["PurchaseStatus"]
                                      .toString() ==
                                  "Purchased";

                          return Card(

                            margin:
                                const EdgeInsets.only(
                              bottom: 10,
                            ),

                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(14),
                            ),

                            child: ListTile(

                              leading: CircleAvatar(

                                backgroundColor: purchased
                                    ? Colors.green.shade100
                                    : Colors.red.shade100,

                                child: Icon(

                                  purchased
                                      ? Icons.check
                                      : Icons.close,

                                  color: purchased
                                      ? Colors.green
                                      : Colors.red,

                                ),

                              ),

                              title: Text(
                                row["MonthName"],
                              ),

                              subtitle: Column(

                                crossAxisAlignment:
                                    CrossAxisAlignment.start,

                                children: [

                                  Text(
                                      "Qty : ${qty.toStringAsFixed(2)} MT"),

                                  Text(
                                      "Amount : ${amount(amt)}"),

                                ],

                              ),

                              trailing: Container(

                                padding:
                                    const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),

                                decoration: BoxDecoration(

                                  color: purchased
                                      ? Colors.green.shade50
                                      : Colors.red.shade50,

                                  borderRadius:
                                      BorderRadius.circular(20),

                                ),

                                child: Text(

                                  row["PurchaseStatus"],

                                  style: TextStyle(

                                    color: purchased
                                        ? Colors.green
                                        : Colors.red,

                                    fontWeight:
                                        FontWeight.bold,

                                  ),

                                ),

                              ),

                            ),

                          );

                        },

                      ),

                    ],

                  ),

                ),

    );

  }

}