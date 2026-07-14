import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://api.guljaginfotech.in";

  static const _storage = FlutterSecureStorage(
    webOptions: WebOptions(
      dbName: 'cmpy_q',
      publicKey: 'as_key_2024',
    ),
  );

  // ───────────────── TOKEN ─────────────────

  static Future<void> saveToken(String t) =>
      _storage.write(key: "token", value: t);

  static Future<String?> getToken() =>
      _storage.read(key: "token");

  static Future<void> clearToken() =>
      _storage.delete(key: "token");

  // ───────────────── SESSION ─────────────────

  static Future<void> saveUserSession({
    required String token,
    required String userId,
    required String utg,
    required String userName,
    required String userEmail,
    required String databaseName,
    required String companyCode,
  }) async {
    await Future.wait([
      _storage.write(key: "token", value: token),
      _storage.write(key: "userId", value: userId),
      _storage.write(key: "utg", value: utg),
      _storage.write(key: "userName", value: userName),
      _storage.write(key: "userEmail", value: userEmail),
      _storage.write(key: "databaseName", value: databaseName),
      _storage.write(key: "companyCode", value: companyCode),
    ]);
  }

  static Future<String?> getUTG() async {
  return await _storage.read(key: "utg");
}

  static Future<Map<String, String>?> getUserSession() async {
    final token = await _storage.read(key: "token");

    if (token == null || token.isEmpty) return null;

    return {
      "token": token,
      "userId": await _storage.read(key: "userId") ?? "",
      "utg": await _storage.read(key: "utg") ?? "",
      "userName": await _storage.read(key: "userName") ?? "",
      "userEmail": await _storage.read(key: "userEmail") ?? "",
      "databaseName":
          await _storage.read(key: "databaseName") ?? "",
      "companyCode":
          await _storage.read(key: "companyCode") ?? "",
    };
  }

  static Future<List<dynamic>> getBranches(
    String databaseName) async {

  final response = await http.post(
    Uri.parse('$baseUrl/api/branches'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'databaseName': databaseName,
    }),
  );
  print("STATUS: ${response.statusCode}");
print("BODY:");
print(response.body);

  final data = jsonDecode(response.body);

  return data['data'] ?? [];
}

  static Future<String?> getUserId() =>
      _storage.read(key: "userId");

  static Future<String> getClientIp() async {
    try {
      final res = await http
          .get(Uri.parse("https://api.ipify.org?format=json"))
          .timeout(const Duration(seconds: 10));

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body) as Map<String, dynamic>;
        return body["ip"]?.toString() ?? "";
      }
    } catch (e) {
      print("CLIENT IP ERROR: $e");
    }

    return "";
  }

  static Future<Set<String>> getNotifiedPendingChallanIds() async {
    final raw = await _storage.read(key: "notifiedPendingChallanIds");
    if (raw == null || raw.isEmpty) return {};

    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded.map((e) => e.toString()).toSet();
      }
    } catch (e) {
      print("READ NOTIFIED CHALLAN IDS ERROR: $e");
    }

    return {};
  }

  static Future<void> saveNotifiedPendingChallanIds(Set<String> ids) =>
      _storage.write(
        key: "notifiedPendingChallanIds",
        value: jsonEncode(ids.toList()),
      );

  static Future<void> clearSession() async {
    await Future.wait([
      _storage.delete(key: "token"),
      _storage.delete(key: "userId"),
      _storage.delete(key: "utg"),
      _storage.delete(key: "userName"),
      _storage.delete(key: "userEmail"),
      _storage.delete(key: "databaseName"),
      _storage.delete(key: "companyCode"),
      _storage.delete(key: "notifiedPendingChallanIds"),
    ]);
  }


static Future<List<dynamic>> getPendingChallans({
  required String databaseName,
  required String branchId,
}) async {

  final response = await http.post(
    Uri.parse('$baseUrl/api/pending-challan'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'databaseName': databaseName,
      'branchId': branchId,
    }),
  );

  final data = jsonDecode(response.body);

  return data['data'] ?? [];
}

static Future<List<dynamic>> getPendingSRL({
  required String databaseName,
  required String branchId,
}) async {

  final response = await http.post(
    Uri.parse('$baseUrl/api/pending-srl'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'databaseName': databaseName,
      'branchId': branchId,
    }),
  );

  final data = jsonDecode(response.body);

  return data['data'] ?? [];
}

static Future<Map<String, dynamic>>
approveSRL({

  required String databaseName,

  required String userId,

  required String srlUnq,

}) async {

  final response = await http.post(

    Uri.parse(
      '$baseUrl/api/srl-approval',
    ),

    headers: {
      'Content-Type': 'application/json',
    },

    body: jsonEncode({

      'databaseName':
          databaseName,

      'userId':
          userId,

      'srlUnq':
          srlUnq,
    }),
  );

  return jsonDecode(
    response.body,
  );
}

static Future<Map<String, dynamic>>
rejectSRL({

  required String databaseName,
  required String userId,
  required String srlUnq,

}) async {

  final response = await http.post(

    Uri.parse(
      '$baseUrl/api/srl-reject',
    ),

    headers: {
      'Content-Type': 'application/json',
    },

    body: jsonEncode({

      'databaseName': databaseName,
      'userId': userId,
      'srlUnq': srlUnq,
    }),
  );

  return jsonDecode(response.body);
}

static Future<Map<String, dynamic>>
approveChallan({

  required String databaseName,
  required String userId,
  required String challanUnq,

}) async {

  final response = await http.post(

    Uri.parse(
      '$baseUrl/api/challan-approval',
    ),

    headers: {
      'Content-Type': 'application/json',
    },

    body: jsonEncode({

      'databaseName':
          databaseName,

      'userId':
          userId,

      'challanUnq':
          challanUnq,
    }),
  );

  return jsonDecode(
    response.body,
  );
}

static Future<void> saveDeviceToken({
  required String userId,
  required String userName,
  required String token,
}) async {

  try {

    await http.post(

      Uri.parse(
        '$baseUrl/api/save-device-token',
      ),

      headers: {
        'Content-Type':
            'application/json',
      },

      body: jsonEncode({

        'userId': userId,
        'userName': userName,
        'token': token,
      }),
    );

  } catch (e) {

    print(
      "Token Save Error: $e",
    );
  }
}

static Future<List<dynamic>> getCounts({
  required String databaseName,
}) async {

  final response = await http.post(
    Uri.parse("$baseUrl/api/get-count"),
    headers: {
      "Content-Type": "application/json",
    },
    body: jsonEncode({
      "databaseName": databaseName,
    }),
  );

  final json =
      jsonDecode(response.body);

  return json["data"] ?? [];
}
static Future<void>
sendChatMessage({

  required String databaseName,

  required String referenceId,

  required String fromUser,

  required String toUser,

  required String message,

}) async {

  await http.post(

    Uri.parse(
      '$baseUrl/api/send-chat',
    ),

    headers: {

      'Content-Type':
          'application/json',
    },

    body: jsonEncode({

      'databaseName':
          databaseName,

      'referenceId':
          referenceId,

      'fromUser':
          fromUser,

      'toUser':
          toUser,

      'message':
          message,
    }),
  );
}
/////chat api
static Future<List<dynamic>>
getChatMessages({
  required String databaseName,
  required String referenceId,
}) async {
  final response = await http.post(
    Uri.parse('$baseUrl/api/get-chat'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'databaseName': databaseName,
      'referenceId': referenceId,
    }),
  );

  final data =
      jsonDecode(response.body);

  return data["data"] ?? [];
}



static Future<Map<String, dynamic>>
getSalesDashboard({

  required String databaseName,

  required String userId,

}) async {

  final response =
      await http.post(

    Uri.parse(
      '$baseUrl/api/sales-dashboard',
    ),

    headers: {

      'Content-Type':
          'application/json',
    },

    body: jsonEncode({

      'databaseName':
          databaseName,

      'userId':
          userId,
    }),
  );

  return jsonDecode(
    response.body,
  );
}

static Future<List<dynamic>>
getChatUsers({

  required String databaseName,

  required String userId,

}) async {

  final response =
      await http.post(

    Uri.parse(
      '$baseUrl/api/chat-users',
    ),

    headers: {
      'Content-Type':
          'application/json',
    },

    body: jsonEncode({

      'databaseName':
          databaseName,

      'userId':
          userId,
    }),
  );

  final data =
      jsonDecode(
    response.body,
  );

  return data["data"] ?? [];
}
static Future<void> readChat({

  required String databaseName,

  required String currentUser,

  required String targetUser,

}) async {

  await http.post(

    Uri.parse(
      '$baseUrl/api/read-chat',
    ),

    headers: {
      'Content-Type':
          'application/json',
    },

    body: jsonEncode({

      'databaseName':
          databaseName,

      'currentUser':
          currentUser,

      'targetUser':
          targetUser,
    }),
  );
}

static Future<List<dynamic>>
getAllUsers({

  required String databaseName,

}) async {

  final response =
      await http.post(

    Uri.parse(
      '$baseUrl/api/all-users',
    ),

    headers: {
      'Content-Type':
          'application/json',
    },

    body: jsonEncode({

      'databaseName':
          databaseName,
    }),
  );

  final data =
      jsonDecode(
    response.body,
  );

  return data["data"] ?? [];
}

static Future<List<dynamic>> getCustomerFollowUp({
  required String databaseName,
  required String userId,
}) async {
  final response = await http.post(
    Uri.parse("$baseUrl/api/customer-follow-up"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "databaseName": databaseName,
      "userId": userId,
    }),
  );

  final data = jsonDecode(response.body);

  if (data["success"] == true) {
    return data["customers"] ?? [];
  }

  return [];
}

static Future<List<dynamic>> getLostCustomers({
  required String databaseName,
  required String userId,
  required String filter,
  String basis = "QTY",
  String paymentFilter = "ALL",
}) async {
  final response = await http.post(
    Uri.parse("$baseUrl/api/lost-customers"),
    headers: {
      "Content-Type": "application/json",
    },
    body: jsonEncode({
      "databaseName": databaseName,
      "userId": userId,
     "filter": filter,

      "basis": basis,

      "paymentFilter": paymentFilter,
    }),
  );

  return jsonDecode(response.body);
}

static Future<Map<String, dynamic>> getCategoryTargets({

  required String databaseName,
  required String userId,

}) async {

  final response = await http.post(

    Uri.parse("$baseUrl/api/category-target"),

    headers: {
      "Content-Type": "application/json",
    },

    body: jsonEncode({

      "databaseName": databaseName,

      "userId": userId,

    }),

  );

  return jsonDecode(response.body);

}

static Future<Map<String, dynamic>> getCustomerHealth({
  required String databaseName,
  required String userId,
}) async {

  final response = await http.post(

    Uri.parse("$baseUrl/api/customer-health"),

    headers: {
      "Content-Type": "application/json",
    },

    body: jsonEncode({

      "databaseName": databaseName,

      "userId": userId,

    }),
  );

  if (response.statusCode == 200) {

    return Map<String, dynamic>.from(

      jsonDecode(response.body),

    );
  }

  throw Exception("Failed to load customer health");
}

static Future<List<dynamic>> getCustomerHealthDetails({
  required String databaseName,
  required String userId,
  required String type,
}) async {

  final response = await http.post(

    Uri.parse("$baseUrl/api/customer-health-details"),

    headers: {
      "Content-Type": "application/json",
    },

    body: jsonEncode({

      "databaseName": databaseName,

      "userId": userId,

      "type": type,

    }),
  );

  if (response.statusCode == 200) {

    return jsonDecode(response.body);

  }

  throw Exception("Failed to load customers");
}

static Future<List<dynamic>> getCategoryDecline({

  required String databaseName,

  required String userId,

}) async {

  final response = await http.post(

    Uri.parse("$baseUrl/api/category-decline"),

    headers: {

      "Content-Type": "application/json",

    },

    body: jsonEncode({

      "databaseName": databaseName,

      "userId": userId,

    }),

  );

  if (response.statusCode == 200) {

    return jsonDecode(response.body);

  } else {

    throw Exception("Failed to load category decline");

  }
}

static Future<List<dynamic>> getCategoryCustomers({

  required String databaseName,

  required String userId,

  required String categoryName,

}) async {

  final response = await http.post(

    Uri.parse("$baseUrl/api/category-customers"),

    headers: {

      "Content-Type": "application/json",

    },

    body: jsonEncode({

      "databaseName": databaseName,

      "userId": userId,

      "categoryName": categoryName,

    }),

  );

  if (response.statusCode == 200) {

    return jsonDecode(response.body);

  }

  throw Exception("Failed to load category customers");

}

static Future<List<dynamic>> getCustomerProducts({

  required String databaseName,

  required String userId,

  required String customerId,

}) async {

  final response = await http.post(

    Uri.parse("$baseUrl/api/customer-products"),

    headers: {

      "Content-Type": "application/json",

    },

    body: jsonEncode({

      "databaseName": databaseName,

      "userId": userId,

      "customerId": customerId,

    }),

  );

  if (response.statusCode == 200) {

    return jsonDecode(response.body);

  }

  throw Exception("Failed to load customer products");

}

static Future<List<dynamic>> getProductGrowthDetails({

  required String databaseName,

  required String userId,

  required String period,

}) async {

  final response = await http.post(

    Uri.parse("$baseUrl/api/product-growth-details"),

    headers: {
      "Content-Type":"application/json",
    },

    body: jsonEncode({

      "databaseName":databaseName,

      "userId":userId,

      "period":period,

    }),

  );

  return jsonDecode(response.body);

}

static Future<List<dynamic>>
    getCategoryBestMonthCustomers({
      required String databaseName,

  required String userId,

  required String categoryId,
  required int year,
  required int month,
}) async {

  final response = await http.post(
    Uri.parse(
      "$baseUrl/api/category-best-month-customers",
    ),

    headers: {
      "Content-Type": "application/json",
    },

    body: jsonEncode({
      "databaseName":databaseName,
      "userId":userId,
      "categoryId": categoryId,
      "year": year,
      "month": month,
    }),
  );

  final data = jsonDecode(response.body);

  if (data["success"] == true) {
    return data["data"] ?? [];
  }

  throw Exception(
    data["message"] ??
        "Unable to load customer details",
  );
}


  // ───────────────── DEVICE ID ─────────────────

  static Future<String> getDeviceId() async {
    try {
      final deviceInfo = DeviceInfoPlugin();

      if (kIsWeb) {
        // For web: generate a persistent unique ID stored in secure storage
        String? storedId = await _storage.read(key: "device_id");
        if (storedId != null && storedId.isNotEmpty) {
          return storedId;
        }
        // Generate a new unique ID for this browser
        final newId =
    "web_${DateTime.now().millisecondsSinceEpoch}";
        await _storage.write(key: "device_id", value: newId);
        return newId;
      }

      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        return "android_${androidInfo.id}";
      }

      if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        return "ios_${iosInfo.identifierForVendor ?? DateTime.now().millisecondsSinceEpoch.toString()}";
      }

      if (Platform.isWindows) {
        final windowsInfo = await deviceInfo.windowsInfo;
        return "win_${windowsInfo.deviceId}";
      }

      return "device_${DateTime.now().millisecondsSinceEpoch}";
    } catch (e) {
      print("DEVICE ID ERROR: $e");
      return "fallback_${DateTime.now().millisecondsSinceEpoch}";
    }
  }
 // ───────────────── NOTIFICATIONS ─────────────────

 static Future<List<dynamic>> getNotifications({
  required String userId,
  required String allowedDatabases,
}) async {

  final response = await http.post(
    Uri.parse('$baseUrl/api/notifications'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'userId': userId,
      'allowedDatabases': allowedDatabases,
    }),
  );

  final data = jsonDecode(response.body);

  return data["data"] ?? [];
}
  static Future<List<Map<String, dynamic>>> getChallanRetailIncentive({String dateType = 'challan'}) async {
    try {
      final token = await getToken();
      if (token == null || token.isEmpty) return [];

      final res = await http.get(
        Uri.parse("$baseUrl/api/challan/retail-incentive?dateType=$dateType"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      ).timeout(const Duration(seconds: 30));

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body) as Map<String, dynamic>;
        if (body['success'] == true && body['data'] is List) {
          return List<Map<String, dynamic>>.from(
            (body['data'] as List).map((e) => Map<String, dynamic>.from(e as Map)),
          );
        }
      }
      return [];
    } catch (e) {
      print("CHALLAN ERROR: $e");
      return [];
    }
  }

  /// Fetches complete challan details for editing
  /// Calls the stored procedure with @what = 'Edit' and @sp_462
  /// Returns a map with all challan fields
  static Future<Map<String, dynamic>?> getChallanEditDetails(String sp462) async {
    try {
      final token = await getToken();
      if (token == null || token.isEmpty) {
        print("❌ CHALLAN EDIT: No token found");
        throw Exception("Authentication required. Please login again.");
      }

      final url = "$baseUrl/api/challan/edit/$sp462";
      print("🌐 CHALLAN EDIT: Calling $url");

      final res = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      ).timeout(const Duration(seconds: 30));

      print("📡 CHALLAN EDIT: Status ${res.statusCode}");
      print("📦 CHALLAN EDIT: Body ${res.body}");

      if (res.statusCode == 404) {
        throw Exception("Challan not found. The record may have been deleted.");
      }

      if (res.statusCode == 401) {
        throw Exception("Unauthorized. Please login again.");
      }

      if (res.statusCode == 500) {
        final body = jsonDecode(res.body) as Map<String, dynamic>;
        final errorMsg = body['error'] ?? body['message'] ?? 'Server error';
        throw Exception("Server error: $errorMsg");
      }

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body) as Map<String, dynamic>;
        if (body['success'] == true && body['data'] is Map) {
          print("✅ CHALLAN EDIT: Data received successfully");
          return Map<String, dynamic>.from(body['data'] as Map);
        } else {
          final errorMsg = body['message'] ?? 'Invalid response format';
          throw Exception(errorMsg);
        }
      }

      throw Exception("Unexpected response: HTTP ${res.statusCode}");
    } catch (e) {
      print("❌ CHALLAN EDIT ERROR: $e");
      rethrow;
    }
  }

  
  static Future<void> logout(String token) async {

  try {

    await http.post(
      Uri.parse("$baseUrl/api/auth/logout"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

  } catch (e) {

    print("LOGOUT API ERROR: $e");
  }
}
  // ───────────────── LOGIN ─────────────────

  static Future<Map?> login({
    required String databaseName,
    required String userId,
    required String password,
  }) async {
    try {
      //await ensureAwake();

      // GET DEVICE ID
      final deviceId = await getDeviceId();

      if (kIsWeb) {
        print("DEVICE ID: $deviceId");
      }

      final res = await http.post(
        Uri.parse("$baseUrl/api/login"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "databaseName": databaseName,
          "userId": userId,
          "password": password,
          "deviceId": deviceId,
        }),
      ).timeout(const Duration(seconds: 30));

      if (kIsWeb) {
        print("LOGIN STATUS: ${res.statusCode}");
        print("LOGIN BODY: ${res.body}");
      }

      // BLOCKED LOGIN
      if (res.statusCode == 403) {
        final data = jsonDecode(res.body);

        return {
          "success": false,
          "message": data['message'] ??
              "This account is already logged in on another device"
        };
      }

      // SUCCESS
      if (res.statusCode == 200 &&
          !res.body.trim().startsWith('<')) {

        final data = jsonDecode(res.body);

        if (data['token'] != null) {

          await saveUserSession(
            token: data['token'],
            userId:
                data['userId']?.toString() ?? userId,
            utg:
                data['utg']?.toString() ?? "",
            userName:
                data['name']?.toString() ?? userId,
            userEmail:
                data['email']?.toString() ?? "",
            databaseName:
                data['databaseName']?.toString() ??
                    databaseName,
            companyCode: "",
          );
        }

        return data;
      }

      // INVALID LOGIN
      return {
        "success": false,
        "message": "Invalid User ID or Password"
      };

    } catch (e) {

      print("LOGIN ERROR: $e");

      return {
        "success": false,
        "message": e.toString(),
      };
    }
  }


  static Future<int>
getNotificationCount({

  required String userId,
  required String allowedDatabases,

}) async {

  final response = await http.post(

    Uri.parse(
      '$baseUrl/api/notification-count',
    ),

    headers: {
      'Content-Type': 'application/json',
    },

    body: jsonEncode({

      'userId': userId,

      'allowedDatabases':
          allowedDatabases,
    }),
  );

  final data =
      jsonDecode(response.body);

  return data["count"] ?? 0;
}

static Future<void> markNotificationRead({
  required int id,
  required String databaseName,
}) async {

  await http.post(

    Uri.parse(
      '$baseUrl/api/read-notification',
    ),

    headers: {
      'Content-Type': 'application/json',
    },

    body: jsonEncode({

      'id': id,

      'databaseName':
          databaseName,
    }),
  );
}

static Future<void>
saveFCMToken(String fcmToken) async {

  try {

    final token = await getToken();

    if (token == null) return;

    await http.post(

      Uri.parse(
        "$baseUrl/api/auth/save-fcm-token",
      ),

      headers: {

        "Content-Type":
            "application/json",

        "Authorization":
            "Bearer $token",
      },

      body: jsonEncode({
        "token": fcmToken,
      }),
    );

    print("FCM TOKEN SAVED");

  } catch (e) {

    print(
      "SAVE FCM TOKEN ERROR: $e"
    );
  }
}

}
