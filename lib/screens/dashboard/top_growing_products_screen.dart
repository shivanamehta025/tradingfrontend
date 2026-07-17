import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../utils/app_config.dart';

class TopGrowingProductsScreen extends StatefulWidget {
  const TopGrowingProductsScreen({super.key});

  @override
  State<TopGrowingProductsScreen> createState() =>
      _TopGrowingProductsScreenState();
}

class _TopGrowingProductsScreenState
    extends State<TopGrowingProductsScreen> {

  bool loading = true;

  List<dynamic> products = [];

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {

      final data =
          await ApiService.getTopGrowingProducts(

        databaseName: AppConfig.databaseName,

        userId: AppConfig.userId,

      );

      setState(() {

        products = data;

        loading = false;

      });

    } catch (e) {

      debugPrint(e.toString());

      setState(() {

        loading = false;

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

        title: const Text(
          "Top Growing Products",
        ),
      ),

      body: loading

          ? const Center(
              child: CircularProgressIndicator(),
            )

          : products.isEmpty

              ? const Center(
                  child: Text(
                    "No Data Found",
                  ),
                )

              : ListView.separated(

                  padding: const EdgeInsets.all(16),

                  itemCount: products.length,

                  separatorBuilder: (_, __) =>
                      const SizedBox(height: 12),

                  itemBuilder: (context, index) {

                    final item = products[index];

                    return Container(

                      padding: const EdgeInsets.all(16),

                      decoration: BoxDecoration(

                        color: Colors.white,

                        borderRadius:
                            BorderRadius.circular(18),

                        boxShadow: [

                          BoxShadow(

                            color: Colors.black.withOpacity(.08),

                            blurRadius: 8,

                            offset: const Offset(0, 3),

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

                                width: 44,

                                height: 44,

                                decoration: BoxDecoration(

                                  color:
                                      Colors.green.shade50,

                                  borderRadius:
                                      BorderRadius.circular(12),

                                ),

                                child: const Icon(

                                  Icons.trending_up,

                                  color: Colors.green,

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

                                      style:
                                          const TextStyle(

                                        fontSize: 16,

                                        fontWeight:
                                            FontWeight.bold,

                                      ),

                                    ),

                                    const SizedBox(height: 3),

                                    Text(

                                      item["CategoryName"],

                                      style:
                                          TextStyle(

                                        color:
                                            Colors.grey.shade600,

                                      ),

                                    ),

                                  ],

                                ),

                              ),

                              Container(

                                padding:
                                    const EdgeInsets.symmetric(

                                  horizontal: 10,

                                  vertical: 6,

                                ),

                                decoration: BoxDecoration(

                                  color:
                                      Colors.green.shade50,

                                  borderRadius:
                                      BorderRadius.circular(20),

                                ),

                                child: Text(

                                  "+${item["GrowthQty"]} MT",

                                  style:
                                      const TextStyle(

                                    color: Colors.green,

                                    fontWeight:
                                        FontWeight.bold,

                                  ),

                                ),

                              ),

                            ],

                          ),

                          const SizedBox(height: 15),

                          Row(

                            children: [

                              Expanded(

                                child: _infoBox(

                                  "Previous",

                                  "${item["PreviousQty"]} MT",

                                ),

                              ),

                              const SizedBox(width: 10),

                              Expanded(

                                child: _infoBox(

                                  "Current",

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

                          const SizedBox(height: 14),

                          Text(

                            "Contribution ${double.parse(item["ContributionPercent"].toString()).toStringAsFixed(1)}%",

                            style: const TextStyle(

                              fontWeight: FontWeight.bold,

                            ),

                          ),

                          const SizedBox(height: 6),

                          ClipRRect(

                            borderRadius:
                                BorderRadius.circular(8),

                            child: LinearProgressIndicator(

                              minHeight: 8,

                              value:

                                  double.parse(

                                    item["ContributionPercent"]

                                        .toString(),

                                  ) /

                                      100,

                              color: Colors.green,

                              backgroundColor:
                                  Colors.grey.shade200,

                            ),

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

        color: const Color(0xffF8F9FD),

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

}