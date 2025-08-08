import 'package:get/get.dart';

class StatusListModel{
  final String statusTitle;
  final String status;
  StatusListModel({required this.statusTitle, required this.status});

  static List<StatusListModel> getHomeStatusList(){
    return [
      StatusListModel(statusTitle: 'pending'.tr, status: 'pending'),
      StatusListModel(statusTitle: 'confirmed'.tr, status: 'confirmed'),
      StatusListModel(statusTitle: 'ongoing'.tr, status: 'ongoing'),
    ];
  }

  static List<StatusListModel> getHistoryStatusList(){
    return [
      StatusListModel(statusTitle: 'pending'.tr, status: 'pending'),
      StatusListModel(statusTitle: 'confirmed'.tr, status: 'confirmed'),
      StatusListModel(statusTitle: 'ongoing'.tr, status: 'ongoing'),
      StatusListModel(statusTitle: 'completed'.tr, status: 'completed'),
      StatusListModel(statusTitle: 'canceled'.tr, status: 'canceled'),
      StatusListModel(statusTitle: 'payment_failed'.tr, status: 'payment_failed'),
    ];
  }

  static List<StatusListModel> getDriverStatusList(){
    return [
      StatusListModel(statusTitle: 'confirmed'.tr, status: 'confirmed'),
      StatusListModel(statusTitle: 'ongoing'.tr, status: 'ongoing'),
      StatusListModel(statusTitle: 'completed'.tr, status: 'completed'),
      StatusListModel(statusTitle: 'canceled'.tr, status: 'canceled'),
    ];
  }

}