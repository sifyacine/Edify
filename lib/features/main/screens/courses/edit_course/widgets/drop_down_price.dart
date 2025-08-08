import 'package:edify/features/main/controller/courses/course_edit_controller.dart/course_update_controller.dart';
import 'package:edify/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class DropDownPrice extends StatefulWidget {
  final RxInt selectedItem;
  final List<RxInt> prices;
  final controller;

  const DropDownPrice(
      {super.key,
      required this.selectedItem,
      required this.prices,
      required this.controller});

  @override
  State<DropDownPrice> createState() => _DropDownPriceState();
}

class _DropDownPriceState extends State<DropDownPrice> {
  @override
  Widget build(BuildContext context) {
    RxInt item = widget.selectedItem;
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<RxInt>(
            decoration: InputDecoration(
              labelText: "اختر السعر",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
            value: widget.selectedItem,
            items: widget.prices.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Row(
                  children: [Text(item.value.toString()), const Text(" DZ")],
                ),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                widget.selectedItem.value = newValue!.value;
                item = newValue;
                print(item);
              });
            },
          ),
        ),
        IconButton(
            onPressed: () async {
              if (!widget.controller.isLoadingPrice.value) {
                widget.controller.editPrice(item.toString());
              }
            },
            icon: const Icon(
              Icons.send,
              color: TColors.primary,
            ))
      ],
    );
  }
}
