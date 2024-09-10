class EventDetail {
  final String idSukien;
  final String idThuonghieu;
  final String idGame;
  final String tenSuKien;
  final String hinhAnh;
  final int soLuongVoucher;
  final String moTa;
  final DateTime thoiGianBatDau;
  final DateTime thoiGianKetThuc;
  final String brandName;

  EventDetail({
    required this.idSukien,
    required this.idThuonghieu,
    required this.idGame,
    required this.tenSuKien,
    required this.hinhAnh,
    required this.soLuongVoucher,
    required this.moTa,
    required this.thoiGianBatDau,
    required this.thoiGianKetThuc,
    required this.brandName,
  });

  factory EventDetail.fromJson(Map<String, dynamic> json) {
    return EventDetail(
      idSukien: json['id_sukien'],
      idThuonghieu: json['id_thuonghieu'],
      idGame: json['id_game'],
      tenSuKien: json['tensukien'],
      hinhAnh: json['hinhanh'],
      soLuongVoucher: json['soluongvoucher'],
      moTa: json['mota'],
      thoiGianBatDau: DateTime.parse(json['thoigianbatdau']),
      thoiGianKetThuc: DateTime.parse(json['thoigianketthuc']),
      brandName: json['brand_name'],
    );
  }
}