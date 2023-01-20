import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:bts_mobile/provider/mana_ara_list.dart';
import 'package:bts_mobile/widget/kelime_ara/kelime_ara_list_widget.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'main.dart';
import 'model/debouncer.dart';
import 'model/theme/colors.dart';
import 'provider/kelime_ara_list.dart';

class YukleniyorPage extends StatefulWidget {
  @override
  _YukleniyorPageState createState() => _YukleniyorPageState();
}

class _YukleniyorPageState extends State<YukleniyorPage> {
  String message = 'YÜKLENİYOR...';

  double percent = 0.0;
  int progM = 0;
  late Box<Sozluk> sozlukBox;
  bool hazir = false;
  List<Kelime> kelimeList = <Kelime>[];
  var manaList;
  bool start = false;
  final _debouncer = DebouncerMain(seconds: 5, action: () {});

  final String kelimePath = 'assets/szlkint.json';
  //final String manaPath = 'assets/manalar_data.json';
  Future<List<Kelime>> kelimeJson() async {
    var kelimeData = await rootBundle.loadString('assets/szlkint.json');

    List<dynamic> decodedJson = json.decode(kelimeData);

    kelimeList = decodedJson.map((kelime) => Kelime.fromMap(kelime)).toList();
    var kelimem = Sozluk(kelime: kelimeList, mana: []);
    await sozlukBox.put('kelime', kelimem);
    return kelimeList;
  }

  /* Future<void> manaJson() async {
    var manaData = await rootBundle.loadString('assets/manalar_data.json');

    List<dynamic> decodedJson = json.decode(manaData);
    manaList = decodedJson.map((mana) => Mana.fromMap(mana)).toList();
    var manam = Sozluk(mana: manaList);
    await sozlukBox.put('mana', manam);

    return manaList;
  } */

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    super.initState();
    sozlukBox = Hive.box<Sozluk>('Sozluk');
    manaListele();
  }

  manaListele() async {
    setState(() {
      percent = 0.2;
    });

    //await manaJson();
    setState(() {
      percent = 0.7;
    });
    await kelimeJson();
    setState(() {
      percent = 1;
      hazir = true;
      message = "TAMAMLANDI";
    });
    /* _debouncer.run(() {
      Navigator.of(context).pushReplacementNamed('/MyHomePage');
    }); */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          new LinearPercentIndicator(
            linearGradient: LinearGradient(
              colors: [CustomColors.renk3, CustomColors.renk5],
            ),
            animateFromLastPercent: true,
            animation: true,
            width: MediaQuery.of(context).size.width - 20,
            lineHeight: 20.0,
            percent: percent,
            backgroundColor: CustomColors.renk5.withOpacity(0.3),
            //progressColor: CustomColors.siyah,
          ),
          ElevatedButton(
            onPressed: () {
              if (hazir) {
                getIt.registerSingleton<KelimeModel>(
                    KelimeModelImplementation(),
                    signalsReady: true);

                getIt.registerSingleton<ManaAraModel>(
                    ManaAraModelImplementation(),
                    signalsReady: true);

                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => KelimeAraList()),
                    ModalRoute.withName('/KelimePage'));
              } else {
                null;
              }
            },
            child: hazir ? Text('TAMAMLANDI...') : Text('HAZIRLANIYOR...'),
          ),
        ],
      ),
    );
  }
}
