import 'package:doctor/core/theme/app_color.dart';
import 'package:flutter/material.dart';

class SelectOneFromOptionsWidget extends StatefulWidget {
  const SelectOneFromOptionsWidget({super.key, required this.items});
  final List<String> items;

  @override
  State<SelectOneFromOptionsWidget> createState() =>
      _SelectOneFromOptionsWidgetState();
}

class _SelectOneFromOptionsWidgetState
    extends State<SelectOneFromOptionsWidget> {
  int currentINdex = -1;

  @override
  Widget build(BuildContext context) {
    final bool desktop = MediaQuery.of(context).size.width >= 900;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: desktop ? 420 : double.infinity, // ✅ FIX
        ),
        child: Row(
          children: [
            ...List.generate(widget.items.length, (index) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    decoration: BoxDecoration(
                      gradient:
                          index == currentINdex
                              ? LinearGradient(
                                colors: [AppColor.darkblue, AppColor.lightblue],
                              )
                              : null,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColor.darkblue),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        setState(() {
                          currentINdex = index;
                        });
                      },
                      child: Text(
                        widget.items[index],
                        style: TextStyle(
                          fontSize: 10,
                          fontFamily: 'Serif',
                          color:
                              index == currentINdex
                                  ? Colors.white
                                  : const Color.fromARGB(255, 33, 33, 33),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
