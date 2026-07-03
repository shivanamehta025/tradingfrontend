import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../utils/app_config.dart';

class GrowthAnalysisScreen extends StatelessWidget {
final double currentMTD;
final double lastMTD;
final double mtdgrowthPercent;

final double currentYTD;
final double lastYTD;
final double ytdgrowthPercent;

  const GrowthAnalysisScreen({
    super.key,
  required this.currentMTD,
  required this.lastMTD,
  required this.mtdgrowthPercent,
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

  double mtdDiff = currentMTD - lastMTD;
  double ytdDiff = currentYTD - lastYTD;

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

          /// ==========================
          /// MTD & YTD Growth Cards
          /// ==========================

          Row(
            children: [

              Expanded(
                child: _growthCard(
                  title: "MTD",
                  growth: mtdgrowthPercent,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _growthCard(
                  title: "YTD",
                  growth: ytdgrowthPercent,
                ),
              ),

            ],
          ),

          const SizedBox(height: 20),

          /// ==========================
          /// Month To Date
          /// ==========================

          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [

                  const Row(
                    children: [
                      Icon(Icons.calendar_month,
                          color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        "Month To Date",
                        style: TextStyle(
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
                    title:
                        const Text("Current MTD"),
                    trailing: Text(
                      "₹ ${formatAmount(currentMTD)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  ListTile(
                    dense: true,
                    leading:
                        const Icon(Icons.history),
                    title:
                        const Text("Last Month"),
                    trailing: Text(
                      "₹ ${formatAmount(lastMTD)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  ListTile(
                    dense: true,
                    leading: Icon(
                      mtdDiff >= 0
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                      color: mtdDiff >= 0
                          ? Colors.green
                          : Colors.red,
                    ),
                    title:
                        const Text("Difference"),
                    trailing: Text(
                      "₹ ${formatAmount(mtdDiff.abs())}",
                      style: TextStyle(
                        color: mtdDiff >= 0
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),

          const SizedBox(height: 18),

          /// ==========================
          /// Financial Year
          /// ==========================

          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [

                  const Row(
                    children: [
                      Icon(Icons.bar_chart,
                          color: Colors.deepPurple),
                      SizedBox(width: 8),
                      Text(
                        "Financial Year",
                        style: TextStyle(
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
                    title:
                        const Text("Current FY"),
                    trailing: Text(
                      "₹ ${formatAmount(currentYTD)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  ListTile(
                    dense: true,
                    leading:
                        const Icon(Icons.history),
                    title:
                        const Text("Last FY"),
                    trailing: Text(
                      "₹ ${formatAmount(lastYTD)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  ListTile(
                    dense: true,
                    leading: Icon(
                      ytdDiff >= 0
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                      color: ytdDiff >= 0
                          ? Colors.green
                          : Colors.red,
                    ),
                    title:
                        const Text("Difference"),
                    trailing: Text(
                      "₹ ${formatAmount(ytdDiff.abs())}",
                      style: TextStyle(
                        color: ytdDiff >= 0
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),

        ],
      ),
    ),
  );
}

Widget _infoCard(
  String title,
  String value,
  IconData icon,
  Color color,
) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      children: [

        Icon(icon, color: color),

        const SizedBox(height: 8),

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
            fontSize: 16,
          ),
        ),
      ],
    ),
  );
}

Widget _growthCard({
  required String title,
  required double growth,
}) {
  final positive = growth >= 0;

  return Container(
    padding: const EdgeInsets.all(18),
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
          size: 42,
          color: positive
              ? Colors.green
              : Colors.red,
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
          "${growth.toStringAsFixed(2)}%",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color:
                positive ? Colors.green : Colors.red,
          ),
        ),

        Text(
          positive ? "Growth" : "Decline",
          style: TextStyle(
            color:
                positive ? Colors.green : Colors.red,
          ),
        ),

      ],
    ),
  );
}
}