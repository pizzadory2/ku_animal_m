import 'package:get/get.dart';

import 'koKR.dart';
import 'enUS.dart';
import 'jaJP.dart';

class Languages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'ko_KR': koKR,
        'en_US': enUS,
        'ja_JP': jaJP,
        'ar': {
          'hello': 'مرحبا بالعالم',
        },
      };
}
