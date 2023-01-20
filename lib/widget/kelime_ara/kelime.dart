import 'dart:ffi';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bts_mobile/model/debouncer.dart';
import 'package:bts_mobile/model/theme/colors.dart';
import 'package:bts_mobile/provider/kelime_ara_list.dart';
import 'package:bts_mobile/widget/class/customclass.dart';
import 'package:indexed_list_view/indexed_list_view.dart';

import '../../main.dart';

class ListKelime extends StatefulWidget {
  @override
  _ListKelimeState createState() => _ListKelimeState();
}

class _ListKelimeState extends State<ListKelime> {
  var controller = IndexedScrollController();

  FocusNode kelimeFocus = FocusNode();
  bool sapkali = false;
  bool deyim = false;
  late String searchtext;
  int kelimesec = getIt<KelimeModel>().itm;
  TextEditingController tcontroller = new TextEditingController();

  var kelimeList = getIt<KelimeModel>().item;
  int kelime = getIt<KelimeModel>().itm;
  final _debouncer = Debouncer(milliseconds: 200, action: () {});
  String kelimesay = getIt<KelimeModel>().kelimeler.length.toString();

  @override
  void initState() {
    getIt
        .isReady<KelimeModel>()
        .then((_) => getIt<KelimeModel>().addListener(update));
    getIt.isReady<KelimeModel>().then((_) => getIt<KelimeModel>().itm);
    super.initState();
  }

  @override
  void dispose() {
    getIt<KelimeModel>().removeListener(update);

    super.dispose();
  }

  void update() => setState(() => {
        kelimeList = getIt<KelimeModel>().item,
        if (kelime != getIt<KelimeModel>().itm)
          {
            kelime = getIt<KelimeModel>().itm,
            controller.jumpToIndex(kelime),
          },
        kelimesay = getIt<KelimeModel>().kelimeler.length.toString(),
      });

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Container(
      decoration: BoxDecoration(
        color: CustomColors.renk4,
        border: Border.all(color: CustomColors.renk5, width: 5),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50), topRight: Radius.circular(50)),
      ),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          //elim avucum bomboş heba eyledim dünü
          //ey yatak beni yarın çağır bugün iş günü

          Container(
            height: 26,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              verticalDirection: VerticalDirection.down,
              children: [
                SizedBox(
                  width: 60,
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(bottom: 50),
                    child: Icon(
                      Icons.search,
                      color: CustomColors.kelimeAra,
                      semanticLabel: 'MANA',
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: new TextField(
                    style: Theme.of(context).textTheme.headline3,
                    focusNode: kelimeFocus,
                    controller: tcontroller,
                    decoration: new InputDecoration(
                      hintText: 'Kelime',
                      hintStyle: Theme.of(context).textTheme.headline5,
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(bottom: 12),
                    ),
                    onChanged: (value) {
                      _debouncer.run(() {
                        kelimeAra(value, sapkali, deyim);
                      });
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        sapkali = !sapkali;
                      });
                      kelimeAra(tcontroller.text, sapkali, deyim);
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: CustomColors.renk5,
                      ),
                      child: Center(
                        child: Text(
                          "â",
                          textAlign: TextAlign.center,
                          style: sapkali
                              ? Theme.of(context).textTheme.caption
                              : Theme.of(context).textTheme.headline1,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      print(deyim);
                      setState(() {
                        deyim ? deyim = false : deyim = true;
                      });
                      kelimeAra(tcontroller.text, sapkali, deyim);
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: CustomColors.renk5,
                      ),
                      child: deyim
                          ? Icon(
                              Icons.format_align_center,
                              color: CustomColors.renk3,
                            )
                          : Icon(
                              Icons.format_align_justify,
                              color: CustomColors.renk1,
                            ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 25,
                )
              ],
            ),
          ),
          Image.asset(
            'assets/images/cizgi.png',
          ),
          Expanded(
            child: IndexedListView.separated(
                physics: ScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                minItemCount: 0,
                separatorBuilder: (context, index) {
                  return new Container(
                    padding: EdgeInsets.zero,
                    margin: EdgeInsets.zero,
                    height: 0.05,
                    color: Colors.white,
                  );
                },
                controller: controller,
                maxItemCount: kelimeList.length,
                itemBuilder: (context, index) {
                  if (kelimeList != null) {
                    return Container(
                      height: 20,
                      child: TextButton(
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                EdgeInsets.all(0)),
                            overlayColor: MaterialStateProperty.all<Color>(
                                CustomColors.hover.withOpacity(0.5)),
                            backgroundColor: kelimesec == index
                                ? MaterialStateProperty.all<Color>(
                                    CustomColors.hover.withOpacity(0.4))
                                : MaterialStateProperty.all<Color>(
                                    CustomColors.renk5)),
                        onPressed: () {
                          getMana(context, kelimeList, index);
                          setState(() {
                            kelimesec = index;
                          });
                        },
                        child: AutoSizeText(
                          kelimeList[index].text,
                          textAlign: TextAlign.justify,
                          maxLines: 1,
                          style: kelimeList[index].deyimid == 0
                              ? Theme.of(context).textTheme.subtitle1
                              : Theme.of(context).textTheme.subtitle2,
                        ),
                      ),
                    ); /*
                        Container(
                      color: kelimesec == index
                          ? CustomColors.hover.withOpacity(0.4)
                          : CustomColors.renk5,
                      child: ListTile(
                        dense: true,
                        onTap: () {
                          getMana(context, kelimeList, index);
                          setState(() {
                            kelimesec = index;
                          });
                        },
                        title: Padding(
                          padding:
                              const EdgeInsets.only(left: 25.0, right: 50.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 3,
                                child: AutoSizeText(
                                  kelimeList[index].text,
                                  textAlign: TextAlign.start,
                                  maxLines: 1,
                                  style: kelimeList[index].deyimid == 0
                                      ? Theme.of(context).textTheme.headline2
                                      : Theme.of(context).textTheme.headline4,
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 3,
                                child: AutoSizeText(
                                  kelimeList[index].osmanlica,
                                  textAlign: TextAlign.start,
                                  maxLines: 1,
                                  style: Theme.of(context).textTheme.headline1,
                                  textDirection: TextDirection.rtl,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );*/
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
          ),
        ],
      ),
    );
  }
}
