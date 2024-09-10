import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/voucher.dart';
import '../models/voucher_detail.dart';
import '../config/environment.dart';

class VoucherRequest {
  static final String baseUrl = '${Environment.baseUrl}';

  static Future<bool> checkVoucher(String userId, String voucherId, String eventId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';

      final response = await http.post(
        Uri.parse('${baseUrl}/brand/api/voucher/updatevoucheramount'),
        headers: { 
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id_sukien': eventId,
          'id_voucher': voucherId,
          'soluong': 1
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error occurred while checking voucher: $e');
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>> fetchAllVoucher() async { 
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';

      final response = await http.get(
        Uri.parse('${baseUrl}/brand/api/voucher/allvoucherevent'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['success'] && jsonData['vouchers'] is List) {
          return List<Map<String, dynamic>>.from(jsonData['vouchers']);
        } else {
          throw Exception('No vouchers found');
        }
      } else {
        throw Exception('Failed to load vouchers');
      }
    } catch (e) {
      print('Error occurred while fetching vouchers: $e');
      rethrow;
    }
  }
  static Future<List<Map<String, dynamic>>> fetchVoucherForEvent(String eventId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';

      final response = await http.get(
        Uri.parse('${baseUrl}/brand/api/voucher/voucherofevent/$eventId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['success'] && jsonData['voucher'] is List) {
          return (jsonData['voucher'] as List).map((voucher) => {
            'id': voucher['id_voucher'] as String,
            'diem': voucher['diem'] as int,
          }).toList();
        } else {
          throw Exception('No vouchers found for this event');
        }
      } else {
        throw Exception('Failed to load vouchers for event');
      }
    } catch (e) {
      print('Error occurred while fetching vouchers for event: $e');
      rethrow;
    }
  }

  static Future<bool> updateVoucherAfterGame(String userId, String eventId, String voucherId, int quantity, int diem, String phoneNumber) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';

      print('userId: $userId');
      print('voucherId: $voucherId');
      print('quantity: $quantity');
      print('diem: $diem');
      print('$baseUrl/users/voucher/$userId');
      final response = await http.post(
        Uri.parse('$baseUrl/users/voucher/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'voucher': voucherId,
          'event': eventId,
          'quantity': quantity,
          'point': diem,
          'targetPhone': phoneNumber
        }),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
         print('Voucher updated successfully');
          return true;
      } else {
        print('Failed to update voucher. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error occurred while updating voucher: $e');
      return false;
    }
  }

  static Future<List<Voucher>> fetchVouchers(String userId) async {
    print('Fetching vouchers from: ${baseUrl}list');
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';
      print('Token: $token');
      print('User ID: $userId');
      final response = await http.get(
        Uri.parse('${baseUrl}/users/voucher/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        Map<String, dynamic> decodedData = jsonDecode(response.body);
        
        if (decodedData['username'] != null && decodedData['vouchers'] is Map) {
          Map<String, dynamic> vouchersData = decodedData['vouchers'];
          print('Parsed vouchers data: $vouchersData');
          
          List<Voucher> vouchers = vouchersData.entries.map((entry) {
            return Voucher(
              idVoucher: entry.key,
              quantity: entry.value,
            );
          }).toList();
          
          print('Converted to ${vouchers.length} Voucher objects');
          return vouchers;
        } else {
          print('Unexpected data format');
          throw Exception('Unexpected data format');
        }
      } else {
        print('Failed to load vouchers. Status code: ${response.statusCode}');
        throw Exception('Failed to load vouchers');
      }
    } catch (e) {
      print('Error occurred while fetching vouchers: $e');
      rethrow;
    }
  }

  static Future<VoucherDetail> fetchVoucherDetail(String voucherId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';

      final response = await http.get(
        Uri.parse('${baseUrl}/brand/api/voucher/detailvoucher/$voucherId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['success'] && jsonData['vouchers'].isNotEmpty) {
        return VoucherDetail.fromJson(jsonData['vouchers'][0]);
      } else {
        throw Exception('Voucher detail not found');
      }
    } else {
      throw Exception('Failed to load voucher detail');
    }
  } catch (e) {
    print('Error occurred while fetching voucher detail: $e');
    rethrow;
  }
}

  static Future<bool> sendVoucherGift(String userId, String idVoucher, String friendPhone, int quantity) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';
      final response = await http.post(
        Uri.parse('${baseUrl}/users/send-voucher/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'voucher': idVoucher,
          'targetPhone': friendPhone,
          'quantity': quantity
        }),
      );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    print('Error occurred while fetching voucher detail: $e');
    rethrow;
  }
  }
}
