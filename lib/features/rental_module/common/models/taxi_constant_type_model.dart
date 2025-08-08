import 'package:get/get.dart';

class TaxiConstantTypeModel {
  final String key;
  final String value;
  TaxiConstantTypeModel({required this.key, required this.value});

  static List<TaxiConstantTypeModel> getVehicleTypeList(){
    return [
      TaxiConstantTypeModel(key: 'family', value: 'family'),
      TaxiConstantTypeModel(key: 'luxury', value: 'luxury'),
      TaxiConstantTypeModel(key: 'affordable', value: 'affordable'),
      TaxiConstantTypeModel(key: 'executives', value: 'executives'),
      TaxiConstantTypeModel(key: 'compact', value: 'compact'),
      TaxiConstantTypeModel(key: 'midsize', value: 'midsize'),
      TaxiConstantTypeModel(key: 'full_size', value: 'full_size'),
    ];
  }

  static List<TaxiConstantTypeModel> getFuelTypeList(){
    return [
      TaxiConstantTypeModel(key: 'octan', value: 'octan'),
      TaxiConstantTypeModel(key: 'diesel', value: 'diesel'),
      TaxiConstantTypeModel(key: 'cng', value: 'cng'),
      TaxiConstantTypeModel(key: 'petrol', value: 'petrol'),
      TaxiConstantTypeModel(key: 'electric', value: 'electric'),
      TaxiConstantTypeModel(key: 'jet_fuel', value: 'jet_fuel'),
    ];
  }

  static List<TaxiConstantTypeModel> getTransmissionTypeList(){
    return [
      TaxiConstantTypeModel(key: 'automatic', value: 'automatic'),
      TaxiConstantTypeModel(key: 'manual', value: 'manual'),
      TaxiConstantTypeModel(key: 'continuously_variable', value: 'continuously_variable'),
      TaxiConstantTypeModel(key: 'dual_clutch', value: 'dual_clutch'),
      TaxiConstantTypeModel(key: 'semi_automatic', value: 'semi_automatic'),
    ];
  }

  static List<TaxiConstantTypeModel> getTimeDurationList(){
    return [
      TaxiConstantTypeModel(key: 'min', value: 'min'.tr),
      TaxiConstantTypeModel(key: 'hours', value: 'hours'.tr),
      TaxiConstantTypeModel(key: 'days', value: 'days'.tr),
    ];
  }

  static List<TaxiConstantTypeModel> getVehicleCoolingList(){
    return [
      TaxiConstantTypeModel(key: 'air_conditioned', value: 'air_conditioned'),
      TaxiConstantTypeModel(key: 'non_air_conditioned', value: 'non_air_conditioned'),
    ];
  }

  static List<TaxiConstantTypeModel> getVehicleSeatList(){
    return [
      TaxiConstantTypeModel(key: '1-4', value: '1-4'),
      TaxiConstantTypeModel(key: '5-8', value: '5-8'),
      TaxiConstantTypeModel(key: '9-13', value: '9-13'),
      TaxiConstantTypeModel(key: '14-1000', value: '14+'),
    ];
  }

  static List<TaxiConstantTypeModel> getIdentityTypeList(){
    return [
      TaxiConstantTypeModel(key: 'passport', value: 'passport'.tr),
      TaxiConstantTypeModel(key: 'driving_license', value: 'driving_license'.tr),
      TaxiConstantTypeModel(key: 'nid', value: 'nid'.tr),
    ];
  }

}