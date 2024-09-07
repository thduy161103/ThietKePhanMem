import 'package:flutter/material.dart';
import '../network/voucher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AllVouchersPage extends StatefulWidget {

  const AllVouchersPage({Key? key}) : super(key: key);

  @override
  _AllVouchersPageState createState() => _AllVouchersPageState();
}

class _AllVouchersPageState extends State<AllVouchersPage> {
  late Future<List<Map<String, dynamic>>> _vouchersFuture;

  @override
  void initState() {
    super.initState();
    _vouchersFuture = VoucherRequest.fetchAllVoucher();
  }

  Future<void> _redeemVoucher(String voucherId, int points) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    String userId = decodedToken['id'] as String;

    bool success = await VoucherRequest.updateVoucherAfterGame(userId, voucherId, 1, points);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã đổi thành công 1 voucher')),
      );
      // Refresh the voucher list
      setState(() {
        _vouchersFuture = VoucherRequest.fetchAllVoucher();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đổi voucher không thành công')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Vouchers'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _vouchersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No vouchers available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final voucher = snapshot.data![index];
                return VoucherCard(
                  voucherId: voucher['id'],
                  points: voucher['point'],
                  onRedeem: _redeemVoucher,
                );
              },
            );
          }
        },
      ),
    );
  }
}

class VoucherCard extends StatelessWidget {
  final String voucherId;
  final int points;
  final Function(String, int) onRedeem;

  const VoucherCard({
    Key? key,
    required this.voucherId,
    required this.points,
    required this.onRedeem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Voucher ID: $voucherId',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Points: $points',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => onRedeem(voucherId, points),
              child: Text('Đổi Voucher'),
            ),
          ],
        ),
      ),
    );
  }
}