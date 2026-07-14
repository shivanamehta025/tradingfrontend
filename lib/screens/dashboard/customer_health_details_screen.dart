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
      Map<String, List<dynamic>> customerProducts = {};

      Set<String> loadingCustomers = {};

  String formatAmount(double value) {

    if (value >= 10000000) {
      return "${(value / 10000000).toStringAsFixed(2)} Cr";
    }

    if (value >= 100000) {
      return "${(value / 100000).toStringAsFixed(2)} L";
    }

    return value.toStringAsFixed(0);
  }

  String formatDate(dynamic value) {

  if (value == null ||
      value.toString().isEmpty ||
      value.toString() == "null") {

    return "-";

  }

  try {

    final date =
        DateTime.parse(value.toString());

    const months = [

      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",

    ];

    return
        "${date.day.toString().padLeft(2, '0')} "
        "${months[date.month - 1]} "
        "${date.year}";

  } catch (e) {

    return value.toString();

  }

}

String formatSaleDays(int days) {

  if (days <= 0) {
    return "Today";
  }

  if (days == 1) {
    return "1 day ago";
  }

  if (days < 30) {
    return "$days days ago";
  }

  if (days < 365) {

    final months = days ~/ 30;

    if (months == 1) {
      return "1 month ago";
    }

    return "$months months ago";

  }

  final years = days ~/ 365;

  if (years == 1) {
    return "1 year ago";
  }

  return "$years years ago";

}

  Future<void> loadProducts(String customerId) async {

  if (customerProducts.containsKey(customerId)) return;

  loadingCustomers.add(customerId);

  setState(() {});

  try {

    final data = await ApiService.getCustomerProducts(

      databaseName: AppConfig.databaseName,

      userId: AppConfig.userId,

      customerId: customerId,

    );

    customerProducts[customerId] = data;

  } finally {

    loadingCustomers.remove(customerId);

    setState(() {});

  }

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

 final customerId = (c["CustomerId"] ?? "").toString();

return Card(

  margin: const EdgeInsets.symmetric(
    horizontal: 10,
    vertical: 5,
  ),

  elevation: 2,

  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),

  child: ExpansionTile(

    onExpansionChanged: (expanded) {

      if (expanded) {

        loadProducts(customerId);

      }

    },

    leading: CircleAvatar(

      backgroundColor: Colors.blue.shade50,

      child: const Icon(
        Icons.business,
        color: Colors.blue,
      ),

    ),

    title: Text(

      c["CustomerName"] ?? "",

      style: const TextStyle(
        fontWeight: FontWeight.bold,
      ),

    ),

   subtitle: Padding(
  padding: const EdgeInsets.only(top: 4),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

      /// QTY + AMOUNT
      Row(
        children: [

          const Icon(
            Icons.scale_outlined,
            size: 14,
            color: Colors.grey,
          ),

          const SizedBox(width: 4),

          Text(
            "${((c["TotalQty"] ?? 0) as num).toStringAsFixed(2)} MT",
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
            ),
          ),

          const SizedBox(width: 14),

          const Icon(
            Icons.currency_rupee,
            size: 14,
            color: Colors.green,
          ),

          Text(
            formatAmount(
              ((c["TotalAmount"] ?? 0) as num).toDouble(),
            ),
            style: const TextStyle(
              fontSize: 12,
              color: Colors.green,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),


      /// RETENTION DETAILS
      if (c["RetentionDate"] != null &&
          c["RetentionDate"].toString() != "null" &&
          c["RetentionDate"].toString().isNotEmpty) ...[

        const SizedBox(height: 7),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [

              const Icon(
                Icons.refresh_rounded,
                size: 14,
                color: Colors.orange,
              ),

              const SizedBox(width: 5),

              Text(
                "Retained: ${formatDate(c["RetentionDate"])}",
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.orange,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(width: 8),

              if (c["InactiveDays"] != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "${c["InactiveDays"]} days inactive",
                    style: const TextStyle(
                      fontSize: 9,
                      color: Colors.orange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    ],
  ),
),

    children: [

      if (loadingCustomers.contains(customerId))

        const Padding(

          padding: EdgeInsets.all(20),

          child: Center(
            child: CircularProgressIndicator(),
          ),

        )

      else

      ...(customerProducts[customerId] ?? [])
    .map<Widget>((p) {

  final double qty =
      double.tryParse(
        p["Qty"]?.toString() ?? "0",
      ) ??
      0;

  final double amount =
      double.tryParse(
        p["Amount"]?.toString() ?? "0",
      ) ??
      0;

  final int lastSaleDays =
      int.tryParse(
        p["LastSaleDays"]?.toString() ?? "0",
      ) ??
      0;

  final String lastSaleDate =
      formatDate(p["LastSaleDate"]);

  Color daysColor;

  if (lastSaleDays >= 365) {
    daysColor = Colors.red;
  } else if (lastSaleDays >= 180) {
    daysColor = Colors.deepOrange;
  } else if (lastSaleDays >= 90) {
    daysColor = Colors.orange;
  } else {
    daysColor = Colors.green;
  }

  return Container(
    margin: const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 4,
    ),

    padding: const EdgeInsets.all(10),

    decoration: BoxDecoration(
      color: Colors.grey.shade50,

      borderRadius: BorderRadius.circular(10),

      border: Border.all(
        color: Colors.grey.shade200,
      ),
    ),

    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        /// PRODUCT ICON
        Container(
          width: 38,
          height: 38,

          decoration: BoxDecoration(
            color: Colors.indigo.shade50,

            borderRadius: BorderRadius.circular(10),
          ),

          child: const Icon(
            Icons.inventory_2_outlined,
            color: Colors.indigo,
            size: 20,
          ),
        ),

        const SizedBox(width: 10),

        /// PRODUCT DETAILS
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              /// PRODUCT NAME + AMOUNT
              Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Expanded(
                    child: Text(
                      p["ProductName"]
                              ?.toString() ??
                          "",

                      maxLines: 2,

                      overflow: TextOverflow.ellipsis,

                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  Text(
                    "₹ ${formatAmount(amount)}",

                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 5),

              /// QTY
              Row(
                children: [

                  const Icon(
                    Icons.scale_outlined,
                    size: 13,
                    color: Colors.grey,
                  ),

                  const SizedBox(width: 4),

                  Text(
                    "${qty.toStringAsFixed(2)} MT",

                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 5),

              /// LAST SALE DETAILS
              Wrap(
                spacing: 6,
                runSpacing: 4,

                crossAxisAlignment:
                    WrapCrossAlignment.center,

                children: [

                  Row(
                    mainAxisSize: MainAxisSize.min,

                    children: [

                      Icon(
                        Icons.calendar_month_outlined,
                        size: 13,
                        color: daysColor,
                      ),

                      const SizedBox(width: 4),

                      Text(
                        "Last Sale: $lastSaleDate",

                        style: TextStyle(
                          fontSize: 11,
                          color: daysColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),

                    decoration: BoxDecoration(
                      color:
                          daysColor.withOpacity(.10),

                      borderRadius:
                          BorderRadius.circular(10),
                    ),

                    child: Text(
                      formatSaleDays(lastSaleDays),

                      style: TextStyle(
                        fontSize: 10,
                        color: daysColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );

}).toList(),

      if ((customerProducts[customerId] ?? []).isNotEmpty)

        Padding(

          padding: const EdgeInsets.only(
            right: 16,
            bottom: 12,
          ),

          child: Align(

            alignment: Alignment.centerRight,

            child: Text(

              "${customerProducts[customerId]!.length} Products",

              style: const TextStyle(

                color: Colors.grey,

                fontWeight: FontWeight.bold,

              ),

            ),

          ),

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