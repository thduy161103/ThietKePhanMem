import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/voucher.dart';
import '../models/voucher_detail.dart';
import '../config/environment.dart';

class VoucherRequest {
  static final String baseUrl = '${Environment.baseUrl}/brand/api/voucher/';

  static Future<List<Voucher>> fetchVouchers() async {
    print('Fetching vouchers from: ${baseUrl}list');
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';

      final response = await http.get(
        Uri.parse('${baseUrl}list'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        Map<String, dynamic> decodedData = jsonDecode(response.body);
        
        if (decodedData['success'] == true && decodedData['vouchers'] is List) {
          List<dynamic> vouchersData = decodedData['vouchers'];
          print('Parsed vouchers data: $vouchersData');
          
          List<Voucher> vouchers = vouchersData.map((json) => Voucher.fromJson(json)).toList();
          print('Converted to ${vouchers.length} Voucher objects');
          return vouchers;
        } else {
          print('Unexpected data format or success is false');
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
        Uri.parse('${baseUrl}detail/$voucherId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['success'] == true && jsonData['voucher'] != null) {
          return VoucherDetail.fromJson(jsonData['voucher']);
        } else {
          throw Exception('Voucher detail not found or invalid data format');
        }
      } else {
        throw Exception('Failed to load voucher details');
      }
    } catch (e) {
      print('Error occurred while fetching voucher detail: $e');
      rethrow;
    }
  }
}
