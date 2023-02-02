class CashbackModel {
  int? id;
  int? createdDt;
  String? fillType;
  String? cashback;
  bool? isAutoFill;
  String? amountPayout;
  String? amountReceipt;
  int? order;
  dynamic tariff;

  CashbackModel({
    this.id,
    this.createdDt,
    this.fillType,
    this.cashback,
    this.isAutoFill,
    this.amountPayout,
    this.amountReceipt,
    this.order,
    this.tariff,
  });

  factory CashbackModel.fromJson(Map<String, dynamic> json) => CashbackModel(
        id: json['id'] as int?,
        createdDt: json['created_dt'] as int?,
        fillType: json['fill_type'] as String?,
        cashback: json['cashback'] as String?,
        isAutoFill: json['is_auto_fill'] as bool?,
        amountPayout: json['amount_payout'] as String?,
        amountReceipt: json['amount_receipt'] as String?,
        order: json['order'] as int?,
        tariff: json['tariff'] as dynamic,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'created_dt': createdDt,
        'fill_type': fillType,
        'cashback': cashback,
        'is_auto_fill': isAutoFill,
        'amount_payout': amountPayout,
        'amount_receipt': amountReceipt,
        'order': order,
        'tariff': tariff,
      };

  CashbackModel copyWith({
    int? id,
    int? createdDt,
    String? fillType,
    String? cashback,
    bool? isAutoFill,
    String? amountPayout,
    String? amountReceipt,
    int? order,
    dynamic tariff,
  }) {
    return CashbackModel(
      id: id ?? this.id,
      createdDt: createdDt ?? this.createdDt,
      fillType: fillType ?? this.fillType,
      cashback: cashback ?? this.cashback,
      isAutoFill: isAutoFill ?? this.isAutoFill,
      amountPayout: amountPayout ?? this.amountPayout,
      amountReceipt: amountReceipt ?? this.amountReceipt,
      order: order ?? this.order,
      tariff: tariff ?? this.tariff,
    );
  }
}
