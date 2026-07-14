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

    final data =
        await ApiService.getProductGrowthDetails(

      databaseName: AppConfig.databaseName,

      userId: AppConfig.userId,

      period: widget.period,

    );

    setState(() {

      products = data;

      loading = false;

    });

  }

  Color statusColor(String status){

    switch(status){

      case "GROWTH":
        return Colors.green;

      case "DECLINE":
        return Colors.red;

      case "NEW":
        return Colors.blue;

      default:
        return Colors.orange;

    }

  }

  @override
  Widget build(BuildContext context){

    return Scaffold(

      appBar: AppBar(

        title: Text(widget.title),

        backgroundColor: Colors.green,

        foregroundColor: Colors.white,

      ),

      body: loading

      ? const Center(
          child: CircularProgressIndicator(),
        )

      : ListView.builder(

          itemCount: products.length,

          padding: const EdgeInsets.all(12),

          itemBuilder: (_,i){

            final p=products[i];

            final color=statusColor(p["Status"]);

            return Card(

              margin: const EdgeInsets.only(bottom:10),

              child: ListTile(

                title: Text(
                  p["ProductName"],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                subtitle: Column(

                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Text(p["CategoryName"]),

                    const SizedBox(height:5),

                    Row(

                      children:[

                        Expanded(
                          child: Text(
                              "Prev : ${p["PreviousQty"]} MT"),
                        ),

                        Expanded(
                          child: Text(
                              "Current : ${p["CurrentQty"]} MT"),
                        ),

                      ],

                    ),

                    const SizedBox(height:3),

                    Row(

                      children:[

                        Expanded(
                          child: Text(
                              "Diff : ${p["DifferenceQty"]} MT"),
                        ),

                        Expanded(
                          child: Text(
                              "${p["GrowthPercent"]}%"),
                        ),

                      ],

                    )

                  ],

                ),

                trailing: Container(

                  padding: const EdgeInsets.symmetric(
                    horizontal:10,
                    vertical:6,
                  ),

                  decoration: BoxDecoration(

                    color: color.withOpacity(.15),

                    borderRadius:
                        BorderRadius.circular(20),

                  ),

                  child: Text(

                    p["Status"],

                    style: TextStyle(

                      color: color,

                      fontWeight: FontWeight.bold,

                    ),

                  ),

                ),

              ),

            );

          },

      ),

    );

  }

}