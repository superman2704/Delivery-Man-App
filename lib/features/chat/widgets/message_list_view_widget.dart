import 'package:flutter/material.dart';
import 'package:sixvalley_delivery_boy/features/chat/controllers/chat_controller.dart';
import 'package:sixvalley_delivery_boy/common/basewidgets/paginated_list_view_widget.dart';
import 'package:sixvalley_delivery_boy/features/chat/widgets/message_bubble_widget.dart';

class MessageListViewWidget extends StatelessWidget {
  final ChatController chatController;
  final ScrollController scrollController;
  final int? userId;
  const MessageListViewWidget({Key? key, required this.chatController, required this.scrollController, this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      reverse: true,
      child: PaginatedListViewWidget(
        reverse: true,
        scrollController: scrollController,
        totalSize: chatController.messageModel?.totalSize,
        offset: chatController.messageModel != null ? int.parse(chatController.messageModel!.offset!) : 1,
        onPaginate: (int? offset) async => await chatController.getChats(offset!, userId),

        itemView: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          reverse: true,
          itemCount: chatController.messageModel?.message?.length,
          itemBuilder: (context, index) => MessageBubbleWidget(message: chatController.messageModel!.message![index])),
      ),
    );
  }
}
