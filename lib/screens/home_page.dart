import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Stories Section
          SliverToBoxAdapter(
            child: Container(
              height: 200,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                children: [
                  _buildCreateStory(t),
                  _buildStoryItem('Nguyễn Văn A', Colors.blue),
                  _buildStoryItem('Trần Thị B', Colors.purple),
                  _buildStoryItem('Lê Văn C', Colors.orange),
                  _buildStoryItem('Phạm Thị D', Colors.green),
                  _buildStoryItem('Hoàng Văn E', Colors.red),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Divider(thickness: 8, color: Color(0xFFEEEEEE)),
          ),
          // Posts
          SliverList(
            delegate: SliverChildListDelegate([
              _buildPost(
                context,
                t,
                userName: 'Nguyễn Văn A',
                time: '2h',
                content: 'Hôm nay trời đẹp quá! 🌞',
                likes: 120,
                comments: 45,
                shares: 12,
                color: Colors.blue,
              ),
              const Divider(thickness: 8, color: Color(0xFFEEEEEE)),
              _buildPost(
                context,
                t,
                userName: 'Trần Thị B',
                time: '5h',
                content:
                    'Vừa hoàn thành dự án Flutter đầu tiên! 🎉🚀\n\n#flutter #dart #mobile',
                likes: 256,
                comments: 89,
                shares: 34,
                color: Colors.purple,
                hasImage: true,
              ),
              const Divider(thickness: 8, color: Color(0xFFEEEEEE)),
              _buildPost(
                context,
                t,
                userName: 'Lê Văn C',
                time: '1d',
                content: 'Cuộc sống là những chuyến đi... ✈️🌍',
                likes: 89,
                comments: 23,
                shares: 5,
                color: Colors.orange,
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateStory(AppLocalizations t) {
    return Container(
      width: 110,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              child: const Center(
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.person, color: Colors.white, size: 30),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  t.translate('home_your_story'),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryItem(String name, Color color) {
    return Container(
      width: 110,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withValues(alpha: 0.8), color.withValues(alpha: 0.4)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: color,
                child: Text(
                  name[0],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            left: 8,
            right: 8,
            child: Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPost(
    BuildContext context,
    AppLocalizations t, {
    required String userName,
    required String time,
    required String content,
    required int likes,
    required int comments,
    required int shares,
    required Color color,
    bool hasImage = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: color,
                child: Text(
                  userName[0],
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
                      userName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Text(
                          time,
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
          const SizedBox(height: 10),
          // Content
          Text(content, style: const TextStyle(fontSize: 15)),
          if (hasImage) ...[
            const SizedBox(height: 10),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                  colors: [
                    color.withValues(alpha: 0.3),
                    color.withValues(alpha: 0.1),
                  ],
                ),
              ),
              child: Center(child: Icon(Icons.image, size: 60, color: color)),
            ),
          ],
          const SizedBox(height: 10),
          // Like/Comment count
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
                  Text('$likes', style: TextStyle(color: Colors.grey.shade600)),
                ],
              ),
              Text(
                '$comments ${t.translate('home_comment')}  •  $shares ${t.translate('home_share')}',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
            ],
          ),
          const Divider(),
          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildActionButton(
                Icons.thumb_up_outlined,
                t.translate('home_like'),
              ),
              _buildActionButton(
                Icons.chat_bubble_outline,
                t.translate('home_comment'),
              ),
              _buildActionButton(
                Icons.share_outlined,
                t.translate('home_share'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return TextButton.icon(
      onPressed: () {},
      icon: Icon(icon, color: Colors.grey.shade700, size: 20),
      label: Text(
        label,
        style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
      ),
    );
  }
}
