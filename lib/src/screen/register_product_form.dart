import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:npc_mobile_flutter/src/screen/product_details.dart';
import 'package:npc_mobile_flutter/src/util/util.dart';
import 'package:npc_mobile_flutter/src/util/widgets/drop_down/drop_down.dart';
import 'package:npc_mobile_flutter/src/util/widgets/drop_down/drop_down_item.dart';
import 'package:npc_mobile_flutter/src/widget/inputs/text_input.dart';

class RequestData {
  int quantity;
  String source;
  String type;

  RequestData(
      {required this.quantity, required this.source, required this.type});
}

// ignore: must_be_immutable
class RegisterProductForm extends StatefulWidget {
  Function(RequestData) onRegisterClick;
  RegisterProductForm({super.key, required this.onRegisterClick});

  @override
  State<RegisterProductForm> createState() => _RegisterProductFormState();
}

class _RegisterProductFormState extends State<RegisterProductForm> {
  ActionType? selectedActionType;
  var quantityController = TextEditingController();
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  final defaultSource = "Select location";
  final sourceItems = ["Select location", "NDA", "NMS", "JMS", "Facility"]
      .map((item) => DropDownItem(text: item, value: item))
      .toList();

  String selectedSource = "Select location";
  List<ActionType> actionTypes = ActionType.values;

  final locationAndTypes = {
    "NDA": [ActionType.commission],
    "NMS": [ActionType.receipt, ActionType.dispatch],
    "JMS": [ActionType.receipt, ActionType.dispatch],
    "Facility": [ActionType.receipt, ActionType.decommission],
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 60,
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.only(left: 4, right: 4, bottom: 8),
      child: Card(
        color: Colors.white,
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Text(
                  'Register product',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 8,
                ),
                textFieldInput(
                    hintText: 'Quantity',
                    validator: (final value) {
                      if (value == null) {
                        return 'Quantity is required';
                      }

                      bool isNumeric = num.tryParse(value) != null;
                      if (!isNumeric) {
                        return 'Quantity must be a number';
                      }

                      return null;
                    },
                    controller: quantityController,
                    textInputAction: TextInputAction.done,
                    keyboardType: const TextInputType.numberWithOptions()),
                const SizedBox(
                  height: 4,
                ),
                dropDown(
                    context: context,
                    list: sourceItems,
                    defaultValue: defaultSource,
                    selectedValue: selectedSource,
                    onChanged: (final newValue) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      setState(() {
                        selectedSource = newValue;
                        if (selectedSource != defaultSource) {
                          actionTypes = locationAndTypes[selectedSource]!;
                        }
                      });
                    }),
                const SizedBox(
                  height: 4,
                ),
                actionTypeForm(context, selectedActionType,
                    (ActionType? value) {
                  setState(() {
                    selectedActionType = value;
                  });
                }),
                const SizedBox(
                  height: 4,
                ),
                SizedBox(
                  width: 200,
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState != null &&
                                !formKey.currentState!.validate()) {
                              return;
                            }

                            if (selectedSource == defaultSource) {
                              aweSomeDialog(
                                  dialogType: DialogType.error,
                                  context: context,
                                  desc: 'Please provide a location',
                                  btnOkPress: () {});
                              return;
                            }

                            if (selectedActionType == null) {
                              aweSomeDialog(
                                  dialogType: DialogType.error,
                                  context: context,
                                  desc: 'Please provide a type',
                                  btnOkPress: () {});
                              return;
                            }

                            RequestData requestData = RequestData(
                                quantity:
                                    int.tryParse(quantityController.text) ?? 0,
                                source: selectedSource,
                                type: selectedActionType?.name ?? 'N/A');
                            widget.onRegisterClick(requestData);
                          },
                          child: const Text('Save')),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget actionTypeForm(
    BuildContext context,
    ActionType? groupValue,
    ValueChanged<ActionType?> onChanged,
  ) {
    return Visibility(
      visible: selectedSource != defaultSource,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: actionTypes.map((item) {
          return RadioListTile<ActionType>(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: Text(capitalizeFirst(item.name)),
            value: item,
            groupValue: groupValue,
            onChanged: onChanged,
          );
        }).toList(),
      ),
    );
  }
}
