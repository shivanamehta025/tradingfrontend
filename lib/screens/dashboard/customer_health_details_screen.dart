import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../utils/app_config.dart';

class CustomerHealthDetailsScreen extends StatefulWidget {

  final String title;
  final List<dynamic> customers;

  const CustomerHealthDetailsScreen({

    super.key,

    required this.title,

    required this.customers,

  });

  @override
  State<CustomerHealthDetailsScreen> createState() =>
      _CustomerHealthDetailsScreenState();
}

class _CustomerHealthDetailsScreenState
    extends State<CustomerHealthDetailsScreen> {

  String formatAmount(double value) {

    if (value >= 10000000) {
      return "${(value / 10000000).toStringAsFixed(2)} Cr";
    }

    if (value >= 100000) {
      return "${(value / 100000).toStringAsFixed(2)} L";
    }

    return value.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xffF5F7FA),

      appBar: AppBar(

        title: Text(widget.title),

        backgroundColor: Colors.blue,

        foregroundColor: Colors.white,
      ),

     body: Column(
  children: [

    Expanded(
      child: ListView.separated(

        itemCount: widget.customers.length,

        separatorBuilder: (_, __) => const Divider(height: 1),

      itemBuilder: (context, index) {

  final c = widget.customers[index];

  return Container(

    padding: const EdgeInsets.symmetric(
      horizontal: 14,
      vertical: 10,
    ),

    decoration: const BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: Color(0xffECECEC),
        ),
      ),
    ),

    child: Row(

      children: [

        Expanded(

          child: Text(

            c["CustomerName"],

            maxLines: 2,

            overflow: TextOverflow.ellipsis,

            style: const TextStyle(

              fontSize: 15,

              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        const SizedBox(width: 12),

        Column(

          crossAxisAlignment: CrossAxisAlignment.end,

          children: [

            Text(

              "${double.parse(c["TotalQty"].toString()).toStringAsFixed(2)} MT",

              style: const TextStyle(

                fontSize: 15,

                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 2),

            Text(

              "₹ ${formatAmount((c["TotalAmount"] ?? 0).toDouble())}",

              style: const TextStyle(

                color: Colors.green,

                fontSize: 13,

                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    ),
  );
},
      ),
    ),
  ],
),
    );
  }

  Widget _item(

    String title,

    String value,

    IconData icon,

    Color color,

  ){

    return Row(

      children: [

        CircleAvatar(

          radius:16,

          backgroundColor: color.withOpacity(.12),

          child: Icon(

            icon,

            size:16,

            color: color,
          ),
        ),

        const SizedBox(width:8),

        Expanded(

          child: Column(

            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Text(

                title,

                style: const TextStyle(

                  fontSize:12,

                  color: Colors.grey,
                ),
              ),

              Text(

                value,

                style: const TextStyle(

                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

}