import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import 'dart:math';
import 'story_detail.dart';

class StorySection extends StatefulWidget {
  const StorySection({super.key});

  @override
  State<StorySection> createState() => _StorySectionState();
}

class _StorySectionState extends State<StorySection> {
  static const List<String> _names = [
    'Nguyễn Văn A',
    'Trần Thị B',
    'Lê Văn C',
    'Phạm Thị D',
    'Hoàng Văn E',
  ];

  final List<_StoryVisual> _storyVisuals = [];

  List<StoryDetailData> get _storyDetails {
    return List.generate(
      _names.length,
      (index) => StoryDetailData(
        userName: _names[index],
        imagePath: _storyVisuals[index].imagePath,
        avatarColor: _storyVisuals[index].color,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    final random = Random();

    // Generate visuals once so language rebuilds do not reshuffle story images/colors.
    _storyVisuals.addAll(
      List.generate(
        _names.length,
        (_) => _StoryVisual(
          imagePath: 'assets/images/img_${random.nextInt(10) + 1}.jpg',
          color: Colors.primaries[random.nextInt(Colors.primaries.length)],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Container(
      height: 200,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: _names.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) return _buildCreateStory(t);

          final visual = _storyVisuals[index - 1];

          return _buildStoryItem(
            storyIndex: index - 1,
            name: _names[index - 1],
            color: visual.color,
            imagePath: visual.imagePath,
          );
        },
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

  Widget _buildStoryItem({
    required int storyIndex,
    required String name,
    required Color color,
    required String imagePath,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => StoryDetailPage(
              stories: _storyDetails,
              initialIndex: storyIndex,
            ),
          ),
        );
      },
      child: Container(
        width: 110,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.1),
                Colors.black.withValues(alpha: 0.5),
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 8,
                left: 8,
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: color,
                  child: Text(
                    name[0],
                    style: const TextStyle(color: Colors.white),
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
        ),
      ),
    );
  }
}

class _StoryVisual {
  final String imagePath;
  final Color color;

  const _StoryVisual({required this.imagePath, required this.color});
}
