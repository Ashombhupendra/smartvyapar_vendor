import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixam_mart_store/api/api_client.dart';
import 'package:sixam_mart_store/features/rental_module/chat/domain/models/taxi_conversation_model.dart';
import 'package:sixam_mart_store/features/rental_module/chat/domain/models/taxi_message_model.dart';
import 'package:sixam_mart_store/features/rental_module/chat/domain/repositories/taxi_chat_repository_interface.dart';
import 'package:sixam_mart_store/util/app_constants.dart';

class TaxiChatRepository implements TaxiChatRepositoryInterface {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  TaxiChatRepository({required this.apiClient, required this.sharedPreferences});

  @override
  Future<TaxiConversationsModel?> getConversationList(int offset) async {
    TaxiConversationsModel? conversationModel;
    Response response = await apiClient.getData('${AppConstants.taxiConversationListUri}?offset=$offset&limit=10');
    if(response.statusCode == 200) {
      conversationModel = TaxiConversationsModel.fromJson(response.body);
    }
    return conversationModel;
  }

  @override
  Future<TaxiConversationsModel?> searchConversationList(String name) async {
    TaxiConversationsModel? searchConversationModel;
    Response response = await apiClient.getData('${AppConstants.searchConversationListUri}?name=$name&limit=20&offset=1');
    if(response.statusCode == 200) {
      searchConversationModel = TaxiConversationsModel.fromJson(response.body);
    }
    return searchConversationModel;
  }

  @override
  Future<TaxiMessageModel?> getMessages(int offset, int? userId, String userType, int? conversationID) async {
    TaxiMessageModel? messageModel;
    /*Response response = await apiClient.getData('${AppConstants.taxiMessageDetailsUri}?offset=$offset&limit=10&${conversationID != null ?
    'conversation_id' : userType == AppConstants.deliveryMan ? 'delivery_man_id' : 'user_id'}=${conversationID ?? userId}');*/

    Response response = await apiClient.getData('${AppConstants.taxiMessageDetailsUri}?offset=$offset&limit=10&${conversationID != null ? 'conversation_id' : 'user_id'}=${conversationID ?? userId}');

    if(response.statusCode == 200 && response.body['messages'] != {}) {
      messageModel = TaxiMessageModel.fromJson(response.body);
    }
    return messageModel;
  }

  @override
  Future<TaxiMessageModel?> sendMessage(String message, List<MultipartBody> images, int? conversationId, int? userId, String userType) async {
    TaxiMessageModel? messageModel;
    Response response = await apiClient.postMultipartData(AppConstants.taxiSendMessageUri,
      {'message': message, 'receiver_type': userType, conversationId != null ? 'conversation_id' : 'receiver_id': '${conversationId ?? userId}', 'offset': '1', 'limit': '10'}, images);
    if(response.statusCode == 200) {
      messageModel = TaxiMessageModel.fromJson(response.body);
    }
    return messageModel;
  }

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future delete(int? id) {
    throw UnimplementedError();
  }

  @override
  Future get(int? id) {
    throw UnimplementedError();
  }

  @override
  Future getList() {
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body) {
    throw UnimplementedError();
  }

}