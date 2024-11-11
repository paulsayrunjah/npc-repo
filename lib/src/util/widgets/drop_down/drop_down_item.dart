class DropDownItem {
  DropDownItem(
      {required this.text, this.value, this.icon = "", this.hasIcon = false});

  DropDownItem.dummyItem(final String hint)
      : value = 0,
        text = hint,
        icon = "",
        hasIcon = false;

  factory DropDownItem.fromJson(final Map<String, dynamic> json) =>
      DropDownItem(
        value: json['value'],
        text: json['text'],
      );

  dynamic value;
  String text;
  String icon;
  bool hasIcon;

  Map<String, dynamic> toJson() => {
        'value': value,
        'text': text,
      };
}
