import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../../utils/app_config.dart';

class ProductGrowthDetailsScreen extends StatefulWidget {
  final String period;
  final String title;

  const ProductGrowthDetailsScreen({
    super.key,
    required this.period,
    required this.title,
  });

  @override
  State<ProductGrowthDetailsScreen> createState() =>
      _ProductGrowthDetailsScreenState();
}

class _ProductGrowthDetailsScreenState
    extends State<ProductGrowthDetailsScreen> {
  bool loading = true;

  List products = [];

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    final data = await ApiService.getProductGrowthDetails(
      databaseName: AppConfig.databaseName,
      userId: AppConfig.userId,
      period: widget.period,
    );

    if (!mounted) return;

    setState(() {
      products = data;
      loading = false;
    });
  }

  double _toDouble(dynamic value) {
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  String _qty(dynamic value) {
    return _toDouble(value).toStringAsFixed(2);
  }

  String _percent(dynamic value) {
    return "${_toDouble(value).toStringAsFixed(2)}%";
  }

  Color statusColor(String status) {
    switch (status.toUpperCase()) {
      case "GROWTH":
        return Colors.green;

      case "DECLINE":
        return Colors.red;

      case "NEW":
        return Colors.blue;

      case "SAME":
        return Colors.orange;

      default:
        return Colors.grey;
    }
  }

  IconData statusIcon(String status) {
    switch (status.toUpperCase()) {
      case "GROWTH":
        return Icons.trending_up;

      case "DECLINE":
        return Icons.trending_down;

      case "NEW":
        return Icons.auto_awesome;

      default:
        return Icons.remove;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),

      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),

      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : products.isEmpty
              ? const Center(
                  child: Text("No product data found"),
                )
              : ListView.builder(
                  itemCount: products.length,
                  padding: const EdgeInsets.all(12),
                  itemBuilder: (_, i) {
                    return _buildProductCard(products[i]);
                  },
                ),
    );
  }

  Widget _buildProductCard(dynamic p) {
    final String status =
        p["Status"]?.toString() ?? "SAME";

    final Color color = statusColor(status);

    final double growth =
        _toDouble(p["GrowthPercent"]);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),

      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),

        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 5,
          ),

          childrenPadding: const EdgeInsets.fromLTRB(
            14,
            0,
            14,
            14,
          ),

          leading: Container(
            width: 42,
            height: 42,

            decoration: BoxDecoration(
              color: color.withOpacity(.12),
              borderRadius: BorderRadius.circular(12),
            ),

            child: Icon(
              statusIcon(status),
              color: color,
            ),
          ),

          title: Text(
            p["ProductName"]?.toString() ?? "",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,

            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),

          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),

            child: Text(
              p["CategoryName"]?.toString() ?? "",

              maxLines: 1,
              overflow: TextOverflow.ellipsis,

              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ),

          trailing: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 9,
              vertical: 5,
            ),

            decoration: BoxDecoration(
              color: color.withOpacity(.12),
              borderRadius: BorderRadius.circular(20),
            ),

            child: Text(
              status,

              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),

          children: [
            const Divider(),

            /// =========================================
            /// CURRENT VS PREVIOUS
            /// =========================================

            Row(
              children: [
                Expanded(
                  child: _summaryBox(
                    title: "Previous",
                    value: "${_qty(p["PreviousQty"])} MT",
                    icon: Icons.history,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: _summaryBox(
                    title: "Current",
                    value: "${_qty(p["CurrentQty"])} MT",
                    icon: Icons.calendar_today,
                    color: Colors.blue,
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: _summaryBox(
                    title: "Growth",
                    value: _percent(growth),
                    icon: growth >= 0
                        ? Icons.arrow_upward
                        : Icons.arrow_downward,
                    color: growth >= 0
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// =========================================
            /// DIFFERENCE
            /// =========================================

            _analyticsRow(
              icon: Icons.compare_arrows,
              title: "Quantity Difference",
              value:
                  "${_qty(p["DifferenceQty"])} MT",
              valueColor:
                  _toDouble(p["DifferenceQty"]) >= 0
                      ? Colors.green
                      : Colors.red,
            ),

            const SizedBox(height: 14),

            /// =========================================
            /// BEST PERFORMANCE
            /// =========================================

            _sectionTitle(
              Icons.emoji_events,
              "Best Performance",
              Colors.orange,
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: _performanceBox(
                    title: "Best Month",
                    period:
                        p["BestMonth"]?.toString() ?? "-",
                    qty:
                        "${_qty(p["BestMonthQty"])} MT",
                    icon: Icons.calendar_month,
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: _performanceBox(
                    title: "Best Quarter",
                    period:
                        p["BestQuarter"]?.toString() ?? "-",
                    qty:
                        "${_qty(p["BestQuarterQty"])} MT",
                    icon: Icons.pie_chart,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            /// =========================================
            /// SALES HISTORY
            /// =========================================

            _sectionTitle(
              Icons.insights,
              "Sales Performance",
              Colors.deepPurple,
            ),

            const SizedBox(height: 6),

            _analyticsRow(
              icon: Icons.inventory_2_outlined,
              title: "Till Date Qty",
              value: "${_qty(p["TillDateQty"])} MT",
            ),

            _analyticsRow(
              icon: Icons.functions,
              title: "Avg Monthly Qty",
              value:
                  "${_qty(p["AvgMonthlyQty"])} MT",
            ),

            _analyticsRow(
              icon: Icons.calendar_today,
              title: "Current Month Qty",
              value:
                  "${_qty(p["CurrentMonthQty"])} MT",
            ),

            _percentageRow(
              title: "Vs Monthly Average",
              value:
                  _toDouble(p["VsMonthlyAvgPercent"]),
            ),

            const Divider(height: 22),

            _analyticsRow(
              icon: Icons.calculate_outlined,
              title: "Avg Quarterly Qty",
              value:
                  "${_qty(p["AvgQuarterlyQty"])} MT",
            ),

            _analyticsRow(
              icon: Icons.pie_chart_outline,
              title: "Current Quarter Qty",
              value:
                  "${_qty(p["CurrentQuarterQty"])} MT",
            ),

            _percentageRow(
              title: "Vs Quarterly Average",
              value:
                  _toDouble(p["VsQuarterlyAvgPercent"]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryBox({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 6,
      ),

      decoration: BoxDecoration(
        color: color.withOpacity(.08),
        borderRadius: BorderRadius.circular(12),
      ),

      child: Column(
        children: [
          Icon(
            icon,
            size: 18,
            color: color,
          ),

          const SizedBox(height: 5),

          Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 10,
            ),
          ),

          const SizedBox(height: 3),

          FittedBox(
            fit: BoxFit.scaleDown,

            child: Text(
              value,

              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(
    IconData icon,
    String title,
    Color color,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          color: color,
          size: 19,
        ),

        const SizedBox(width: 7),

        Text(
          title,

          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _performanceBox({
    required String title,
    required String period,
    required String qty,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.orange.withOpacity(.15),
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 17,
                color: Colors.orange,
              ),

              const SizedBox(width: 6),

              Expanded(
                child: Text(
                  title,

                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            period,

            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            qty,

            style: const TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _analyticsRow({
    required IconData icon,
    required String title,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),

      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.grey.shade600,
            size: 18,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              title,

              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 13,
              ),
            ),
          ),

          Text(
            value,

            style: TextStyle(
              color: valueColor ?? Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _percentageRow({
    required String title,
    required double value,
  }) {
    final bool positive = value >= 0;

    final Color color =
        positive ? Colors.green : Colors.red;

    return Container(
      margin: const EdgeInsets.only(top: 5),

      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),

      decoration: BoxDecoration(
        color: color.withOpacity(.08),
        borderRadius: BorderRadius.circular(10),
      ),

      child: Row(
        children: [
          Icon(
            positive
                ? Icons.trending_up
                : Icons.trending_down,
            color: color,
            size: 18,
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              title,

              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ),

          Text(
            "${value.toStringAsFixed(2)}%",

            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}