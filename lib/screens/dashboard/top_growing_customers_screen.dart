import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../utils/app_config.dart';

class TopGrowingCustomersScreen extends StatefulWidget {
  const TopGrowingCustomersScreen({super.key});

  @override
  State<TopGrowingCustomersScreen> createState() =>
      _TopGrowingCustomersScreenState();
}

class _TopGrowingCustomersScreenState
    extends State<TopGrowingCustomersScreen> {

  bool loading = true;
  List<dynamic> customers = [];
  Map<String, List<dynamic>> customerProducts = {};

  Map<String, bool> loadingProducts = {};
  Map<String, bool> expandedCustomers = {};

  @override
  void initState() {
    super.initState();
    loadCustomers();
  }

  Future<void> loadCustomers() async {
    try {

      final data = await ApiService.getTopGrowingCustomers(
        databaseName: AppConfig.databaseName,
        userId: AppConfig.userId,
      );

      setState(() {
        customers = data;
        loading = false;
      });

    } catch (e) {

      debugPrint(e.toString());

      setState(() {
        loading = false;
      });

    }
  }

  Future<void> loadCustomerProducts(String customerId) async {

  if (customerProducts.containsKey(customerId)) {
    return;
  }

  setState(() {
    loadingProducts[customerId] = true;
  });

  try {

    final products =
        await ApiService.getTopGrowingCustomerProducts(

      databaseName: AppConfig.databaseName,

      userId: AppConfig.userId,

      customerId: customerId,

    );

    setState(() {

      customerProducts[customerId] = products;

      loadingProducts[customerId] = false;

    });

  } catch (e) {

    setState(() {

      loadingProducts[customerId] = false;

    });

  }

}

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

    return Scaffold(

      backgroundColor: const Color(0xffF5F7FA),

      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: const Text("Top Growing Customers"),
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : customers.isEmpty
              ? const Center(child: Text("No Data Found"))
              : ListView.separated(

                  padding: const EdgeInsets.all(16),

                  itemCount: customers.length,

                  separatorBuilder: (_, __) =>
                      const SizedBox(height: 12),

                  itemBuilder: (context, index) {

                    final item = customers[index];

                    return Container(

                      padding: const EdgeInsets.all(16),

                      decoration: BoxDecoration(

                        color: Colors.white,

                        borderRadius: BorderRadius.circular(18),

                        boxShadow: [

                          BoxShadow(

                            color: Colors.black.withOpacity(.08),

                            blurRadius: 8,

                            offset: const Offset(0,3),

                          )

                        ],

                      ),

                      child: Column(

                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [

                          Row(

                            children: [

                              Container(

                                width: 46,
                                height: 46,

                                decoration: BoxDecoration(

                                  color: Colors.green.shade50,

                                  borderRadius:
                                      BorderRadius.circular(12),

                                ),

                                child: const Icon(

                                  Icons.person,

                                  color: Colors.green,

                                ),

                              ),

                              const SizedBox(width: 12),

                              Expanded(

                                child: Text(

                                  item["CustomerName"],

                                  style: const TextStyle(

                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,

                                  ),

                                ),

                              ),

                              Container(

                                padding:
                                    const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),

                                decoration: BoxDecoration(

                                  color: Colors.green.shade50,

                                  borderRadius:
                                      BorderRadius.circular(20),

                                ),

                                child: Text(

                                  "+${item["GrowthQty"]} MT",

                                  style: const TextStyle(

                                    color: Colors.green,

                                    fontWeight: FontWeight.bold,

                                  ),

                                ),

                              )

                            ],

                          ),

                          const SizedBox(height: 15),

                          Row(

                            children: [

                              Expanded(
                                child: _infoBox(
                                  "Previous Qty",
                                  "${item["PreviousQty"]} MT",
                                ),
                              ),

                              const SizedBox(width: 10),

                              Expanded(
                                child: _infoBox(
                                  "Current Qty",
                                  "${item["CurrentQty"]} MT",
                                ),
                              ),

                            ],

                          ),

                          const SizedBox(height: 10),

                          Row(

                            children: [

                              Expanded(
                                child: _infoBox(
                                  "Growth",
                                  "${item["GrowthPercent"]}%",
                                ),
                              ),

                              const SizedBox(width: 10),

                              Expanded(
                                child: _infoBox(
                                  "Revenue",
                                  "₹ ${formatAmount(double.parse(item["GrowthAmount"].toString()))}",
                                ),
                              ),

                            ],

                          ),

                          const SizedBox(height: 10),

                          Row(

                            children: [

                              Expanded(
                                child: _infoBox(
                                  "Prev Amount",
                                  "₹ ${formatAmount(double.parse(item["PreviousAmount"].toString()))}",
                                ),
                              ),

                              const SizedBox(width: 10),

                              Expanded(
                                child: _infoBox(
                                  "Current Amount",
                                  "₹ ${formatAmount(double.parse(item["CurrentAmount"].toString()))}",
                                ),
                              ),

                            ],

                          ),

                          const SizedBox(height: 15),

                          Text(

                            "Contribution ${double.parse(item["ContributionPercent"].toString()).toStringAsFixed(1)}%",

                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),

                          ),

                          const SizedBox(height: 6),

                         ClipRRect(
  borderRadius: BorderRadius.circular(10),
  child: LinearProgressIndicator(
    minHeight: 8,
    value: double.parse(
          item["ContributionPercent"].toString(),
        ) /
        100,
    color: Colors.green,
    backgroundColor: Colors.grey.shade300,
  ),
),

const SizedBox(height: 12),

InkWell(
  borderRadius: BorderRadius.circular(10),
  onTap: () async {

    final customerId = item["CustomerId"].toString();

    if (expandedCustomers[customerId] != true &&
        !customerProducts.containsKey(customerId)) {

      await loadCustomerProducts(customerId);

    }

    setState(() {
      expandedCustomers[customerId] =
          !(expandedCustomers[customerId] ?? false);
    });

  },
  child: Container(
    padding: const EdgeInsets.symmetric(
      vertical: 12,
      horizontal: 10,
    ),
    decoration: BoxDecoration(
      color: Colors.green.shade50,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [

        const Icon(
          Icons.shopping_bag,
          color: Colors.green,
        ),

        const SizedBox(width: 8),

        Expanded(
          child: Text(
            expandedCustomers[item["CustomerId"].toString()] == true
                ? "Hide Purchased Products"
                : "View Purchased Products",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ),

        AnimatedRotation(
          turns: expandedCustomers[item["CustomerId"].toString()] == true
              ? .5
              : 0,
          duration: const Duration(milliseconds: 300),
          child: const Icon(
            Icons.keyboard_arrow_down,
            color: Colors.green,
          ),
        )

      ],
    ),
  ),
),

AnimatedSwitcher(
  duration: const Duration(milliseconds: 300),
  child: expandedCustomers[item["CustomerId"].toString()] == true
      ? _buildProducts(item["CustomerId"].toString())
      : const SizedBox(),
),

                        ],

                      ),

                    );

                  },

                ),

    );

  }

  Widget _infoBox(String title, String value) {

    return Container(

      padding: const EdgeInsets.all(10),

      decoration: BoxDecoration(

        color: const Color(0xffF7F8FC),

        borderRadius: BorderRadius.circular(12),

      ),

      child: Column(

        children: [

          Text(

            title,

            style: const TextStyle(

              color: Colors.grey,

              fontSize: 12,

            ),

          ),

          const SizedBox(height: 5),

          Text(

            value,

            style: const TextStyle(

              fontWeight: FontWeight.bold,

              fontSize: 15,

            ),

          ),

        ],

      ),

    );

  }

  Widget _buildProducts(String customerId) {

  if (loadingProducts[customerId] == true) {

    return const Padding(
      padding: EdgeInsets.all(20),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );

  }

  final products = customerProducts[customerId] ?? [];

  if (products.isEmpty) {

    return const Padding(
      padding: EdgeInsets.all(20),
      child: Center(
        child: Text("No Products Found"),
      ),
    );

  }

  return Padding(

    padding: const EdgeInsets.only(top: 12),

    child: Column(

      children: products.map((product) {

        return Container(

          margin: const EdgeInsets.only(bottom: 10),

          padding: const EdgeInsets.all(14),

          decoration: BoxDecoration(

            color: const Color(0xffF8FAFC),

            borderRadius: BorderRadius.circular(15),

            border: Border.all(
              color: Colors.green.shade100,
            ),

          ),

          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              Row(

                children: [

                  Container(

                    width: 42,
                    height: 42,

                    decoration: BoxDecoration(

                      color: Colors.green.shade50,

                      borderRadius:
                          BorderRadius.circular(10),

                    ),

                    child: const Icon(

                      Icons.inventory_2,

                      color: Colors.green,

                    ),

                  ),

                  const SizedBox(width: 10),

                  Expanded(

                    child: Text(

                      product["ProductName"],

                      style: const TextStyle(

                        fontWeight: FontWeight.bold,

                        fontSize: 15,

                      ),

                    ),

                  ),

                ],

              ),

              const SizedBox(height: 12),

              Row(

                children: [

                  Expanded(
                    child: _infoBox(
                      "Qty",
                      "${product["Qty"]} MT",
                    ),
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: _infoBox(
                      "Amount",
                      "₹ ${formatAmount(double.parse(product["Amount"].toString()))}",
                    ),
                  ),

                ],

              ),

              const SizedBox(height: 8),

              Row(

                children: [

                  Expanded(
                    child: _infoBox(
                      "Invoices",
                      product["InvoiceCount"].toString(),
                    ),
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: _infoBox(
                      "Share",
                      "${product["SharePercent"] ?? 0}%",
                    ),
                  ),

                ],

              ),

            ],

          ),

        );

      }).toList(),

    ),

  );

}

  

}