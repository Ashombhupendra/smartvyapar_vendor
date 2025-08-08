import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sixam_mart_store/features/advertisement/controllers/advertisement_controller.dart';
import 'package:sixam_mart_store/features/auth/controllers/auth_controller.dart';
import 'package:sixam_mart_store/features/chat/controllers/chat_controller.dart';
import 'package:sixam_mart_store/features/dashboard/screens/dashboard_screen.dart';
import 'package:sixam_mart_store/features/notification/controllers/notification_controller.dart';
import 'package:sixam_mart_store/features/order/controllers/order_controller.dart';
import 'package:sixam_mart_store/features/notification/domain/models/notification_body_model.dart';
import 'package:sixam_mart_store/features/rental_module/chat/controllers/taxi_chat_controller.dart';
import 'package:sixam_mart_store/features/rental_module/chat/screens/taxi_chat_screen.dart';
import 'package:sixam_mart_store/features/rental_module/trips/controllers/trip_controller.dart';
import 'package:sixam_mart_store/features/rental_module/trips/screens/trip_details_screen.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/app_constants.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:sixam_mart_store/features/dashboard/widgets/new_request_dialog_widget.dart';

class NotificationHelper {

  static Future<void> initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize = const AndroidInitializationSettings('notification_icon');
    var iOSInitialize = const DarwinInitializationSettings();
    var initializationsSettings = InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation < AndroidFlutterLocalNotificationsPlugin>()!.requestNotificationsPermission();
    flutterLocalNotificationsPlugin.initialize(initializationsSettings, onDidReceiveNotificationResponse: (NotificationResponse load) async{
      try{
        if(load.payload!.isNotEmpty){
          NotificationBodyModel payload = NotificationBodyModel.fromJson(jsonDecode(load.payload!));

          final Map<NotificationType, Function> notificationActions = {
            NotificationType.order: () {
              if(Get.find<AuthController>().getModuleType() == 'rental'){
                Get.to(()=> TripDetailsScreen(tripId: payload.orderId!, fromNotification: true));
              }else{
                Get.toNamed(RouteHelper.getOrderDetailsRoute(payload.orderId, fromNotification: true));
              }
            },
            NotificationType.advertisement: () => Get.toNamed(RouteHelper.getAdvertisementDetailsScreen(advertisementId: payload.advertisementId, fromNotification: true)),
            NotificationType.block: () => Get.offAllNamed(RouteHelper.getSignInRoute()),
            NotificationType.unblock: () => Get.offAllNamed(RouteHelper.getSignInRoute()),
            NotificationType.withdraw: () => Get.to(const DashboardScreen(pageIndex: 3)),
            NotificationType.campaign: () => Get.toNamed(RouteHelper.getCampaignDetailsRoute(id: payload.campaignId, fromNotification: true)),
            NotificationType.message: () {
              if(Get.find<AuthController>().getModuleType() == 'rental'){
                Get.to(()=> TaxiChatScreen(notificationBody: payload, conversationId: payload.conversationId, fromNotification: true));
              }else{
                Get.toNamed(RouteHelper.getChatRoute(notificationBody: payload, conversationId: payload.conversationId, fromNotification: true));
              }
            },
            NotificationType.subscription: () => Get.toNamed(RouteHelper.getMySubscriptionRoute(fromNotification: true)),
            NotificationType.product_approve: () => Get.offAll(const DashboardScreen(pageIndex: 2)),
            NotificationType.product_rejected: () => Get.toNamed(RouteHelper.getPendingItemRoute(fromNotification: true)),
            NotificationType.general: () => Get.toNamed(RouteHelper.getNotificationRoute(fromNotification: true)),
          };

          notificationActions[payload.notificationType]?.call();
        }
      }catch(_){}
      return;
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("onMessage message type:${message.data['type']}");
      debugPrint("onMessage message :${message.data}");

      if(message.data['type'] == 'message' && (Get.currentRoute.startsWith(RouteHelper.chatScreen) || Get.currentRoute.startsWith('/TaxiChatScreen'))) {
        if(Get.find<AuthController>().getModuleType() == 'rental'){
          if(Get.find<AuthController>().isLoggedIn()) {
            Get.find<TaxiChatController>().getConversationList(1);
            if(Get.find<TaxiChatController>().messageModel!.conversation!.id.toString() == message.data['conversation_id'].toString()) {
              Get.find<TaxiChatController>().getMessages(
                1, NotificationBodyModel(
                notificationType: NotificationType.message,
                customerId: message.data['sender_type'] == AppConstants.user ? 0 : null,
                deliveryManId: message.data['sender_type'] == AppConstants.deliveryMan ? 0 : null,
              ),
                null, int.parse(message.data['conversation_id'].toString()),
              );
            }else {
              NotificationHelper.showNotification(message, flutterLocalNotificationsPlugin);
            }
          }
        }else{
          if(Get.find<AuthController>().isLoggedIn()) {
            Get.find<ChatController>().getConversationList(1);
            if(Get.find<ChatController>().messageModel!.conversation!.id.toString() == message.data['conversation_id'].toString()) {
              Get.find<ChatController>().getMessages(
                1, NotificationBodyModel(
                notificationType: NotificationType.message,
                customerId: message.data['sender_type'] == AppConstants.user ? 0 : null,
                deliveryManId: message.data['sender_type'] == AppConstants.deliveryMan ? 0 : null,
              ),
                null, int.parse(message.data['conversation_id'].toString()),
              );
            }else {
              NotificationHelper.showNotification(message, flutterLocalNotificationsPlugin);
            }
          }
        }
      }else if(message.data['type'] == 'message' && (Get.currentRoute.startsWith(RouteHelper.conversationListScreen) || Get.currentRoute.startsWith('/TaxiConversationScreen'))) {
        if(Get.find<AuthController>().getModuleType() == 'rental'){
          if(Get.find<AuthController>().isLoggedIn()) {
            Get.find<TaxiChatController>().getConversationList(1);
          }
          NotificationHelper.showNotification(message, flutterLocalNotificationsPlugin);
        }else{
          if(Get.find<AuthController>().isLoggedIn()) {
            Get.find<ChatController>().getConversationList(1);
          }
          NotificationHelper.showNotification(message, flutterLocalNotificationsPlugin);
        }
      }else {
        NotificationHelper.showNotification(message, flutterLocalNotificationsPlugin);

        if (message.data['type'] == 'new_order' || message.data['title'] == 'New order placed') {
          if(Get.find<AuthController>().getModuleType() == 'rental'){
            TripController tripController = Get.find<TripController>();
            tripController.getTripList(status: 'pending', offset: '1');
            tripController.getTripList(status: 'confirmed', offset: '1');
            tripController.getTripList(status: 'ongoing', offset: '1');
          }else{
            Get.find<OrderController>().getPaginatedOrders(1, true);
            Get.find<OrderController>().getCurrentOrders();
          }
          Get.dialog(NewRequestDialogWidget(orderId: int.parse(message.data['order_id'])));
        }else if(message.data['type'] == 'advertisement') {
          Get.find<AdvertisementController>().getAdvertisementList('1', 'all');
        }
        Get.find<NotificationController>().getNotificationList();
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("onOpenApp message type:${message.data['type']}");
      debugPrint("onOpenApp message :${message.data}");

      try{
        NotificationBodyModel notificationBody = convertNotification(message.data);

        final Map<NotificationType, Function> notificationActions = {
          NotificationType.order: () {
            if(Get.find<AuthController>().getModuleType() == 'rental'){
              Get.to(()=> TripDetailsScreen(tripId: int.parse(message.data['order_id']), fromNotification: true));
            }else{
              Get.toNamed(RouteHelper.getOrderDetailsRoute(int.parse(message.data['order_id']), fromNotification: true));
            }
          },
          NotificationType.advertisement: () => Get.toNamed(RouteHelper.getAdvertisementDetailsScreen(advertisementId:  notificationBody.advertisementId, fromNotification: true)),
          NotificationType.block: () => Get.offAllNamed(RouteHelper.getSignInRoute()),
          NotificationType.unblock: () => Get.offAllNamed(RouteHelper.getSignInRoute()),
          NotificationType.withdraw: () => Get.to(const DashboardScreen(pageIndex: 3)),
          NotificationType.campaign: () => Get.toNamed(RouteHelper.getCampaignDetailsRoute(id: notificationBody.campaignId, fromNotification: true)),
          NotificationType.message: () {
            if(Get.find<AuthController>().getModuleType() == 'rental'){
              Get.to(()=> TaxiChatScreen(notificationBody: notificationBody, conversationId: notificationBody.conversationId, fromNotification: true));
            }else{
              Get.toNamed(RouteHelper.getChatRoute(notificationBody: notificationBody, conversationId: notificationBody.conversationId, fromNotification: true));
            }
          },
          NotificationType.subscription: () => Get.toNamed(RouteHelper.getMySubscriptionRoute(fromNotification: true)),
          NotificationType.product_approve: () => Get.offAll(const DashboardScreen(pageIndex: 2)),
          NotificationType.product_rejected: () => Get.toNamed(RouteHelper.getPendingItemRoute(fromNotification: true)),
          NotificationType.general: () => Get.toNamed(RouteHelper.getNotificationRoute(fromNotification: true)),
        };

        notificationActions[notificationBody.notificationType]?.call();
      }catch (_){}
    });
  }

  static Future<void> showNotification(RemoteMessage message, FlutterLocalNotificationsPlugin fln) async {
    if(!GetPlatform.isIOS) {
      String? title;
      String? body;
      String? image;
      NotificationBodyModel notificationBody = convertNotification(message.data);

      title = message.data['title'];
      body = message.data['body'];
      image = (message.data['image'] != null && message.data['image'].isNotEmpty) ? message.data['image'].startsWith('http') ? message.data['image']
        : '${AppConstants.baseUrl}/storage/app/public/notification/${message.data['image']}' : null;

      if(image != null && image.isNotEmpty) {
        try{
          await showBigPictureNotificationHiddenLargeIcon(title, body, notificationBody, image, fln);
        }catch(e) {
          await showBigTextNotification(title, body!, notificationBody, fln);
        }
      }else {
        await showBigTextNotification(title, body!, notificationBody, fln);
      }
    }
  }

  static Future<void> showTextNotification(String title, String body, NotificationBodyModel notificationBody, FlutterLocalNotificationsPlugin fln) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'Smart Vyapaar', AppConstants.appName, playSound: true,
      importance: Importance.max, priority: Priority.max, sound: RawResourceAndroidNotificationSound('notification'),
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, title, body, platformChannelSpecifics, payload: jsonEncode(notificationBody.toJson()));
  }

  static Future<void> showBigTextNotification(String? title, String body, NotificationBodyModel notificationBody, FlutterLocalNotificationsPlugin fln) async {
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      body, htmlFormatBigText: true,
      contentTitle: title, htmlFormatContentTitle: true,
    );
    AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'Smart Vyapaar', AppConstants.appName, importance: Importance.max,
      styleInformation: bigTextStyleInformation, priority: Priority.max, playSound: true,
      sound: const RawResourceAndroidNotificationSound('notification'),
    );
    NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, title, body, platformChannelSpecifics, payload: jsonEncode(notificationBody.toJson()));
  }

  static Future<void> showBigPictureNotificationHiddenLargeIcon(String? title, String? body, NotificationBodyModel notificationBody, String image, FlutterLocalNotificationsPlugin fln) async {
    final String largeIconPath = await _downloadAndSaveFile(image, 'largeIcon');
    final String bigPicturePath = await _downloadAndSaveFile(image, 'bigPicture');
    final BigPictureStyleInformation bigPictureStyleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap(bigPicturePath), hideExpandedLargeIcon: true,
      contentTitle: title, htmlFormatContentTitle: true,
      summaryText: body, htmlFormatSummaryText: true,
    );
    final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'Smart Vyapaar', AppConstants.appName,
      largeIcon: FilePathAndroidBitmap(largeIconPath), priority: Priority.max, playSound: true,
      styleInformation: bigPictureStyleInformation, importance: Importance.max,
      sound: const RawResourceAndroidNotificationSound('notification'),
    );
    final NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, title, body, platformChannelSpecifics, payload: jsonEncode(notificationBody.toJson()));
  }

  static Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  static NotificationBodyModel convertNotification(Map<String, dynamic> data) {
    final type = data['type'];

    switch (type) {
      case 'advertisement':
        return NotificationBodyModel(notificationType: NotificationType.advertisement, advertisementId: int.tryParse(data['advertisement_id']));
      case 'block':
        return NotificationBodyModel(notificationType: NotificationType.block);
      case 'unblock':
        return NotificationBodyModel(notificationType: NotificationType.unblock);
      case 'withdraw':
        return NotificationBodyModel(notificationType: NotificationType.withdraw);
      case 'product_approve':
        return NotificationBodyModel(notificationType: NotificationType.product_approve);
      case 'product_rejected':
      return NotificationBodyModel(notificationType: NotificationType.product_rejected);
      case 'campaign':
        return NotificationBodyModel(notificationType: NotificationType.campaign, campaignId: int.tryParse(data['data_id']));
      case 'subscription':
      return NotificationBodyModel(notificationType: NotificationType.subscription);
      case 'new_order':
      case 'New order placed':
      case 'order_status':
        return _handleOrderNotification(data);
      case 'message':
        return _handleMessageNotification(data);
      default:
        return NotificationBodyModel(notificationType: NotificationType.general);
    }
  }

  static NotificationBodyModel _handleOrderNotification(Map<String, dynamic> data) {
    final orderId = data['order_id'];
    return NotificationBodyModel(
      orderId: int.tryParse(orderId) ?? 0,
      notificationType: NotificationType.order,
    );
  }

  static NotificationBodyModel _handleMessageNotification(Map<String, dynamic> data) {
    final orderId = data['order_id'];
    final conversationId = data['conversation_id'];
    final senderType = data['sender_type'];

    return NotificationBodyModel(
      orderId: orderId != null && orderId.isNotEmpty ? int.tryParse(orderId) : null,
      conversationId: conversationId != null && conversationId.isNotEmpty ? int.tryParse(conversationId) : null,
      notificationType: NotificationType.message,
      type: senderType == AppConstants.deliveryMan ? AppConstants.deliveryMan : AppConstants.customer,
    );
  }

}

Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
  debugPrint("onBackground: ${message.data}");
}