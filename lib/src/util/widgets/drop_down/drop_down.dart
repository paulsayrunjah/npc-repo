import 'package:flutter/material.dart';
import 'package:npc_mobile_flutter/src/util/themes/app_colors.dart';
import 'package:npc_mobile_flutter/src/util/widgets/drop_down/drop_down_item.dart';

dropDown(
        {required final BuildContext context,
        required final List<DropDownItem> list,
        final selectedValue,
        final defaultValue,
        final hintTextColor,
        final hintFontWeight,
        final title,
        final fillColor,
        final double? height,
        final InputDecoration? inputDecoration,
        final onChanged}) =>
    Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
            visible: title != null,
            child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: Text(
                  '$title',
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppColors.appTextLight,
                      fontSize: 15),
                ))),
        SizedBox(
          height: height ?? 50,
          child: FormField<String>(
            builder: (final state) => InputDecorator(
              decoration: InputDecoration(
                  fillColor: fillColor ?? AppColors.textInputBg,
                  filled: true,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0.0, horizontal: 14),
                  focusedBorder: const OutlineInputBorder()),
              isEmpty: selectedValue == defaultValue,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  dropdownColor: Colors.white,
                  style: TextStyle(
                      color: hintTextColor ?? AppColors.darkGray1,
                      fontWeight: hintFontWeight),
                  value: selectedValue,
                  onChanged: onChanged,
                  items: list
                      .map((final value) => DropdownMenuItem<String>(
                            value: value.value.toString(),
                            child: !value.hasIcon
                                ? Text(value.text)
                                : Row(
                                    children: [
                                      Image.asset(
                                        value.icon,
                                        width: 26,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        value.text,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                          ))
                      .toList(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
