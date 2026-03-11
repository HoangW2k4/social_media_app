// lib/screens/chat_page/chat_page.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:social_media_app/screens/messages_page/chat_models.dart';
import 'package:social_media_app/screens/messages_page/conversation_state.dart';

export 'package:social_media_app/screens/messages_page/chat_models.dart';

const List<String> _reactionEmojis = ['❤️', '😆', '😮', '😢', '😡', '👍'];

final List<String> _autoReplies = [
  'Mình hiểu rồi 😊', 'Oke bạn!', 'Thú vị đấy!', 'Vậy á? Hay quá!',
  'Mình đang bận chút, lát trả lời nha', 'Haha đúng vậy đó! 😄',
  'Cảm ơn bạn nhé 🙏', 'Nghe hay đó, kể thêm đi!',
  'Ừ mình cũng nghĩ vậy', 'Ok ok, để mình thử xem sao',
];

// ─────────────────────────────────────────────────────────────────────────────
// SEED DATA
// ─────────────────────────────────────────────────────────────────────────────

final Map<String, List<Map<String, dynamic>>> _seeds = {
  'Nguyễn Văn A': [
    {'isMe': false, 'text': 'Hey bạn ơi, hôm nay bạn có rảnh không?'},
    {'isMe': true,  'text': 'Có, mình rảnh từ 3h chiều nha'},
    {'isMe': false, 'text': 'Tuyệt! Vậy mình gặp nhau ở quán cà phê gần nhà bạn nha'},
    {'isMe': true,  'text': 'Oke bạn, mình chờ bạn nhé 😊'},
    {'isMe': false, 'text': 'Ok nghen, mình sắp xong việc rồi'},
    {'isMe': true,  'text': 'Không sao, mình đợi được mà'},
    {'isMe': false, 'text': 'Hẹn gặp lại nhé! 👋'},
  ],
  'Trần Thị B': [
    {'isMe': true,  'text': 'Bạn đã xem qua tài liệu mình gửi chưa?'},
    {'isMe': false, 'text': 'Rồi, mình đang đọc đây'},
    {'isMe': true,  'text': 'Có điểm nào chưa rõ không?'},
    {'isMe': false, 'text': 'Phần thứ 3 hơi khó hiểu một chút'},
    {'isMe': true,  'text': 'Để mình giải thích thêm nha...'},
    {'isMe': false, 'text': 'À hiểu rồi, cảm ơn bạn đã giải thích!'},
    {'isMe': false, 'text': 'Ok, mình hiểu rồi ✅'},
  ],
  'Lê Văn C': [
    {'isMe': false, 'text': 'Mình vừa đi du lịch Đà Lạt về nè'},
    {'isMe': true,  'text': 'Ôi thật á! Vui không bạn?'},
    {'isMe': false, 'text': 'Vui lắm, trời mát mẻ, phong cảnh đẹp'},
    {'isMe': true,  'text': 'Chụp được nhiều ảnh không?'},
    {'isMe': false, 'text': 'Nhiều lắm, để mình gửi cho xem nha'},
    {'isMe': true,  'text': 'Oke nha, mình chờ!'},
    {'isMe': false, 'text': 'Ảnh đẹp quá!'},
  ],
  'Phạm Thị D': [
    {'isMe': false, 'text': 'Bạn ơi, mình cần nhờ bạn một việc'},
    {'isMe': true,  'text': 'Gì vậy bạn? Mình nghe'},
    {'isMe': false, 'text': 'Bạn có thể review code của mình không?'},
    {'isMe': true,  'text': 'Được chứ, bạn gửi link repo đi'},
    {'isMe': false, 'text': 'Cảm ơn bạn nhiều lắm nha!'},
    {'isMe': true,  'text': 'Không có gì, bạn gửi đi mình xem cho'},
  ],
  'Hoàng Văn E': [
    {'isMe': true,  'text': 'Bạn có khỏe không? Lâu rồi không gặp'},
    {'isMe': false, 'text': 'Mình ổn bạn ơi, dạo này bận quá'},
    {'isMe': true,  'text': 'Mình hiểu, công việc nhiều không?'},
    {'isMe': false, 'text': 'Ừ, dự án deadline cuối tháng rồi'},
    {'isMe': true,  'text': 'Cố lên bạn nhé, mình tin bạn làm được!'},
    {'isMe': false, 'text': 'Cảm ơn bạn nhiều 🙏'},
  ],
  'Vũ Thị F': [
    {'isMe': false, 'text': 'Hi bạn, dạo này bạn thế nào?'},
    {'isMe': true,  'text': 'Mình bình thường bạn ơi, còn bạn?'},
    {'isMe': false, 'text': 'Mình cũng vậy 😄 Cuối tuần này có kế hoạch gì không?'},
    {'isMe': true,  'text': 'Chưa có gì đặc biệt lắm'},
    {'isMe': false, 'text': 'Bạn rảnh không?'},
  ],
  'Đặng Văn G': [
    {'isMe': true,  'text': 'Bạn ơi tiến độ dự án đến đâu rồi?'},
    {'isMe': false, 'text': 'Đang hoàn thiện phần cuối rồi bạn'},
    {'isMe': true,  'text': 'Tốt quá, có gặp vấn đề gì không?'},
    {'isMe': false, 'text': 'Một vài bug nhỏ thôi, mình fix hết rồi'},
    {'isMe': true,  'text': 'Bạn giỏi thật đó!'},
    {'isMe': false, 'text': 'Dự án hoàn thành rồi!'},
  ],
  'Bùi Thị H': [
    {'isMe': false, 'text': 'Bạn đã xem video hài mình gửi chưa?'},
    {'isMe': true,  'text': 'Rồi! Hay quá trời 😂'},
    {'isMe': false, 'text': 'Đúng không, cái đoạn cuối bá nhất'},
    {'isMe': true,  'text': 'Mình xem đi xem lại mấy lần luôn'},
    {'isMe': false, 'text': 'Haha 😂😂'},
  ],
};

// ─────────────────────────────────────────────────────────────────────────────
// CHAT PAGE
// ─────────────────────────────────────────────────────────────────────────────

class ChatPage extends StatefulWidget {
  final String contactName;
  final Color  contactColor;

  const ChatPage({
    super.key,
    required this.contactName,
    required this.contactColor,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final TextEditingController _inputCtrl  = TextEditingController();
  final ScrollController      _scrollCtrl = ScrollController();
  final FocusNode             _focusNode  = FocusNode();

  late List<ChatMessage> _messages;
  bool _isTyping = false;
  late AnimationController _sendBtnCtrl;
  String? _activeReactionMsgId;
  Timer? _subtitleTimer;

  @override
  void initState() {
    super.initState();
    _sendBtnCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _loadConversation();
    _isTyping = ConversationState.instance.isTyping(widget.contactName);
    ConversationState.instance.addListener(_onStateChange);
    _inputCtrl.addListener(_onInputChanged);
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _scrollToBottom(animated: false));
    _subtitleTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() {});
    });
  }

  void _loadConversation() {
    final state = ConversationState.instance;
    if (state.hasHistory(widget.contactName)) {
      _messages = state.getHistory(widget.contactName);
    } else {
      final seed = _seeds[widget.contactName] ?? [];
      final now  = DateTime.now();
      _messages  = seed.asMap().entries.map((e) {
        final minsAgo = (seed.length - e.key) * 3;
        return ChatMessage(
          id: 'seed_${e.key}',
          text: e.value['text'] as String,
          isMe: e.value['isMe'] as bool,
          time: now.subtract(Duration(minutes: minsAgo)),
          status: MessageStatus.seen,
        );
      }).toList();
    }
  }

  void _onStateChange() {
    if (!mounted) return;
    final state        = ConversationState.instance;
    final newTyping    = state.isTyping(widget.contactName);
    final stateHistory = state.getHistory(widget.contactName);
    setState(() {
      _isTyping = newTyping;
      if (stateHistory.length > _messages.length) {
        _messages = List.from(stateHistory);
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      }
    });
  }

  void _persistHistory() =>
      ConversationState.instance.saveHistory(widget.contactName, _messages);

  @override
  void dispose() {
    _subtitleTimer?.cancel();
    ConversationState.instance.removeListener(_onStateChange);
    _persistHistory();
    _inputCtrl.dispose();
    _scrollCtrl.dispose();
    _focusNode.dispose();
    _sendBtnCtrl.dispose();
    super.dispose();
  }

  void _onInputChanged() {
    setState(() {});
    _inputCtrl.text.isNotEmpty ? _sendBtnCtrl.forward() : _sendBtnCtrl.reverse();
  }

  void _scrollToBottom({bool animated = true}) {
    if (!_scrollCtrl.hasClients) return;
    final target = _scrollCtrl.position.maxScrollExtent;
    if (animated) {
      _scrollCtrl.animateTo(target,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      _scrollCtrl.jumpTo(target);
    }
  }

  void _onLongPressMessage(String msgId) {
    HapticFeedback.mediumImpact();
    _focusNode.unfocus();
    setState(() {
      _activeReactionMsgId = _activeReactionMsgId == msgId ? null : msgId;
    });
  }

  void _addReaction(String msgId, String emoji) {
    HapticFeedback.lightImpact();
    setState(() {
      final idx = _messages.indexWhere((m) => m.id == msgId);
      if (idx == -1) return;
      final reactions = Map<String, int>.from(_messages[idx].reactions);
      reactions[emoji] = (reactions[emoji] ?? 0) + 1;
      _messages[idx] = _messages[idx].copyWith(reactions: reactions);
      _activeReactionMsgId = null;
      ConversationState.instance.updateReactionPreview(
          widget.contactName, emoji, _messages[idx].text);
      _persistHistory();
    });
  }

  void _removeReaction(String msgId, String emoji) {
    HapticFeedback.lightImpact();
    setState(() {
      final idx = _messages.indexWhere((m) => m.id == msgId);
      if (idx == -1) return;
      final reactions = Map<String, int>.from(_messages[idx].reactions);
      final current   = reactions[emoji] ?? 0;
      if (current <= 1) reactions.remove(emoji); else reactions[emoji] = current - 1;
      _messages[idx] = _messages[idx].copyWith(reactions: reactions);
      final last = _messages.lastWhere((m) => !m.isMe, orElse: () => _messages.last);
      ConversationState.instance.restoreLastMessagePreview(widget.contactName, last.text);
      _persistHistory();
    });
  }

  Future<void> _sendMessage() async {
    final text = _inputCtrl.text.trim();
    if (text.isEmpty) return;
    setState(() => _activeReactionMsgId = null);

    final msg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text, isMe: true,
      time: DateTime.now(), status: MessageStatus.sending,
    );
    setState(() { _messages.add(msg); _inputCtrl.clear(); });
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() {
      final idx = _messages.indexWhere((m) => m.id == msg.id);
      if (idx != -1) _messages[idx] = msg.copyWith(status: MessageStatus.sent);
    });
    _persistHistory();

    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    final reply = _autoReplies[Random().nextInt(_autoReplies.length)];
    ConversationState.instance.scheduleReply(widget.contactName, reply);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            setState(() => _activeReactionMsgId = null);
            _focusNode.unfocus();
          },
          behavior: HitTestBehavior.translucent,
          child: Column(children: [
            _buildHeader(),
            Expanded(child: _buildMessageList()),
            if (_isTyping) _buildTypingRow(),
            _buildInputBar(),
          ]),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final state          = ConversationState.instance;
    final isOnline       = state.isOnline(widget.contactName);
    final activityStatus = state.getActivityStatus(widget.contactName);
    final subtitle       = activityStatus ?? 'Không hoạt động gần đây';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFF0F2F5))),
        boxShadow: [BoxShadow(color: Color(0x0D000000), blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Row(children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF1877F2), size: 22),
          onPressed: () => Navigator.of(context).pop(),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
        ),
        const SizedBox(width: 4),
        Stack(children: [
          CircleAvatar(
              radius: 22, backgroundColor: widget.contactColor,
              child: Text(widget.contactName[0],
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18))),
          // ✅ FIX: right: 0, bottom: 0 — căn góc chuẩn, size 12, border 2.5
          if (isOnline)
            Positioned(right: 0, bottom: 0,
                child: Container(width: 12, height: 12,
                    decoration: BoxDecoration(color: const Color(0xFF31A24C),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2.5)))),
        ]),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.contactName,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 16, color: Color(0xFF050505))),
              const SizedBox(height: 1),
              Text(subtitle,
                  style: TextStyle(
                      fontSize: 12,
                      color: isOnline
                          ? const Color(0xFF31A24C)
                          : const Color(0xFF65676B))),
            ],
          ),
        ),
        _headerAction(Icons.phone_rounded),
        _headerAction(Icons.videocam_rounded),
        _headerAction(Icons.info_outline_rounded),
      ]),
    );
  }

  Widget _headerAction(IconData icon) {
    return Container(
      width: 36, height: 36,
      margin: const EdgeInsets.only(left: 4),
      decoration: const BoxDecoration(color: Color(0xFFF0F2F5), shape: BoxShape.circle),
      child: IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(icon, size: 20, color: const Color(0xFF1877F2)),
          onPressed: () {}),
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollCtrl,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      itemCount: _messages.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) return _buildDateLabel('Hôm nay');
        final msg  = _messages[index - 1];
        final prev = index > 1 ? _messages[index - 2] : null;
        final next = index < _messages.length ? _messages[index] : null;
        return _buildBubbleRow(
          msg: msg,
          isFirst: prev == null || prev.isMe != msg.isMe,
          isLast:  next == null || next.isMe != msg.isMe,
          showAvatar: !msg.isMe && (next == null || next.isMe != msg.isMe),
          isReactionOpen: _activeReactionMsgId == msg.id,
        );
      },
    );
  }

  Widget _buildDateLabel(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
              color: const Color(0xFFF0F2F5), borderRadius: BorderRadius.circular(12)),
          child: Text(label,
              style: const TextStyle(
                  fontSize: 12, color: Color(0xFF65676B), fontWeight: FontWeight.w500)),
        ),
      ),
    );
  }

  Widget _buildBubbleRow({
    required ChatMessage msg,
    required bool isFirst,
    required bool isLast,
    required bool showAvatar,
    required bool isReactionOpen,
  }) {
    final isMe         = msg.isMe;
    const r            = Radius.circular(18);
    const rSmall       = Radius.circular(4);
    final hasReactions = msg.reactions.isNotEmpty;

    final br = isMe
        ? BorderRadius.only(topLeft: r, topRight: isFirst ? r : rSmall,
        bottomRight: isLast ? rSmall : rSmall, bottomLeft: r)
        : BorderRadius.only(topLeft: isFirst ? r : rSmall, topRight: r,
        bottomLeft: isLast ? rSmall : rSmall, bottomRight: r);

    return Padding(
      padding: EdgeInsets.only(
        top: isFirst ? 6 : 1.5,
        bottom: isReactionOpen ? 54 : (hasReactions ? 8 : (isLast ? 2 : 1.5)),
      ),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            SizedBox(width: 32,
                child: showAvatar
                    ? CircleAvatar(radius: 14, backgroundColor: widget.contactColor,
                    child: Text(widget.contactName[0],
                        style: const TextStyle(
                            color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)))
                    : null),
            const SizedBox(width: 6),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (isReactionOpen) _buildReactionPicker(msg.id, isMe),
                GestureDetector(
                  onLongPress: () => _onLongPressMessage(msg.id),
                  child: Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.68),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isMe ? const Color(0xFF1877F2) : const Color(0xFFF0F2F5),
                      borderRadius: br,
                      boxShadow: isMe
                          ? [BoxShadow(color: const Color(0xFF1877F2).withValues(alpha: 0.2),
                          blurRadius: 6, offset: const Offset(0, 2))]
                          : [],
                    ),
                    child: Text(msg.text,
                        style: TextStyle(
                            color: isMe ? Colors.white : const Color(0xFF050505),
                            fontSize: 15, height: 1.35)),
                  ),
                ),
                if (hasReactions) ...[
                  const SizedBox(height: 4),
                  _buildReactionBar(msg.id, msg.reactions),
                ],
                if (isMe && isLast) ...[
                  const SizedBox(height: 3),
                  _buildStatusRow(msg.status),
                ],
              ],
            ),
          ),
          if (isMe) const SizedBox(width: 4),
        ],
      ),
    );
  }

  Widget _buildReactionPicker(String msgId, bool isMe) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 280),
        curve: Curves.elasticOut,
        builder: (_, value, child) => Transform.scale(
          scale: value,
          alignment: isMe ? Alignment.bottomRight : Alignment.bottomLeft,
          child: child,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(32),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.14),
                blurRadius: 20, spreadRadius: 1, offset: const Offset(0, 4))],
          ),
          child: Row(mainAxisSize: MainAxisSize.min,
            children: List.generate(_reactionEmojis.length, (i) {
              final emoji = _reactionEmojis[i];
              return GestureDetector(
                onTap: () => _addReaction(msgId, emoji),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.3, end: 1.0),
                  duration: Duration(milliseconds: 180 + i * 35),
                  curve: Curves.elasticOut,
                  builder: (_, v, __) => Transform.scale(
                    scale: v,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      child: Text(emoji, style: const TextStyle(fontSize: 26)),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildReactionBar(String msgId, Map<String, int> reactions) {
    return Wrap(
      spacing: 4, runSpacing: 4,
      children: reactions.entries.map((entry) {
        return GestureDetector(
          onTap: () => _removeReaction(msgId, entry.key),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFE7F3FF), borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: const Color(0xFF1877F2).withValues(alpha: 0.35), width: 1),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Text(entry.key, style: const TextStyle(fontSize: 15)),
              if (entry.value > 1) ...[
                const SizedBox(width: 3),
                Text('${entry.value}', style: const TextStyle(
                    fontSize: 12, color: Color(0xFF1877F2), fontWeight: FontWeight.w700)),
              ],
            ]),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStatusRow(MessageStatus status) {
    switch (status) {
      case MessageStatus.sending:
        return const Text('Đang gửi...',
            style: TextStyle(fontSize: 11, color: Color(0xFF65676B)));
      case MessageStatus.sent:
        return const Text('Đã gửi',
            style: TextStyle(fontSize: 11, color: Color(0xFF65676B)));
      case MessageStatus.delivered:
        return const Text('Đã nhận',
            style: TextStyle(fontSize: 11, color: Color(0xFF65676B)));
      case MessageStatus.seen:
        return Row(mainAxisSize: MainAxisSize.min, children: [
          CircleAvatar(radius: 8, backgroundColor: widget.contactColor,
              child: Text(widget.contactName[0],
                  style: const TextStyle(
                      color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold))),
          const SizedBox(width: 4),
          const Text('Đã xem', style: TextStyle(fontSize: 11, color: Color(0xFF65676B))),
        ]);
    }
  }

  Widget _buildTypingRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
      child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        CircleAvatar(radius: 14, backgroundColor: widget.contactColor,
            child: Text(widget.contactName[0],
                style: const TextStyle(
                    color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))),
        const SizedBox(width: 8),
        const _TypingBubble(),
      ]),
    );
  }

  Widget _buildInputBar() {
    final hasText = _inputCtrl.text.trim().isNotEmpty;
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
      decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFF0F2F5)))),
      child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        _inputIcon(Icons.add_circle_outline_rounded),
        _inputIcon(Icons.camera_alt_outlined),
        _inputIcon(Icons.image_outlined),
        _inputIcon(Icons.mic_none_rounded),
        const SizedBox(width: 4),
        Expanded(
          child: Container(
            constraints: const BoxConstraints(maxHeight: 120),
            decoration: BoxDecoration(
                color: const Color(0xFFF0F2F5), borderRadius: BorderRadius.circular(22)),
            child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Expanded(
                child: TextField(
                  controller: _inputCtrl, focusNode: _focusNode,
                  maxLines: null, keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  style: const TextStyle(fontSize: 15, color: Color(0xFF050505)),
                  decoration: const InputDecoration(
                    hintText: 'Aa',
                    hintStyle: TextStyle(color: Color(0xFF65676B), fontSize: 15),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 6, bottom: 6),
                child: Text('😊', style: TextStyle(fontSize: 20)),
              ),
            ]),
          ),
        ),
        const SizedBox(width: 8),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 150),
          transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
          child: hasText ? _sendButton() : _likeButton(),
        ),
      ]),
    );
  }

  Widget _inputIcon(IconData icon) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 6),
    child: Icon(icon, color: const Color(0xFF1877F2), size: 26),
  );

  Widget _sendButton() => GestureDetector(
    key: const ValueKey('send'), onTap: _sendMessage,
    child: Container(width: 38, height: 38,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(colors: [Color(0xFF00C6FF), Color(0xFF1877F2)],
              begin: Alignment.topLeft, end: Alignment.bottomRight),
          boxShadow: [BoxShadow(color: Color(0x331877F2), blurRadius: 8, offset: Offset(0, 3))],
        ),
        child: const Icon(Icons.send_rounded, color: Colors.white, size: 20)),
  );

  Widget _likeButton() => GestureDetector(
    key: const ValueKey('like'),
    onTap: () {
      setState(() {
        _messages.add(ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: '👍', isMe: true,
          time: DateTime.now(), status: MessageStatus.sent,
        ));
      });
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    },
    child: const SizedBox(width: 38, height: 38,
        child: Center(child: Text('👍', style: TextStyle(fontSize: 26)))),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// TYPING BUBBLE
// ─────────────────────────────────────────────────────────────────────────────

class _TypingBubble extends StatefulWidget {
  const _TypingBubble();
  @override
  State<_TypingBubble> createState() => _TypingBubbleState();
}

class _TypingBubbleState extends State<_TypingBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))..repeat();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFFF0F2F5),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(4), topRight: Radius.circular(18),
          bottomRight: Radius.circular(18), bottomLeft: Radius.circular(18),
        ),
      ),
      child: Row(mainAxisSize: MainAxisSize.min,
          children: [_dot(0.0), _dot(0.3), _dot(0.6)]),
    );
  }

  Widget _dot(double delay) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        final t     = (_ctrl.value + delay) % 1.0;
        final scale = 1.0 + (t < 0.5 ? t : 1.0 - t) * 0.7;
        return Container(
          width: 8 * scale, height: 8 * scale,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: const BoxDecoration(
              color: Color(0xFF65676B), shape: BoxShape.circle),
        );
      },
    );
  }
}