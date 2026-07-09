import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../../utils/app_config.dart';

class CategoryCustomersScreen extends StatefulWidget {

  final String categoryName;

  final double remainingTarget;

  const CategoryCustomersScreen({

    super.key,

    required this.categoryName,

    required this.remainingTarget,

  });

  @override
  State<CategoryCustomersScreen> createState() =>
      _CategoryCustomersScreenState();
}

class _CategoryCustomersScreenState
    extends State<CategoryCustomersScreen> {

  bool loading = true;

  List customers = [];

  @override
  void initState() {
    super.initState();
    loadCustomers();
  }

  Future<void> loadCustomers() async {

    final data =
        await ApiService.getCategoryCustomers(

      databaseName: AppConfig.databaseName,

      userId: AppConfig.userId,

      categoryName: widget.categoryName,

    );

    setState(() {

      customers = data;

      loading = false;

    });

  }

  Color recommendationColor(String value){

    if(value.contains("VISIT")){
      return Colors.red;
    }

    if(value.contains("CALL")){
      return Colors.orange;
    }

    if(value.contains("FOLLOW")){
      return Colors.blue;
    }

    return Colors.green;

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xffF5F7FA),

      appBar: AppBar(

        title: Text(widget.categoryName),

        backgroundColor: Colors.indigo,

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

            padding: const EdgeInsets.all(16),

            decoration: BoxDecoration(

              gradient: const LinearGradient(

                colors: [

                  Color(0xff243B55),

                  Color(0xff141E30),

                ],

              ),

              borderRadius:
                  BorderRadius.circular(18),

            ),

            child: Row(

              mainAxisAlignment:
                  MainAxisAlignment.spaceAround,

              children: [

                Column(

                  children: [

                    const Text(

                      "Remaining",

                      style: TextStyle(

                        color: Colors.white70,

                      ),

                    ),

                    Text(

                      "${widget.remainingTarget.toStringAsFixed(1)} MT",

                      style: const TextStyle(

                        color: Colors.white,

                        fontSize: 22,

                        fontWeight: FontWeight.bold,

                      ),

                    ),

                  ],

                ),

                Column(

                  children: [

                    const Text(

                      "Customers",

                      style: TextStyle(

                        color: Colors.white70,

                      ),

                    ),

                    Text(

                      customers.length.toString(),

                      style: const TextStyle(

                        color: Colors.white,

                        fontSize: 22,

                        fontWeight: FontWeight.bold,

                      ),

                    ),

                  ],

                ),

              ],

            ),

          ),

          Expanded(

            child: ListView.builder(

              padding:
                  const EdgeInsets.symmetric(horizontal: 15),

              itemCount: customers.length,

              itemBuilder: (_, i){

                final item = customers[i];

                return Card(
  margin: const EdgeInsets.only(bottom: 10),
  elevation: 2,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(14),
  ),
  child: Padding(
    padding: const EdgeInsets.all(12),
    child: Column(
      children: [

        Row(
          children: [

            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.business,
                color: Colors.indigo,
                size: 22,
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Text(
                item["CustomerName"],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5),
              decoration: BoxDecoration(
                color: recommendationColor(item["Recommendation"])
                    .withOpacity(.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                item["Recommendation"],
                style: TextStyle(
                  color: recommendationColor(
                      item["Recommendation"]),
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Column(

  children: [

    Row(

      children: [

        Expanded(

          child: _miniInfo(

            Icons.inventory_2_outlined,

            "Potential",

            "${item["AvgQty"]} MT",

          ),

        ),

        Expanded(

          child: _miniInfo(

            Icons.calendar_today,

            "Last Purchase",

            item["LastPurchase"] .toString(),

          ),

        ),

      ],

    ),

    const SizedBox(height: 10),

    Row(

      children: [

        Expanded(

          child: _miniInfo(

            Icons.schedule,

            "Current Gap",

            "${item["CurrentGap"]} Days",

          ),

        ),

        Expanded(

          child: _miniInfo(

            Icons.timelapse,

            "Avg Gap",

            "${item["AvgPurchaseGap"]} Days",

          ),

        ),

      ],

    ),

  ],

),
      ],
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

  Widget _info(String t,String v){

    return Column(

      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        Text(

          t,

          style: const TextStyle(

            color: Colors.grey,

            fontSize: 12,

          ),

        ),

        const SizedBox(height: 2),

        Text(

          v,

          style: const TextStyle(

            fontWeight: FontWeight.bold,

          ),

        ),

      ],

    );

  }

  Widget _miniInfo(
    IconData icon,
    String title,
    String value,
) {
  return Row(
    children: [

      Icon(
        icon,
        size: 16,
        color: Colors.grey,
      ),

      const SizedBox(width: 5),

      Expanded(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 2),

            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

}