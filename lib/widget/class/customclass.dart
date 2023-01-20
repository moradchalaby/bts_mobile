import 'package:flutter/cupertino.dart';
import 'package:bts_mobile/main.dart';
import 'package:bts_mobile/model/debouncer.dart';
import 'package:bts_mobile/provider/kelime_ara_list.dart';

sapkalifonk(TextEditingController controller, String harf) {
  controller.text = controller.text + harf;
  controller.selection =
      TextSelection.fromPosition(TextPosition(offset: controller.text.length));
}

kelimeAra(String aranan, bool sapkali, bool deyim) {
  getIt<KelimeModel>().changeSearchString(aranan, sapkali, deyim);
  getIt<KelimeModel>().incrementCounter();
}

getMana(context, data, index) {
  getIt<KelimeModel>().changeSearchmana(data[index].id);
  getIt<KelimeModel>().getMMana();
}
