import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../../utils/app_config.dart';
import '../challan/pending_challan_screen.dart';
import '../srl/pending_srl_screen.dart';

class BranchSelectionScreen extends StatefulWidget {
  const BranchSelectionScreen({super.key});

  @override
  State<BranchSelectionScreen> createState() =>
      _BranchSelectionScreenState();
}

class _BranchSelectionScreenState
    extends State<BranchSelectionScreen> {
  List<dynamic> counts = [];
  bool loading = true;

  void showLoader() {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withOpacity(0.15),
              blurRadius: 15,
            ),
          ],
        ),
        child: const Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              strokeWidth: 3,
            ),
            SizedBox(height: 16),
            Text(
              "Loading...",
              style: TextStyle(
                fontSize: 15,
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

void hideLoader() {
  if (mounted) {
    Navigator.pop(context);
  }
}

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      counts = await ApiService.getCounts(
        databaseName: AppConfig.databaseName,
      );
    } catch (e) {
      debugPrint(e.toString());
    }

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

 Future<void> onRowTap(dynamic row) async {

  showLoader();

  try {

    AppConfig.branchId =
        row["branchunq"];

    AppConfig.branchName =
        row["Branch"];

    if (row["Document Type"] ==
        "SRL") {

      final srls =
          await ApiService.getPendingSRL(
        databaseName:
            AppConfig.databaseName,

        branchId:
            AppConfig.branchId,
      );

      if (!mounted) return;

      hideLoader();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              PendingSRLScreen(
            srls: srls,
          ),
        ),
      );

    } else {

      final challans =
          await ApiService
              .getPendingChallans(
        databaseName:
            AppConfig.databaseName,

        branchId:
            AppConfig.branchId,
      );

      if (!mounted) return;

      hideLoader();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              PendingChallanScreen(
            challans: challans,
          ),
        ),
      );
    }

  } catch (e) {

    hideLoader();

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content:
            Text(e.toString()),
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F7FB),

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppConfig.selectedCompany,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: loading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : Container(
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black
                        .withOpacity(0.06),
                    blurRadius: 12,
                    offset:
                        const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildHeader(),

                  Expanded(
                    child:
                        ListView.separated(
                      itemCount:
                          counts.length,

                      separatorBuilder:
                          (_, __) =>
                              const Divider(
                        height: 1,
                      ),

                      itemBuilder:
                          (context, index) {
                        final row =
                            counts[index];

                        return InkWell(
                          onTap: () =>
                              onRowTap(
                                  row),

                          child:
                              Container(
                            color:
                                index.isEven
                                    ? Colors
                                        .white
                                    : const Color(
                                        0xFFF8FBFF,
                                      ),

                            padding:
                                const EdgeInsets
                                    .symmetric(
                              horizontal:
                                  12,
                              vertical:
                                  14,
                            ),

                            child: Row(
                              children: [
                                /// BRANCH
                                Expanded(
                                  flex: 5,
                                  child:
                                      Text(
                                    row["Branch"]
                                        .toString(),

                                    style:
                                        const TextStyle(
                                      fontSize:
                                          13,
                                      fontWeight:
                                          FontWeight
                                              .w600,
                                    ),
                                  ),
                                ),

                                /// DOCUMENT
                                Expanded(
                                  flex: 3,
                                  child:
                                      Center(
                                    child:
                                        Container(
                                      padding:
                                          const EdgeInsets.symmetric(
                                        horizontal:
                                            12,
                                        vertical:
                                            6,
                                      ),

                                      decoration:
                                          BoxDecoration(
                                        color: row["Document Type"] ==
                                                "SRL"
                                            ? Colors.orange.shade100
                                            : Colors.green.shade100,

                                        borderRadius:
                                            BorderRadius.circular(
                                          20,
                                        ),
                                      ),

                                      child:
                                          Text(
                                        row["Document Type"],

                                        style:
                                            TextStyle(
                                          fontSize:
                                              12,

                                          fontWeight:
                                              FontWeight.bold,

                                          color: row["Document Type"] ==
                                                  "SRL"
                                              ? Colors.orange.shade900
                                              : Colors.green.shade900,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                /// COUNT
                                Expanded(
                                  flex: 2,
                                  child:
                                      Text(
                                    row["TotalCount"]
                                        .toString(),

                                    textAlign:
                                        TextAlign
                                            .center,

                                    style:
                                        const TextStyle(
                                      color:
                                          Color(
                                        0xFF1A56DB,
                                      ),

                                      fontSize:
                                          20,

                                      fontWeight:
                                          FontWeight
                                              .bold,
                                    ),
                                  ),
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
            ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration:
          const BoxDecoration(
        gradient:
            LinearGradient(
          colors: [
            Color(0xFF0D3F8A),
            Color(0xFF2C6CE0),
          ],
        ),

        borderRadius:
            BorderRadius.only(
          topLeft:
              Radius.circular(16),
          topRight:
              Radius.circular(16),
        ),
      ),

      padding:
          const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 14,
      ),

      child: const Row(
        children: [
          Expanded(
            flex: 5,
            child: Text(
              "Branch",
              style: TextStyle(
                color: Colors.white,
                fontWeight:
                    FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),

          Expanded(
            flex: 3,
            child: Text(
              "Document",
              textAlign:
                  TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight:
                    FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),

          Expanded(
            flex: 2,
            child: Text(
              "Count",
              textAlign:
                  TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight:
                    FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}