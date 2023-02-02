class PeymetTypeModel {
  String? paymentType;
  dynamic cardId;

  PeymetTypeModel({this.paymentType, this.cardId});

  factory PeymetTypeModel.from(Map<String, dynamic> json) => PeymetTypeModel(
        paymentType: json['payment_type'] as String?,
        cardId: json['card_id'] as dynamic,
      );

  Map<String, dynamic> to() => {
        'payment_type': paymentType,
        'card_id': cardId,
      };

  PeymetTypeModel copyWith({
    String? paymentType,
    dynamic cardId,
  }) {
    return PeymetTypeModel(
      paymentType: paymentType ?? this.paymentType,
      cardId: cardId ?? this.cardId,
    );
  }
}
