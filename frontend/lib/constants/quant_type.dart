// ignore_for_file: constant_identifier_names

const wasteImageDir = 'assets/images/waste_images';

enum QuantType {
  TREND_FOLLOW(
    code: 'TF',
    name: '추세추종법',
  ),

  DUAL_MOMENTUM_INTL(
    code: 'DM-INTL',
    name: '듀얼모멘텀 국제',
  ),

  // ETC(
  //   code: 'ETC',
  //   name: '기타 투자법',
  // ),

  SELECT(
    code: 'SELECT',
    name: '선택',
  );

  final String code;
  final String name;

  const QuantType({required this.code, required this.name});

  static QuantType fromCode(String code) {
    return QuantType.values.firstWhere(
      (category) => category.code == code,
      orElse: () => SELECT,
    );
  }
}
