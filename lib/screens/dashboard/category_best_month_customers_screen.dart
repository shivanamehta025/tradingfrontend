import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../../utils/app_config.dart';
import 'customer_product_insight_screen.dart';

class CategoryBestMonthCustomersScreen
    extends StatefulWidget {

  final String productId;
  final String productName;
  final String bestMonth;
  final int year;
  final int month;

  const CategoryBestMonthCustomersScreen({
    super.key,
    required this.productId,
    required this.productName,
    required this.bestMonth,
    required this.year,
    required this.month,
  });

  @override
  State<CategoryBestMonthCustomersScreen>
      createState() =>
          _CategoryBestMonthCustomersScreenState();
}

class _CategoryBestMonthCustomersScreenState
    extends State<CategoryBestMonthCustomersScreen> {

  List<dynamic> customers = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    _loadCustomers();
  }

  Future<void> _loadCustomers() async {

    try {

      final data =
          await ApiService
              .getCategoryBestMonthCustomers(
                  databaseName: AppConfig.databaseName,

                  userId: AppConfig.userId,


        productId: widget.productId,

        year: widget.year,

        month: widget.month,
      );

      if (!mounted) return;

      setState(() {
        customers = data;
        isLoading = false;
      });

    } catch (e) {

      debugPrint(
        "BEST MONTH CUSTOMER ERROR: $e",
      );

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  double _number(dynamic value) {

    return double.tryParse(
          value?.toString() ?? "0",
        ) ??
        0;
  }

  String _formatAmount(double value) {

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

@override
Widget build(BuildContext context) {

  final totalQty = customers.fold<double>(
    0,
    (sum, item) => sum + _number(item["Qty"]),
  );

  final totalAmount = customers.fold<double>(
    0,
    (sum, item) => sum + _number(item["Amount"]),
  );

  return Scaffold(
    appBar: AppBar(
      title: Text(widget.productName),
    ),

    body: ListView.builder(
      itemCount: customers.length,

      itemBuilder: (context, index) {

        final customer = customers[index];
        final qty = _number(customer["Qty"]);
        final amount = _number(customer["Amount"]);

        return InkWell(
          onTap: () {

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CustomerProductInsightScreen(
                  customerId: customer["CustomerId"].toString(),
                  productId: widget.productId,
                  productName: widget.productName,
                  bestMonthYear: widget.year,
                  bestMonthNo: widget.month,
                ),
              ),
            );

          },
  child: Card(

    elevation: 1,

    margin: const EdgeInsets.only(bottom: 10),

    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
    ),

    child: Padding(

      padding: const EdgeInsets.all(14),

      child: Row(

        children: [

          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.orange.shade50,
            child: Text(
              "${index + 1}",
              style: TextStyle(
                color: Colors.orange.shade800,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Text(
                  customer["CustomerName"].toString(),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  "${qty.toStringAsFixed(2)} MT",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),

              ],

            ),

          ),

          Column(

            crossAxisAlignment: CrossAxisAlignment.end,

            children: [

              Text(
                _formatAmount(amount),
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
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
  );
}
  

  Widget _summaryValue(
    String title,
    String value,
  ) {

    return Column(

      children: [

        Text(

          title,

          style: const TextStyle(
            color: Colors.grey,
            fontSize: 11,
          ),
        ),

        const SizedBox(height: 5),

        Text(

          value,

          textAlign: TextAlign.center,

          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}