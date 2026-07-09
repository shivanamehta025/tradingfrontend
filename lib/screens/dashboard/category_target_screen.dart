import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../utils/app_config.dart';
import '../dashboard/category_customers_screen.dart';

class CategoryTargetScreen extends StatefulWidget {
  const CategoryTargetScreen({super.key});

  @override
 State<CategoryTargetScreen> createState() =>
      _CategoryTargetScreenState();
}

class _CategoryTargetScreenState
    extends State<CategoryTargetScreen> {

  bool loading = true;

  List targets = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {

     final data = await ApiService.getCategoryTargets(

  databaseName: AppConfig.databaseName,

  userId: AppConfig.userId,

);

setState(() {

  targets = data["list"];

  loading = false;

});
    } catch (e) {

      setState(() {
        loading = false;
      });
    }
  }

  Color statusColor(double percent) {

    if (percent >= 100) {
      return Colors.green;
    }

    if (percent >= 75) {
      return Colors.blue;
    }

    if (percent >= 50) {
      return Colors.orange;
    }

    return Colors.red;
  }

  String status(double percent) {

    if (percent >= 100) {
      return "Target Achieved";
    }

    if (percent >= 75) {
      return "On Track";
    }

    if (percent >= 50) {
      return "Needs Push";
    }

    return "Critical";
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xffF5F7FA),

      appBar: AppBar(

        title: const Text("Category Wise Target"),

        backgroundColor: Colors.blue,

        foregroundColor: Colors.white,
      ),

      body: loading

          ? const Center(
              child:
                  CircularProgressIndicator(),
            )

          : ListView.builder(

              padding:
                  const EdgeInsets.all(15),

              itemCount: targets.length,

              itemBuilder:
                  (context, index) {

                final item = targets[index];

                final target =
                    (item["MonthlyTarget"] ?? 0)
                        .toDouble();

                final current =
                    (item["CurrentQty"] ?? 0)
                        .toDouble();

                        final avgqty =
                    (item["AvgQty"] ?? 0)
                        .toDouble();

                final remaining =
                    (item["RemainingQty"] ?? 0)
                        .toDouble();

                final excess =
                    (item["ExcessQty"] ?? 0)
                        .toDouble();

                final percent =
                    (item["AchievementPercent"] ?? 0)
                        .toDouble();

                final color =
                    statusColor(percent);

               return InkWell(

  borderRadius: BorderRadius.circular(18),

  onTap: () {

    Navigator.push(

      context,

      MaterialPageRoute(

        builder: (_) => CategoryCustomersScreen(

          categoryName: item["CategoryName"],

          remainingTarget: remaining,

        ),

      ),

    );

  },

  child: Card(

    margin: const EdgeInsets.only(bottom: 15),

    elevation: 4,

    shape: RoundedRectangleBorder(

      borderRadius: BorderRadius.circular(18),

    ),

    child: Padding(

      padding: const EdgeInsets.all(12),

      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Row(

            children: [

              Expanded(

                child: Text(

                  item["CategoryName"],

                  style: const TextStyle(

                    fontSize: 16,

                    fontWeight: FontWeight.bold,

                  ),

                ),

              ),

              Container(

                padding: const EdgeInsets.symmetric(

                  horizontal: 8,

                  vertical: 4,

                ),

                decoration: BoxDecoration(

                  color: color.withOpacity(.12),

                  borderRadius: BorderRadius.circular(20),

                ),

                child: Text(

                  "${percent.toStringAsFixed(1)}%",

                  style: TextStyle(

                    color: color,

                    fontWeight: FontWeight.bold,

                  ),

                ),

              ),

            ],

          ),

          const SizedBox(height: 8),

          Row(

            children: [

              Expanded(

                child: _value(

                  "Avg(3M)",

                  "${avgqty.toStringAsFixed(1)} MT",

                ),

              ),

              Expanded(

                child: _value(

                  "Target",

                  "${target.toStringAsFixed(1)} MT",

                ),

              ),

              Expanded(

                child: _value(

                  "Achieved",

                  "${current.toStringAsFixed(1)} MT",

                ),

              ),

            ],

          ),

          const SizedBox(height: 10),

          ClipRRect(

            borderRadius: BorderRadius.circular(10),

            child: LinearProgressIndicator(

              value: (percent / 100).clamp(0.0, 1.0),

              minHeight: 5,

              backgroundColor: Colors.grey.shade300,

              valueColor: AlwaysStoppedAnimation(color),

            ),

          ),

          const SizedBox(height: 8),

          Row(

            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [

              Text(

                status(percent),

                style: TextStyle(

                  color: color,

                  fontWeight: FontWeight.bold,

                ),

              ),

              Text(

                current >= target

                    ? "Exceeded ${excess.toStringAsFixed(1)} MT"

                    : "Remaining ${remaining.toStringAsFixed(1)} MT",

                style: const TextStyle(

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
              },
            ),
    );
  }

  Widget _value(
    String title,
    String value,
  ) {

    return Column(

      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        Text(

          title,

          style: const TextStyle(

            color: Colors.grey,

            fontSize: 13,
          ),
        ),

        const SizedBox(height: 4),

        Text(

          value,

          style: const TextStyle(

            fontWeight:
                FontWeight.bold,

            fontSize: 11,
          ),
        ),
      ],
    );
  }
}