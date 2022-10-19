class Customermodel {
   String? customerid;
  String? name;
  String? phoneNumber;
  String? email;
  String? schoolName;
  String? latitude;
  String? longitude;
  String? paymentMethod;
  String?neighbrhoods;
  String?pickupDriver;
  String?dropoffDriver;

  Customermodel(
      {this.customerid,
      this.name,
      this.phoneNumber,
      this.email,
      this.schoolName,
      this.latitude,
      this.longitude,
      this.paymentMethod,
      this.neighbrhoods,
      this.pickupDriver,
      this.dropoffDriver
      });
  //receiving data from server
  factory Customermodel.fromMap(map) {
    return Customermodel(
     customerid: map['customerid'],
      name: map['Name'],
      phoneNumber: map['phoneNumber'],
      email: map['email'],
      schoolName: map['schoolName'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      paymentMethod: map['paymentMethod'],
      neighbrhoods:map['neighbrhoods'],
      pickupDriver: map['driverPickup'],
      dropoffDriver: map['driverDropoff']
      
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'customerid': customerid,
      'Name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'schoolName': schoolName,
      'latitude': latitude,
      'longitude': longitude,
      'paymentMethod': paymentMethod,
      'neighbrhoods':neighbrhoods,
      'driverPickup':pickupDriver,
      'driverDropoff':dropoffDriver
  
    };
  }
}
