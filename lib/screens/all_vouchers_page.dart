import 'dart:math';

import 'package:flutter/material.dart';
import '../network/voucher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'drawer.dart'; // Add this import
import '../models/user.dart';
import '../network/user_api.dart';
import '../network/point.dart'; // Add this import
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

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
  void redeemVoucher(BuildContext context,String userId, String voucherId, int quantity, int point) async {
    print('userId: $userId');
    print('voucherId: $voucherId');
    print('quantity: $quantity');
    print('point: $point');
    // TODO: Implement voucher redemption logic base on voucherId and points
    final result = await VoucherRequest.updateVoucherAfterGame( userId,  voucherId,  quantity,  point);

    print('result: $result');
    if (result) {
      // cập nhật lại số dư point của user
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.setUserPoints(userProvider.userPoints - point);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Voucher redeemed successfully')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to redeem voucher')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    final userPoints = userProvider.userPoints;

    return Scaffold(
      drawer: user != null ? MyDrawer() : null,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('All Vouchers'),
        leading: Builder(
          builder: (BuildContext context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.orange.shade100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Available Vouchers',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.orange),
                    SizedBox(width: 4),
                    Text(
                      '$userPoints points',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
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
                      return _buildVoucherItem(voucher);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
    
  }

  Widget _buildVoucherItem(Map<String, dynamic> voucher) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Voucher ${voucher['id_voucher']}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${voucher['point']} points',
                  style: TextStyle(fontSize: 16, color: Colors.orange),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              voucher['description'] ?? 'No description available',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final userProvider = Provider.of<UserProvider>(context, listen: false);
                redeemVoucher(context, userProvider.userId!, voucher['id_voucher'], 1, voucher['point']);
              },
              child: Text('Redeem Voucher'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }
 
}

class VoucherCard extends StatelessWidget {
  final String voucherId;
  final int points;
  final Function(String, int) onRedeem;
 void redeemVoucher(BuildContext context,String userId, String voucherId, int quantity, int point) async {
    print('userId: $userId');
    print('voucherId: $voucherId');
    print('quantity: $quantity');
    print('point: $point');
    // TODO: Implement voucher redemption logic base on voucherId and points
    final result = await VoucherRequest.updateVoucherAfterGame( userId,  voucherId,  quantity,  point);

    print('result: $result');
    if (result) {

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Voucher redeemed successfully')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to redeem voucher')));
    }
  }
  const VoucherCard({
    Key? key,
    required this.voucherId,
    required this.points,
    required this.onRedeem,
  }) : super(key: key);



  // TODO: Implement voucher redemption logic
  

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
              onPressed: () {
                // UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
                // redeemVoucher(context,userProvider.userId!, voucherId, 1, points);
              },
              child: Text('Đổi Voucher'),
            ),
          ],
        ),
      ),
    );
  }
}