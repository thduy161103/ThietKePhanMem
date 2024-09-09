import 'voucher_detail.dart';

class Voucher {
  final String idVoucher;
  int? diem;
  final String? ten;
  final String? hinhanh;
  final String? trigia;
  int quantity;
  VoucherDetail? detail; // Thêm trường này

  Voucher({
    required this.idVoucher,
    required this.quantity,
    this.ten,
    this.hinhanh,
    this.trigia,
    this.detail,
    this.diem,
  });

  // Update fromJson method if needed
  factory Voucher.fromJson(Map<String, dynamic> json) {
    return Voucher(
      idVoucher: json['id'],
      quantity: json['quantity'],
      ten: json['ten'],
      hinhanh: json['hinhanh'],
      trigia: json['trigia'],
    );
  }
}