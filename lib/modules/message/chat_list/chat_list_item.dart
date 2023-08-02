import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:bm_flash/core/remote_urls.dart';
import 'package:bm_flash/modules/message/models/seller_messages_dto.dart';
import 'package:bm_flash/utils/constants.dart';

import '../../../utils/formatting.dart';


class ChatListItem extends StatelessWidget {
  const ChatListItem({
    Key? key,
    required this.item,
    required this.onPressed,
  }) : super(key: key);

  final SellerDto item;
  final void Function(SellerDto) onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading:  DottedBorder(
        borderType: BorderType.Circle,
        color: lightningYellowColor,
          padding: const EdgeInsets.all(8),
        dashPattern: const [6,3],
        child: CircleAvatar(
          backgroundColor: primaryColor,
          backgroundImage: NetworkImage(RemoteUrls.imageUrl(item.shopLogo)),
        ),
      ),
      title: Text(
        item.shopName,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              item.messages.last.message,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          Text(utcToLocal(item.messages.last.createdAt),style: Theme.of(context).textTheme.caption,),
        ],
      ),
      onTap: () => onPressed(item),
    );
  }
}
