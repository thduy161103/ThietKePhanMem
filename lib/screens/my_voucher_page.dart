import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../models/voucher.dart';
import '../models/voucher_detail.dart';
import '../network/voucher.dart';
import '../utils/app_styles.dart';
import 'dart:developer' as developer;

class MyVoucherPage extends StatefulWidget {
  const MyVoucherPage({Key? key}) : super(key: key);

  @override
  State<MyVoucherPage> createState() => _MyVoucherPageState();
}

class _MyVoucherPageState extends State<MyVoucherPage> {
  late Future<List<Voucher>> _vouchersFuture;

  @override
  void initState() {
    super.initState();
    _vouchersFuture = _fetchVouchers();
  }

  Future<List<Voucher>> _fetchVouchers() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    if (token == null) {
      throw Exception('No token found');
    }

    try {
      return await VoucherRequest.fetchVouchers();
    } catch (e) {
      developer.log('Error fetching vouchers: $e');
      rethrow;
    }
  }

  void _showVoucherDetails(String voucherId) async {
    try {
      VoucherDetail voucherDetail = await VoucherRequest.fetchVoucherDetail(voucherId);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(voucherDetail.ten),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Image.network(voucherDetail.hinhanh, height: 150, width: double.infinity, fit: BoxFit.cover),
                  SizedBox(height: 10),
                  Text('Mã QR: ${voucherDetail.qrcode}'),
                  Text('Trị giá: ${voucherDetail.trigia}'),
                  Text('Mô tả: ${voucherDetail.mota}'),
                  Text('Ngày hết hạn: ${voucherDetail.ngayhethan.toString()}'),
                  Text('Trạng thái: ${voucherDetail.trangthai}'),
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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể tải thông tin voucher: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppStyles.getGradientDecoration(),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Danh sách voucher của bạn',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
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
                          return Card(
                            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 4,
                            child: ListTile(
                              leading: Image.network(
                                voucher.hinhanh,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                              title: Text(voucher.ten),
                              subtitle: Text('Trị giá: ${voucher.trigia}'),
                              trailing: Icon(Icons.chevron_right),
                              onTap: () => _showVoucherDetails(voucher.idVoucher),
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
}
