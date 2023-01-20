import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bts_mobile/model/theme/colors.dart';
import 'package:bts_mobile/widget/kelime_ara/kelime_ara_list_widget.dart';
import 'package:bts_mobile/widget/mana_ara/mana_ara_list_widget.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../main.dart';
import '../service/ad_state.dart';

Widget drawe(context, ref) {
  final adInitialization = MobileAds.instance.initialize();
  final adstate = AdState(initialization: adInitialization);

  return SafeArea(
    child: Container(
      color: CustomColors.renk4,
      child: ListTileTheme(
        textColor: Colors.white,
        iconColor: Colors.white,
        child: Container(
          color: CustomColors.renk4,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: 128.0,
                height: 128.0,
                margin: const EdgeInsets.only(
                  top: 24.0,
                  bottom: 64.0,
                ),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: CustomColors.renk4,
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'assets/images/img2.png',
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => KelimeAraList()),
                        ModalRoute.withName('/KelimePage'));

                    adstate.loadInterstitialAd(context);
                    adstate.interstitialAd?.show();
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(CustomColors.siyah)),
                  child: Container(
                    width: 150,
                    height: 50,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Kelime',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        Icon(
                          Icons.search,
                          color: CustomColors.manaArafield,
                          semanticLabel: 'MANA',
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ),
                  )),
              SizedBox(
                height: 50,
              ),
              ElevatedButton(
                  onPressed: () {
                    adstate.loadInterstitialAd(context);
                    adstate.interstitialAd?.show();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => ManaAraList()),
                        ModalRoute.withName('/ManaPage'));
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(CustomColors.siyah)),
                  child: Container(
                    height: 50,
                    width: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Kafiye ',
                          maxLines: 1,
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        Icon(
                          Icons.search,
                          color: CustomColors.kelimeAra,
                          semanticLabel: 'MANA',
                          textDirection: TextDirection.rtl,
                        ),
                        Text(
                          ' Mânâ',
                          maxLines: 1,
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ],
                    ),
                  )),
              Spacer(),
              DefaultTextStyle(
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white54,
                ),
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 16.0,
                  ),
                  child: Text('Kafiyeli Türkçe Sözlük'),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
