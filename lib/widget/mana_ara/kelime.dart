import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bts_mobile/model/debouncer.dart';
import 'package:bts_mobile/model/theme/colors.dart';
import 'package:bts_mobile/provider/kelime_ara_list.dart';
import 'package:bts_mobile/provider/mana_ara_list.dart';

import '../../main.dart';

class ListManaAraKelime extends StatefulWidget {
  @override
  _ListManaAraKelimeState createState() => _ListManaAraKelimeState();
}

class _ListManaAraKelimeState extends State<ListManaAraKelime> {
  ScrollController controller = ScrollController();
  bool sapkali = false;
  bool deyim = false;
  TextEditingController mcontroller = new TextEditingController();
  TextEditingController kcontroller = new TextEditingController();
  FocusNode kelimeFocus = FocusNode();
  int kelimesec = getIt<KelimeModel>().itm;

  /* var controller =
      IndexedScrollController(initialIndex: 0, initialScrollOffset: 0.0); */
  var kelimeList = getIt<ManaAraModel>().item;
  int kelimesay = getIt<ManaAraModel>().item.length;
  final _debouncer = Debouncer(milliseconds: 300, action: () {});
  getMana(context, data, index) {
    getIt<ManaAraModel>().changeSearchmana(data[index].id);
    getIt<ManaAraModel>().getMana();
  }

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
        deyim = getIt<ManaAraModel>().deyim,
        kelimeList = getIt<ManaAraModel>().item,
        kelimesay = getIt<ManaAraModel>().item.length,
        controller = ScrollController(initialScrollOffset: 0.0),
      });

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    print(MediaQuery.of(context).size.width);
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
                      child: kcontroller.text.isNotEmpty
                          ? Icon(
                              Icons.manage_search_sharp,
                              color: CustomColors.kelimeAra,
                            )
                          : Icon(
                              Icons.search,
                              color: CustomColors.kelimeAra,
                              semanticLabel: 'MANA',
                              textDirection: TextDirection.rtl,
                            )),
                ),
                Expanded(
                  flex: 3,
                  child: new TextField(
                    style: Theme.of(context).textTheme.headline3,
                    focusNode: kelimeFocus,
                    cursorRadius: Radius.circular(50),
                    controller: kcontroller,
                    decoration: new InputDecoration(
                      hintText: 'Kafiye',
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
                        getIt<ManaAraModel>()
                            .changeSearchString(mcontroller.text, value, deyim);
                        getIt<ManaAraModel>().incrementCounter();
                      });
                    },
                  ),
                ),
                Expanded(
                  child: VerticalDivider(
                    thickness: 1,
                    color: CustomColors.renk5,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(bottom: 50),
                    child: Icon(
                      Icons.search,
                      color: CustomColors.manaArafield,
                      semanticLabel: 'MANA',
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: TextField(
                    style: Theme.of(context).textTheme.headline3,
                    focusNode: kelimeFocus,
                    cursorRadius: Radius.circular(50),
                    controller: mcontroller,
                    decoration: new InputDecoration(
                      hintText: 'Mâna ',
                      hintStyle: Theme.of(context).textTheme.bodyText1,
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(bottom: 12),
                    ),
                    onChanged: (value) {
                      _debouncer.run(() {
                        getIt<ManaAraModel>()
                            .changeSearchString(value, kcontroller.text, deyim);
                        getIt<ManaAraModel>().incrementCounter();
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
              ],
            ),
          ),
          Image.asset(
            'assets/images/cizgi.png',
            color: CustomColors.renk1.withOpacity(0.7),
          ),
          Container(
            width: 350,
            alignment: Alignment.center,
            margin: EdgeInsets.only(right: 25),
            decoration: BoxDecoration(
                color: CustomColors.renk4,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            child: Text(
              kelimesay.toString() + ' kelime bulundu.',
              style: TextStyle(
                  fontSize: 12,
                  color: CustomColors.renk1.withOpacity(0.8),
                  fontFamily: 'Minion',
                  fontWeight: FontWeight.normal),
            ),
          ),
          Image.asset(
            'assets/images/cizgi.png',
            color: CustomColors.renk1.withOpacity(0.7),
          ),
          Expanded(
              flex: 30,
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 0.0,
                    crossAxisSpacing: 1.0,
                    childAspectRatio: 8,
                  ),
                  // emptyItemBuilder: (context, index) => Text('geleyor'),
                  physics:
                      ScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  itemCount: kelimeList.length,
                  /* separatorBuilder: (context, index) {
                    return new Container(
                      padding: EdgeInsets.zero,
                      margin: EdgeInsets.zero,
                      height: 0.05,
                      color: Colors.white,
                    );
                  }, */
                  controller: controller,
                  //itemCount: kelimeList.length,

                  itemBuilder: (context, index) {
                    if (kelimeList.length == 0) {
                      return Center(
                          child: CircularProgressIndicator(
                        backgroundColor: CustomColors.renk5,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(CustomColors.renk4),
                      ));
                    } else {
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
                      );
                    }
                  })),
        ],
      ),
    );
  }
}
