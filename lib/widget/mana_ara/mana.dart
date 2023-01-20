//? listview e consumer eklenecek

import 'package:auto_size_text/auto_size_text.dart';
import 'package:bts_mobile/service/ad_state.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:bts_mobile/model/debouncer.dart';
import 'package:bts_mobile/model/theme/colors.dart';
import 'package:bts_mobile/provider/kelime_ara_list.dart';
import 'package:bts_mobile/provider/mana_ara_list.dart';
import 'package:bts_mobile/widget/kelime_ara/kelime_ara_list_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:styled_text/styled_text.dart';
import 'package:styled_text/tags/styled_text_tag.dart';
import 'package:styled_text/tags/styled_text_tag_action.dart';

import '../../main.dart';

class ListManaAraMana extends StatefulWidget {
  @override
  _ListManaAraManaState createState() => _ListManaAraManaState();
}

class _ListManaAraManaState extends State<ListManaAraMana> {
  int say = 0;
  final _debouncer = Debouncer(milliseconds: 10, action: () {});
  late Box<Sozluk> sozlukBox;
  var manaList = getIt<ManaAraModel>().mana.mana;
  Kelime kelime = getIt<ManaAraModel>().mana;
  @override
  void initState() {
    getIt
        .isReady<ManaAraModel>()
        .then((_) => getIt<ManaAraModel>().addListener(update));

    super.initState();
  }

  @override
  void dispose() {
    getIt<ManaAraModel>().removeListener(update);
    super.dispose();
  }

  void update() => setState(() => {
        kelime = getIt<ManaAraModel>().mana,
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
            child: Column(
              children: [
                Image.asset(
                  'assets/images/cizgi.png',
                ),
                /* Container(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  decoration: BoxDecoration(
                      color: CustomColors.renk5,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20))),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 50.0, right: 50.0),
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
                      ],
                    ),
                  ),
                ), */
                Expanded(
                  child: new Column(
                    children: <Widget>[
                      new Expanded(
                        child: ListView.builder(
                          itemCount: manaList.length,
                          itemBuilder: (context, index) {
                            if (manaList.isEmpty) {
                              return CircularProgressIndicator();
                            } else {
                              bool firstChar = true;

                              String aranan;
                              if (manaList[index].contains('^') ||
                                  manaList[index].contains('*') ||
                                  manaList[index].contains('%') ||
                                  manaList[index].contains('#')) {
                                firstChar = false;
                              } else {
                                say++;

                                firstChar = true;
                              }

                              return Container(
                                margin:
                                    EdgeInsets.only(left: 10.0, right: 20.0),
                                child: StyledText.selectable(
                                    textAlign: TextAlign.start,
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
                                          style: TextStyle(
                                              color: CustomColors
                                                  .rakam)), //?sayılar
                                      '*': StyledTextTag(
                                          style: TextStyle(
                                              color:
                                                  CustomColors.aruz)), //?Aruz
                                      '#': StyledTextTag(
                                          style: TextStyle(
                                              height: 1,
                                              fontStyle: FontStyle.italic,
                                              color:
                                                  CustomColors.ornek)), //?örnek
                                      '%': StyledTextTag(
                                          style: TextStyle(
                                              color: CustomColors
                                                  .aciklama)), //?değişim açıklama
                                      '^': StyledTextTag(
                                          style: TextStyle(
                                              height: 2,
                                              color: CustomColors.tur)),
                                    } //?özellik
                                    ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  child: const GetBannerAd(),
                  height: 50,
                )
              ],
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
