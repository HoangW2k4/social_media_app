import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);

    final conversations = [
      _ConversationData(
        'Nguyễn Văn A',
        'Hẹn gặp lại nhé! 👋',
        '2m',
        true,
        Colors.blue,
      ),
      _ConversationData(
        'Trần Thị B',
        'Ok, mình hiểu rồi ✅',
        '15m',
        true,
        Colors.purple,
      ),
      _ConversationData('Lê Văn C', 'Ảnh đẹp quá!', '1h', false, Colors.orange),
      _ConversationData(
        'Phạm Thị D',
        t.translate('messages_typing'),
        t.translate('messages_active_now'),
        true,
        Colors.green,
      ),
      _ConversationData(
        'Hoàng Văn E',
        'Cảm ơn bạn nhiều 🙏',
        '3h',
        false,
        Colors.red,
      ),
      _ConversationData(
        'Vũ Thị F',
        'Bạn rảnh không?',
        '5h',
        false,
        Colors.teal,
      ),
      _ConversationData(
        'Đặng Văn G',
        'Dự án hoàn thành rồi!',
        '1d',
        false,
        Colors.indigo,
      ),
      _ConversationData('Bùi Thị H', 'Haha 😂😂', '2d', false, Colors.pink),
    ];

    return Scaffold(
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: t.translate('messages_search'),
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          // Online avatars
          SizedBox(
            height: 90,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: conversations
                  .where((c) => c.isOnline)
                  .map((c) => _buildOnlineAvatar(c.name, c.color))
                  .toList(),
            ),
          ),
          const Divider(height: 1),
          // Conversations list
          Expanded(
            child: ListView.builder(
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                final conv = conversations[index];
                return _buildConversationTile(context, conv);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blue,
        child: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }

  Widget _buildOnlineAvatar(String name, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: color,
                child: Text(
                  name[0],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: 60,
            child: Text(
              name.split(' ').last,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationTile(BuildContext context, _ConversationData conv) {
    final isTyping = conv.lastMessage.contains('...');
    return ListTile(
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: conv.color,
            child: Text(
              conv.name[0],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (conv.isOnline)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
      title: Text(
        conv.name,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        conv.lastMessage,
        style: TextStyle(
          color: isTyping ? Colors.blue : Colors.grey.shade600,
          fontStyle: isTyping ? FontStyle.italic : FontStyle.normal,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        conv.time,
        style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
      ),
      onTap: () {},
    );
  }
}

class _ConversationData {
  final String name;
  final String lastMessage;
  final String time;
  final bool isOnline;
  final Color color;

  _ConversationData(
    this.name,
    this.lastMessage,
    this.time,
    this.isOnline,
    this.color,
  );
}
