import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import 'post_comments.dart';
import 'post_image_grid.dart';

class PostLayout extends StatelessWidget {
  final List<PostItemData> posts;

  const PostLayout({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);

    final children = <Widget>[];
    for (int i = 0; i < posts.length; i++) {
      children.add(_PostCard(post: posts[i], t: t));
      if (i < posts.length - 1) {
        children.add(const Divider(thickness: 8, color: Color(0xFFEEEEEE)));
      }
    }

    return SliverList(delegate: SliverChildListDelegate(children));
  }
}

class _PostCard extends StatelessWidget {
  final PostItemData post;
  final AppLocalizations t;

  const _PostCard({required this.post, required this.t});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: post.color,
                child: Text(
                  post.userName[0],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.userName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Text(
                          post.time,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.public,
                          size: 12,
                          color: Colors.grey.shade600,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(icon: const Icon(Icons.more_horiz), onPressed: () {}),
            ],
          ),
        ),

        // Content
        if (post.content.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: Text(post.content, style: const TextStyle(fontSize: 15)),
          ),

        // Image grid
        if (post.images.isNotEmpty) ...[
          const SizedBox(height: 10),
          PostImageGrid(images: post.images),
        ],

        // Actions + comments
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          child: PostComments(
            likes: post.likes,
            commentsCount: post.commentsCount,
            shares: post.shares,
            commentItems: post.commentItems,
            likeLabel: t.translate('home_like'),
            commentLabel: t.translate('home_comment'),
            shareLabel: t.translate('home_share'),
            replyLabel: t.translate('home_reply'),
            writeCommentHint: t.translate('home_write_comment'),
          ),
        ),
      ],
    );
  }
}

class PostItemData {
  final String userName;
  final String time;
  final String content;
  final int likes;
  final int commentsCount;
  final int shares;
  final Color color;
  final List<PostImage> images;
  final List<CommentData> commentItems;

  const PostItemData({
    required this.userName,
    required this.time,
    required this.content,
    required this.likes,
    required this.commentsCount,
    required this.shares,
    required this.color,
    this.images = const [],
    this.commentItems = const [],
  });
}

class CommentData {
  final String userName;
  final Color avatarColor;
  final String text;
  final String time;
  final int likeCount;
  final List<CommentData> replies;

  const CommentData({
    required this.userName,
    required this.text,
    required this.time,
    this.avatarColor = Colors.blueGrey,
    this.likeCount = 0,
    this.replies = const [],
  });
}
