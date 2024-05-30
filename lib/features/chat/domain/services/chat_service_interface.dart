import 'package:sixvalley_delivery_boy/data/api/api_client.dart';

abstract class ChatServiceInterface {

  Future<dynamic> getConversationList(int offset,String _userTypeIndex);
  Future<dynamic> searchChatList(String  _userTypeIndex , String searchChat);
  Future<dynamic> getChatList(int offset, int? userId);
  Future<dynamic> sendMessage(String message, int userId,List<MultipartBody> files);
  Future<dynamic> searchConversationList(String name);
}