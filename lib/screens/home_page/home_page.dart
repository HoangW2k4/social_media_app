import 'package:flutter/material.dart';
import 'package:social_media_app/screens/home_page/widgets/story_section.dart';
import 'widgets/post_item.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const _posts = [
    PostItemData(
      userName: 'Nguyễn Văn A',
      time: '2h',
      content: 'Hôm nay trời đẹp quá! 🌞',
      likes: 120,
      commentsCount: 45,
      shares: 12,
      color: Colors.blue,
      images: [PostImage(color: Color(0xFF4A90D9))],
      commentItems: [
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
    // ─── 2 images ─────────────────────────────
    PostItemData(
      userName: 'Trần Thị B',
      time: '5h',
      content:
          'Vừa hoàn thành dự án Flutter đầu tiên! 🎉🚀\n\n#flutter #dart #mobile',
      likes: 256,
      commentsCount: 89,
      shares: 34,
      color: Colors.purple,
      images: [
        PostImage(color: Color(0xFF7B1FA2)),
        PostImage(color: Color(0xFF9C27B0)),
      ],
      commentItems: [
        CommentData(
          userName: 'Phạm Văn D',
          text: 'Chúc mừng bạn! 🎊',
          time: '4h',
          avatarColor: Colors.teal,
          likeCount: 5,
        ),
      ],
    ),
    // ─── 3 images ─────────────────────────────
    PostItemData(
      userName: 'Lê Văn C',
      time: '1d',
      content: 'Cuộc sống là những chuyến đi... ✈️🌍',
      likes: 89,
      commentsCount: 23,
      shares: 5,
      color: Colors.orange,
      images: [
        PostImage(color: Color(0xFFE65100)),
        PostImage(color: Color(0xFFF57C00)),
        PostImage(color: Color(0xFFFFB74D)),
      ],
    ),
    // ─── 4 images ─────────────────────────────
    PostItemData(
      userName: 'Phạm Văn D',
      time: '2d',
      content: 'Bộ sưu tập ảnh cuối tuần 📸',
      likes: 340,
      commentsCount: 67,
      shares: 18,
      color: Colors.teal,
      images: [
        PostImage(color: Color(0xFF00695C)),
        PostImage(color: Color(0xFF00897B)),
        PostImage(color: Color(0xFF26A69A)),
        PostImage(color: Color(0xFF80CBC4)),
      ],
      commentItems: [
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
    // ─── 5+ images (6 total, shows +1 overlay) ─
    PostItemData(
      userName: 'Hoàng Thị E',
      time: '3d',
      content: 'Album du lịch Phú Quốc 🏖️🌊🐚',
      likes: 512,
      commentsCount: 134,
      shares: 45,
      color: Colors.indigo,
      images: [
        PostImage(color: Color(0xFF283593)),
        PostImage(color: Color(0xFF3949AB)),
        PostImage(color: Color(0xFF5C6BC0)),
        PostImage(color: Color(0xFF7986CB)),
        PostImage(color: Color(0xFF9FA8DA)),
        PostImage(color: Color(0xFFC5CAE9)),
      ],
      commentItems: [
        CommentData(
          userName: 'Lê Văn C',
          text: 'Phú Quốc đẹp lắm luôn! Mình cũng muốn đi 🥺',
          time: '2d',
          avatarColor: Colors.orange,
          likeCount: 8,
        ),
      ],
    ),
    // ─── no image, text only ──────────────────
    PostItemData(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: StorySection()),
          const SliverToBoxAdapter(
            child: Divider(thickness: 8, color: Color(0xFFEEEEEE)),
          ),
          const PostLayout(posts: _posts),
        ],
      ),
    );
  }
}
