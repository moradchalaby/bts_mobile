import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:bts_mobile/model/theme/colors.dart';

import 'package:bts_mobile/provider/mana_ara_list.dart';
import 'package:bts_mobile/widget/drawer.dart';
import 'package:bts_mobile/widget/mana_ara/kelime.dart';
import 'package:bts_mobile/widget/mana_ara/mana.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../main.dart';
import '../../model/debouncer.dart';

class ManaAraList extends ConsumerStatefulWidget {
  @override
  ConsumerState<ManaAraList> createState() => _ManaAraListState();
}

class _ManaAraListState extends ConsumerState<ManaAraList> {
  late String searchtext;
  TextEditingController tcontroller = new TextEditingController();

  //Box manaBox;

  final _advancedDrawerController = AdvancedDrawerController();

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }

  @override
  void initState() {
    // Access the instance of the registered AppModel
    // As we don't know for sure if AppModel is already ready we use getAsync

    getIt
        .isReady<ManaAraModel>()
        .then((_) => getIt<ManaAraModel>().addListener(update));
    // Alternative
    // getIt.getAsync<AppModel>().addListener(update);

    super.initState();
  }

  @override
  void dispose() {
    getIt<ManaAraModel>().removeListener(update);
    super.dispose();
  }

  void update() => setState(() => {});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return FutureBuilder(
        future: getIt.allReady(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return AdvancedDrawer(
                backdropColor: CustomColors.renk4,
                controller: _advancedDrawerController,
                animationCurve: Curves.easeInOut,
                animationDuration: const Duration(milliseconds: 300),
                childDecoration: const BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                drawer: drawe(context, ref),
                child: Scaffold(
                  appBar: AppBar(
                    leadingWidth: 30,
                    toolbarHeight: 30,
                    backgroundColor: CustomColors.renk5,
                    shadowColor: Colors.transparent,
                    title: const Text('KAFİYE VE MANA',
                        style: TextStyle(fontSize: 20)),
                    leading: IconButton(
                      iconSize: 20,
                      onPressed: _handleMenuButtonPressed,
                      icon: ValueListenableBuilder<AdvancedDrawerValue>(
                        valueListenable: _advancedDrawerController,
                        builder: (context, value, child) {
                          return Icon(
                            value.visible ? Icons.clear : Icons.menu,
                          );
                        },
                      ),
                    ),
                  ),
                  body: DoubleBackToCloseApp(
                    snackBar: const SnackBar(
                      content: Text('Çıkmak için tekrar tıklaıyın.'),
                    ),
                    child: Column(
                      //alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Expanded(flex: 1, child: ListManaAraMana()),
                        Expanded(flex: 1, child: ListManaAraKelime())
                      ],
                    ),
                  ),
                ));
          } else {
            return new Scaffold(
              body: new Center(child: const Text('Mana Ara')),
            );
          }
        });
  }
}
