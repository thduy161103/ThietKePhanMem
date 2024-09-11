//import 'dart:math';

import 'package:flutter/material.dart';
import '../network/voucher.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//import 'package:jwt_decoder/jwt_decoder.dart';
import 'drawer.dart'; // Add this import
//import '../models/user.dart';
//import '../network/user_api.dart';
//import '../network/point.dart'; // Add this import
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void redeemVoucher(BuildContext context, String userId, String voucherId, int quantity, int point, String eventId) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String myPhoneNumber = userProvider.user!.phone;
    String? phoneNumber;
    bool? forSelf = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        bool _forSelf = true;
        return AlertDialog(
          title: Text('Mua Voucher', style: TextStyle(color: Colors.orange[800])),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Who is this voucher for?', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    InkWell(
                      onTap: () {
                        setState(() {
                          print(userProvider.user?.phone);
                          phoneNumber = myPhoneNumber;
                          _forSelf = true;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: _forSelf ? Colors.orange[50] : Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: _forSelf ? Colors.orange : Colors.grey[300]!),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.person, color: _forSelf ? Colors.orange : Colors.grey),
                            SizedBox(width: 12),
                            Text('For myself', style: TextStyle(fontWeight: _forSelf ? FontWeight.bold : FontWeight.normal)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    InkWell(
                      onTap: () => setState(() => _forSelf = false),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: !_forSelf ? Colors.orange[50] : Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: !_forSelf ? Colors.orange : Colors.grey[300]!),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.people, color: !_forSelf ? Colors.orange : Colors.grey),
                            SizedBox(width: 12),
                            Text('For a friend', style: TextStyle(fontWeight: !_forSelf ? FontWeight.bold : FontWeight.normal)),
                          ],
                        ),
                      ),
                    ),
                    if (!_forSelf) ...[
                      SizedBox(height: 16),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Friend\'s Phone Number',
                          prefixIcon: Icon(Icons.phone, color: Colors.orange),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.orange),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.orange, width: 2),
                          ),
                        ),
                        onChanged: (value) => phoneNumber = value,
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: Text('Confirm'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () => Navigator.of(context).pop(_forSelf),
            ),
          ],
        );
      },
    );

    if (forSelf == null) return; // User cancelled the dialog

    if (!forSelf && (phoneNumber == null || phoneNumber!.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter a phone number for your friend')));
      return;
    }

    if(forSelf && phoneNumber == null){
      phoneNumber = myPhoneNumber;
    }

    final check = await VoucherRequest.checkVoucher(userId, voucherId, eventId);
    if(check){
      // Call VoucherRequest.updateVoucherAfterGame
      final result = await VoucherRequest.updateVoucherAfterGame(
        userId,
        eventId,
        voucherId,
        quantity,
        point,
        phoneNumber!,
      );

      if (result) {
        // Update user's points
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUserPoints(userProvider.userPoints - point);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Voucher redeemed successfully')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to redeem voucher')));
      }
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
                  'Name: ${voucher['tenvoucher']}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                
                Text(
                  '${voucher['diem']} diem',
                  style: TextStyle(fontSize: 16, color: Colors.orange),
                ),
              ],
            ),
            SizedBox(height: 8),
            // Text(
            //       'Voucher Name: ${voucher['tenvoucher']}',
            //       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            //     ),
            // SizedBox(height: 8),
            Text(
                  'Event: ${voucher['tensukien']}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
            SizedBox(height: 8),
            Text(
                  'Amount: ${voucher['soluong']}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
            SizedBox(height: 8),
            Text(
                  'Expired: ${_formatDate(DateTime.parse(voucher['ngayhethan']))}',
                  style: TextStyle(fontSize: 15),
                ),
            SizedBox(height: 16),
            Text(
              voucher['mota'] ?? 'No description available',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                final userProvider = Provider.of<UserProvider>(context, listen: false);
                redeemVoucher(context, userProvider.userId!, voucher['id_voucher'], 1, voucher['diem'], voucher['id_sukien']);
              },
              child: Text('Mua Voucher'),
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
  final String voucherName;
  final int diem;
  final Function(String, int) onRedeem;
 void redeemVoucher(BuildContext context,String userId, String voucherId, int quantity, int point, String eventId) async {
    String? phoneNumber;
    bool? forSelf = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        bool _forSelf = true;
        return AlertDialog(
          title: Text('Mua Voucher', style: TextStyle(color: Colors.orange[800])),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Who is this voucher for?', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    InkWell(
                      onTap: () {
                        final userProvider = Provider.of<UserProvider>(context, listen: false);
                        phoneNumber = userProvider.user!.phone;
                        setState(() => _forSelf = true);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: _forSelf ? Colors.orange[50] : Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: _forSelf ? Colors.orange : Colors.grey[300]!),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.person, color: _forSelf ? Colors.orange : Colors.grey),
                            SizedBox(width: 12),
                            Text('For myself', style: TextStyle(fontWeight: _forSelf ? FontWeight.bold : FontWeight.normal)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    InkWell(
                      onTap: () => setState(() => _forSelf = false),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: !_forSelf ? Colors.orange[50] : Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: !_forSelf ? Colors.orange : Colors.grey[300]!),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.people, color: !_forSelf ? Colors.orange : Colors.grey),
                            SizedBox(width: 12),
                            Text('For a friend', style: TextStyle(fontWeight: !_forSelf ? FontWeight.bold : FontWeight.normal)),
                          ],
                        ),
                      ),
                    ),
                    if (!_forSelf) ...[
                      SizedBox(height: 16),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Friend\'s Phone Number',
                          prefixIcon: Icon(Icons.phone, color: Colors.orange),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.orange),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.orange, width: 2),
                          ),
                        ),
                        onChanged: (value) => phoneNumber = value,
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: Text('Confirm'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () => Navigator.of(context).pop(_forSelf),
            ),
          ],
        );
      },
    );

    if (forSelf == null) return; // User cancelled the dialog

    if (!forSelf && (phoneNumber == null || phoneNumber!.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter a phone number for your friend')));
      return;
    }

    final check = await VoucherRequest.checkVoucher(userId, voucherId, eventId);
    if(check){
    // Call VoucherRequest.updateVoucherAfterGame
      final result = await VoucherRequest.updateVoucherAfterGame(
        userId,
        eventId,
        voucherId,
        quantity,
        point,
        phoneNumber!,
      );

      if (result) {
        // Update user's points
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUserPoints(userProvider.userPoints - point);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Voucher redeemed successfully')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to redeem voucher')));
      }
    }
  }
  const VoucherCard({
    Key? key,
    required this.voucherId,
    required this.voucherName,
    required this.diem,
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
              'ID: $voucherId',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Name: $voucherName',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Points: $diem',
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