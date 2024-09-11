import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/user.dart';
import '../models/voucher.dart';
//import '../models/voucher_detail.dart';
import '../network/user_api.dart';
import '../network/voucher.dart';
import '../providers/user_provider.dart';
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
          print("voucher.detail?.hinhanh: ${voucher.detail?.hinhanh}");
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
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (voucher.detail?.hinhanh != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      voucher.detail!.hinhanh,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        print('Error loading image: $error');
                        return Container(
                          height: 200,
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: Icon(Icons.error, size: 50, color: Colors.grey[600]),
                        );
                      },
                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                SizedBox(height: 20),
                Text(
                  voucher.ten ?? 'Voucher',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 15),
                _buildDetailRow(Icons.qr_code, 'Mã QR', voucher.detail?.qrcode ?? 'N/A', isQR: true),
                _buildDetailRow(Icons.monetization_on, 'Trị giá', voucher.detail?.trigia.toString() ?? 'N/A'),
                //_buildDetailRow(Icons.description, 'Mô tả', voucher.detail?.mota ?? 'N/A'),
                _buildDetailRow(Icons.calendar_today, 'Ngày hết hạn', _formatDate(voucher.detail?.ngayhethan ?? DateTime.now())),
                //_buildDetailRow(Icons.info_outline, 'Trạng thái', voucher.detail?.trangthai.toString() ?? 'N/A'),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    child: Text('Đóng'),
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, {bool isQR = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.blue),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600], fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 4),
                if (isQR && value != 'N/A')
                  QrImageView(
                    data: value,
                    version: QrVersions.auto,
                    size: 200.0,
                  )
                else
                  Text(
                    value,
                    style: TextStyle(fontSize: 16),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Add this helper method if it doesn't exist
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _sendVoucherGift(Voucher voucher, String friendPhone, int quantity) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final userId = userProvider.userId!;
      final result = await VoucherRequest.sendVoucherGift(
        userId,
        voucher.idVoucher,
        friendPhone,
        quantity
      );
      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đã gửi tặng voucher thành công')),
        );
        // Refresh the voucher list
        setState(() {
          _vouchersFuture = _fetchVouchers();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gửi tặng voucher thất bại')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Có lỗi xảy ra: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: currentUser != null ? MyDrawer() : null,
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                                    child: Image.network(
                                      voucher.detail?.hinhanh ?? '',
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
                                          voucher.detail?.ten ?? '',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                          Text(
                                            'Thương hiệu: ${voucher.detail!.brandName}',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Trị giá: ${voucher.detail?.trigia ?? 'N/A'}',
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
                                          
                                        ],
                                        SizedBox(height: 16),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () => _showVoucherDetails(voucher),
                                              child: Text('Xem chi tiết'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () => _showGiftDialog(voucher),
                                              child: Text('Tặng voucher'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
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

  void _showGiftDialog(Voucher voucher) {
    String friendPhone = '';
    int quantity = 1;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tặng voucher cho bạn',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Số điện thoại bạn',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) => friendPhone = value,
                ),
                SizedBox(height: 15),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Số lượng',
                    prefixIcon: Icon(Icons.confirmation_number),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => quantity = int.tryParse(value) ?? 1,
                ),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Hủy'),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.grey[600],
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        if (friendPhone.isNotEmpty && quantity > 0) {
                          Navigator.of(context).pop();
                          _sendVoucherGift(voucher, friendPhone, quantity);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Vui lòng nhập số điện thoại và số lượng hợp lệ')),
                          );
                        }
                      },
                      child: Text('Tặng'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
