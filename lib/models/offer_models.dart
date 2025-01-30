class Offer {
  final String id;
  final String discount;
  final String details;
  final String validFrom;
  final String validUntil;

  Offer({
    required this.id,
    required this.discount,
    required this.details,
    required this.validFrom,
    required this.validUntil,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json['id'],
      discount: json['discount'],
      details: json['details'],
      validFrom: json['validFrom'],
      validUntil: json['validUntil'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'discount': discount,
      'details': details,
      'validFrom': validFrom,
      'validUntil': validUntil,
    };
  }
}
