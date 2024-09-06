class EventDetail {
  final String idSuKien;
  final String idThuongHieu;
  final String idGame;
  final String tenSuKien;
  final String hinhAnh;
  final int soLuongVoucher;
  final String moTa;
  final DateTime thoiGianBatDau;
  final DateTime thoiGianKetThuc;
  final String brandName;
  final String gameName;

  EventDetail({
    required this.idSuKien,
    required this.idThuongHieu,
    required this.idGame,
    required this.tenSuKien,
    required this.hinhAnh,
    required this.soLuongVoucher,
    required this.moTa,
    required this.thoiGianBatDau,
    required this.thoiGianKetThuc,
    required this.brandName,
    required this.gameName,
  });

  factory EventDetail.fromJson(Map<String, dynamic> json) {
    return EventDetail(
      idSuKien: json['id_sukien'],
      idThuongHieu: json['id_thuonghieu'],
      idGame: json['id_game'],
      tenSuKien: json['tensukien'],
      hinhAnh: json['hinhanh'],
      soLuongVoucher: json['soluongvoucher'],
      moTa: json['mota'],
      thoiGianBatDau: DateTime.parse(json['thoigianbatdau']),
      thoiGianKetThuc: DateTime.parse(json['thoigianketthuc']),
      brandName: json['brand_name'],
      gameName: json['game_name'],
    );
  }
}