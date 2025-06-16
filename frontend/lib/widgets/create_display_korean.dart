import 'dart:math';

const maxPrecision = 12;

enum RoundingType {
  round,
  floor,
  ceil,
}

// ✅ 내부 숫자 반올림 유틸 함수
List<String> _rounding(
    String? intStr, String? decimalStr, int decimalLength, RoundingType type) {
  intStr = intStr ?? '';
  if ((decimalStr == null) || (decimalStr == '0')) {
    decimalStr = '';
  }
  if (decimalStr.length <= decimalLength) {
    return [intStr, decimalStr];
  }
  decimalLength = max(min(decimalLength, maxPrecision - intStr.length), 0);
  final value = double.parse('$intStr.${decimalStr}e$decimalLength');
  List<String> rstStrs;
  if (type == RoundingType.ceil) {
    rstStrs = (value.ceil() / pow(10, decimalLength)).toString().split('.');
  } else if (type == RoundingType.floor) {
    rstStrs = (value.floor() / pow(10, decimalLength)).toString().split('.');
  } else {
    rstStrs = (value.round() / pow(10, decimalLength)).toString().split('.');
  }
  if (rstStrs.length == 2) {
    if (rstStrs[1] == '0') {
      rstStrs[1] = '';
    }
    return rstStrs;
  }
  return [rstStrs[0], ''];
}

// ✅ 반환 타입 정의
typedef Display = String Function(num? value);

// ✅ 한국식 단위 스타일 포맷터
Display createDisplayKorean({
  int length = 5,
  int? decimal,
  String placeholder = '',
  String? separator = ',',
  String? decimalPoint = '.',
  RoundingType roundingType = RoundingType.round,
  List<String> units = const ['만', '억', '조', '경', '해', '자', '양', '구', '간', '정'],
}) =>
    (num? value) {
      decimal ??= length;
      placeholder = placeholder.substring(0, min(length, placeholder.length));

      if (value == null || !value.isFinite) {
        return placeholder;
      }

      final valueStr =
          num.parse(value.toStringAsPrecision(maxPrecision)).toString();
      final negative = RegExp(r'^-?').stringMatch(valueStr) ?? '';

      var roundingRst = _rounding(
        RegExp(r'\d+').stringMatch(valueStr) ?? '',
        RegExp(r'(?<=\.)\d+$').stringMatch(valueStr) ?? '',
        decimal!,
        roundingType,
      );
      var integer = roundingRst[0];
      var deci = roundingRst[1];

      final regex = RegExp(r'(\d+?)(?=(\d{4})+(?!\d))');
      final localeInt = integer.replaceAllMapped(regex, (m) => '${m[1]},');

      separator = separator?.substring(0, 1);
      decimalPoint = decimalPoint?.substring(0, 1);

      final currentLen = negative.length + localeInt.length + 1 + deci.length;
      if (separator != null && currentLen <= length) {
        deci = deci.replaceAll(RegExp(r'0+$'), '');
        deci = deci.substring(0, min(decimal!, deci.length));
        return '${negative}${localeInt.replaceAll(',', separator!)}${deci == '' ? '' : decimalPoint}${deci}';
      }

      var space = length - negative.length - integer.length;
      if (space >= 0) {
        roundingRst = _rounding(integer, deci, space - 1, roundingType);
        integer = roundingRst[0];
        deci = roundingRst[1].replaceAll(RegExp(r'0+$'), '');
        deci = deci.substring(0, min(decimal!, deci.length));

        // 💡 3자리 단위 쉼표 적용
        final formattedInt = (separator != null)
            ? integer.replaceAllMapped(
                RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                (m) => '${m[1]}$separator',
              )
            : integer;

        return '${negative}${formattedInt}${deci == '' ? '' : decimalPoint}${deci}';
      }

      final sections = localeInt.split(',');
      if (sections.length > 1) {
        final mainSection = sections[0];
        final tailSection = sections.sublist(1).join();
        final unitIndex = sections.length - 2;

        final unit = unitIndex < units.length ? units[unitIndex] : '';

        space = length - negative.length - mainSection.length - unit.length;
        if (space >= 0) {
          roundingRst =
              _rounding(mainSection, tailSection, space - 1, roundingType);
          final main = roundingRst[0];
          var tail = roundingRst[1].replaceAll(RegExp(r'0+$'), '');
          tail = tail.substring(0, min(decimal!, tail.length));
          return '${negative}${main}${tail == '' ? '' : decimalPoint}${tail}${unit}';
        }
      }

      print('number_display: length: $length is too small for $value');
      return value.toString();
    };
