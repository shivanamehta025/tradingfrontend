import 'dart:html' as html;

class NotificationService {
  static Future<void> initialize() async {
    if (!html.Notification.supported) return;

    if (html.Notification.permission == 'default') {
      await html.Notification.requestPermission();
    }
  }

  static Future<void> showPendingChallanNotifications(
    List<Map<String, dynamic>> rows,
    {int? totalCount}
  ) async {
    await initialize();

    final count = totalCount ?? rows.length;
    if (count == 0 || html.Notification.permission != 'granted') return;

    html.Notification(
      '$count Pending Challan',
      body: 'Open MyAutoShop to review pending challans',
      icon: 'icons/Icon-192.png',
    );

    for (final row in rows) {
      final challanNo = row['sp_468']?.toString() ?? '-';
      final customer = row['sp_469']?.toString() ?? 'Customer';

      html.Notification(
        'Pending Challan $challanNo',
        body: customer,
        icon: 'icons/Icon-192.png',
      );
    }
  }
}
