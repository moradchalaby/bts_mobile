import 'package:flutter/material.dart';
import 'package:bts_mobile/model/theme/colors.dart';

class KelimeCard extends StatelessWidget {
  final String id;
  final String team;
  final String osmanlica;
  final String text;
  final String deyimid;

  const KelimeCard(
      {super.key,
      required this.id,
      required this.team,
      required this.osmanlica,
      required this.text,
      required this.deyimid});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selectedTileColor: CustomColors.mavi,
      title: Tooltip(
        message: text,
        child: Text(text,
            textAlign: TextAlign.center,
            style: deyimid != '0'
                ? TextStyle(color: CustomColors.gri)
                : Theme.of(context).textTheme.headline1),
      ),
    );
  }
}
