import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../../utils/app_config.dart';
import 'customer_product_insight_screen.dart';

class ProductCustomerAnalysisScreen extends StatefulWidget {
  final String productId;
  final String productName;

  const ProductCustomerAnalysisScreen({
    super.key,
    required this.productId,
    required this.productName,
  });

  @override
  State<ProductCustomerAnalysisScreen> createState() =>
      _ProductCustomerAnalysisScreenState();
}

class _ProductCustomerAnalysisScreenState
    extends State<ProductCustomerAnalysisScreen> {

  bool loading = true;

  List<dynamic> customers = [];
  List<dynamic> filteredCustomers = [];

  String selectedStatus = "ALL";

  final TextEditingController searchController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    loadCustomers();
  }

  Future<void> loadCustomers() async {

    try {

      final data =
          await ApiService.getProductCustomerAnalysis(
        databaseName: AppConfig.databaseName,
        userId: AppConfig.userId,
        productId: widget.productId,
      );

      customers = data;
      filteredCustomers = data;

    } catch (e) {

      debugPrint(e.toString());

    }

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  double number(dynamic value) {
    return double.tryParse(value.toString()) ?? 0;
  }

  String amount(double value) {

    if (value >= 10000000) {
      return "₹ ${(value / 10000000).toStringAsFixed(2)} Cr";
    }

    if (value >= 100000) {
      return "₹ ${(value / 100000).toStringAsFixed(2)} L";
    }

    if (value >= 1000) {
      return "₹ ${(value / 1000).toStringAsFixed(1)} K";
    }

    return "₹ ${value.toStringAsFixed(0)}";
  }

  void filterData() {

    final search =
        searchController.text.toLowerCase();

    filteredCustomers = customers.where((c) {

      final customer =
          c["CustomerName"]
              .toString()
              .toLowerCase();

      final status =
          c["Status"]
              .toString()
              .toUpperCase();

      bool matchSearch =
          customer.contains(search);

      bool matchStatus =
          selectedStatus == "ALL"
              ? true
              : status == selectedStatus;

      return matchSearch && matchStatus;

    }).toList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    final previousQty = customers.fold<double>(
      0,
      (a, b) => a + number(b["PreviousQty"]),
    );

    final currentQty = customers.fold<double>(
      0,
      (a, b) => a + number(b["CurrentQty"]),
    );

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

          : Column(

              children: [

                Container(

                  margin: const EdgeInsets.all(15),

                  padding: const EdgeInsets.all(15),

                  decoration: BoxDecoration(

                    color: Colors.white,

                    borderRadius:
                        BorderRadius.circular(16),

                  ),

                  child: Column(

                    children: [

                      Row(

                        children: [

                          Expanded(

                            child: _summaryCard(

                              "Customers",

                              customers.length.toString(),

                              Icons.people,

                              Colors.blue,

                            ),

                          ),

                          const SizedBox(width: 10),

                          Expanded(

                            child: _summaryCard(

                              "Previous",

                              "${previousQty.toStringAsFixed(2)} MT",

                              Icons.history,

                              Colors.grey,

                            ),

                          ),

                          const SizedBox(width: 10),

                          Expanded(

                            child: _summaryCard(

                              "Current",

                              "${currentQty.toStringAsFixed(2)} MT",

                              Icons.calendar_today,

                              Colors.green,

                            ),

                          ),

                        ],

                      ),

                      const SizedBox(height: 15),

                      

                    ],

                  ),

                ),

                Expanded(

                  child: ListView.builder(

                    itemCount:
                        filteredCustomers.length,

                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 15,
                    ),

                    itemBuilder:
                        (context, index) {

                      final c =
                          filteredCustomers[index];

                      return _customerCard(c);

                    },

                  ),

                ),

              ],

            ),

    );

  }
    Widget _customerCard(dynamic c) {

    final previousQty = number(c["PreviousQty"]);
    final currentQty = number(c["CurrentQty"]);

    final previousAmount = number(c["PreviousAmount"]);
    final currentAmount = number(c["CurrentAmount"]);

    double growth = 0;

    if (previousQty > 0) {
      growth =
          ((currentQty - previousQty) / previousQty) *
              100;
    } else if (currentQty > 0) {
      growth = 100;
    }

    final status =
        c["Status"].toString().toUpperCase();

    Color statusColor = Colors.grey;

    switch (status) {

      case "GROWING":
        statusColor = Colors.green;
        break;

      case "DECLINING":
        statusColor = Colors.orange;
        break;

      case "LOST":
        statusColor = Colors.red;
        break;

      case "STABLE":
        statusColor = Colors.blue;
        break;
    }

    return Card(

      margin: const EdgeInsets.only(bottom: 12),

      elevation: 2,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),

      child: InkWell(

        borderRadius: BorderRadius.circular(16),

        onTap: () {

          Navigator.push(

            context,

            MaterialPageRoute(

              builder: (_) =>
                  CustomerProductInsightScreen(

                customerId:
                    c["CustomerId"].toString(),

                productId: widget.productId,

                productName: widget.productName,

                bestMonthYear: DateTime.now().year,

                bestMonthNo: DateTime.now().month,

              ),

            ),

          );

        },

        child: Padding(

          padding: const EdgeInsets.all(15),

          child: Column(

            children: [

              Row(

                children: [

                  CircleAvatar(

                    radius: 22,

                    backgroundColor:
                        statusColor.withOpacity(.15),

                    child: Icon(
                      Icons.person,
                      color: statusColor,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(

                    child: Column(

                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        Text(

                          c["CustomerName"],

                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),

                        ),

                        const SizedBox(height: 5),

                        Text(

                          "Previous Invoice : ${c["PreviousInvoices"]}   Current Invoice : ${c["CurrentInvoices"]}",

                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 11,
                          ),

                        ),

                      ],

                    ),

                  ),

                ],

              ),

              const SizedBox(height: 15),

              Row(

                children: [

                  Expanded(
                    child: _valueBox(
                      "Previous",
                      "${previousQty.toStringAsFixed(2)} MT",
                      Colors.grey,
                    ),
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: _valueBox(
                      "Current",
                      "${currentQty.toStringAsFixed(2)} MT",
                      Colors.green,
                    ),
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: _valueBox(
                      "Growth",
                      "${growth.toStringAsFixed(1)}%",
                      growth >= 0
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),

                ],

              ),

              const SizedBox(height: 15),

              Row(

                children: [

                  Expanded(

                    child: Text(
                      "Previous Amount",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),

                  ),

                  Text(

                    amount(previousAmount),

                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),

                  ),

                ],

              ),

              const SizedBox(height: 8),

              Row(

                children: [

                  Expanded(

                    child: Text(
                      "Current Amount",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),

                  ),

                  Text(

                    amount(currentAmount),

                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),

                  ),

                ],

              ),

              const SizedBox(height: 15),

              const Divider(),

              Row(

                children: [

                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.green,
                  ),

                  const SizedBox(width: 6),

                  const Text(

                    "Tap to view customer insight",

                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),

                  ),

                ],

              ),

            ],

          ),

        ),

      ),

    );

  }

  Widget _summaryCard(
      String title,
      String value,
      IconData icon,
      Color color) {

    return Container(

      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(

        color: color.withOpacity(.10),

        borderRadius: BorderRadius.circular(12),

      ),

      child: Column(

        children: [

          Icon(icon, color: color),

          const SizedBox(height: 6),

          Text(
            title,
            style: const TextStyle(fontSize: 11),
          ),

          const SizedBox(height: 4),

          Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),

        ],

      ),

    );

  }

  Widget _filterChip(String text) {

    final selected =
        selectedStatus == text;

    return Padding(

      padding:
          const EdgeInsets.only(right: 8),

      child: ChoiceChip(

        label: Text(text),

        selected: selected,

        onSelected: (v) {

          selectedStatus = text;

          filterData();

        },

      ),

    );

  }

  Widget _valueBox(
      String title,
      String value,
      Color color) {

    return Container(

      padding: const EdgeInsets.all(10),

      decoration: BoxDecoration(

        color: color.withOpacity(.08),

        borderRadius:
            BorderRadius.circular(10),

      ),

      child: Column(

        children: [

          Text(
            title,
            style: const TextStyle(fontSize: 11),
          ),

          const SizedBox(height: 5),

          Text(

            value,

            style: TextStyle(

              color: color,

              fontWeight: FontWeight.bold,

            ),

          ),

        ],

      ),

    );

  }

}