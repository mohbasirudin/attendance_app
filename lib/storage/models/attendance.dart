class Attendance {
  final int id;
  final String name;
  final String inTime;
  final String outTime;
  final String createdAt;
  final String updatedAt;
  final int success;

  Attendance({
    required this.id,
    required this.name,
    required this.inTime,
    required this.outTime,
    required this.createdAt,
    required this.updatedAt,
    required this.success,
  });

  factory Attendance.fromMap(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'],
      name: json['name'],
      inTime: json['inTime'],
      outTime: json['outTime'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      success: json['success'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'inTime': inTime,
      'outTime': outTime,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'success': success,
    };
  }
}
