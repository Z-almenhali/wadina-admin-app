class Schedual{
  String? pickupTime;

  String?dropoff;
  bool?active;
  String? Day;
  Schedual({
    this.Day,
    this.active,this.pickupTime,
      this.dropoff,
    
    
  
      });
  factory Schedual.fromMap(map) {
    return Schedual(
      Day: map['Day'],
     active: map['active'],
      dropoff: map['dropoff'],
      
      pickupTime: map['pickup'],
    
    
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
       'active':active,
        'Day':Day,
         'dropoff':dropoff,
        'pickup':pickupTime,
       
    
     
      
  
  
    };
  }
}