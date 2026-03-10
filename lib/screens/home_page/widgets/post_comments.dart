import 'package:flutter/material.dart';
import '../../../widgets/feature_not_ready.dart' show showFeatureNotReady;
import 'post_layout.dart' show CommentData;

class PostComments extends StatefulWidget {
  final int likes;
  final int commentsCount;
  final int shares;
  final List<CommentData> commentItems;
  final String commentLabel;
  final String shareLabel;
  final String likeLabel;
  final String replyLabel;
  final String writeCommentHint;
  final bool initiallyExpanded;

  const PostComments({
    super.key,
    required this.likes,
    required this.commentsCount,
    required this.shares,
    required this.commentLabel,
    required this.shareLabel,
    required this.likeLabel,
    required this.replyLabel,
    required this.writeCommentHint,
    this.commentItems = const [],
    this.initiallyExpanded = false,
  });

  @override
  State<PostComments> createState() => _PostCommentsState();
}

class _PostCommentsState extends State<PostComments> {
  late bool _showComments;
  bool _liked = false;
  late int _likeCount;

  @override
  void initState() {
    super.initState();
    _likeCount = widget.likes;
    _showComments = widget.initiallyExpanded;
  }

  void _toggleLike() {
    setState(() {
      _liked = !_liked;
      _likeCount += _liked ? 1 : -1;
    });
  }

  void _openFeatureNotReady(BuildContext context) {
    showFeatureNotReady(context);
  }

  @override
  Widget build(BuildContext context) {
    final likeColor = _liked ? Colors.blue : Colors.grey.shade700;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Like / Comment count row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.thumb_up,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '$_likeCount',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
            Text(
              '${widget.commentsCount} ${widget.commentLabel}  •  ${widget.shares} ${widget.shareLabel}',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
          ],
        ),
        const Divider(),

        // Action buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _ActionButton(
              icon: _liked ? Icons.thumb_up : Icons.thumb_up_outlined,
              label: widget.likeLabel,
              color: likeColor,
              onTap: _toggleLike,
            ),
            _ActionButton(
              icon: Icons.chat_bubble_outline,
              label: widget.commentLabel,
              onTap: () => setState(() => _showComments = !_showComments),
            ),
            _ActionButton(
              icon: Icons.share_outlined,
              label: widget.shareLabel,
              onTap: () => _openFeatureNotReady(context),
            ),
          ],
        ),

        // Comment section (toggled)
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: _buildCommentSection(),
          crossFadeState: _showComments
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 250),
        ),
      ],
    );
  }

  Widget _buildCommentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.commentItems.isNotEmpty) ...[
          const Divider(),
          for (final comment in widget.commentItems)
            _CommentBubble(
              comment: comment,
              likeLabel: widget.likeLabel,
              replyLabel: widget.replyLabel,
            ),
        ],

        // Write a comment input
        const SizedBox(height: 8),
        Row(
          children: [
            const CircleAvatar(
              radius: 16,
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, size: 18, color: Colors.white),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.writeCommentHint,
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.camera_alt_outlined,
                      size: 20,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.gif_box_outlined,
                      size: 20,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.emoji_emotions_outlined,
                      size: 20,
                      color: Colors.grey.shade500,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CommentBubble extends StatefulWidget {
  final CommentData comment;
  final String likeLabel;
  final String replyLabel;

  const _CommentBubble({
    required this.comment,
    required this.likeLabel,
    required this.replyLabel,
  });

  @override
  State<_CommentBubble> createState() => _CommentBubbleState();
}

class _CommentBubbleState extends State<_CommentBubble> {
  bool _liked = false;
  late int _likeCount;

  @override
  void initState() {
    super.initState();
    _likeCount = widget.comment.likeCount;
  }

  void _toggleLike() {
    setState(() {
      _liked = !_liked;
      _likeCount += _liked ? 1 : -1;
    });
  }

  void _openFeatureNotReady() {
    showFeatureNotReady(context);
  }

  @override
  Widget build(BuildContext context) {
    final comment = widget.comment;
    final likeColor = _liked ? Colors.blue : Colors.grey.shade700;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: comment.avatarColor,
                child: Text(
                  comment.userName[0],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Bubble
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            comment.userName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            comment.text,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    // Time · Like · Reply · reaction count
                    Padding(
                      padding: const EdgeInsets.only(left: 12, top: 4),
                      child: Row(
                        children: [
                          Text(
                            comment.time,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 16),
                          GestureDetector(
                            onTap: _toggleLike,
                            child: Text(
                              widget.likeLabel,
                              style: TextStyle(
                                color: likeColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          GestureDetector(
                            onTap: _openFeatureNotReady,
                            child: Text(
                              widget.replyLabel,
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (_likeCount > 0) ...[
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.thumb_up,
                                    color: Colors.blue,
                                    size: 12,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    '$_likeCount',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Nested replies (indented)
          if (comment.replies.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 40, top: 4),
              child: Column(
                children: [
                  for (final reply in comment.replies)
                    _CommentBubble(
                      comment: reply,
                      likeLabel: widget.likeLabel,
                      replyLabel: widget.replyLabel,
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Action button ───────────────────────────────────────────────────────────
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? Colors.grey.shade700;
    return TextButton.icon(
      onPressed: onTap ?? () {},
      icon: Icon(icon, color: c, size: 20),
      label: Text(label, style: TextStyle(color: c, fontSize: 13)),
    );
  }
}
