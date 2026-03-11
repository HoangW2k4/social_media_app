// lib/screens/messages_page/messages_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../l10n/app_localizations.dart';
import 'package:social_media_app/screens/chat_page/chat_page.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/providers/language_provider.dart';
import 'conversation_state.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  double fabRight = 16;
  double fabBottom = 16;
  String _selectedFilter = 'all';

  // 5 người có story ring trên avatar trong list
  static const Set<String> _storyContacts = {
    'Nguyễn Văn A',
    'Trần Thị B',
    'Lê Văn C',
    'Phạm Thị D',
    'Hoàng Văn E',
  };

  final Map<String, _ConvData> _convMap = {
    'Nguyễn Văn A': _ConvData('Nguyễn Văn A', 'Hẹn gặp lại nhé! 👋',  '2m',  true,  Colors.blue),
    'Trần Thị B':   _ConvData('Trần Thị B',   'Ok, mình hiểu rồi ✅',  '15m', true,  Colors.purple),
    'Lê Văn C':     _ConvData('Lê Văn C',     'Ảnh đẹp quá!',          '1h',  false, Colors.orange),
    'Phạm Thị D':   _ConvData('Phạm Thị D',   '',                       '',    true,  Colors.green),
    'Hoàng Văn E':  _ConvData('Hoàng Văn E',  'Cảm ơn bạn nhiều 🙏',   '3h',  false, Colors.red),
    'Vũ Thị F':     _ConvData('Vũ Thị F',     'Bạn rảnh không?',       '5h',  false, Colors.teal),
    'Đặng Văn G':   _ConvData('Đặng Văn G',   'Dự án hoàn thành rồi!', '1d',  false, Colors.indigo),
    'Bùi Thị H':    _ConvData('Bùi Thị H',    'Haha 😂😂',             '2d',  false, Colors.pink),
  };

  final Map<String, bool> _initialUnread = {
    'Nguyễn Văn A': true,
    'Trần Thị B':   true,
    'Lê Văn C':     false,
    'Phạm Thị D':   false,
    'Hoàng Văn E':  false,
    'Vũ Thị F':     false,
    'Đặng Văn G':   false,
    'Bùi Thị H':    false,
  };

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);

    return ListenableBuilder(
      listenable: ConversationState.instance,
      builder: (context, _) {
        final state = ConversationState.instance;

        final ordered = state.contactOrder
            .map((n) => _convMap[n])
            .whereType<_ConvData>()
            .toList();

        ordered.sort((a, b) {
          final ap = state.isPinned(a.name) ? 0 : 1;
          final bp = state.isPinned(b.name) ? 0 : 1;
          return ap.compareTo(bp);
        });

        final visible  = ordered.where((c) => !state.isArchived(c.name)).toList();
        final filtered = _selectedFilter == 'unread'
            ? visible.where((c) => state.isEffectivelyUnread(
            c.name, _initialUnread[c.name] ?? false)).toList()
            : visible;

        final archivedCount = ordered.where((c) => state.isArchived(c.name)).length;

        return Scaffold(
          body: SafeArea(
            child: Stack(children: [
              Column(children: [
                _buildSearchBar(t),
                _buildStoryRow(),
                _buildFilterRow(),
                Expanded(
                  child: filtered.isEmpty
                      ? _emptyUnread()
                      : ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: filtered.length + (archivedCount > 0 ? 1 : 0),
                    itemBuilder: (_, i) {
                      if (i == filtered.length) return _archivedBanner(archivedCount);
                      return _SwipeableTile(
                        key: ValueKey(filtered[i].name),
                        conv: filtered[i],
                        initialUnread: _initialUnread[filtered[i].name] ?? false,
                        hasStory: _storyContacts.contains(filtered[i].name),
                        onTap: () => _openChat(filtered[i]),
                        onPin: () => state.togglePin(filtered[i].name),
                        onArchive: () => state.toggleArchive(filtered[i].name),
                      );
                    },
                  ),
                ),
              ]),
              _fab(),
            ]),
          ),
        );
      },
    );
  }

  void _openChat(_ConvData conv) {
    ConversationState.instance.markAsRead(conv.name);
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ChatPage(
        contactName: conv.name,
        contactColor: conv.color,
      ),
    ));
  }

  Widget _emptyUnread() {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.mark_chat_read_outlined, size: 64, color: Colors.grey[300]),
        const SizedBox(height: 12),
        Text('Không có tin nhắn chưa đọc',
            style: TextStyle(fontSize: 15, color: Colors.grey[500])),
      ]),
    );
  }

  Widget _archivedBanner(int count) {
    return InkWell(
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$count cuộc trò chuyện đã lưu trữ'))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(children: [
          Container(width: 46, height: 46,
              decoration: const BoxDecoration(color: Color(0xFFF0F2F5), shape: BoxShape.circle),
              child: const Icon(Icons.archive_outlined, color: Color(0xFF65676B), size: 22)),
          const SizedBox(width: 12),
          Expanded(child: Text('Đã lưu trữ ($count)',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500))),
        ]),
      ),
    );
  }

  Widget _buildSearchBar(AppLocalizations t) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Container(
        height: 42,
        decoration: BoxDecoration(
            color: const Color(0xFFF0F2F5), borderRadius: BorderRadius.circular(24)),
        child: TextField(
          decoration: InputDecoration(
            hintText: t.translate('messages_search'),
            hintStyle: const TextStyle(color: Color(0xFF65676B), fontSize: 15),
            prefixIcon: const Icon(Icons.search, color: Color(0xFF65676B), size: 22),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
          ),
        ),
      ),
    );
  }

  // ✅ Story row: CHỈ hiện người trong _storyContacts VÀ đang online
  Widget _buildStoryRow() {
    final state = ConversationState.instance;

    // Lấy danh sách online, lọc chỉ giữ người thuộc _storyContacts
    // state.onlineContacts đã sắp xếp theo thứ tự online (cũ → mới)
    final onlineStory = state.onlineContacts
        .where((n) => _storyContacts.contains(n) && _convMap.containsKey(n))
        .toList();

    return SizedBox(
      height: 96,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        children: [
          _createStory(),
          ...onlineStory.map((name) => _storyItem(name, _convMap[name]!.color)),
        ],
      ),
    );
  }

  Widget _buildFilterRow() {
    final isEn = context.watch<LanguageProvider>().locale.languageCode == 'en';
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
      child: Row(children: [
        _chip(isEn ? 'All' : 'Tất cả', 'all'),
        const SizedBox(width: 8),
        _chip(isEn ? 'Unread' : 'Chưa đọc', 'unread'),
        const SizedBox(width: 8),
        _chip(isEn ? 'Groups' : 'Nhóm', 'groups'),
        const Spacer(),
        const Icon(Icons.more_horiz, color: Color(0xFF65676B)),
      ]),
    );
  }

  Widget _chip(String label, String value) {
    final selected = _selectedFilter == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
            color: selected ? const Color(0xFFE7F3FF) : const Color(0xFFF0F2F5),
            borderRadius: BorderRadius.circular(18)),
        child: Text(label,
            style: TextStyle(
                color: selected ? const Color(0xFF1877F2) : const Color(0xFF050505),
                fontSize: 14,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500)),
      ),
    );
  }

  Widget _fab() {
    return Positioned(
      right: fabRight, bottom: fabBottom,
      child: GestureDetector(
        onPanUpdate: (d) {
          final size = MediaQuery.of(context).size;
          const s = 58.0, pad = 8.0;
          setState(() {
            fabRight  = (fabRight  - d.delta.dx).clamp(pad, size.width  - s - pad);
            fabBottom = (fabBottom - d.delta.dy).clamp(pad, size.height - s - pad);
          });
        },
        child: Container(
          width: 58, height: 58,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
                colors: [Color(0xFF00C6FF), Color(0xFF6F42FF)],
                begin: Alignment.topLeft, end: Alignment.bottomRight),
            boxShadow: [BoxShadow(color: Color(0x22000000), blurRadius: 8, offset: Offset(0, 3))],
          ),
          child: const Icon(Icons.edit, color: Colors.white, size: 24),
        ),
      ),
    );
  }

  Widget _createStory() {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Column(children: [
        Stack(clipBehavior: Clip.none, children: [
          Container(width: 60, height: 60,
              decoration: BoxDecoration(color: const Color(0xFFE4E6EB),
                  shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
              child: const Icon(Icons.person, color: Colors.grey, size: 30)),
          Positioned(bottom: -2, right: -2,
              child: Container(width: 22, height: 22,
                  decoration: BoxDecoration(color: const Color(0xFF0084FF),
                      shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2.5)),
                  child: const Icon(Icons.add, size: 14, color: Colors.white))),
        ]),
        const SizedBox(height: 6),
        const SizedBox(width: 64,
            child: Text('Tạo tin', maxLines: 1, overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.black87))),
      ]),
    );
  }

  // Story item: luôn có viền xanh + chấm online (vì chỉ render khi online)
  Widget _storyItem(String name, Color color) {
    return GestureDetector(
      onTap: () { final conv = _convMap[name]; if (conv != null) _openChat(conv); },
      child: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Column(children: [
          Stack(children: [
            Container(
              width: 60, height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF0084FF), width: 2.5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: CircleAvatar(
                  backgroundColor: color,
                  child: Text(name[0], style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22)),
                ),
              ),
            ),
            // Luôn có chấm online vì chỉ xuất hiện khi online
            Positioned(right: 0, bottom: 0,
                child: Container(width: 16, height: 16,
                    decoration: BoxDecoration(color: const Color(0xFF31A24C),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2.5)))),
          ]),
          const SizedBox(height: 6),
          SizedBox(width: 64,
              child: Text(name.split(' ').last, maxLines: 1, overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, color: Colors.black87))),
        ]),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SWIPEABLE TILE
// ─────────────────────────────────────────────────────────────────────────────

class _SwipeableTile extends StatefulWidget {
  final _ConvData conv;
  final bool initialUnread;
  final bool hasStory;
  final VoidCallback onTap;
  final VoidCallback onPin;
  final VoidCallback onArchive;

  const _SwipeableTile({
    super.key,
    required this.conv,
    required this.initialUnread,
    required this.hasStory,
    required this.onTap,
    required this.onPin,
    required this.onArchive,
  });

  @override
  State<_SwipeableTile> createState() => _SwipeableTileState();
}

class _SwipeableTileState extends State<_SwipeableTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;
  static const double _actionW   = 210.0;
  static const double _threshold = _actionW * 0.45;
  double _drag = 0;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 250));
    _anim = Tween<double>(begin: 0, end: 0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  void _onDragUpdate(DragUpdateDetails d) =>
      setState(() => _drag = (_drag - d.delta.dx).clamp(0.0, _actionW));

  void _onDragEnd(DragEndDetails d) => _drag > _threshold ? _open() : _close();

  void _open() {
    HapticFeedback.lightImpact();
    setState(() => _isOpen = true);
    _animTo(_actionW);
  }

  void _close() {
    setState(() => _isOpen = false);
    _animTo(0);
  }

  void _animTo(double target) {
    final begin = _drag;
    _anim = Tween<double>(begin: begin, end: target)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _ctrl.forward(from: 0).then((_) {
      if (mounted) setState(() => _drag = target);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isPinned = ConversationState.instance.isPinned(widget.conv.name);
    return GestureDetector(
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: _onDragEnd,
      onTap: () => _isOpen ? _close() : widget.onTap(),
      child: SizedBox(
        height: 72,
        child: Stack(children: [
          Positioned.fill(
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              _ActionBtn(label: 'Khác', color: const Color(0xFF8E8E93),
                  icon: Icons.more_horiz_rounded, width: 70,
                  onTap: () { _close(); _moreSheet(context); }),
              _ActionBtn(
                  label: isPinned ? 'Bỏ ghim' : 'Ghim',
                  color: const Color(0xFFFF9500),
                  icon: isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                  width: 70,
                  onTap: () { _close(); widget.onPin(); }),
              _ActionBtn(label: 'Lưu trữ', color: const Color(0xFF7B2FF7),
                  icon: Icons.archive_rounded, width: 70,
                  onTap: () { _close(); widget.onArchive(); }),
            ]),
          ),
          AnimatedBuilder(
            animation: _ctrl,
            builder: (_, child) => Transform.translate(
              offset: Offset(-(_ctrl.isAnimating ? _anim.value : _drag), 0),
              child: child,
            ),
            child: _ConvTile(
              conv: widget.conv,
              initialUnread: widget.initialUnread,
              hasStory: widget.hasStory,
              onTap: widget.onTap,
            ),
          ),
        ]),
      ),
    );
  }

  void _moreSheet(BuildContext ctx) {
    final state = ConversationState.instance;
    final name  = widget.conv.name;
    final isCurrentlyUnread = state.isEffectivelyUnread(name, widget.initialUnread);

    showModalBottomSheet(
      context: ctx,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                  color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
          if (isCurrentlyUnread)
            _sheetItem(Icons.mark_chat_read_outlined, 'Đánh dấu là đã đọc', () {
              state.markAsRead(name); Navigator.pop(ctx);
            })
          else
            _sheetItem(Icons.mark_chat_unread_outlined, 'Đánh dấu là chưa đọc', () {
              state.markAsUnread(name); Navigator.pop(ctx);
            }, highlight: true),
          _sheetItem(Icons.notifications_off_outlined, 'Tắt thông báo', () => Navigator.pop(ctx)),
          _sheetItem(Icons.block_outlined, 'Chặn', () => Navigator.pop(ctx), color: Colors.red),
          _sheetItem(Icons.delete_outline_rounded, 'Xóa đoạn chat', () => Navigator.pop(ctx), color: Colors.red),
        ]),
      ),
    );
  }

  Widget _sheetItem(IconData icon, String label, VoidCallback onTap,
      {Color? color, bool highlight = false}) {
    final c = color ?? (highlight ? const Color(0xFF1877F2) : const Color(0xFF050505));
    return ListTile(
      leading: Icon(icon, color: c),
      title: Text(label, style: TextStyle(fontSize: 15, color: c,
          fontWeight: highlight ? FontWeight.w600 : FontWeight.w400)),
      onTap: onTap,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ACTION BUTTON
// ─────────────────────────────────────────────────────────────────────────────

class _ActionBtn extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  final double width;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.label, required this.color,
    required this.icon, required this.width, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width, color: color,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, color: Colors.white, size: 22),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(
              color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
        ]),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CONVERSATION TILE
// ─────────────────────────────────────────────────────────────────────────────

class _ConvTile extends StatelessWidget {
  final _ConvData conv;
  final bool initialUnread;
  final bool hasStory;
  final VoidCallback onTap;

  const _ConvTile({
    required this.conv,
    required this.initialUnread,
    required this.hasStory,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final state       = ConversationState.instance;
    final isTyping    = state.isTyping(conv.name);
    final preview     = state.getPreview(conv.name);
    final isPinned    = state.isPinned(conv.name);
    final isUnread    = state.isEffectivelyUnread(conv.name, initialUnread);
    final showBlueDot = state.hasUnreadReply(conv.name) || state.isManuallyUnread(conv.name);
    final isReaction  = preview != null && preview.startsWith('Đã bày tỏ cảm xúc');
    final isOnline    = state.isOnline(conv.name);
    final bool showDot = isUnread || showBlueDot;

    final String displayMsg = isTyping
        ? ''
        : (preview != null && preview.isNotEmpty ? preview : conv.lastMessage);

    return Container(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(children: [

            // ── Avatar ───────────────────────────────────────────────────────
            Stack(children: [
              if (hasStory)
              // Có story: viền xanh luôn hiển thị
                Container(
                  width: 60, height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF0084FF), width: 2.5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: CircleAvatar(
                      backgroundColor: conv.color,
                      child: Text(conv.name[0],
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                  ),
                )
              else
                CircleAvatar(
                  radius: 28,
                  backgroundColor: conv.color,
                  child: Text(conv.name[0],
                      style: const TextStyle(
                          color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                ),

              // Chấm online xanh lá
              if (isOnline)
                Positioned(right: 0, bottom: 0,
                    child: Container(width: 14, height: 14,
                        decoration: BoxDecoration(color: const Color(0xFF31A24C),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2.5)))),
            ]),

            const SizedBox(width: 12),

            // ── Name + Preview ───────────────────────────────────────────────
            Expanded(
              child: SizedBox(
                height: 56,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Expanded(
                        child: Text(conv.name,
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: isUnread ? FontWeight.w800 : FontWeight.w500,
                                color: isUnread
                                    ? const Color(0xFF050505)
                                    : const Color(0xFF333333))),
                      ),
                      if (isPinned) ...[
                        const SizedBox(width: 4),
                        const Icon(Icons.push_pin, size: 14, color: Color(0xFF65676B)),
                      ],
                    ]),
                    const SizedBox(height: 3),
                    isTyping
                        ? const _TypingPillBubble()
                        : Row(children: [
                      if (isReaction)
                        const Padding(
                            padding: EdgeInsets.only(right: 3),
                            child: Icon(Icons.favorite_rounded,
                                size: 13, color: Color(0xFF65676B))),
                      Expanded(
                        child: Text(displayMsg,
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 13.5,
                                color: isUnread
                                    ? const Color(0xFF050505)
                                    : const Color(0xFF65676B),
                                fontWeight: isUnread
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                fontStyle: isReaction
                                    ? FontStyle.italic
                                    : FontStyle.normal)),
                      ),
                    ]),
                  ],
                ),
              ),
            ),

            // ── Cột ngoài cùng ───────────────────────────────────────────────
            const SizedBox(width: 8),
            SizedBox(
              width: 36,
              child: Align(
                alignment: Alignment.centerRight,
                child: showDot
                    ? Container(width: 10, height: 10,
                    decoration: const BoxDecoration(
                        color: Color(0xFF1877F2), shape: BoxShape.circle))
                    : Text(conv.time.isNotEmpty ? conv.time : '',
                    style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF65676B),
                        fontWeight: FontWeight.w400)),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TYPING PILL BUBBLE
// ─────────────────────────────────────────────────────────────────────────────

class _TypingPillBubble extends StatefulWidget {
  const _TypingPillBubble();
  @override
  State<_TypingPillBubble> createState() => _TypingPillBubbleState();
}

class _TypingPillBubbleState extends State<_TypingPillBubble>
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

  Widget _dot(double delay) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        final t  = (_ctrl.value + delay) % 1.0;
        final dy = -(t < 0.5 ? t : 1.0 - t) * 5;
        return Transform.translate(
          offset: Offset(0, dy),
          child: Container(
            width: 7, height: 7,
            margin: const EdgeInsets.symmetric(horizontal: 2.5),
            decoration: const BoxDecoration(
                color: Color(0xFF8A8A8E), shape: BoxShape.circle),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
            color: const Color(0xFFE9E9EB), borderRadius: BorderRadius.circular(18)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [_dot(0.0), _dot(0.33), _dot(0.66)],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DATA
// ─────────────────────────────────────────────────────────────────────────────

class _ConvData {
  final String name, lastMessage, time;
  final bool   initialOnline;
  final Color  color;

  _ConvData(this.name, this.lastMessage, this.time, this.initialOnline, this.color);
}