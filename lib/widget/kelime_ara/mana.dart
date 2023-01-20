//? listview e consumer eklenecek

import 'dart:io';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:bts_mobile/model/debouncer.dart';
import 'package:bts_mobile/model/theme/colors.dart';
import 'package:bts_mobile/provider/kelime_ara_list.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:styled_text/styled_text.dart';

import '../../main.dart';
import '../../service/ad_state.dart';

class ListMana extends StatefulWidget {
  @override
  _ListManaState createState() => _ListManaState();
}

class _ListManaState extends State<ListMana> {
  int say = 0;
  final _debouncer = Debouncer(milliseconds: 10, action: () {});
  late Box<Sozluk> sozlukBox;
  var manaList = getIt<KelimeModel>().mana.mana;
  Kelime kelime = getIt<KelimeModel>().mana;
  ScrollController controller = ScrollController();
  final _screencont = ScreenshotController();
  late File _imageFile;
  @override
  void initState() {
    getIt
        .isReady<KelimeModel>()
        .then((_) => getIt<KelimeModel>().addListener(update));

    super.initState();
  }

  @override
  void dispose() {
    getIt<KelimeModel>().removeListener(update);
    super.dispose();
  }

  void update() => setState(() => {
        kelime = getIt<KelimeModel>().mana,
        manaList = kelime.mana,
      });

  @override
  Widget build(BuildContext context) {
    say = 0;
    var copyci = manaList.toString();
    var copy = copyci
        .substring(1, copyci.length - 1)
        .replaceAll('<^>', '\n')
        .replaceAll('</^>', '')
        .replaceAll('<#>', '\n')
        .replaceAll('</#>', '')
        .replaceAll('<link>', '\n')
        .replaceAll('</link>', '')
        .replaceAll('<*>', '\n')
        .replaceAll('</*>', '')
        .replaceAll('<%>', '\n')
        .replaceAll('</%>', '')
        .replaceAll('. , ', '.\n');
    return Scaffold(
      body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Screenshot(
              controller: _screencont,
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/cizgi.png',
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 25,
                    decoration: const BoxDecoration(
                        color: CustomColors.renk5,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20))),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 40.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 3,
                            child: AutoSizeText(
                              kelime.text,
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              style: kelime.deyimid == 0
                                  ? Theme.of(context).textTheme.subtitle1
                                  : Theme.of(context).textTheme.subtitle2,
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 3,
                            child: AutoSizeText(
                              kelime.osmanlica,
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              style: Theme.of(context).textTheme.headline2,
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                          const SizedBox(
                            width: 1,
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Expanded(
                          child: ListView.builder(
                            controller: controller,
                            itemCount: manaList.length,
                            itemBuilder: (context, index) {
                              if (manaList.isEmpty) {
                                return const CircularProgressIndicator();
                              } else {
                                bool firstChar = true;

                                String aranan = "";
                                if (manaList[index].contains('^') ||
                                    manaList[index].contains('*') ||
                                    manaList[index].contains('%') ||
                                    manaList[index].contains('#')) {
                                  firstChar = false;
                                } else {
                                  say++;

                                  firstChar = true;
                                }
                                if (manaList[index].contains('(bk.') &&
                                    !manaList[index].contains('<link>')) {
                                  const start = "(bk. ";
                                  const end = ")";

                                  final startIndex =
                                      manaList[index].indexOf(start);
                                  final endIndex = manaList[index]
                                      .indexOf(end, startIndex + start.length);
                                  aranan = manaList[index].substring(
                                      startIndex + start.length, endIndex);

                                  manaList[index] =
                                      '<link>' + manaList[index] + '</link>';
                                } else if (manaList[index].contains('(bk.') &&
                                    manaList[index].contains('<link>')) {
                                  const start = "(bk. ";
                                  const end = ")";

                                  final startIndex =
                                      manaList[index].indexOf(start);
                                  final endIndex = manaList[index]
                                      .indexOf(end, startIndex + start.length);
                                  aranan = manaList[index].substring(
                                      startIndex + start.length, endIndex);
                                } else if (!manaList[index].contains('(bk.')) {
                                  if (manaList[index].contains('bk.') &&
                                      !manaList[index].contains('<link>')) {
                                    aranan = manaList[index]
                                        .substring(
                                            3, (manaList[index].length - 1))
                                        .trimLeft();
                                    manaList[index] =
                                        '<link>' + manaList[index] + '</link>';
                                  } else if (manaList[index].contains('bk.') &&
                                      manaList[index].contains('<link>')) {
                                    aranan = manaList[index]
                                        .substring(
                                            9, (manaList[index].length - 8))
                                        .trimLeft();
                                  }
                                }

                                return Container(
                                  margin: const EdgeInsets.only(
                                      left: 5.0, right: 3.0),
                                  child: StyledText.selectable(
                                    textAlign: TextAlign.justify,
                                    text: ((firstChar
                                            ? '<_>' +
                                                (say).toString() +
                                                '. ' +
                                                '</_>'
                                            : '') +
                                        manaList[index]),
                                    style:
                                        Theme.of(context).textTheme.headline1,
                                    tags: {
                                      '_': StyledTextTag(
                                          style: const TextStyle(
                                              color: CustomColors
                                                  .rakam)), //?sayılar
                                      '*': StyledTextTag(
                                          style: const TextStyle(
                                              color:
                                                  CustomColors.aruz)), //?Aruz
                                      '#': StyledTextTag(
                                          style: const TextStyle(
                                              height: 1,
                                              fontStyle: FontStyle.italic,
                                              color:
                                                  CustomColors.ornek)), //?örnek
                                      '%': StyledTextTag(
                                          style: const TextStyle(
                                              color: CustomColors
                                                  .aciklama)), //?değişim açıklama
                                      '^': StyledTextTag(
                                          style: const TextStyle(
                                              height: 2,
                                              color:
                                                  CustomColors.tur)), //?özellik
                                      'link': StyledTextActionTag(
                                        (text, attrs) => _debouncer.run(() {
                                          if (kDebugMode) {
                                            print(aranan);
                                          }
                                          getIt<KelimeModel>()
                                              .changeSearchString(
                                                  aranan, false, false);
                                          getIt<KelimeModel>()
                                              .incrementCounter();
                                        }),
                                        style: const TextStyle(
                                            decorationThickness: 0.5,
                                            decorationColor: CustomColors.renk3,
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                    },
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                    child: GetBannerAd(),
                  )
                ],
              ),
            ),
          )),
      floatingActionButton: FloatingActionButton(
          mini: true,
          tooltip: 'müstensih',
          backgroundColor: CustomColors.renk5.withOpacity(0), //!Kopyalaarkaplan
          elevation: 7.0,
          onPressed: () {
            Share.share(kelime.text + ':\n' + copy);
          },
          child: Icon(
            Icons.share,
            color: Colors.white.withOpacity(0.3),
          )),
    );
  }
}
