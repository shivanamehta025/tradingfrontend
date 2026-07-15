import 'package:flutter/material.dart';

import '../dashboard/product_growth_details_screen.dart';

class GrowthAnalysisScreen extends StatelessWidget {
  final double currentMTD;
  final double lastMTD;
  final double mtdgrowthPercent;

  final double currentQuarter;
  final double previousQuarter;
  final double quarterGrowthPercent;

  final double currentYTD;
  final double lastYTD;
  final double ytdgrowthPercent;

  const GrowthAnalysisScreen({
    super.key,
    required this.currentMTD,
    required this.lastMTD,
    required this.mtdgrowthPercent,
    required this.currentQuarter,
    required this.previousQuarter,
    required this.quarterGrowthPercent,
    required this.currentYTD,
    required this.lastYTD,
    required this.ytdgrowthPercent,
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
    final double mtdDiff = currentMTD - lastMTD;

    final double quarterDiff =
        currentQuarter - previousQuarter;

    final double ytdDiff = currentYTD - lastYTD;

    return Scaffold(
      backgroundColor: const Color(0xffF4F6FA),

      appBar: AppBar(
        title: const Text("Growth Analysis"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            /// ==========================================
            /// MTD / QUARTER / FY GROWTH
            /// ==========================================

            Row(
              children: [

                Expanded(
                  child: InkWell(
                    borderRadius:
                        BorderRadius.circular(18),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const ProductGrowthDetailsScreen(
                            period: "MTD",
                            title:
                                "Previous Month Products",
                          ),
                        ),
                      );
                    },

                    child: _growthCard(
                      title: "MTD",
                      growth: mtdgrowthPercent,
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: InkWell(
                    borderRadius:
                        BorderRadius.circular(18),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const ProductGrowthDetailsScreen(
                            period: "QTD",
                            title:
                                "Previous Quarter Products",
                          ),
                        ),
                      );
                    },

                    child: _growthCard(
                      title: "Quarter",
                      growth: quarterGrowthPercent,
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: InkWell(
                    borderRadius:
                        BorderRadius.circular(18),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const ProductGrowthDetailsScreen(
                            period: "YTD",
                            title:
                                "Last Financial Year Products",
                          ),
                        ),
                      );
                    },

                    child: _growthCard(
                      title: "FY",
                      growth: ytdgrowthPercent,
                    ),
                  ),
                ),

              ],
            ),

            const SizedBox(height: 20),

            /// ==========================================
            /// MONTH TO DATE
            /// ==========================================

            _analysisCard(
              title: "Month To Date",
              icon: Icons.calendar_month,
              iconColor: Colors.blue,

              currentTitle: "Current MTD",
              previousTitle: "Last Month",

              currentValue: currentMTD,
              previousValue: lastMTD,

              difference: mtdDiff,
            ),

            const SizedBox(height: 18),

            /// ==========================================
            /// QUARTER
            /// ==========================================

            _analysisCard(
              title: "Quarter Performance",
              icon: Icons.pie_chart,
              iconColor: Colors.orange,

              currentTitle: "Current Quarter",
              previousTitle: "Previous Quarter",

              currentValue: currentQuarter,
              previousValue: previousQuarter,

              difference: quarterDiff,
            ),

            const SizedBox(height: 18),

            /// ==========================================
            /// FINANCIAL YEAR
            /// ==========================================

            _analysisCard(
              title: "Financial Year",
              icon: Icons.bar_chart,
              iconColor: Colors.deepPurple,

              currentTitle: "Current FY",
              previousTitle: "Last FY",

              currentValue: currentYTD,
              previousValue: lastYTD,

              difference: ytdDiff,
            ),

          ],
        ),
      ),
    );
  }

  /// ==========================================
  /// ANALYSIS CARD
  /// ==========================================

  Widget _analysisCard({
    required String title,
    required IconData icon,
    required Color iconColor,

    required String currentTitle,
    required String previousTitle,

    required double currentValue,
    required double previousValue,

    required double difference,
  }) {
    final bool positive = difference >= 0;

    return Card(
      elevation: 3,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),

      child: Padding(
        padding: const EdgeInsets.all(15),

        child: Column(
          children: [

            Row(
              children: [

                Icon(
                  icon,
                  color: iconColor,
                ),

                const SizedBox(width: 8),

                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

              ],
            ),

            const Divider(height: 25),

            ListTile(
              dense: true,

              leading:
                  const Icon(Icons.currency_rupee),

              title: Text(currentTitle),

              trailing: Text(
                "₹ ${formatAmount(currentValue)}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            ListTile(
              dense: true,

              leading:
                  const Icon(Icons.history),

              title: Text(previousTitle),

              trailing: Text(
                "₹ ${formatAmount(previousValue)}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            ListTile(
              dense: true,

              leading: Icon(
                positive
                    ? Icons.arrow_upward
                    : Icons.arrow_downward,

                color: positive
                    ? Colors.green
                    : Colors.red,
              ),

              title: const Text("Difference"),

              trailing: Text(
                "₹ ${formatAmount(difference.abs())}",

                style: TextStyle(
                  color: positive
                      ? Colors.green
                      : Colors.red,

                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  /// ==========================================
  /// GROWTH CARD
  /// ==========================================

  Widget _growthCard({
    required String title,
    required double growth,
  }) {
    final bool positive = growth >= 0;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 15,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.15),
            blurRadius: 8,
          ),
        ],
      ),

      child: Column(
        children: [

          Icon(
            positive
                ? Icons.trending_up
                : Icons.trending_down,

            size: 34,

            color: positive
                ? Colors.green
                : Colors.red,
          ),

          const SizedBox(height: 8),

          Text(
            title,

            maxLines: 1,

            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 5),

          FittedBox(
            fit: BoxFit.scaleDown,

            child: Text(
              "${growth.toStringAsFixed(2)}%",

              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,

                color: positive
                    ? Colors.green
                    : Colors.red,
              ),
            ),
          ),

          Text(
            positive ? "Growth" : "Decline",

            style: TextStyle(
              fontSize: 12,

              color: positive
                  ? Colors.green
                  : Colors.red,
            ),
          ),

        ],
      ),
    );
  }
}