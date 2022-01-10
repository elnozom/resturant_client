class Setting {
  late String comName;
  late String capital;
  late int cashtraySerial;


  Setting({
    required this.comName,
    required this.capital,
    required this.cashtraySerial,
  
  });
  Setting.fromJson(Map<String, dynamic> json) {
    comName = json['ComName'];
    capital = json['Capital'];
    cashtraySerial = json['CashtraySerial'];
    
  }
}
