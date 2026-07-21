import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../utils/app_config.dart';
import '../branch/branch_selection_screen.dart';
import '../notification/notification_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import '../chat/chat_users_screen.dart';
import '../dashboard/due_customers_screen.dart';
import '../dashboard/growth_analysis_screen.dart';
import '../dashboard/today_sales_screen.dart';
import '../dashboard/customer_followup_screen.dart';
import '../dashboard/lost_customers_screen.dart';
import '../dashboard/category_target_screen.dart';
import '../dashboard/customer_health_details_screen.dart';
import '../dashboard/category_decline_screen.dart';
import '../enquiry/enquiry_screen.dart';

class SalesDashboardScreen extends StatefulWidget {
  const SalesDashboardScreen({super.key});

  @override
  State<SalesDashboardScreen> createState() =>
      _SalesDashboardScreenState();
}

class _SalesDashboardScreenState
    extends State<SalesDashboardScreen> {
Map<String, dynamic> dashboard = {};
List<dynamic> monthlyTrend = [];
List<dynamic> topDueCustomers = [];
List topDueCustomersByDueDays = [];
List<dynamic> todaySalesList = [];
List<dynamic> categoryDeclineList = [];
List<dynamic> categoryTargetList = [];
double mtdSales = 0;
double todaySales = 0;

int totalCustomers = 0;
int totalChallans = 0;

double mtdgrowthPercent = 0;
double dueAmount = 0;
double currentMTD = 0;
double lastMTD = 0;
double currentQty = 0;
double avgLast3MonthsQty = 0;
double targetQty = 0;
double remainingQty = 0;
double excessQty = 0;
double achievementPercent = 0;
double mtdTarget = 0;

double ytdgrowthPercent = 0;
double currentYTD = 0;
double lastYTD = 0;

double currentQuarter = 0;
double previousQuarter = 0;
double quarterGrowthPercent = 0;

int newCustomers = 0;
int repeatCustomers = 0;
int retentionCustomers = 0;
int lostCustomers = 0;

int criticalCount = 0;
int needsPushCount = 0;
int onTrackCount = 0;
int targetAchievedCount = 0;


bool loading = true;

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
void initState() {
  super.initState();
   if (AppConfig.designation.toUpperCase() == "ADMINISTRATOR") {
    setState(() {
      loading = false;
    });
    return;
  }
  loadDashboard();
  loadCustomerHealth();
  loadCategoryDecline();
  loadCategoryTarget();
}

Future<void> loadDashboard() async {

  try {

    final data =
        await ApiService.getSalesDashboard(
      databaseName: AppConfig.databaseName,
      userId: AppConfig.userId,
    );

    setState(() {

      dashboard = data;

      mtdSales =
          double.tryParse(
            data["MTDSALES"].toString(),
          ) ??
          0;

      currentQty = double.tryParse(
        data["CurrentQty"].toString()) ??
    0;

      avgLast3MonthsQty = double.tryParse(
        data["avgLast3MonthsQty"].toString()) ??
    0;

      targetQty = double.tryParse(
        data["TargetQty"].toString()) ??
    0;
    
      remainingQty = double.tryParse(
        data["RemainingQty"].toString()) ??
    0;

    excessQty = double.tryParse(
        data["ExcessQty"].toString()) ??
    0;

    achievementPercent = double.tryParse(
        data["AchievementPercent"].toString()) ??
    0;

    todaySales =
          double.tryParse(
            data["TODAYSALES"].toString(),
          ) ??
          0;

    dueAmount =
    double.tryParse(
      data["DUEAMOUNT"].toString(),
    ) ??
    0;

    totalChallans =
          int.tryParse(
            data["TOTALCHALLANS"].toString(),
          ) ??
          0;

    totalCustomers =
          int.tryParse(
            data["CUSTOMERS"].toString(),
          ) ??
          0;

 

      monthlyTrend =
    data["MONTHLYTREND"] ?? [];

      topDueCustomers = data["TOPDUECUSTOMERS"] ?? [];
      topDueCustomersByDueDays = data["TOPDUECUSTOMERSBYDUEDAYS"] ?? [];

  currentMTD =
    double.tryParse(
      data["CURRENTMTD"].toString(),
    ) ??
    0;

lastMTD =
    double.tryParse(
      data["LASTMTD"].toString(),
    ) ??
    0;

mtdgrowthPercent =
    double.tryParse(
      data["MTDGROWTHPERCENT"].toString(),
    ) ??
    0;


// ========================================
// QUARTER
// ========================================

currentQuarter =
    double.tryParse(
      data["CURRENTQTD"].toString(),
    ) ??
    0;

previousQuarter =
    double.tryParse(
      data["LASTQTD"].toString(),
    ) ??
    0;

quarterGrowthPercent =
    double.tryParse(
      data["QTDGROWTHPERCENT"].toString(),
    ) ??
    0;


// ========================================
// FINANCIAL YEAR
// ========================================

currentYTD =
    double.tryParse(
      data["CURRENTYTD"].toString(),
    ) ??
    0;

lastYTD =
    double.tryParse(
      data["LASTYTD"].toString(),
    ) ??
    0;

ytdgrowthPercent =
    double.tryParse(
      data["YTDGROWTHPERCENT"].toString(),
    ) ??
    0;

      todaySalesList = data["TODAYSALESLIST"] ?? [];
      categoryDeclineList = data["CATEGORY_DECLINE"] ?? [];

      loading = false;
    });
  }
  catch (e) {

    setState(() {
      loading = false;
    });
  }
}

Future<void> loadCustomerHealth() async {

  final data = await ApiService.getCustomerHealth(

    databaseName: AppConfig.databaseName,

    userId: AppConfig.userId,

  );

  setState(() {

    //totalCustomers_health = data["TotalCustomers"] ?? 0;

    newCustomers = data["NewCustomers"] ?? 0;

    repeatCustomers = data["RepeatCustomers"] ?? 0;

    retentionCustomers =
        data["ReactivatedCustomers"] ?? 0;

    lostCustomers = data["LostCustomers"] ?? 0;

  });

}

Future<void> loadCategoryDecline() async {

  final categoryData  = await ApiService.getCategoryDecline(

    databaseName: AppConfig.databaseName,

    userId: AppConfig.userId,

  );

  setState(() {
  categoryDeclineList = categoryData;

  });

}

Future<void> loadCategoryTarget() async {

  final data = await ApiService.getCategoryTargets(

    databaseName: AppConfig.databaseName,

    userId: AppConfig.userId,

  );

  setState(() {

    categoryTargetList = data["list"];

    final summary = data["summary"];

    criticalCount = summary["CriticalCount"] ?? 0;

    needsPushCount = summary["NeedsPushCount"] ?? 0;

    onTrackCount = summary["OnTrackCount"] ?? 0;

    targetAchievedCount =
        summary["TargetAchievedCount"] ?? 0;

  });

}
@override
Widget build(BuildContext context) {

  if (loading) {

    return const Scaffold(

      body: Center(

        child:
            CircularProgressIndicator(),
      ),
    );
  }
  

  return Scaffold(

    backgroundColor:
        const Color(0xFFF8FAFC),

body: AppConfig.designation.toUpperCase() == "ADMINISTRATOR"

    ? SafeArea(
        child: Column(
          children: [

            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [

                    Icon(
                      Icons.admin_panel_settings,
                      size: 90,
                      color: Colors.blue,
                    ),

                    SizedBox(height: 20),

                    Text(
                      "Administrator Dashboard",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 8),

                    Text(
                      "Company Dashboard Coming Soon",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),

                  ],
                ),
              ),
            ),

            _buildQuickActionsBar(),

          ],
        ),
      )

    : SafeArea(
        child: Column(
          children: [

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [

                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                      child: _buildHeroCard(),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildStatsGrid(),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildCustomerHealth(),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: _buildSalesTrend(),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildLostCustomersCard(),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildCategoryAlertCard(),
                    ),

                    const SizedBox(height: 20),

                  ],
                ),
              ),
            ),

            _buildQuickActionsBar(),

          ],
        ),
      ),
  );
}


Widget _buildHeroCard() {
  String status;

  if (achievementPercent >= 100) {
    status = "🏆 Target Achieved";
  } else if (achievementPercent >= 75) {
    status = "🚀 On Track";
  } else if (achievementPercent >= 50) {
    status = "⚡ Needs Push";
  } else {
    status = "⚠ Critical";
  }

  return InkWell(
    borderRadius: BorderRadius.circular(20),

    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const CategoryTargetScreen(),
        ),
      );
    },

    child: Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),

        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF243B55),
            Color(0xFF141E30),
          ],
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          // =========================
          // TITLE
          // =========================

          const Row(
            children: [
              Expanded(
                child: Text(
                  "MONTH TO DATE SALES",
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),

              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white70,
                size: 16,
              ),
            ],
          ),

          const SizedBox(height: 8),

          // =========================
          // MTD SALES
          // =========================

          Text(
            "₹ ${formatAmount(mtdSales)}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 18),

          const Divider(
            color: Colors.white24,
            height: 1,
          ),

          const SizedBox(height: 12),

          // =========================
          // TARGET STATUS
          // =========================

          Container(
            padding: const EdgeInsets.all(12),

            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.08),
              borderRadius: BorderRadius.circular(12),
            ),

            child: Column(
              children: [

                // STATUS

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Text(
                    status,
                    style: const TextStyle(
                      color: Color(0xFF243B55),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // COUNTERS

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,

                  children: [

                    Expanded(
                      child: _heroCounter(
                        "Critical",
                        criticalCount,
                        Icons.warning_amber_rounded,
                        Colors.redAccent,
                      ),
                    ),

                    Expanded(
                      child: _heroCounter(
                        "Push",
                        needsPushCount,
                        Icons.trending_up,
                        Colors.orangeAccent,
                      ),
                    ),

                    Expanded(
                      child: _heroCounter(
                        "Track",
                        onTrackCount,
                        Icons.show_chart,
                        Colors.lightBlueAccent,
                      ),
                    ),

                    Expanded(
                      child: _heroCounter(
                        "Achieved",
                        targetAchievedCount,
                        Icons.emoji_events,
                        Colors.greenAccent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // =========================
          // GROWTH
          // =========================

          Row(
            children: [

              Icon(
                mtdgrowthPercent >= 0
                    ? Icons.trending_up
                    : Icons.trending_down,
                color: Colors.white,
                size: 18,
              ),

              const SizedBox(width: 6),

              Text(
                "${mtdgrowthPercent.toStringAsFixed(2)}%",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              const SizedBox(width: 6),

              Text(
                mtdgrowthPercent >= 0
                    ? "Growth vs Last Month"
                    : "Decline vs Last Month",
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

 Widget _buildStatsGrid() {

  return GridView.count(

    shrinkWrap: true,

    physics:
        const NeverScrollableScrollPhysics(),

    crossAxisCount: 2,

    crossAxisSpacing: 10,

    mainAxisSpacing: 10,

    childAspectRatio: 1.28,

    children: [

     InkWell(
  onTap: () {

    Navigator.push(

      context,

      MaterialPageRoute(

        builder: (_) => TodaySalesScreen(
          sales: todaySalesList,
        ),
      ),
    );
  },

  child: _statCard(
    "Today Sales",
    "₹ ${formatAmount(todaySales)}",
    Icons.currency_rupee,
    const Color(0xFFEFF6FF),
    Colors.blue,
  ),
),

     InkWell(
  onTap: () {

    Navigator.push(

      context,

      MaterialPageRoute(

        builder: (_) => DueCustomersScreen(

          customers: topDueCustomers,

          topDueCustomersByDueDays:
              topDueCustomersByDueDays,
        ),
      ),
    );
  },

  child: _statCard(

    "Due Amount",

    "₹ ${formatAmount(dueAmount)}",

    Icons.account_balance_wallet,

    const Color(0xFFFFF3E0),

    Colors.deepOrange,
  ),
),

      _statCard(
        "Challans",
        totalChallans.toString(),
        Icons.receipt_long,
        const Color(0xFFFFFBEB),
        Colors.orange,
      ),

     InkWell(
  onTap: () {

    Navigator.push(

      context,

      MaterialPageRoute(

        builder: (_) => GrowthAnalysisScreen(

         currentMTD: currentMTD,
         lastMTD: lastMTD,
         mtdgrowthPercent: mtdgrowthPercent,

          currentQuarter: currentQuarter,
          previousQuarter: previousQuarter,
          quarterGrowthPercent: quarterGrowthPercent,

         currentYTD: currentYTD,
         lastYTD: lastYTD,
         ytdgrowthPercent: ytdgrowthPercent,
        ),
      ),
    );
  },

  child: _statCard(
    mtdgrowthPercent >= 0 ? "Growth" : "Decline",
    "${mtdgrowthPercent.toStringAsFixed(2)}%",
    mtdgrowthPercent >= 0
        ? Icons.trending_up
        : Icons.trending_down,
    const Color(0xFFFEF2F2),
    mtdgrowthPercent >= 0
        ? Colors.green
        : Colors.red,
  ),
),
    ],
  );
}

Widget _statCard(
  String title,
  String value,
  IconData icon,
  Color bgColor,
  Color iconColor,
) {

  return Container(

    padding: const EdgeInsets.all(12),

    decoration: BoxDecoration(

      color: bgColor,

      borderRadius:
          BorderRadius.circular(20),
    ),

    child: Column(

      crossAxisAlignment:
          CrossAxisAlignment.start,

      mainAxisAlignment:
          MainAxisAlignment.center,

      children: [

        Icon(
          icon,
          color: iconColor,
          size: 30,
        ),

        const SizedBox(height: 12),

        Text(

          value,

          style: const TextStyle(

            fontSize: 20,

            fontWeight:
                FontWeight.bold,
          ),
        ),

        const SizedBox(height: 4),

        Text(title),
      ],
    ),
  );
}


Widget _buildQuickActionsBar() {
  return Container(
    height: 62,
    decoration: const BoxDecoration(
      color: Colors.white,
      border: Border(
        top: BorderSide(
          color: Color(0xffECECEC),
        ),
      ),
    ),
   child: Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    if (AppConfig.canApprove)
    _bottomMenu(
      icon: Icons.approval_outlined,
      title: "Approval",
      selected: true,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const BranchSelectionScreen(),
          ),
        );
      },
    ),

    _bottomMenu(
      icon: Icons.notifications_none,
      title: "Alerts",
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const NotificationScreen(),
          ),
        );
      },
    ),

    _bottomMenu(
      icon: Icons.support_agent_outlined,
      title: "Enquiry",
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const EnquiryScreen(),
          ),
        );
      },
    ),

    _bottomMenu(
      icon: Icons.chat_bubble_outline,
      title: "Chat",
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ChatUsersScreen(),
          ),
        );
      },
    ),
  ],
),
  );
}

Widget _bottomMenu({
  required IconData icon,
  required String title,
  required VoidCallback onTap,
  bool selected = false,
}) {
  final Color color =
      selected ? const Color(0xff2F80ED) : Colors.grey.shade700;

  return InkWell(
    onTap: onTap,
    child: SizedBox(
      width: 70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Icon(
            icon,
            color: color,
            size: 22,
          ),

          const SizedBox(height: 4),

          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight:
                  selected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),

          const SizedBox(height: 3),

          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 3,
            width: selected ? 18 : 0,
            decoration: BoxDecoration(
              color: const Color(0xff2F80ED),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildSalesTrend() {
  if (monthlyTrend.isEmpty) {
    return const SizedBox();
  }

  double maxSales = 0;

  for (var item in monthlyTrend) {
    final current =
        double.tryParse(item["CurrentFY"].toString()) ?? 0;

    final previous =
        double.tryParse(item["PreviousFY"].toString()) ?? 0;

    if (current > maxSales) maxSales = current;
    if (previous > maxSales) maxSales = previous;
  }

  // Prevent maxY = 0
  if (maxSales <= 0) {
    maxSales = 100000;
  }

  return Container(
    width: double.infinity,

    padding: const EdgeInsets.fromLTRB(
      14,
      12,
      10,
      10,
    ),

    decoration: BoxDecoration(
      color: Colors.white,

      // Smaller radius gives more rectangular appearance
      borderRadius: BorderRadius.circular(16),

      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 8,
          offset: Offset(0, 3),
        ),
      ],
    ),

    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        /// TITLE
        const Text(
          "Monthly Sales Trend",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 8),

        /// LEGEND
        Row(
          children: [
            Container(
              width: 16,
              height: 3,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(width: 5),

            const Text(
              "Current FY",
              style: TextStyle(
                fontSize: 12,
                color: Colors.black87,
              ),
            ),

            const SizedBox(width: 18),

            Container(
              width: 16,
              height: 3,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(width: 5),

            const Text(
              "Previous FY",
              style: TextStyle(
                fontSize: 12,
                color: Colors.black87,
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        /// COMPACT RECTANGULAR CHART
        SizedBox(
          height: 170,
          width: double.infinity,

          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: (monthlyTrend.length - 1).toDouble(),

              minY: 0,
              maxY: maxSales * 1.12,

              /// GRID
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                horizontalInterval: maxSales / 3,
                verticalInterval: 1,

                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.blueGrey.withOpacity(0.20),
                    strokeWidth: 1,
                    dashArray: [5, 5],
                  );
                },

                getDrawingVerticalLine: (value) {
                  return FlLine(
                    color: Colors.blueGrey.withOpacity(0.16),
                    strokeWidth: 1,
                    dashArray: [5, 5],
                  );
                },
              ),

              borderData: FlBorderData(
                show: false,
              ),

              /// TOOLTIP
              lineTouchData: LineTouchData(
                handleBuiltInTouches: true,

                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (spots) {
                    return spots.map((spot) {
                      final index = spot.x.toInt();

                      if (index < 0 ||
                          index >= monthlyTrend.length) {
                        return null;
                      }

                      final row = monthlyTrend[index];

                      final fyName = spot.barIndex == 0
                          ? "Current FY"
                          : "Previous FY";

                      return LineTooltipItem(
                        "${row["MonthName"]}\n"
                        "$fyName\n"
                        "₹ ${formatAmount(spot.y)}",
                        const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    }).toList();
                  },
                ),
              ),

              /// TITLES
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  ),
                ),

                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  ),
                ),

                /// LEFT SALES VALUE
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 38,
                    interval: maxSales / 3,

                    getTitlesWidget: (value, meta) {
                      return SideTitleWidget(
                        meta: meta,

                        child: Text(
                          "${(value / 100000).toStringAsFixed(0)}L",
                          style: const TextStyle(
                            fontSize: 9,
                            color: Colors.black54,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                /// MONTHS
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 24,
                    interval: 1,

                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();

                      if (index < 0 ||
                          index >= monthlyTrend.length) {
                        return const SizedBox();
                      }

                      return SideTitleWidget(
                        meta: meta,

                        child: Padding(
                          padding: const EdgeInsets.only(top: 5),

                          child: Text(
                            monthlyTrend[index]["MonthName"]
                                .toString(),

                            style: const TextStyle(
                              fontSize: 9,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              /// LINES
              lineBarsData: [
                /// CURRENT FY
                LineChartBarData(
                  isCurved: true,

                  curveSmoothness: 0.25,

                  color: Colors.blue,

                  barWidth: 3,

                  isStrokeCapRound: true,

                  dotData: FlDotData(
                    show: true,

                    getDotPainter: (
                      spot,
                      percent,
                      barData,
                      index,
                    ) {
                      return FlDotCirclePainter(
                        radius: 3,
                        color: Colors.blue,
                        strokeWidth: 0,
                      );
                    },
                  ),

                  belowBarData: BarAreaData(
                    show: false,
                  ),

                  spots: List.generate(
                    monthlyTrend.length,
                    (i) => FlSpot(
                      i.toDouble(),
                      double.tryParse(
                            monthlyTrend[i]["CurrentFY"]
                                .toString(),
                          ) ??
                          0,
                    ),
                  ),
                ),

                /// PREVIOUS FY
                LineChartBarData(
                  isCurved: true,

                  curveSmoothness: 0.25,

                  color: Colors.orange,

                  barWidth: 2.5,

                  dashArray: [7, 4],

                  isStrokeCapRound: true,

                  dotData: FlDotData(
                    show: true,

                    getDotPainter: (
                      spot,
                      percent,
                      barData,
                      index,
                    ) {
                      return FlDotCirclePainter(
                        radius: 3,
                        color: Colors.orange,
                        strokeWidth: 0,
                      );
                    },
                  ),

                  belowBarData: BarAreaData(
                    show: false,
                  ),

                  spots: List.generate(
                    monthlyTrend.length,
                    (i) => FlSpot(
                      i.toDouble(),
                      double.tryParse(
                            monthlyTrend[i]["PreviousFY"]
                                .toString(),
                          ) ??
                          0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
/* Widget _buildCustomerFollowUp() {
  return InkWell(
    borderRadius: BorderRadius.circular(20),

    onTap: () async {

      final customers =
          await ApiService.getCustomerFollowUp(
        databaseName: AppConfig.databaseName,
        userId: AppConfig.userId,
      );

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CustomerFollowUpScreen(
            customers: customers,
          ),
        ),
      );
    },

    child: Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
          )
        ],
      ),

      child: Row(
        children: [

          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.red.shade50,
            child: const Icon(
              Icons.support_agent,
              color: Colors.red,
              size: 30,
            ),
          ),

          const SizedBox(width: 15),

          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  "Customer Follow-up",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 5),

                Text(
                  "Customers with reduced purchases.\nTap to view details.",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          const Icon(Icons.arrow_forward_ios),
        ],
      ),
    ),
  );
} */

Widget _buildLostCustomersCard() {

  return InkWell(

    borderRadius: BorderRadius.circular(20),

    onTap: () async {

      final customers =
          await ApiService.getLostCustomers(

        databaseName: AppConfig.databaseName,

        userId: AppConfig.userId,

        filter: "ALL",
      );

      if (!mounted) return;

      Navigator.push(

        context,

        MaterialPageRoute(

          builder: (_) => LostCustomersScreen(

            customers: customers,
          ),
        ),
      );
    },

    child: Container(

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius: BorderRadius.circular(20),

        boxShadow: const [

          BoxShadow(

            color: Colors.black12,

            blurRadius: 10,
          ),
        ],
      ),

      child: Row(

        children: [

          CircleAvatar(

            radius: 28,

            backgroundColor: Colors.deepOrange.shade50,

            child: const Icon(

              Icons.person_off,

              color: Colors.deepOrange,

              size: 30,
            ),
          ),

          const SizedBox(width: 15),

          const Expanded(

            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(

                  "Customer Re-Engagement",

                  style: TextStyle(

                    fontSize: 18,

                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 5),

                Text(

                  "Inactive customer-product combinations.\nTap to view details.",

                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.arrow_forward_ios,
          ),
        ],
      ),
    ),
  );
}

Widget _buildCustomerHealth() {
  return Container(
    margin: const EdgeInsets.only(top: 16),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      gradient: const LinearGradient(
        colors: [
          Color(0xffF7F9FC),
          Color(0xffEEF5FF),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.08),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const Text(
          "Customer Health",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 16),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            _healthItem(
              icon: Icons.person_add_alt_1,
              color: Colors.green,
              title: "New",
              count: newCustomers,
              type: "NEW",
            ),

            _healthItem(
              icon: Icons.people,
              color: Colors.blue,
              title: "Key/Top",
              count: repeatCustomers,
              type: "REPEAT",
            ),

            _healthItem(
              icon: Icons.refresh,
              color: Colors.orange,
              title: "Retention",
              count: retentionCustomers,
              type: "RETENTION",
            ),

            _healthItem(
              icon: Icons.person_off,
              color: Colors.red,
              title: "Lost",
              count: lostCustomers,
              type: "LOST",
            ),
          ],
        ),
      ],
    ),
  );
}
Widget _healthItem({

  required IconData icon,
  required Color color,
  required String title,
  required int count,
  required String type,

}) {

  return InkWell(

    borderRadius: BorderRadius.circular(16),

onTap: () async {

 
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => PopScope(
      canPop: false,
      child: Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              CircularProgressIndicator(),

              SizedBox(height: 20),

              Text(
                "Loading customers...",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),

            ],
          ),
        ),
      ),
    ),
  );

  try {

    final customers =
        await ApiService.getCustomerHealthDetails(
      databaseName: AppConfig.databaseName,
      userId: AppConfig.userId,
      type: type,
    );

   

    if (!context.mounted) return;

    Navigator.of(
      context,
      rootNavigator: true,
    ).pop();

   
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CustomerHealthDetailsScreen(
          title: title,
          customers: customers,
        ),
      ),
    );

  } catch (e) {

    if (!context.mounted) return;

    Navigator.of(
      context,
      rootNavigator: true,
    ).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.toString()),
      ),
    );
  }
},

    child: Column(
      children: [

        Container(
          height: 62,
          width: 62,
          decoration: BoxDecoration(
            color: color.withOpacity(.12),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: color.withOpacity(.35),
            ),
          ),
          child: Icon(
            icon,
            color: color,
            size: 32,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 2),

        Text(
          "$count",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    ),
  );
}
Widget _divider() {
  return Container(
    width: 1,
    height: 90,
    color: Colors.black12,
  );
}

Widget _buildCategoryAlertCard() {
  if (categoryDeclineList.isEmpty) {
    return const SizedBox();
  }

  return Container(
    margin: const EdgeInsets.only(top: 18),

    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.08),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),

    child: InkWell(
      borderRadius: BorderRadius.circular(20),

      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CategoryDeclineScreen(
              categories: categoryDeclineList,
            ),
          ),
        );
      },

      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),

        child: Row(
          children: [

            // WARNING ICON

            Container(
              width: 46,
              height: 46,

              decoration: BoxDecoration(
                color: Colors.red.withOpacity(.10),
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.warning_amber_rounded,
                color: Colors.redAccent,
                size: 25,
              ),
            ),

            const SizedBox(width: 14),

            // TITLE

            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    "Categories Needing Attention",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 4),

                  Text(
                    "Categories below expected performance",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            // COUNT

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),

              decoration: BoxDecoration(
                color: Colors.redAccent.withOpacity(.10),
                borderRadius: BorderRadius.circular(20),
              ),

              child: Text(
                "${categoryDeclineList.length}",
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(width: 8),

            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.black54,
              size: 17,
            ),
          ],
        ),
      ),
    ),
  );
}


Widget _heroCounter(

  String title,
  int count,
  IconData icon,
  Color iconColor,

) {

  return Column(

    mainAxisSize: MainAxisSize.min,

    children: [

      Icon(
        icon,
        color: iconColor,
        size: 18,
      ),

      const SizedBox(height: 3),

      Text(

        "$count",

        style: const TextStyle(

          color: Colors.white,

          fontSize: 20,

          fontWeight: FontWeight.bold,

        ),

      ),

      const SizedBox(height: 2),

      Text(

        title,

        textAlign: TextAlign.center,

        style: const TextStyle(

          color: Colors.white70,

          fontSize: 10,

          fontWeight: FontWeight.w500,

        ),

      ),

    ],

  );

}


}