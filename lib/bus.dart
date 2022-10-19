class Bus {
  String? busNumber;
  String? busPlate;

  Bus({
    this.busNumber,
    this.busPlate,
  });

  //receiving data from server
  factory Bus.fromMap(map) {
    return Bus(busNumber: map['busNumber'], busPlate: map['busPlate']);
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {'busNumber': busNumber, 'busPlate': busPlate};
  }
}
