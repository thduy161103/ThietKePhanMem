class VoucherDetail {
  final String idVoucher;
  final String idThuongHieu;
  final String ten;
  final String qrcode;
  final String hinhanh;
  final double trigia;
  final String mota;
  final DateTime ngayhethan;
  final String trangthai;

  VoucherDetail({
    required this.idVoucher,
    required this.idThuongHieu,
    required this.ten,
    required this.qrcode,
    required this.hinhanh,
    required this.trigia,
    required this.mota,
    required this.ngayhethan,
    required this.trangthai,
  });

  factory VoucherDetail.fromJson(Map<String, dynamic> json) {
    return VoucherDetail(
      idVoucher: json['ID_Voucher'],
      idThuongHieu: json['ID_ThuongHieu'],
      ten: json['ten'],
      qrcode: json['qrcode'],
      hinhanh: json['hinhanh'],
      trigia: json['trigia'].toDouble(),
      mota: json['mota'],
      ngayhethan: DateTime.parse(json['ngayhethan']),
      trangthai: json['trangthai'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID_Voucher': idVoucher,
      'ID_ThuongHieu': idThuongHieu,
      'ten': ten,
      'qrcode': qrcode,
      'hinhanh': hinhanh,
      'trigia': trigia,
      'mota': mota,
      'ngayhethan': ngayhethan.toIso8601String(),
      'trangthai': trangthai,
    };
  }
}