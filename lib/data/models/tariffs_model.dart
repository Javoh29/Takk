class TariffModel {
  int? id;
  String? amountPayout;
  String? amountReceipt;
  int? percent;

  TariffModel({
    this.id,
    this.amountPayout,
    this.amountReceipt,
    this.percent,
  });

  factory TariffModel.fromJson(Map<String, dynamic> json) => TariffModel(
        id: json['id'] as int?,
        amountPayout: json['amount_payout'] as String?,
        amountReceipt: json['amount_receipt'] as String?,
        percent: json['percent'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'amount_payout': amountPayout,
        'amount_receipt': amountReceipt,
        'percent': percent,
      };
}
