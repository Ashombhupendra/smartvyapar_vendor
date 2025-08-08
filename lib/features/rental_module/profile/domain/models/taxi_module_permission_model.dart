class TaxiModulePermissionModel{
  bool? trip;
  bool? vehicle;
  bool? driver;
  bool? marketing;
  bool? storeSetup;
  bool? myWallet;
  bool? profile;
  bool? rentalEmployees;
  bool? myShop;
  bool? reviews;
  bool? chat;
  bool? rentalReport;

  TaxiModulePermissionModel({
    this.trip,
    this.vehicle,
    this.driver,
    this.marketing,
    this.storeSetup,
    this.myWallet,
    this.profile,
    this.rentalEmployees,
    this.myShop,
    this.reviews,
    this.chat,
    this.rentalReport,
  });

  TaxiModulePermissionModel.fromJson(Map<String, dynamic> json) {
    trip = json['trip'];
    vehicle = json['vehicle'];
    driver = json['driver'];
    marketing = json['marketing'];
    storeSetup = json['store_setup'];
    myWallet = json['my_wallet'];
    profile = json['profile'];
    rentalEmployees = json['rental_employees'];
    myShop = json['my_shop'];
    reviews = json['reviews'];
    chat = json['chat'];
    rentalReport = json['rental_report'];
  }

  Map<String, bool?> toJson() {
    final Map<String, bool?> data = <String, bool?>{};
    data['trip'] = trip ;
    data['vehicle'] = vehicle;
    data['driver'] = driver;
    data['marketing'] = marketing;
    data['store_setup'] = storeSetup;
    data['my_wallet'] = myWallet;
    data['profile'] = profile;
    data['rental_employees'] = rentalEmployees;
    data['my_shop'] = myShop;
    data['reviews'] = reviews;
    data['chat'] = chat;
    data['rental_report'] = rentalReport;
    return data;
  }
}