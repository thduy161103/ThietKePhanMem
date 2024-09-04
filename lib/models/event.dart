import 'dart:developer' as developer;

class Event {
  final String idSuKien;
  final String idThuongHieu;
  final String tenSuKien;
  final String hinhAnh;
  final int soLuongVoucher;
  final String thoiGianBatDau;
  final String thoiGianKetThuc;

  Event({
    required this.idSuKien,
    required this.idThuongHieu,
    required this.tenSuKien,
    required this.hinhAnh,
    required this.soLuongVoucher,
    required this.thoiGianBatDau,
    required this.thoiGianKetThuc,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    developer.log('Parsing event JSON: $json');
    return Event(
      idSuKien: json['id_sukien']?.toString() ?? '',
      idThuongHieu: json['id_thuonghieu']?.toString() ?? '',
      tenSuKien: json['tensukien']?.toString() ?? '',
      hinhAnh: json['hinhanh']?.toString() ?? '',
      soLuongVoucher: json['soluongvoucher'] as int? ?? 0,
      thoiGianBatDau: _extractDate(json['thoigianbatdau']?.toString() ?? ''),
      thoiGianKetThuc: _extractDate(json['thoigianketthuc']?.toString() ?? ''),
    );
  }

  static String _extractDate(String dateTimeString) {
    if (dateTimeString.isEmpty) return '';
    return dateTimeString.split('T')[0];
  }
}