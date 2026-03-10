import 'dart:math';
import 'package:flutter/material.dart';
import 'package:social_media_app/screens/home_page/widgets/storys/story_section.dart';
import 'widgets/posts/post_item.dart';

String _randomAsset(Random r) => 'assets/images/img_${r.nextInt(30) + 1}.jpg';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<PostItemData> _posts = [];
  late final List<PostItemData> _initialPosts;

  @override
  void initState() {
    super.initState();
    final r = Random();

    _initialPosts = [
      PostItemData(
        userName: 'Nguyễn Văn A',
        time: '2h',
        content: 'Hôm nay trời đẹp quá! 🌞',
        likes: 120,
        commentsCount: 45,
        shares: 12,
        color: Colors.blue,
        images: [PostImage(assetPath: _randomAsset(r))],
        commentItems: const [
          CommentData(
            userName: 'Trần Thị B',
            text: 'Đẹp quá bạn ơi! 😍',
            time: '1h',
            avatarColor: Colors.purple,
            likeCount: 3,
          ),
          CommentData(
            userName: 'Lê Văn C',
            text: 'Chụp ở đâu vậy?',
            time: '45m',
            avatarColor: Colors.orange,
            replies: [
              CommentData(
                userName: 'Nguyễn Văn A',
                text: 'Ở Đà Lạt nè bạn 🌿',
                time: '30m',
                avatarColor: Colors.blue,
                likeCount: 1,
              ),
            ],
          ),
        ],
      ),
      PostItemData(
        userName: 'Trần Thị B',
        time: '5h',
        content:
            'Vừa hoàn thành dự án Flutter đầu tiên! 🎉🚀\n\n#flutter #dart #mobile',
        likes: 256,
        commentsCount: 89,
        shares: 34,
        color: Colors.purple,
        images: List.generate(2, (_) => PostImage(assetPath: _randomAsset(r))),
        commentItems: const [
          CommentData(
            userName: 'Phạm Văn D',
            text: 'Chúc mừng bạn! 🎊',
            time: '4h',
            avatarColor: Colors.teal,
            likeCount: 5,
          ),
        ],
      ),
      PostItemData(
        userName: 'Lê Văn C',
        time: '1d',
        content: 'Cuộc sống là những chuyến đi... ✈️🌍',
        likes: 89,
        commentsCount: 23,
        shares: 5,
        color: Colors.orange,
        images: List.generate(3, (_) => PostImage(assetPath: _randomAsset(r))),
      ),
      PostItemData(
        userName: 'Phạm Văn D',
        time: '2d',
        content: 'Bộ sưu tập ảnh cuối tuần 📸',
        likes: 340,
        commentsCount: 67,
        shares: 18,
        color: Colors.teal,
        images: List.generate(4, (_) => PostImage(assetPath: _randomAsset(r))),
        commentItems: const [
          CommentData(
            userName: 'Nguyễn Văn A',
            text: 'Ảnh đẹp quá! Máy gì vậy bạn?',
            time: '1d',
            avatarColor: Colors.blue,
            likeCount: 2,
            replies: [
              CommentData(
                userName: 'Phạm Văn D',
                text: 'Mình chụp bằng iPhone 15 Pro thôi 😄',
                time: '23h',
                avatarColor: Colors.teal,
              ),
              CommentData(
                userName: 'Trần Thị B',
                text: 'Giỏi quá vậy!',
                time: '22h',
                avatarColor: Colors.purple,
                likeCount: 1,
              ),
            ],
          ),
        ],
      ),
      PostItemData(
        userName: 'Hoàng Thị E',
        time: '3d',
        content: 'Album du lịch Phú Quốc 🏖️🌊🐚',
        likes: 512,
        commentsCount: 134,
        shares: 45,
        color: Colors.indigo,
        images: List.generate(6, (_) => PostImage(assetPath: _randomAsset(r))),
        commentItems: const [
          CommentData(
            userName: 'Lê Văn C',
            text: 'Phú Quốc đẹp lắm luôn! Mình cũng muốn đi 🥺',
            time: '2d',
            avatarColor: Colors.orange,
            likeCount: 8,
          ),
        ],
      ),
      const PostItemData(
        userName: 'Mai Văn F',
        time: '4d',
        content:
            '"Hãy sống mỗi ngày như thể đó là ngày cuối cùng." 🌟\n\n— Steve Jobs',
        likes: 78,
        commentsCount: 12,
        shares: 3,
        color: Colors.red,
      ),
    ];
    _posts.addAll(_initialPosts);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: StorySection()),
          SliverToBoxAdapter(
            child: PostCreateCard(
              currentUserName: 'Bạn',
              currentUserColor: Colors.blueAccent,
              onPostCreated: (post) {
                setState(() => _posts.insert(0, post));
              },
            ),
          ),
          const SliverToBoxAdapter(
            child: Divider(thickness: 8, color: Color(0xFFEEEEEE)),
          ),
          PostLayout(posts: _posts),
        ],
      ),
    );
  }
}
