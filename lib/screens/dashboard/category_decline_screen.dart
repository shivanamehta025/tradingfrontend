import 'package:flutter/material.dart';
import 'category_best_month_customers_screen.dart';

class CategoryDeclineScreen extends StatelessWidget {
  final List<dynamic> categories;

  const CategoryDeclineScreen({
    super.key,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),

      appBar: AppBar(
        title: const Text("Category Performance"),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        itemBuilder: (context, index) {

          final item = categories[index];
final status = item["CategoryStatus"];

Color color;
Color bgColor;
IconData icon;

switch (status) {
  case "No Sale":
    color = Colors.red;
    bgColor = Colors.red.shade50;
    icon = Icons.cancel_rounded;
    break;

  case "Critical":
    color = Colors.red.shade800;
    bgColor = Colors.red.shade100;
    icon = Icons.error_rounded;
    break;

  case "Needs Push":
    color = Colors.orange;
    bgColor = Colors.orange.shade100;
    icon = Icons.trending_down_rounded;
    break;

  default:
    color = Colors.green;
    bgColor = Colors.green.shade100;
    icon = Icons.check_circle_rounded;
}

          double avg =
              double.tryParse(item["AvgLast6Months"].toString()) ?? 0;

          double current =
              double.tryParse(item["CurrentMonthQty"].toString()) ?? 0;

          double progress =
              avg == 0 ? 0 : (current / avg).clamp(0.0, 1.0);

return Card(
  elevation: 2,

  margin: const EdgeInsets.only(bottom: 14),

  clipBehavior: Clip.antiAlias,

  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  ),

  child: InkWell(
    onTap: () {

      Navigator.push(
        context,

        MaterialPageRoute(
          builder: (_) =>
              CategoryBestMonthCustomersScreen(

            categoryId:
                item["CategoryId"].toString(),

            categoryName:
                item["CategoryName"].toString(),

            bestMonth:
                item["BestMonth"].toString(),

            year: int.parse(
              item["BestMonthYear"].toString(),
            ),

            month: int.parse(
              item["BestMonthNumber"].toString(),
            ),
          ),
        ),
      );
    },

    child: Padding(
      padding: const EdgeInsets.all(16),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

                children: [

                  Row(

                    children: [

                     CircleAvatar(
  radius: 20,
  backgroundColor: bgColor,
  child: Icon(
    icon,
    color: color,
    size: 22,
  ),
),

                      const SizedBox(width: 12),

                      Expanded(

                        child: Text(

                          item["CategoryName"],

                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                     Container(
  padding: const EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 6,
  ),
  decoration: BoxDecoration(
    color: bgColor,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(
      color: color.withOpacity(.35),
    ),
  ),
  child: Text(
    status,
    style: TextStyle(
      color: color,
      fontWeight: FontWeight.w700,
      fontSize: 12,
    ),
  ),
),
                    ],
                  ),

                  const SizedBox(height: 16),

                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    borderRadius:
                        BorderRadius.circular(8),
                    backgroundColor:
                        Colors.grey.shade300,
                    valueColor:
                        AlwaysStoppedAnimation(color),
                  ),

                  const SizedBox(height: 16),

                  Row(

                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,

                    children: [

                      _value(
                        "Current",
                        "${current.toStringAsFixed(1)} MT",
                      ),

                      _value(
                        "Average",
                        "${avg.toStringAsFixed(1)} MT",
                      ),

                      _value(
                        "Gap",
                        "${item["GapToAverage"]} MT",
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(

                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,

                    children: [

                      Text(
                        "Best Month : ${item["BestMonth"]}",
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),

                      Text(
                        "${item["BestMonthlyQty"]} MT",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
           )
         );
        },
      ),
    );
  }

  Widget _value(String title, String value) {
    return Column(
      children: [

        Text(
          title,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}