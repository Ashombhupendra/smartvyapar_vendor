import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart_store/api/api_client.dart';
import 'package:sixam_mart_store/features/notification/domain/models/notification_body_model.dart';
import 'package:sixam_mart_store/features/rental_module/chat/domain/models/taxi_conversation_model.dart';
import 'package:sixam_mart_store/features/rental_module/chat/domain/models/taxi_message_model.dart';
import 'package:sixam_mart_store/features/rental_module/chat/domain/repositories/taxi_chat_repository_interface.dart';
import 'package:sixam_mart_store/features/rental_module/chat/domain/services/taxi_chat_service_interface.dart';
import 'package:sixam_mart_store/util/app_constants.dart';

class TaxiChatService implements TaxiChatServiceInterface {
  final TaxiChatRepositoryInterface chatRepositoryInterface;
  TaxiChatService({required this.chatRepositoryInterface});

  @override
  Future<TaxiConversationsModel?> getConversationList(int offset) async {
    return await chatRepositoryInterface.getConversationList(offset);
  }

  @override
  Future<TaxiConversationsModel?> searchConversationList(String name) async {
    return await chatRepositoryInterface.searchConversationList(name);
  }

  @override
  Future<TaxiMessageModel?> getMessages(int offset, int? userId, String userType, int? conversationID) async {
    return await chatRepositoryInterface.getMessages(offset, userId, userType, conversationID);
  }

  @override
  Future<TaxiMessageModel?> sendMessage(String message, List<MultipartBody> images, int? conversationId, int? userId, String userType) async {
    return await chatRepositoryInterface.sendMessage(message, images, conversationId, userId, userType);
  }

  @override
  List<MultipartBody> processMultipartBody(List<XFile> chatImage) {
    List<MultipartBody> multipartImages = [];
    for (var image in chatImage) {
      multipartImages.add(MultipartBody('image[]', image));
    }
    return multipartImages;
  }

  @override
  Future<TaxiMessageModel?> processGetMessage(int offset, NotificationBodyModel notificationBody, int? conversationID) async {
    TaxiMessageModel? messageModel;
    if(notificationBody.customerId != null || notificationBody.type == AppConstants.customer || notificationBody.type == AppConstants.user) {
      messageModel = await getMessages(offset, notificationBody.customerId, AppConstants.user, conversationID);
    }else if(notificationBody.deliveryManId != null || notificationBody.type == AppConstants.deliveryMan) {
      messageModel = await getMessages(offset, notificationBody.deliveryManId, AppConstants.deliveryMan, conversationID);
    }
    return messageModel;
  }

  @override
  Future<TaxiMessageModel?> processSendMessage(NotificationBodyModel? notificationBody, List<MultipartBody> chatImage, String message, int? conversationId) async {
    TaxiMessageModel? messageModel;
    if(notificationBody != null && (notificationBody.customerId != null || notificationBody.type == AppConstants.customer)) {
      messageModel = await sendMessage(message, chatImage, conversationId, notificationBody.customerId, AppConstants.customer);
    }
    else if(notificationBody != null && (notificationBody.deliveryManId != null || notificationBody.type == AppConstants.deliveryMan)){
      messageModel = await sendMessage(message, chatImage, conversationId, notificationBody.deliveryManId, AppConstants.deliveryMan);
    }
    return messageModel;
  }

}