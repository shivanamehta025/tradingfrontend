import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../utils/app_config.dart';

class TodaySalesScreen extends StatelessWidget {
  final List<dynamic> sales;

  const TodaySalesScreen({
    super.key,
    required this.sales,
  });

  String formatAmount(double value) {
    if (value >= 10000000) {
      return "${(value / 10000000).toStringAsFixed(1)} Cr";
    }

    if (value >= 100000) {
      return "${(value / 100000).toStringAsFixed(1)} L";
    }

    return value.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    double totalAmount = 0;
    double totalQty = 0;

    for (final item in sales) {
      totalAmount +=
          double.tryParse(item["Amount"].toString()) ?? 0;

      totalQty +=
          double.tryParse(item["QTY"].toString()) ?? 0;
    }

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),

      appBar: AppBar(
        title: const Text("Today's Sales"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: sales.isEmpty
          ? const Center(
              child: Text(
                "No Sales Today",
                style: TextStyle(fontSize: 18),
              ),
            )
          : Column(
              children: [

                //==================== SUMMARY ====================

                Container(
                  margin: const EdgeInsets.all(15),
                  child: Column(
                    children: [

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xff2563EB),
                              Color(0xff1D4ED8),
                            ],
                          ),
                          borderRadius:
                              BorderRadius.circular(22),
                        ),
                        child: Column(
                          children: [

                            const Text(
                              "Today's Total Sales",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text(
                              "₹ ${formatAmount(totalAmount)}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 15),

                      Row(
                        children: [

                          Expanded(
                            child: Container(
                              padding:
                                  const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                borderRadius:
                                    BorderRadius.circular(18),
                              ),
                              child: Column(
                                children: [

                                  const Icon(
                                    Icons.scale,
                                    color: Colors.orange,
                                    size: 32,
                                  ),

                                  const SizedBox(height: 10),

                                  Text(
                                    totalQty.toStringAsFixed(2),
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 5),

                                  const Text("Total Qty"),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Container(
                              padding:
                                  const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius:
                                    BorderRadius.circular(18),
                              ),
                              child: Column(
                                children: [

                                  const Icon(
                                    Icons.receipt_long,
                                    color: Colors.green,
                                    size: 32,
                                  ),

                                  const SizedBox(height: 10),

                                  Text(
                                    sales.length.toString(),
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 5),

                                  const Text("Invoices"),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Today's Invoice List",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                //==================== LIST ====================

                Expanded(
                  child: ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    itemCount: sales.length,
                    itemBuilder: (context, index) {

                      final item = sales[index];

                      final amount =
                          double.tryParse(
                                  item["Amount"]
                                      .toString()) ??
                              0;

                      return Card(
                        elevation: 4,
                        margin:
                            const EdgeInsets.only(
                                bottom: 15),
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(18),
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [

                              Row(
                                children: [

                                  const Icon(
                                    Icons.receipt,
                                    color: Colors.blue,
                                  ),

                                  const SizedBox(width: 8),

                                  Expanded(
                                    child: Text(
                                      item["Invoice No."]
                                              ?.toString() ??
                                          "",
                                      style:
                                          const TextStyle(
                                        fontSize: 17,
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                                  ),

                                  Text(
                                    "₹ ${formatAmount(amount)}",
                                    style:
                                        const TextStyle(
                                      color: Colors.green,
                                      fontSize: 18,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),

                              const Divider(height: 25),

                              Row(
                                children: [

                                  const Icon(
                                    Icons.person,
                                    size: 20,
                                    color: Colors.grey,
                                  ),

                                  const SizedBox(width: 8),

                                  Expanded(
                                    child: Text(
                                      item["Customer Name"]
                                              ?.toString() ??
                                          "",
                                      style:
                                          const TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 10),

                              Row(
                                children: [

                                  const Icon(
                                    Icons.inventory_2,
                                    size: 20,
                                    color: Colors.orange,
                                  ),

                                  const SizedBox(width: 8),

                                  Expanded(
                                    child: Text(
                                      item["Product"]
                                              ?.toString() ??
                                          "",
                                      style:
                                          const TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 10),

                              Row(
                                children: [

                                  const Icon(
                                    Icons.scale,
                                    size: 20,
                                    color:
                                        Colors.deepPurple,
                                  ),

                                  const SizedBox(width: 8),

                                  Text(
                                    "Qty : ${item["QTY"]}",
                                    style:
                                        const TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}