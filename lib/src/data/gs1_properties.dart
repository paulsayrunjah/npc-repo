class GS1Properties {
  String GTIN;
  String? batchOrLotNumber;
  DateTime? productionDate;
  DateTime? expirationDate;

  GS1Properties({
    required this.GTIN,
    this.batchOrLotNumber,
    this.productionDate,
    this.expirationDate,
  });
}
