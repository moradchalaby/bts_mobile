import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:bts_mobile/model/theme/colors.dart';

import 'package:bts_mobile/widget/drawer.dart';
import 'package:bts_mobile/widget/kelime_ara/kelime.dart';
import 'package:bts_mobile/widget/kelime_ara/mana.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class KelimeAraList extends ConsumerStatefulWidget {
  const KelimeAraList({super.key});

  @override
  ConsumerState<KelimeAraList> createState() => _KelimeAraListState();
}

class _KelimeAraListState extends ConsumerState<KelimeAraList> {
  final _advancedDrawerController = AdvancedDrawerController();

  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
  }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return AdvancedDrawer(
        backdropColor: CustomColors.renk4,
        controller: _advancedDrawerController,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        childDecoration: const BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: Scaffold(
          appBar: AppBar(
            leadingWidth: 30,
            toolbarHeight: 30,
            shadowColor: Colors.transparent,
            backgroundColor: CustomColors.renk4,
            title: Text(
              'SÖZLÜK',
              style: TextStyle(fontSize: 20),
            ),
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
              children: [
                Expanded(flex: 10, child: ListMana()),
                Expanded(flex: 5, child: ListKelime())
              ],
            ),
          ),
        ),
        drawer: drawe(context, ref));
  }
}
