class Voucher {
  final String idVoucher;
  final String idUser;
  final String idVoucherDetail;
  final String ten;
  final String hinhanh;
  final double trigia;
  final DateTime ngayhethan;
  final String trangthai;

  Voucher({
    required this.idVoucher,
    required this.idUser,
    required this.idVoucherDetail,
    required this.ten,
    required this.hinhanh,
    required this.trigia,
    required this.ngayhethan,
    required this.trangthai,
  });

  factory Voucher.fromJson(Map<String, dynamic> json) {
    return Voucher(
      idVoucher: json['ID_Voucher'],
      idUser: json['ID_User'],
      idVoucherDetail: json['ID_VoucherDetail'],
      ten: json['ten'],
      hinhanh: json['hinhanh'],
      trigia: json['trigia'].toDouble(),
      ngayhethan: DateTime.parse(json['ngayhethan']),
      trangthai: json['trangthai'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID_Voucher': idVoucher,
      'ID_User': idUser,
      'ID_VoucherDetail': idVoucherDetail,
      'ten': ten,
      'hinhanh': hinhanh,
      'trigia': trigia,
      'ngayhethan': ngayhethan.toIso8601String(),
      'trangthai': trangthai,
    };
  }
}