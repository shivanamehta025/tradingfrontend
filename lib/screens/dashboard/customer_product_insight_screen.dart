import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../utils/app_config.dart';
import 'customer_product_trend_screen.dart';

class CustomerProductInsightScreen extends StatefulWidget {
  final String customerId;
  final String productId;
  final String productName;
  final int bestMonthYear;
  final int bestMonthNo;

  const CustomerProductInsightScreen({
    super.key,
    required this.customerId,
    required this.productId,
    required this.productName,
    required this.bestMonthYear,
    required this.bestMonthNo,
  });

  @override
  State<CustomerProductInsightScreen> createState() =>
      _CustomerProductInsightScreenState();
}

class _CustomerProductInsightScreenState
    extends State<CustomerProductInsightScreen> {
  bool loading = true;

  Map<String, dynamic>? data;
  List<dynamic> productList = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final result = await ApiService.getProductCustomerInsight(
        databaseName: AppConfig.databaseName,
        userId: AppConfig.userId,
        customerId: widget.customerId,
        productId: widget.productId,
        bestMonthYear: widget.bestMonthYear,
        bestMonthNo: widget.bestMonthNo,
      );
    print(result);

setState(() {
  data = result[0][0];
  productList = result[1];
  loading = false;
      });
    } catch (e, stackTrace) {
  print("========== ERROR ==========");
  print(e);
  print(stackTrace);

  loading = false;
  setState(() {});
    }
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
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (data == null) {
      return const Scaffold(
        body: Center(child: Text("No Data Found")),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: const Text("Customer Product Insight"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            /// CUSTOMER CARD

            Container(
              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.green.shade600,
                    Colors.green.shade400,
                  ],
                ),
                borderRadius: BorderRadius.circular(18),
              ),

              child: Row(
                children: [

                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.inventory_2,
                      color: Colors.green.shade700,
                    ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [

                        Text(
                          data!["CustomerName"],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          data!["ProductName"],
                          style: const TextStyle(
                            color: Colors.white70,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius:
                                BorderRadius.circular(20),
                          ),
                          child: Text(
                            data!["Priority"],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            /// KPI GRID

            Row(
              children: [

                Expanded(
                  child: _buildKpiCard(
                    Icons.emoji_events,
                    "Best Month",
                    "${data!["BestMonthQty"]} MT",
                    Colors.orange,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _buildKpiCard(
                    Icons.calendar_month,
                    "Current",
                    "${data!["CurrentMonthQty"]} MT",
                    Colors.blue,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [

                Expanded(
                  child: _buildKpiCard(
                    Icons.trending_down,
                    "Gap Qty",
                    "${data!["GapQty"]} MT",
                    Colors.red,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _buildKpiCard(
                    Icons.schedule,
                    "Last Purchase",
                    "${data!["LastPurchaseDays"]} Days",
                    Colors.green,
                  ),
                ),
              ],
            ),

              const SizedBox(height: 12),

            Row(
              children: [

                Expanded(
                  child: _buildKpiCard(
                   Icons.bar_chart,
                    "Last Year Avg Monthly Qty",
                    "${data!["LastFYMonthlyAverageQty"]} MT",
                    Colors.red,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _buildKpiCard(
                     Icons.percent,
                    "Achievement",
                    "${data!["AchievementPercent"]}",
                    Colors.green,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// LAST INVOICE CARD

            Container(
              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.08),
                    blurRadius: 8,
                  )
                ],
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  const Row(
                    children: [

                      Icon(Icons.receipt_long,
                          color: Colors.green),

                      SizedBox(width: 8),

                      Text(
                        "Last Invoice",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  _buildInfoRow(
                    "Invoice No",
                    data!["InvoiceNo"],
                  ),

                  _buildInfoRow(
                    "Purchase Date",
                    data!["LastPurchaseDate"]
                        .toString()
                        .substring(0, 10),
                  ),

                  _buildInfoRow(
                    "Qty",
                    "${data!["LastInvoiceQty"]} MT",
                  ),

                  _buildInfoRow(
                    "Amount",
                    amount(double.parse(
                        data!["LastInvoiceAmount"]
                            .toString())),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),
                        /// OUTSTANDING CARD

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.08),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Row(
                    children: [

                      Icon(
                        Icons.account_balance_wallet,
                        color: Colors.orange,
                      ),

                      SizedBox(width: 8),

                      Text(
                        "Outstanding Details",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                    ],
                  ),

                  const SizedBox(height: 18),

                  _buildInfoRow(
                    "Outstanding",
                    amount(double.parse(
                        data!["Outstanding"].toString())),
                  ),

                  _buildInfoRow(
                    "Pending Bills",
                    data!["PendingBills"].toString(),
                  ),

                  _buildInfoRow(
                    "Oldest Due",
                    "${data!["OldestDueDays"]} Days",
                  ),

                ],
              ),
            ),

            const SizedBox(height: 18),

            _buildProductListCard(),

            const SizedBox(height: 18),

            /// STATUS

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.08),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  const Text(
                    "Current Status",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Row(
                    children: [

                      const Text(
                        "Purchase Status",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const Spacer(),

                      _buildStatusChip(
                        data!["PurchaseStatus"],
                      ),

                    ],
                  ),

                  const SizedBox(height: 15),

                  Row(
                    children: [

                      const Text(
                        "Priority",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const Spacer(),

                      _buildStatusChip(
                        data!["Priority"],
                      ),

                    ],
                  ),

                ],
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                ),

                onPressed: () {

                  Navigator.push(

                    context,

                    MaterialPageRoute(

                      builder: (_) =>
                          CustomerProductTrendScreen(

                        customerId: widget.customerId,

                        productId: widget.productId,

                        productName: widget.productName,

                      ),

                    ),

                  );

                },

                icon: const Icon(Icons.show_chart),

                label: const Text(
                  "View Monthly Trend",
                ),

              ),
            ),

            const SizedBox(height: 30),

          ],
        ),
      ),
    );
  }

  Widget _buildKpiCard(
      IconData icon,
      String title,
      String value,
      Color color) {

    return Container(

      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius: BorderRadius.circular(16),

        boxShadow: [

          BoxShadow(

            color: Colors.black.withOpacity(.08),

            blurRadius: 8,

          )

        ],

      ),

      child: Column(

        children: [

          CircleAvatar(

            backgroundColor: color.withOpacity(.15),

            child: Icon(
              icon,
              color: color,
            ),

          ),

          const SizedBox(height: 10),

          Text(

            title,

            style: const TextStyle(
              color: Colors.grey,
            ),

          ),

          const SizedBox(height: 6),

          Text(

            value,

            textAlign: TextAlign.center,

            style: const TextStyle(

              fontWeight: FontWeight.bold,

              fontSize: 17,

            ),

          ),

        ],

      ),

    );

  }

  Widget _buildInfoRow(
      String title,
      String value) {

    return Padding(

      padding:
          const EdgeInsets.symmetric(vertical: 8),

      child: Row(

        children: [

          Expanded(

            child: Text(

              title,

              style: const TextStyle(
                color: Colors.grey,
              ),

            ),

          ),

          Text(

            value,

            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),

          ),

        ],

      ),

    );

  }

  Widget _buildStatusChip(String text) {

    Color color = Colors.green;

    if (text == "Not Purchased") {

      color = Colors.red;

    } else if (text == "Partial") {

      color = Colors.orange;

    } else if (text == "Collect Payment") {

      color = Colors.deepOrange;

    } else if (text == "High Opportunity") {

      color = Colors.blue;

    } else if (text == "Immediate Follow-up") {

      color = Colors.red;

    }

    return Container(

      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),

      decoration: BoxDecoration(

        color: color.withOpacity(.15),

        borderRadius: BorderRadius.circular(20),

      ),

      child: Text(

        text,

        style: TextStyle(

          color: color,

          fontWeight: FontWeight.bold,

        ),

      ),

    );

  }
Widget _buildProductListCard() {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.08),
          blurRadius: 8,
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const Row(
          children: [

            Icon(
              Icons.shopping_bag,
              color: Colors.green,
            ),

            SizedBox(width: 8),

            Text(
              "Products Purchased",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(height: 15),

        ...productList.map((item) {

          final bool isCurrent =
              item["ProductName"] == data!["ProductName"];

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),

            decoration: BoxDecoration(
              color: isCurrent
                  ? Colors.green.shade50
                  : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isCurrent
                    ? Colors.green
                    : Colors.grey.shade300,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.05),
                  blurRadius: 5,
                ),
              ],
            ),

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                CircleAvatar(
                  radius: 20,
                  backgroundColor: isCurrent
                      ? Colors.green.shade100
                      : Colors.blue.shade50,
                  child: Icon(
                    Icons.inventory_2,
                    color: isCurrent
                        ? Colors.green
                        : Colors.blue,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      Text(
                        item["ProductName"],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: isCurrent
                              ? Colors.green.shade800
                              : Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [

                          const Icon(
                            Icons.scale,
                            size: 14,
                            color: Colors.grey,
                          ),

                          const SizedBox(width: 4),

                          Text(
                            "${item["Qty"]} MT",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const Spacer(),

                          Text(
                            amount(
                              double.parse(
                                item["Amount"].toString(),
                              ),
                            ),
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [

                          const Icon(
                            Icons.schedule,
                            size: 14,
                            color: Colors.orange,
                          ),

                          const SizedBox(width: 4),

                          Text(
                            "${item["LastPurchaseDays"]} Days Ago",
                            style: const TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),

                          const Spacer(),

                          if (isCurrent)
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius:
                                    BorderRadius.circular(20),
                              ),
                              child: const Text(
                                "Current",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    ),
  );
}

}