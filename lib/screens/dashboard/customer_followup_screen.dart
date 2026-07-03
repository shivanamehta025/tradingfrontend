import 'package:flutter/material.dart';

class CustomerFollowUpScreen extends StatelessWidget {
  final List<dynamic> customers;

  const CustomerFollowUpScreen({
    super.key,
    required this.customers,
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

  Color statusColor(double qtyPercent) {
    if (qtyPercent <= -50) {
      return Colors.red;
    } else if (qtyPercent <= -20) {
      return Colors.orange;
    }

    return Colors.green;
  }

  String statusText(double qtyPercent) {
    if (qtyPercent <= -50) {
      return "Critical";
    } else if (qtyPercent <= -20) {
      return "Moderate";
    }

    return "Normal";
  }

  @override
  Widget build(BuildContext context) {
    double totalQtyLoss = 0;
    double totalAmountLoss = 0;

    for (final item in customers) {
      totalQtyLoss +=
          double.tryParse(item["QtyDifference"].toString()) ??
              0;

      totalAmountLoss +=
          double.tryParse(
                  item["AmountDifference"].toString()) ??
              0;
    }

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),

      appBar: AppBar(
        title: const Text("Customer Follow-up"),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),

      body: customers.isEmpty
          ? const Center(
              child: Text(
                "No Customer Found",
                style: TextStyle(fontSize: 18),
              ),
            )
          : Column(
              children: [

                /// Summary
                Container(
                  margin: const EdgeInsets.all(15),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(18),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: Row(
                    children: [

                      Expanded(
                        child: Column(
                          children: [

                            const Text(
                              "Customers",
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              customers.length.toString(),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight:
                                    FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Expanded(
                        child: Column(
                          children: [

                            const Text(
                              "Qty Loss",
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              "${totalQtyLoss.toStringAsFixed(2)} MT",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight:
                                    FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Expanded(
                        child: Column(
                          children: [

                            const Text(
                              "Sales Loss",
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              "₹ ${formatAmount(totalAmountLoss)}",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight:
                                    FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(
                            horizontal: 15),
                    itemCount: customers.length,
                    itemBuilder: (context, index) {

                      final item = customers[index];

                      final qtyPercent =
                          double.tryParse(
                                  item["QtyGrowthPercent"]
                                      .toString()) ??
                              0;

                      final amountPercent =
                          double.tryParse(item[
                                      "AmountGrowthPercent"]
                                  .toString()) ??
                              0;

                      final color =
                          statusColor(qtyPercent);

                      return Card(
                        elevation: 3,
                        margin:
                            const EdgeInsets.only(
                                bottom: 15),
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                                  18),
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets.all(
                                  18),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [

                              Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [

    Expanded(

      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          /// Customer Name
          Text(

            item["CustomerName"],

            style: const TextStyle(

              fontSize: 18,

              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          /// Product Chip
          Container(

            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),

            decoration: BoxDecoration(

              color: Colors.blue.shade50,

              borderRadius:
                  BorderRadius.circular(20),

              border: Border.all(
                color: Colors.blue.shade200,
              ),
            ),

            child: Row(

              mainAxisSize: MainAxisSize.min,

              children: [

                const Icon(

                  Icons.inventory_2_outlined,

                  size: 16,

                  color: Colors.blue,
                ),

                const SizedBox(width: 6),

                Flexible(

                  child: Text(

                    item["ProductName"] ?? "",

                    overflow: TextOverflow.ellipsis,

                    style: const TextStyle(

                      color: Colors.blue,

                      fontWeight: FontWeight.w600,

                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),

    const SizedBox(width: 10),

    /// Status Chip
    Container(

      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),

      decoration: BoxDecoration(

        color: color.withOpacity(.15),

        borderRadius:
            BorderRadius.circular(20),
      ),

      child: Text(

        statusText(qtyPercent),

        style: TextStyle(

          color: color,

          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ],
),

                              const Divider(),

                              Row(
                                children: [

                                  Expanded(
                                    child: Text(
                                      "Last Month Qty : ${item["LastMonthQty"]} MT",
                                    ),
                                  ),

                                  Expanded(
                                    child: Text(
                                      "Current Month Qty : ${item["CurrentMonthQty"]} MT",
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(
                                  height: 8),

                              Row(
                                children: [

                                  Expanded(
                                    child: Text(
                                      "Qty Lost : ${qtyPercent.toStringAsFixed(2)}%",
                                      style:
                                          TextStyle(
                                        color: color,
                                        fontWeight:
                                            FontWeight
                                                .bold,
                                      ),
                                    ),
                                  ),

                                  Expanded(
                                    child: Text(
                                      "Amount : ${amountPercent.toStringAsFixed(2)}%",
                                      style:
                                          TextStyle(
                                        color:
                                            amountPercent <
                                                    0
                                                ? Colors
                                                    .red
                                                : Colors
                                                    .green,
                                        fontWeight:
                                            FontWeight
                                                .bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(
                                  height: 10),

                              Row(
                                children: [

                                  Expanded(
                                    child: Text(
                                      "Last Sales\n₹ ${formatAmount(double.parse(item["LastMonthAmount"].toString()))}",
                                    ),
                                  ),

                                  Expanded(
                                    child: Text(
                                      "Current Sales\n₹ ${formatAmount(double.parse(item["CurrentMonthAmount"].toString()))}",
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