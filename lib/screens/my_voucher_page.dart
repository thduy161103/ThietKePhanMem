import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../models/user.dart';
import '../models/voucher.dart';
//import '../models/voucher_detail.dart';
import '../network/user_api.dart';
import '../network/voucher.dart';
import '../utils/app_styles.dart';
import 'dart:developer' as developer;
import 'drawer.dart'; // Add this import

class MyVoucherPage extends StatefulWidget {
  const MyVoucherPage({Key? key}) : super(key: key);

  @override
  State<MyVoucherPage> createState() => _MyVoucherPageState();
}

class _MyVoucherPageState extends State<MyVoucherPage> {
  late Future<List<Voucher>> _vouchersFuture;
  User? currentUser; // Change to nullable
  @override
  void initState() {
    super.initState();
    _vouchersFuture = _fetchVouchers();
    _fetchCurrentUser();
  }

  Future<void> _fetchCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    if (token != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      String userId = decodedToken['id'] as String;
      currentUser = await UserApi.fetchUserData(userId);
      setState(() {}); // Update the UI after fetching the user
    }
  }

  Future<List<Voucher>> _fetchVouchers() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    if (token == null) {
      throw Exception('No token found');
    }

    try {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      String userId = decodedToken['id'] as String;
      print('userId: $userId');
      var vouchers = await VoucherRequest.fetchVouchers(userId);
      
      // Lấy thông tin chi tiết cho mỗi voucher
      for (var voucher in vouchers) {
        try {
          voucher.detail = await VoucherRequest.fetchVoucherDetail(voucher.idVoucher);
        } catch (e) {
          developer.log('Error fetching voucher detail: $e');
          // Xử lý lỗi nếu cần
        }
      }
      
      return vouchers;
    } catch (e) {
      developer.log('Error fetching vouchers: $e');
      rethrow;
    }
  }

  void _showVoucherDetails(Voucher voucher) {
    if (voucher.detail == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không có thông tin chi tiết cho voucher này')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(voucher.ten ?? ''),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                if (voucher.hinhanh != null)
                  Image.network(
                    voucher.hinhanh!,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 150,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: Icon(Icons.error),
                      );
                    },
                  ),
                SizedBox(height: 10),
                Text('Mã QR: ${voucher.detail?.qrcode ?? 'N/A'}'),
                Text('Trị giá: ${voucher.trigia ?? 'N/A'}'),
                Text('Mô tả: ${voucher.detail?.mota ?? 'N/A'}'),
                Text('Ngày hết hạn: ${voucher.detail!.ngayhethan.toString()}'),
                Text('Trạng thái: ${voucher.detail!.trangthai}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Đóng'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: currentUser != null ? MyDrawer(user: currentUser!) : null,
      body: Container(
        decoration: AppStyles.getGradientDecoration(),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Builder(
                      builder: (BuildContext context) => IconButton(
                        icon: Icon(Icons.menu, color: Colors.white),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                    ),
                    Text(
                      'Danh sách voucher của bạn',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 48), // To balance the layout
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: FutureBuilder<List<Voucher>>(
                    future: _vouchersFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('Không có voucher nào'));
                      }

                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final voucher = snapshot.data![index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: InkWell(
                                onTap: () => _showVoucherDetails(voucher),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                                      child: Image.network(
                                        voucher.hinhanh ?? '',
                                        height: 150,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            height: 150,
                                            color: Colors.grey[300],
                                            child: Icon(Icons.error),
                                          );
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            voucher.ten ?? '',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'Trị giá: ${voucher.trigia ?? 'N/A'}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.green,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'Số lượng: ${voucher.quantity}',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          if (voucher.detail != null) ...[
                                            SizedBox(height: 8),
                                            Text(
                                              'Hạn sử dụng: ${_formatDate(voucher.detail!.ngayhethan)}',
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              'Thương hiệu: ${voucher.detail!.brandName}',
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Add this helper method to format the date
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
