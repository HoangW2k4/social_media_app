import 'package:flutter/material.dart';
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
  });

  @override
  State<PostComments> createState() => _PostCommentsState();
}

class _PostCommentsState extends State<PostComments> {
  bool _showComments = false;

  @override
  Widget build(BuildContext context) {
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
                  '${widget.likes}',
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
              icon: Icons.thumb_up_outlined,
              label: widget.likeLabel,
            ),
            _ActionButton(
              icon: Icons.chat_bubble_outline,
              label: widget.commentLabel,
              onTap: () => setState(() => _showComments = !_showComments),
            ),
            _ActionButton(icon: Icons.share_outlined, label: widget.shareLabel),
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

// ─── Single comment bubble ───────────────────────────────────────────────────
class _CommentBubble extends StatelessWidget {
  final CommentData comment;
  final String likeLabel;
  final String replyLabel;

  const _CommentBubble({
    required this.comment,
    required this.likeLabel,
    required this.replyLabel,
  });

  @override
  Widget build(BuildContext context) {
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
                          Text(
                            likeLabel,
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            replyLabel,
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (comment.likeCount > 0) ...[
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
                                    '${comment.likeCount}',
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
                      likeLabel: likeLabel,
                      replyLabel: replyLabel,
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
  final VoidCallback? onTap;

  const _ActionButton({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onTap ?? () {},
      icon: Icon(icon, color: Colors.grey.shade700, size: 20),
      label: Text(
        label,
        style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
      ),
    );
  }
}
