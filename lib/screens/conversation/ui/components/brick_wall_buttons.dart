import 'package:flutter/material.dart';

class BrickWallButtons extends StatelessWidget {
  final List<String> stringList;
  final Function(String) itemOnPressed;
  final Color borderColor;
  final Color textColor;
  const BrickWallButtons(
      {super.key,
      required this.stringList,
      required this.itemOnPressed,
      this.borderColor = Colors.blue,
      this.textColor = Colors.blue});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 48, top: 8, right: 16, bottom: 8),
          child: Wrap(
            alignment: WrapAlignment.end,
            spacing: 8.0,
            runSpacing: 8.0,
            children: stringList.map((String item) {
              return Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: borderColor,
                    ),
                    //color: Colors.blue[400],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextButton(
                    onPressed: () {
                      itemOnPressed(item);
                    },
                    child: Text(
                      item,
                      style: TextStyle(color: textColor),
                    ),
                  ));
            }).toList(),
          ),
        ),
      ),
    );
  }
}
