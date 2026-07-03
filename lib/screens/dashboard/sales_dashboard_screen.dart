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

int newCustomers = 0;
int repeatCustomers = 0;
int retentionCustomers = 0;
int lostCustomers = 0;


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
  loadDashboard();
  loadCustomerHealth();
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

      currentMTD =double.tryParse(data["CURRENTMTD"].toString()) ?? 0;
      lastMTD =double.tryParse(data["LASTMTD"].toString()) ?? 0;
      mtdgrowthPercent =double.tryParse(data["MTDGROWTHPERCENT"].toString(),) ??0;
      currentYTD =double.tryParse(data["CURRENTYTD"].toString()) ?? 0;
      lastYTD =double.tryParse(data["LASTYTD"].toString()) ?? 0;
      ytdgrowthPercent =double.tryParse(data["YTDGROWTHPERCENT"].toString(),) ??0;

    todaySalesList = data["TODAYSALESLIST"] ?? [];

      loading = false;
    });
  }
  catch (e) {

    debugPrint(e.toString());

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

body: SafeArea(
  child: Column(
    children: [
      Expanded(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            children: [

              Padding(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  8, // increased top padding since header is removed
                  16,
                  12,
                ),
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

/* Widget _buildHeader() {

  return Padding(

    padding: const EdgeInsets.fromLTRB(16,10,16,8),

    child: Row(

      children: [

        const CircleAvatar(

          radius: 22,

          child: Icon(Icons.person),

        ),

        const SizedBox(width:12),

        Expanded(

          child: Column(

            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Text(

                AppConfig.userName,

                style: const TextStyle(

                  fontWeight: FontWeight.bold,

                  fontSize:18,
                ),
              ),

              Text(

                AppConfig.selectedCompany,

                style: TextStyle(

                  color: Colors.grey.shade600,

                  fontSize:13,
                ),
              ),
            ],
          ),
        ),

       
      ],
    ),
  );
} */

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
Color startColor;
Color endColor;

if (achievementPercent >= 100) {
  startColor = const Color(0xFF16A34A); // Green
  endColor   = const Color(0xFF15803D);
} else if (achievementPercent >= 75) {
  startColor = const Color(0xFF2563EB); // Blue
  endColor   = const Color(0xFF1D4ED8);
} else if (achievementPercent >= 50) {
  startColor = const Color(0xFFF59E0B); // Orange
  endColor   = const Color(0xFFD97706);
} else {
  startColor = const Color(0xFFDC2626); // Red
  endColor   = const Color(0xFFB91C1C);
}

  return 
  InkWell(

  borderRadius: BorderRadius.circular(20),

  onTap: () {

    Navigator.push(

      context,

      MaterialPageRoute(

        builder: (_) => const CategoryTargetScreen(),

      ),

    );

  },

  child:Container(

    width: double.infinity,

    padding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 14,
    ),

    decoration: BoxDecoration(

      borderRadius: BorderRadius.circular(20),

      gradient: LinearGradient(

  colors: [

    startColor,

    endColor,
  ],
),
    ),

    child: Column(

      crossAxisAlignment: CrossAxisAlignment.start,

      children: [


       /*  const Text(

          "MONTH TO DATE SALES",

          style: TextStyle(

            color: Colors.white70,

            fontWeight: FontWeight.bold,

            fontSize: 14,
          ),
        ),
 */

 Row(
  children: const [

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

        

Container(

  padding: const EdgeInsets.all(12),

  decoration: BoxDecoration(
    color: Colors.white.withOpacity(.12),
    borderRadius: BorderRadius.circular(12),
  ),

  child: Column(

    children: [

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

          style: TextStyle(

            color: startColor,

            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      const SizedBox(height: 12),

      Row(
        children: [
        

      Expanded(
        child: Column(
          children: [

            const Text(
              "Avg (3M)",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              "${avgLast3MonthsQty.toStringAsFixed(1)}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

           /*  const Text(
              "MT",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 11,
              ),
            ), */
          ],
        ),
      ),

      Container(
        width: 1,
        height: 45,
        color: Colors.white24,
      ),

      Expanded(
        child: Column(
          children: [

            const Text(
              "MTD Qty",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              "${currentQty.toStringAsFixed(1)}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            /* const Text(
              "MT",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 11,
              ),
            ), */
          ],
        ),
      ),

      Container(
        width: 1,
        height: 45,
        color: Colors.white24,
      ),

      Expanded(
        child: Column(
          children: [

            const Text(
              "Target",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              "${targetQty.toStringAsFixed(1)}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

           /*  const Text(
              "MT",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 11,
              ),
            ), */
          ],
        ),
      ),
   
        ],
      ),
    ],
  ),
),

        const SizedBox(height: 14),

        ClipRRect(

          borderRadius: BorderRadius.circular(8),

          child: LinearProgressIndicator(

            value: (achievementPercent / 100)
                .clamp(0.0, 1.0),

            minHeight: 5,

            backgroundColor: Colors.white24,

            valueColor: const AlwaysStoppedAnimation(
              Colors.white,
            ),
          ),
        ),

        const SizedBox(height: 10),

        Row(

          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,

          children: [

            Text(

              "${achievementPercent.toStringAsFixed(1)}% Achieved",

              style: const TextStyle(

                color: Colors.white,

                fontWeight: FontWeight.bold,
              ),
            ),

            Text(

              currentQty >= targetQty
      ? "Exceeded by ${excessQty.toStringAsFixed(2)} MT"
      : "Remaining ${remainingQty.toStringAsFixed(2)} MT",

  style: const TextStyle(
    color: Colors.white70,
              ),
            ),

          ],
        ),

        const SizedBox(height: 10),

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

    double maxSales = monthlyTrend
      .map((e) => double.parse(e["SALES"].toString()))
      .reduce((a, b) => a > b ? a : b);

  return Container(

    padding: const EdgeInsets.all(16),

    decoration: BoxDecoration(

      color: Colors.white,

      borderRadius:
          BorderRadius.circular(24),

      boxShadow: [

        BoxShadow(

          color:
              Colors.black12,

          blurRadius: 12,
        )
      ],
    ),

    child: Column(

      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        const Text(

          "Monthly Sales Trend",

          style: TextStyle(

            fontSize: 18,

            fontWeight:
                FontWeight.bold,
          ),
        ),

        const SizedBox(height: 20),

        SizedBox(

          height: 260,

        child: BarChart(

  BarChartData(

    alignment: BarChartAlignment.spaceAround,

    maxY: monthlyTrend
        .map((e) => double.parse(e["SALES"].toString()))
        .reduce((a, b) => a > b ? a : b) *
        1.2,

    gridData: const FlGridData(show: true),

    borderData: FlBorderData(show: false),

    barTouchData: BarTouchData(

      enabled: true,

      touchTooltipData: BarTouchTooltipData(

        tooltipRoundedRadius: 10,

        getTooltipItem: (group, groupIndex, rod, rodIndex) {

          return BarTooltipItem(

            "${monthlyTrend[group.x]["MONTHNAME"]}\n"
            "₹ ${formatAmount(rod.toY)}",

            const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          );
        },
      ),
    ),

    titlesData: FlTitlesData(

      topTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),

      rightTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),

      leftTitles: AxisTitles(

        sideTitles: SideTitles(

          showTitles: true,

          reservedSize: 40,

          getTitlesWidget: (value, meta) {

            return Text(

              "${(value / 100000).toStringAsFixed(0)}L",

              style: const TextStyle(fontSize: 10),
            );
          },
        ),
      ),

      bottomTitles: AxisTitles(

        sideTitles: SideTitles(

          showTitles: true,

          getTitlesWidget: (value, meta) {

            if (value >= monthlyTrend.length) {
              return const SizedBox();
            }

            return Padding(

              padding: const EdgeInsets.only(top: 8),

              child: Text(

                monthlyTrend[value.toInt()]["MONTHNAME"]
                    .toString()
                    .substring(0, 3),

                style: const TextStyle(fontSize: 11),
              ),
            );
          },
        ),
      ),
    ),

    barGroups: List.generate(

      monthlyTrend.length,

      (index) {

        return BarChartGroupData(

          x: index,

          barRods: [
BarChartRodData(

  toY: double.parse(
    monthlyTrend[index]["SALES"].toString(),
  ),

  width: 22,

  color: double.parse(
            monthlyTrend[index]["SALES"].toString(),
          ) ==
          maxSales
      ? Colors.green
      : index == monthlyTrend.length - 1
          ? Colors.orange
          : Colors.blue.shade400,

  borderRadius: const BorderRadius.only(
    topLeft: Radius.circular(8),
    topRight: Radius.circular(8),
  ),
),
          ],
        );
      },
    ),
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
              title: "Repeat",
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

    borderRadius: BorderRadius.circular(18),

    onTap: () async {

      final customers =
          await ApiService.getCustomerHealthDetails(

        databaseName: AppConfig.databaseName,

        userId: AppConfig.userId,

        type: type,
      );

      if (!mounted) return;

      Navigator.push(

        context,

        MaterialPageRoute(

          builder: (_) => CustomerHealthDetailsScreen(

            title: title,

            customers: customers,
          ),
        ),
      );
    },

    child: SizedBox(

      width: 78,

      child: Column(

        children: [

          Container(
  height: 62,
  width: 62,
  decoration: BoxDecoration(
    color: color.withOpacity(.12),
    borderRadius: BorderRadius.circular(18),
    border: Border.all(
      color: color.withOpacity(.25),
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

            textAlign: TextAlign.center,

            style: const TextStyle(

              fontWeight: FontWeight.w600,

              fontSize: 14,
            ),
          ),

          const SizedBox(height: 2),

          Text(

            count.toString(),

            style: TextStyle(

              color: color,

              fontWeight: FontWeight.bold,

              fontSize: 18,
            ),
          ),
        ],
      ),
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


}