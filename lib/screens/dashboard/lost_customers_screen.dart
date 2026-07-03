import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../../utils/app_config.dart';
import 'package:intl/intl.dart';

class LostCustomersScreen extends StatefulWidget {
  final List<dynamic> customers;

  const LostCustomersScreen({
    super.key,
    required this.customers,
  });

  @override
  State<LostCustomersScreen> createState() =>
      _LostCustomersScreenState();
}

class _LostCustomersScreenState
    extends State<LostCustomersScreen> {

  late List<dynamic> customers;

  String selectedFilter = "ALL";
  String selectedBasis = "QTY"; // QTY / AMOUNT

  String selectedPayment = "ALL"; // ALL / CREDIT / CASH

  bool loading = false;

  @override
  void initState() {
    super.initState();
    customers = widget.customers;
  }

Future<void> loadCustomers(String filter) async {

  setState(() {
    loading = true;
    selectedFilter = filter;
  });

  try {

    final data = await ApiService.getLostCustomers(

      databaseName: AppConfig.databaseName,

      userId: AppConfig.userId,

      filter: filter,

      basis: selectedBasis,

      paymentFilter: selectedPayment,
    );

    setState(() {
      customers = data;
      loading = false;
    });

  } catch (e) {

    setState(() {
      loading = false;
    });

  }
}

  Color statusColor(String status) {

    switch (status) {

      case "Active":
        return Colors.green;

      case "Follow-up":
        return Colors.orange;

      case "At Risk":
        return Colors.red;
        case "Inactive":
      return Colors.deepOrange;
       case "Lost":
      return Colors.red.shade900;

      default:
        return Colors.red.shade900;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(

        backgroundColor: Colors.red,

        foregroundColor: Colors.white,

        title: const Text(
          "Customer Re-Engagement",
        ),
      ),

      body: Column(

        children: [

          const SizedBox(height: 12),

         Padding(
  padding: const EdgeInsets.symmetric(horizontal: 12),
  child: Wrap(
    spacing: 8,
    runSpacing: 8,
    children: [
      _chip("ALL", "All"),
      _chip("30", "≤30"),
      _chip("90", "31-90"),
      _chip("180", "91-180"),
      _chip("365", "181-365"),
      _chip("LOST", "365+"),
    ],
  ),
),

const SizedBox(height: 10),

Padding(
  padding: const EdgeInsets.symmetric(horizontal: 12),
  child: Row(
    children: [

      const Text(
        "Based On :",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),

      const SizedBox(width: 10),

      ChoiceChip(
        label: const Text("Qty"),
        selected: selectedBasis == "QTY",
        onSelected: (_) {
          setState(() {
            selectedBasis = "QTY";
          });

          loadCustomers(selectedFilter);
        },
      ),

      const SizedBox(width: 8),

      ChoiceChip(
        label: const Text("Amount"),
        selected: selectedBasis == "AMOUNT",
        onSelected: (_) {
          setState(() {
            selectedBasis = "AMOUNT";
          });

          loadCustomers(selectedFilter);
        },
      ),
    ],
  ),
),
const SizedBox(height: 10),

Padding(
  padding: const EdgeInsets.symmetric(horizontal: 12),
  child: Row(
    children: [

      const Text(
        "Payment :",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),

      const SizedBox(width: 10),

      ChoiceChip(
        label: const Text("All"),
        selected: selectedPayment == "ALL",
        onSelected: (_) {
          setState(() {
            selectedPayment = "ALL";
          });

          loadCustomers(selectedFilter);
        },
      ),

      const SizedBox(width: 8),

      ChoiceChip(
        label: const Text("Credit"),
        selected: selectedPayment == "CREDIT",
        onSelected: (_) {
          setState(() {
            selectedPayment = "CREDIT";
          });

          loadCustomers(selectedFilter);
        },
      ),

      const SizedBox(width: 8),

      ChoiceChip(
        label: const Text("Cash"),
        selected: selectedPayment == "CASH",
        onSelected: (_) {
          setState(() {
            selectedPayment = "CASH";
          });

          loadCustomers(selectedFilter);
        },
      ),
    ],
  ),
),

          const SizedBox(height: 10),

          Expanded(

            child: loading

                ? const Center(
                    child:
                        CircularProgressIndicator(),
                  )

                : customers.isEmpty

                    ? const Center(
                        child: Text(
                          "No Customers Found",
                        ),
                      )

                    : ListView.builder(

                        padding:
                            const EdgeInsets.all(15),

                        itemCount:
                            customers.length,

                        itemBuilder:
                            (context, index) {

                          final item =
                              customers[index];

                          final status =
                              item["CustomerStatus"];

                          final color =
                              statusColor(status);

                          return Card(

                            elevation: 4,

                            margin:
                                const EdgeInsets.only(
                              bottom: 15,
                            ),

                            shape:
                                RoundedRectangleBorder(

                              borderRadius:
                                  BorderRadius.circular(
                                      18),
                            ),

                            child: Padding(

                              padding:
                                  const EdgeInsets.all(
                                      18),

                              child: Column(

                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,

                                children: [

                                  Row(

                                    children: [

                                      Expanded(

                                        child: Column(

                                          crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,

                                          children: [

                                            Text(

                                              item["CustomerName"],

                                              style:
                                                  const TextStyle(

                                                fontWeight:
                                                    FontWeight.bold,

                                                fontSize:
                                                    18,
                                              ),
                                            ),

                                            const SizedBox(
                                                height: 8),

                                            Container(

                                              padding:
                                                  const EdgeInsets.symmetric(

                                                horizontal:
                                                    10,

                                                vertical:
                                                    5,
                                              ),

                                              decoration:
                                                  BoxDecoration(

                                                color: Colors
                                                    .blue
                                                    .shade50,

                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20),
                                              ),

                                              child: Row(

                                                mainAxisSize:
                                                    MainAxisSize.min,

                                                children: [

                                                  const Icon(

                                                    Icons
                                                        .inventory_2_outlined,

                                                    size:
                                                        16,

                                                    color:
                                                        Colors.blue,
                                                  ),

                                                  const SizedBox(
                                                      width:
                                                          5),

                                                  Text(
                                                    item["ProductName"],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      Container(

                                        padding:
                                            const EdgeInsets.symmetric(

                                          horizontal:
                                              12,

                                          vertical: 6,
                                        ),

                                        decoration:
                                            BoxDecoration(

                                          color: color
                                              .withOpacity(
                                                  .15),

                                          borderRadius:
                                              BorderRadius.circular(
                                                  20),
                                        ),

                                        child: Text(

                                          status,

                                          style:
                                              TextStyle(

                                            color:
                                                color,

                                            fontWeight:
                                                FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                       const SizedBox(height: 18),

Row(
  children: [

    Icon(
      Icons.schedule,
      color: Colors.red,
      size: 20,
    ),

    const SizedBox(width: 8),

    Text(

      "${item["LastSaleDays"]} Days Ago",

      style: const TextStyle(

        fontSize: 16,

        fontWeight: FontWeight.bold,
      ),
    ),
  ],
),

const SizedBox(height: 14),

Row(

  children: [

    const Icon(
      Icons.scale,
      size: 20,
      color: Colors.blue,
    ),

    const SizedBox(width: 8),

    Text(

  selectedBasis == "QTY"

      ? "Last Qty : ${item["LastSaleQty"]} MT"

      :  "Last Amount : ₹ ${formatIndianCurrency(item["LastSaleAmount"])}",

  style: const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  ),
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

  Widget _chip(
    String value,
    String title,
  ) {

    final selected =
        selectedFilter == value;

    return Padding(

      padding:
          const EdgeInsets.only(right: 8),

      child: ChoiceChip(

        label: Text(title),

        selected: selected,

        onSelected: (_) {

          loadCustomers(value);
        },
      ),
    );
  }

  Widget _info(
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

            fontSize: 12,
          ),
        ),

        const SizedBox(height: 4),

        Text(

          value,

          style: const TextStyle(

            fontWeight:
                FontWeight.bold,

            fontSize: 15,
          ),
        ),
      ],
    );
  }

  String formatIndianCurrency(dynamic amount) {
  final value = double.tryParse(amount.toString()) ?? 0;

  final formatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '',
    decimalDigits: value % 1 == 0 ? 0 : 2,
  );

  return formatter.format(value).trim();
}
}