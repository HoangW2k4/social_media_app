import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../widgets/feature_not_ready.dart' show showFeatureNotReady;
import '../image_detail.dart';
import 'post_comments.dart';
import 'post_image_grid.dart';
import 'post_layout.dart';

/// Full-screen post detail page (Facebook-style).
class PostDetailPage extends StatelessWidget {
  final PostItemData post;

  const PostDetailPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(post.userName),
        centerTitle: true,
        elevation: 0.5,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () => showFeatureNotReady(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: post.color,
                          child: Text(
                            post.userName[0],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
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
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    post.time,
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.public,
                                    size: 13,
                                    color: Colors.grey.shade600,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Content text
                  if (post.content.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
                      child: Text(
                        post.content,
                        style: const TextStyle(fontSize: 16, height: 1.4),
                      ),
                    ),

                  // Images
                  if (post.images.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    PostImageGrid(images: _imagesWithTap(context, post.images)),
                  ],

                  // Actions + comments (always expanded)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
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
                      initiallyExpanded: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<PostImage> _imagesWithTap(BuildContext context, List<PostImage> images) {
    return List.generate(images.length, (i) {
      final img = images[i];
      return PostImage(
        url: img.url,
        assetPath: img.assetPath,
        color: img.color,
        isVideo: img.isVideo,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ImageDetailPage(images: images, initialIndex: i),
            ),
          );
        },
      );
    });
  }
}
