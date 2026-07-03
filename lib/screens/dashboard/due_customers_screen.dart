import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../utils/app_config.dart';

class DueCustomersScreen extends StatefulWidget {

  final List<dynamic> customers;

  final List<dynamic> topDueCustomersByDueDays;

  const DueCustomersScreen({

    super.key,

    required this.customers,

    required this.topDueCustomersByDueDays,
  });

  @override
  State<DueCustomersScreen> createState() =>
      _DueCustomersScreenState();
}

class _DueCustomersScreenState
    extends State<DueCustomersScreen> {

  late List<dynamic> customers;

  String selectedFilter = "Amount";

  @override
  void initState() {

    super.initState();

    customers = widget.customers;
  }

  String formatAmount(double value) {
    if (value >= 10000000) {
      return "${(value / 10000000).toStringAsFixed(2)} Cr";
    }

    if (value >= 100000) {
      return "${(value / 100000).toStringAsFixed(2)} L";
    }

    return value.toStringAsFixed(2);
  }

  String formatDate(dynamic date) {
    if (date == null) return "";

    try {
      return date.toString().substring(0, 10);
    } catch (e) {
      return date.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),

      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Top 10 Due Customers",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Column(

  children: [

    Padding(

      padding: const EdgeInsets.all(12),

      child: Row(

        children: [

          Expanded(
            child: ChoiceChip(

              label: const Text(
                "Highest Amount",
              ),

              selected:
                  selectedFilter == "Amount",

              onSelected: (_) {

                setState(() {

                  selectedFilter = "Amount";

                  customers = widget.customers;
                });
              },
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: ChoiceChip(

              label: const Text(
                "Highest Due Days",
              ),

              selected:
                  selectedFilter == "Days",

              onSelected: (_) {

                setState(() {

                  selectedFilter = "Days";

                  customers = widget
                      .topDueCustomersByDueDays;
                });
              },
            ),
          ),
        ],
      ),
    ),

    Expanded(

      child: customers.isEmpty
          ? const Center(
              child: Text(
                "No Due Customers Found",
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: customers.length,
              itemBuilder: (context, index) {
                final customer = customers[index];

               final due = double.tryParse(
    customer["TotalDueAmount"].toString()) ??
    0;

final pending =
    customer["PendingInvoices"] ?? 0;

final dueDays =
    customer["DueDays"] ?? 0;

                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () {
                      // TODO :
                      // Open Due Details Screen
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [

                          CircleAvatar(
                            radius: 24,
                            backgroundColor:
                                Colors.red.shade100,
                            child: Text(
                              "${index + 1}",
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(width: 15),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [

                                Text(
                                  customer["CustomerName"] ?? "",
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 12),

                            Row(
  children: [

    const Icon(
      Icons.receipt_long,
      size: 18,
      color: Colors.grey,
    ),

    const SizedBox(width: 5),

    Text(
      "$pending Pending Invoice(s)",
      style: const TextStyle(
        fontWeight: FontWeight.w500,
      ),
    ),
  ],
),

                                const SizedBox(height: 8),

                                Row(
                                  children: [

                                    const Icon(
                                      Icons.calendar_today,
                                      size: 18,
                                      color: Colors.grey,
                                    ),

                                    const SizedBox(width: 5),

                                    Text(
  "Oldest Due : ${formatDate(customer["OldestDueDate"])}",
),
                                  ],
                                ),
                              ],
                            ),
                          ),

                      Column(
  crossAxisAlignment: CrossAxisAlignment.end,
  children: [

    Container(

      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),

      decoration: BoxDecoration(

        color: dueDays >= 180
            ? Colors.red.shade100
            : dueDays >= 90
                ? Colors.orange.shade100
                : dueDays >= 30
                    ? Colors.amber.shade100
                    : Colors.green.shade100,

        borderRadius:
            BorderRadius.circular(12),
      ),

      child: Column(

        children: [

          Text(

            "$dueDays",

            style: TextStyle(

              fontSize: 22,

              fontWeight: FontWeight.bold,

              color: dueDays >= 180
                  ? Colors.red
                  : dueDays >= 90
                      ? Colors.orange
                      : dueDays >= 30
                          ? Colors.amber.shade800
                          : Colors.green,
            ),
          ),

          const Text(
            "Days",
            style: TextStyle(fontSize: 11),
          ),
        ],
      ),
    ),

    const SizedBox(height: 8),

    Container(

      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),

      decoration: BoxDecoration(

        color: dueDays >= 180
            ? Colors.red
            : dueDays >= 90
                ? Colors.orange
                : dueDays >= 30
                    ? Colors.amber
                    : Colors.green,

        borderRadius:
            BorderRadius.circular(20),
      ),

      child: Text(

        dueDays >= 180
            ? "CRITICAL"
            : dueDays >= 90
                ? "HIGH"
                : dueDays >= 30
                    ? "MEDIUM"
                    : "RECENT",

        style: const TextStyle(

          color: Colors.white,

          fontSize: 11,

          fontWeight: FontWeight.bold,
        ),
      ),
    ),

    const SizedBox(height: 10),

    const Text(
      "Total Due",
      style: TextStyle(
        color: Colors.grey,
        fontSize: 12,
      ),
    ),

    Text(

      "₹ ${formatAmount(due)}",

      style: const TextStyle(

        color: Colors.red,

        fontSize: 18,

        fontWeight: FontWeight.bold,
      ),
    ),
  ],
),
                        ],
                      ),
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