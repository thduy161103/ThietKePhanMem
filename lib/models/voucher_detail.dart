class VoucherDetail {
  final String idVoucher;
  final String ten;
  final String qrcode;
  final String hinhanh;
  final int trigia;
  final String mota;
  final DateTime ngayhethan;
  final bool trangthai;
  final String idThuonghieu;
  final String brandName;

  VoucherDetail({
    required this.idVoucher,
    required this.ten,
    required this.qrcode,
    required this.hinhanh,
    required this.trigia,
    required this.mota,
    required this.ngayhethan,
    required this.trangthai,
    required this.idThuonghieu,
    required this.brandName,
  });

  factory VoucherDetail.fromJson(Map<String, dynamic> json) {
    return VoucherDetail(
      idVoucher: json['id_voucher'],
      ten: json['ten'],
      qrcode: json['qrcode'],
      hinhanh: json['hinhanh'],
      trigia: json['trigia'],
      mota: json['mota'],
      ngayhethan: DateTime.parse(json['ngayhethan']),
      trangthai: json['trangthai'],
      idThuonghieu: json['id_thuonghieu'],
      brandName: json['brand_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID_Voucher': idVoucher,
      'ten': ten,
      'qrcode': qrcode,
      'hinhanh': hinhanh,
      'trigia': trigia,
      'mota': mota,
      'ngayhethan': ngayhethan.toIso8601String(),
      'trangthai': trangthai,
      'idThuonghieu': idThuonghieu,
      'brandName': brandName,
    };
  }
}