import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../../utils/app_config.dart';

class PendingSRLScreen extends StatefulWidget {
  final List<dynamic> srls;

  const PendingSRLScreen({
    super.key,
    required this.srls,
  });

  @override
  State<PendingSRLScreen> createState() =>
      _PendingSRLScreenState();
}

class _PendingSRLScreenState
    extends State<PendingSRLScreen> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F7FA),

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor:
            const Color(0xFF1565C0),

        title: const Text(
          "Pending SRL",
          style: TextStyle(
            color: Colors.white,
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),

      body: ListView.builder(
        padding:
            const EdgeInsets.all(16),

        itemCount:
            widget.srls.length,

        itemBuilder:
            (context, index) {

          final item =
              widget.srls[index];

          return Container(
            margin:
                const EdgeInsets.only(
              bottom: 16,
            ),

            decoration:
                BoxDecoration(
              color: Colors.white,

              borderRadius:
                  BorderRadius.circular(
                20,
              ),

              boxShadow: [
                BoxShadow(
                  color: Colors.black
                      .withOpacity(
                    0.06,
                  ),
                  blurRadius: 12,
                  offset:
                      const Offset(
                    0,
                    4,
                  ),
                ),
              ],
            ),

            child: Padding(
              padding:
                  const EdgeInsets.all(
                18,
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [

                  /// HEADER
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,

                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                    children: [

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                          children: [

                            Text(
                              "Order No. #${item["ORDERNO"]}",

                              style:
                                  const TextStyle(
                                fontSize:
                                    20,

                                fontWeight:
                                    FontWeight
                                        .w700,

                                color:
                                    Color(
                                  0xFF1E293B,
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 4,
                            ),

                            Text(
                              item["CUSTOMERNAME"]
                                      ?.toString() ??
                                  "",

                              style:
                                  const TextStyle(
                                color:
                                    Colors.grey,

                                fontSize:
                                    13,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        padding:
                            const EdgeInsets
                                .symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),

                        decoration:
                            BoxDecoration(
                          color: Colors
                              .orange
                              .shade100,

                          borderRadius:
                              BorderRadius
                                  .circular(
                            20,
                          ),
                        ),

                        child:
                            const Row(
                          mainAxisSize:
                              MainAxisSize
                                  .min,

                          children: [

                            Icon(
                              Icons
                                  .schedule,
                              size: 14,
                              color: Colors
                                  .orange,
                            ),

                            SizedBox(
                              width: 4,
                            ),

                            Text(
                              "Pending",

                              style:
                                  TextStyle(
                                fontWeight:
                                    FontWeight
                                        .w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const Divider(
                    height: 28,
                  ),

                  infoRow(
                    "Order Date",
                    item["ODATE"]
                            ?.toString() ??
                        "",
                  ),

                  infoRow(
                    "Product",
                    item["PRODNAME"]
                            ?.toString() ??
                        "",
                  ),

                  infoRow(
                    "Qty",
                    item["QTY"]
                            ?.toString() ??
                        "",
                  ),

                  infoRow(
                    "Actual Rate",
                    "₹ ${item["ActualRate"]}",
                  ),

                  infoRow(
                    "Requested Rate",
                    "₹ ${item["Rate"]}",
                  ),

                  infoRow(
                    "Order Value",
                    "₹ ${item["ORDERVALUE"]}",
                  ),

                  infoRow(
                    "Total Outstanding",
                    item["TOTALOUTSTANDING"]
                            ?.toString() ??
                        "",
                  ),

                  infoRow(
                    "Due Amount",
                    item["TOTALDUEAMT"]
                            ?.toString() ??
                        "",
                  ),

                  infoRow(
                    "Over Due Days",
                    item["OVERDUEDAYS"]
                            ?.toString() ??
                        "",
                  ),

                  infoRow(
                    "Validity",
                    item["validtill"]
                            ?.toString() ??
                        "",
                  ),

                  infoRow(
                    "User",
                    item["USERNAME"]
                            ?.toString() ??
                        "",
                  ),

                  infoRow(
                    "Reason",
                    item["REASON"]
                            ?.toString() ??
                        "",
                  ),

                  const SizedBox(
                    height: 18,
                  ),

Row(
  children: [

    /// REJECT BUTTON (LEFT)
    Expanded(
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFEF4444),
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(14),
          ),
        ),

        onPressed: () async {
          try {

            final result =
                await ApiService.rejectSRL(
              databaseName:
                  AppConfig.databaseName,
              userId:
                  AppConfig.userId,
              srlUnq:
                  item["SRLUNQ"]
                      .toString(),
            );

            if (result["success"] == true) {

              ScaffoldMessenger.of(context)
                  .showSnackBar(
                const SnackBar(
                  content: Text(
                    "Rejected Successfully",
                  ),
                  backgroundColor:
                      Colors.red,
                ),
              );

              setState(() {
                widget.srls.removeAt(index);
              });

            } else {

              ScaffoldMessenger.of(context)
                  .showSnackBar(
                SnackBar(
                  content: Text(
                    result["message"] ??
                        "Reject Failed",
                  ),
                ),
              );
            }

          } catch (e) {

            ScaffoldMessenger.of(context)
                .showSnackBar(
              SnackBar(
                content: Text(
                  e.toString(),
                ),
              ),
            );
          }
        },

        icon: const Icon(
          Icons.cancel_outlined,
        ),

        label: const Text(
          "Reject",
        ),
      ),
    ),

    const SizedBox(width: 12),

    /// APPROVE BUTTON (RIGHT)
    Expanded(
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              const Color(0xFF16A34A),
          foregroundColor:
              Colors.white,
          elevation: 0,
          padding:
              const EdgeInsets.symmetric(
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(14),
          ),
        ),

        onPressed: () async {

          try {

            final result =
                await ApiService.approveSRL(
              databaseName:
                  AppConfig.databaseName,
              userId:
                  AppConfig.userId,
              srlUnq:
                  item["SRLUNQ"]
                      .toString(),
            );

            if (result["success"] == true) {

              ScaffoldMessenger.of(context)
                  .showSnackBar(
                const SnackBar(
                  content: Text(
                    "Approved Successfully",
                  ),
                  backgroundColor:
                      Colors.green,
                ),
              );

              setState(() {
                widget.srls.removeAt(index);
              });

            } else {

              ScaffoldMessenger.of(context)
                  .showSnackBar(
                SnackBar(
                  content: Text(
                    result["message"] ??
                        "Approval Failed",
                  ),
                ),
              );
            }

          } catch (e) {

            ScaffoldMessenger.of(context)
                .showSnackBar(
              SnackBar(
                content: Text(
                  e.toString(),
                ),
              ),
            );
          }
        },

        icon: const Icon(
          Icons.check_circle_outline,
        ),

        label: const Text(
          "Approve",
        ),
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
);
}

Widget infoRow(
  String title,
  String value,
) {
  return Padding(
    padding:
        const EdgeInsets.symmetric(
      vertical: 6,
    ),

    child: Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        SizedBox(
          width: 145,
          child: Text(
            title,
            style:
                const TextStyle(
              fontWeight:
                  FontWeight.w600,
              color:
                  Color(0xFF334155),
              fontSize: 14,
            ),
          ),
        ),

        const Text(
          ": ",
          style: TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),

        Expanded(
          child: Text(
            value,
            style:
                const TextStyle(
              fontSize: 14,
              color:
                  Color(0xFF475569),
            ),
          ),
        ),
      ],
    ),
  );
}
}