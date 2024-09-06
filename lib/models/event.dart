import 'dart:developer' as developer;

class Event {
  final String idSuKien;
  final String idThuongHieu;
  final String idGame;
  final String tenSuKien;
  final String hinhAnh;
  final int soLuongVoucher;
  final String mota;
  final String thoiGianBatDau;
  final String thoiGianKetThuc;
  final String brandName;
  final String gameName;

  Event({
    required this.idSuKien,
    required this.idThuongHieu,
    required this.idGame,
    required this.tenSuKien,
    required this.hinhAnh,
    required this.soLuongVoucher,
    required this.mota,
    required this.thoiGianBatDau,
    required this.thoiGianKetThuc,
    required this.brandName,
    required this.gameName,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    developer.log('Parsing event JSON: $json');
    return Event(
      idSuKien: json['id_sukien']?.toString() ?? '',
      idThuongHieu: json['id_thuonghieu']?.toString() ?? '',
      idGame: json['id_game']?.toString() ?? '',
      tenSuKien: json['tensukien']?.toString() ?? '',
      hinhAnh: json['hinhanh']?.toString() ?? '',
      soLuongVoucher: json['soluongvoucher'] as int? ?? 0,
      mota: json['mota']?.toString() ?? '',
      thoiGianBatDau: _extractDate(json['thoigianbatdau']?.toString() ?? ''),
      thoiGianKetThuc: _extractDate(json['thoigianketthuc']?.toString() ?? ''),
      brandName: json['brand_name']?.toString() ?? '',
      gameName: json['game_name']?.toString() ?? '',
    );
  }

  static String _extractDate(String dateTimeString) {
    if (dateTimeString.isEmpty) return '';
    return dateTimeString.split('T')[0];
  }
}