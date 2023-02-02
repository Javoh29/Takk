class WorkingDay {
  int? id;
  String? day;
  bool? isOpen;
  String? openingTime;
  String? closingTime;

  WorkingDay({
    this.id,
    this.day,
    this.isOpen,
    this.openingTime,
    this.closingTime,
  });

  factory WorkingDay.fromJson(Map<String, dynamic> json) => WorkingDay(
        id: json['id'] as int?,
        day: json['day'] as String?,
        isOpen: json['is_open'] as bool?,
        openingTime: json['opening_time'] as String?,
        closingTime: json['closing_time'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'day': day,
        'is_open': isOpen,
        'opening_time': openingTime,
        'closing_time': closingTime,
      };

  WorkingDay copyWith({
    int? id,
    String? day,
    bool? isOpen,
    String? openingTime,
    String? closingTime,
  }) {
    return WorkingDay(
      id: id ?? this.id,
      day: day ?? this.day,
      isOpen: isOpen ?? this.isOpen,
      openingTime: openingTime ?? this.openingTime,
      closingTime: closingTime ?? this.closingTime,
    );
  }
}
