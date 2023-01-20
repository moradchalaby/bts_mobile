import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import 'package:bts_mobile/provider/mana_ara_list.dart';
import 'package:bts_mobile/widget/mana_ara/mana_ara_list_widget.dart';

import 'loading.dart';
import 'model/theme/theme_model.dart';
import 'provider/kelime_ara_list.dart';
import 'service/ad_state.dart';
import 'widget/kelime_ara/kelime_ara_list_widget.dart';

part 'main.g.dart';

@HiveType(typeId: 2)
class Kelime {
  Kelime({
    required this.id,
    required this.deyimid,
    required this.osmanlica,
    required this.text,
    required this.team,
    required this.mana,
  });
  @HiveField(0)
  int id;
  @HiveField(1)
  int deyimid;
  @HiveField(2)
  String osmanlica;
  @HiveField(3)
  String text;
  @HiveField(4)
  int team;
  @HiveField(5)
  List mana;

  factory Kelime.fromMap(Map<String, dynamic> json) => Kelime(
        id: json["id"],
        deyimid: json["deyimid"],
        osmanlica: json["osmanlica"],
        text: json["text"],
        team: json["team"],
        mana: json['mana'],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "deyimid": deyimid,
        "osmanlica": osmanlica,
        "text": text,
        "team": team,
        "mana": mana,
      };
}

@HiveType(typeId: 3)
class Mana {
  Mana({
    required this.id,
    required this.text,
  });
  @HiveField(0)
  String id;
  @HiveField(1)
  String text;

  factory Mana.fromMap(Map<String, dynamic> json) => Mana(
        id: json["id"],
        text: json["text"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "text": text,
      };
}

@HiveType(typeId: 1)
class Sozluk {
  Sozluk({required this.kelime, required this.mana});

  @HiveField(0)
  List<Kelime> kelime;

  @HiveField(1)
  List<Mana> mana;

  @override
  String toString() {
    return '${kelime.length}: ${mana.length}';
  }
}

final adStateProvider = ChangeNotifierProvider.autoDispose<AdState>(
    ((ref) => throw UnimplementedError()));
GetIt getIt = GetIt.instance;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final adInitialization = MobileAds.instance.initialize();
  final adState = AdState(initialization: adInitialization);

  await adState.loadAppOpenAd();
  Directory document = await getApplicationDocumentsDirectory();
  Hive
    ..init(document.path)
    ..registerAdapter(SozlukAdapter())
    ..registerAdapter(ManaAdapter())
    ..registerAdapter(KelimeAdapter());

  await Hive.openBox<Sozluk>('Sozluk');
  //await Hive.box<Sozluk>('Sozluk').clear();

  runApp(
    ProviderScope(
        overrides: [adStateProvider.overrideWithValue(adState)],
        child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  static const String title = 'KAFİYELİ TÜRKÇE SÖZLÜK';

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return ProviderScope(
        child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      theme: CustomTheme.lightTheme,
      darkTheme: CustomTheme.darkTheme,
      home: SplashScreen(),
      routes: <String, WidgetBuilder>{
        //'/MyHomePage': (BuildContext context) => new MyHomePage(),
        '/YukleniyorPage': (BuildContext context) => new YukleniyorPage(),
        '/ManaPage': (BuildContext context) => new ManaAraList(),
        '/KelimePage': (BuildContext context) => new KelimeAraList(),
      },
    ));
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State {
  late Box<Sozluk> kelimeBox;
  late Box<Sozluk> manaBox;
  late List<Kelime> sozluk;
  @override
  void initState() {
    kelimeBox = Hive.box<Sozluk>('Sozluk');
    Future.delayed(Duration.zero, () async {
      if (kelimeBox.isEmpty) {
        Navigator.of(context).pushReplacementNamed('/YukleniyorPage');
      } else {
        getIt.registerSingleton<KelimeModel>(KelimeModelImplementation(),
            signalsReady: true);

        getIt.registerSingleton<ManaAraModel>(ManaAraModelImplementation(),
            signalsReady: true);

        // Alternative
        // getIt.getAsync<AppModel>().addListener(update);
        SystemChrome.setEnabledSystemUIOverlays([]);
        Navigator.of(context).pushReplacementNamed('/KelimePage');
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getIt.allReady(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return new Scaffold(
              body: new Center(child: Text('Kelimeler listeleniyor...')),
            );
          } else {
            return new Scaffold(
              body: new Center(child: Text('Kelimeler listeleniyor...')),
            );
          }
        });
  }
}
