import 'package:flutter/material.dart';
import 'package:npc_mobile_flutter/src/util/themes/app_colors.dart';

textFieldInput({
  final controller,
  final keyboardType,
  final String? Function(String?)? validator,
  final fillColor,
  final hintText = '',
  final enabled = true,
  final readOnly = false,
  final obscureText = false,
  final prefixIcon,
  final suffixIcon,
  final onChanged,
  final onTap,
  final minLines,
  final maxLines,
  final int? maxLength,
  final title,
  final inputDecoration,
  final TextInputAction? textInputAction,
}) =>
    Column(
      mainAxisSize: MainAxisSize.min,
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
        TextFormField(
          controller: controller,
          maxLength: maxLength,
          keyboardType: keyboardType,
          validator: validator,
          onChanged: onChanged,
          readOnly: readOnly,
          obscureText: obscureText,
          onTap: onTap,
          enabled: enabled,
          minLines: minLines,
          maxLines: maxLines,
          textInputAction: textInputAction ?? TextInputAction.next,
          decoration: inputDecoration ??
              InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 14.0, horizontal: 14),
                  filled: true,
                  isDense: true,
                  fillColor: fillColor ?? AppColors.textInputBg,
                  hintText: hintText,
                  prefixIcon: prefixIcon,
                  suffixIcon: suffixIcon,
                  hintStyle: const TextStyle(
                      color: AppColors.darkGray1, fontSize: 15)),
        )
      ],
    );
