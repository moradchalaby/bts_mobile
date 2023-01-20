import 'dart:async';

import 'package:diacritic/diacritic.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:turkish/turkish.dart';
import '../main.dart';

Box<Sozluk> sozlukBox = Hive.box<Sozluk>('Sozluk');

abstract class KelimeModel extends ChangeNotifier {
  String _searchvalue = '';
  bool _sapkali = true;
  bool _deyim = true;
  void incrementCounter();
  void getMMana();
  List<Kelime> kelimeler = sozlukBox.get('kelime')!.kelime;

  List<Kelime> get item;

  int get itm;
  late int _searchmana;

  Kelime get mana;

  void changeSearchmana(int searchmana) {
    _searchmana = searchmana;

    notifyListeners();
  }

  void changeSearchString(String searchvalue, bool sapkali, bool deyim) {
    _searchvalue = searchvalue;
    _sapkali = sapkali;
    _deyim = deyim;
    notifyListeners();
  }
}

class KelimeModelImplementation extends KelimeModel {
  List<Kelime> _items = sozlukBox.get('kelime')!.kelime;
  int _itm = 0;

  Kelime _mana = sozlukBox.get('kelime')!.kelime.first;
  KelimeModelImplementation() {
    Future.delayed(const Duration(seconds: 3))
        .then((_) => getIt.signalReady(this));
  }

  @override
  List<Kelime> get item => _items;

  @override
  int get itm => _itm == -1 ? 0 : _itm;
  @override
  Kelime get mana => _mana;
  @override
  void incrementCounter() {
    var sabit = _itm;
    switch (_deyim) {
      case true:
        _items = kelimeler.toList();

        break;
      case false:
        _items = kelimeler.where((element) => element.deyimid == 0).toList();
    }

    switch (_deyim) {
      case true:
        switch (_sapkali) {
          case true:
            _itm = _searchvalue == ''
                ? 0
                : _items.indexWhere((a) => (removeDiacritics(a.text)
                    .toLowerCaseTr()
                    .startsWith(
                        removeDiacritics(_searchvalue).toLowerCaseTr())));
            break;
          case false:
            _itm = _searchvalue == ''
                ? 0
                : _items.indexWhere((a) => (a.text
                    .toLowerCaseTr()
                    .startsWith(_searchvalue.toLowerCaseTr())));
        }
        break;

      default:
        switch (_sapkali) {
          case true:
            _itm = _searchvalue == ''
                ? _items.indexWhere((a) => a.deyimid == 0)
                : _items.indexWhere((a) =>
                    a.deyimid == 0 &&
                    (removeDiacritics(a.text).toLowerCaseTr().startsWith(
                        removeDiacritics(_searchvalue).toLowerCaseTr())));
            break;
          case false:
            _itm = _searchvalue == ''
                ? _items.indexWhere((a) => a.deyimid == 0)
                : _items.indexWhere((a) =>
                    a.deyimid == 0 &&
                    (a.text
                        .toLowerCaseTr()
                        .startsWith(_searchvalue.toLowerCaseTr())));
        }
    }
    if (_itm == -1) {
      _itm = sabit;
    }
    print(_itm);
    _mana = kelimeler.where((w) => w.id == _items[_itm].id).first;

    notifyListeners();
  }

  @override
  void getMMana() {
    _mana = kelimeler.where((w) => w.id == _searchmana).first;
    //_itm = _items.indexWhere((e) => e.id == _mana.id);

    notifyListeners();
  }
}
