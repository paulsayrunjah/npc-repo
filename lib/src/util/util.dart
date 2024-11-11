import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

logApp(data, {String? tag = 'NPC-App-Log'}) {
  if (kDebugMode) {
    print("$tag ---> $data");
  }
}

String convertDate(String dateStr) {
  DateTime date = DateFormat("dd/MM/yyyy").parse(dateStr);
  return DateFormat("yyyy-MM-dd").format(date);
}

aweSomeDialog(
    {required final context,
    final title = '',
    final desc = '',
    final body,
    final btnOkPress,
    final btnOkText = 'Ok',
    final btnCancelText,
    final showCloseIcon = false,
    final btnCancelOnPress,
    final width,
    final Widget? btnOk,
    final Widget? closeIcon,
    final Widget? btnCancel,
    final Function(DismissType)? onDismissCallback,
    final dialogType = DialogType.noHeader,
    final dismissOnTouchOutside = true}) async {
  await AwesomeDialog(
          dismissOnTouchOutside: dismissOnTouchOutside,
          context: context,
          width: width,
          headerAnimationLoop: false,
          dialogType: dialogType,
          closeIcon: closeIcon,
          onDismissCallback: onDismissCallback,
          title: title,
          desc: desc,
          body: body,
          btnOkOnPress: btnOkPress,
          btnCancelOnPress: btnCancelOnPress,
          btnOkText: btnOkText,
          btnOk: btnOk,
          btnCancel: btnCancel,
          btnCancelText: btnCancelText,
          showCloseIcon: showCloseIcon)
      .show();
}

String capitalizeFirst(String input) {
  if (input.isEmpty) return input;
  return input[0].toUpperCase() + input.substring(1);
}
