class Table {
  final int floor;
  final int seats;
  final String status;
  final String view;
  final List<String> reservationTimes;

  Table({
    required this.floor,
    required this.seats,
    required this.status,
    required this.view,
    required this.reservationTimes,
  });

  factory Table.fromJson(Map<String, dynamic> json) {
    return Table(
      floor: json['floor'],
      seats: json['seats'],
      status: json['status'],
      view: json['view'],
      reservationTimes: List<String>.from(json['reservationTimes']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'floor': floor,
      'seats': seats,
      'status': status,
      'view': view,
      'reservationTimes': reservationTimes,
    };
  }
}
