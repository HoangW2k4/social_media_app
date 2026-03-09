import 'dart:math' as math;
import 'package:flutter/material.dart';

class StoryDetailData {
  final String userName;
  final String imagePath;
  final Color avatarColor;
  final String timeAgo;
  final bool sponsored;

  const StoryDetailData({
    required this.userName,
    required this.imagePath,
    required this.avatarColor,
    this.timeAgo = '22h',
    this.sponsored = false,
  });
}

class StoryDetailPage extends StatefulWidget {
  final List<StoryDetailData> stories;
  final int initialIndex;

  const StoryDetailPage({
    super.key,
    required this.stories,
    required this.initialIndex,
  }) : assert(stories.length > 0),
       assert(initialIndex >= 0 && initialIndex < stories.length);

  @override
  State<StoryDetailPage> createState() => _StoryDetailPageState();
}

class _StoryDetailPageState extends State<StoryDetailPage> {
  static const Duration _storyDuration = Duration(seconds: 8);
  static const double _dismissDragDistance = 140;
  static const double _dismissVelocityThreshold = 900;

  late PageController _pageController;
  late int _currentIndex;
  int _progressTicker = 0;
  double _progress = 0;
  double _pageValue = 0;

  // Vertical drag-to-dismiss state
  double _verticalDragOffset = 0;
  bool _isVerticalDragging = false;

  StoryDetailData get _currentStory => widget.stories[_currentIndex];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
    _pageValue = _currentIndex.toDouble();

    _pageController.addListener(() {
      setState(() {
        _pageValue = _pageController.page ?? _currentIndex.toDouble();
      });
    });

    _startAutoCloseProgress();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoCloseProgress() {
    _progressTicker++;
    final ticker = _progressTicker;
    setState(() {
      _progress = 0;
    });

    final start = DateTime.now();
    Future.doWhile(() async {
      if (!mounted) return false;
      if (ticker != _progressTicker) return false;

      final elapsed = DateTime.now().difference(start);
      final value = elapsed.inMilliseconds / _storyDuration.inMilliseconds;

      setState(() {
        _progress = value.clamp(0, 1);
      });

      if (_progress >= 1) {
        _goToNextOrClose();
        return false;
      }

      await Future<void>.delayed(const Duration(milliseconds: 16));
      return true;
    });
  }

  void _goToNextOrClose() {
    final next = _currentIndex + 1;
    if (next >= widget.stories.length) {
      Navigator.of(context).pop();
      return;
    }
    _pageController.animateToPage(
      next,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeInOutCubic,
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    _startAutoCloseProgress();
  }

  // --- Vertical drag-to-dismiss ---
  void _onVerticalDragUpdate(DragUpdateDetails details) {
    final next = (_verticalDragOffset + details.delta.dy).clamp(0.0, 320.0);
    setState(() {
      _isVerticalDragging = true;
      _verticalDragOffset = next;
    });
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    if (_verticalDragOffset >= _dismissDragDistance ||
        velocity >= _dismissVelocityThreshold) {
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      _isVerticalDragging = false;
      _verticalDragOffset = 0;
    });
  }

  // --- Cube 3D transform for each page ---
  Widget _buildCubePage(int index) {
    final story = widget.stories[index];
    final diff = index - _pageValue;
    final rotationY = diff * (math.pi / 2.8);

    final isLeaving = diff.abs() > 0.5;
    final transform = Matrix4.identity()
      ..setEntry(3, 2, 0.002)
      ..rotateY(rotationY);

    transform.setTranslationRaw(
      diff < 0 ? -diff * MediaQuery.of(context).size.width * 0.8 : 0,
      0,
      0,
    );

    return Transform(
      alignment: diff <= 0 ? Alignment.centerRight : Alignment.centerLeft,
      transform: transform,
      child: Opacity(
        opacity: (1 - diff.abs() * 0.6).clamp(0.0, 1.0),
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(isLeaving ? 10 : 0),
                child: Image.asset(story.imagePath, fit: BoxFit.cover),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x8A000000),
                      Color(0x1F000000),
                      Color(0x9E000000),
                    ],
                    stops: [0, 0.45, 1],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 8,
              left: 8,
              right: 8,
              child: _buildTopOverlay(context, story),
            ),
            Positioned(
              left: 10,
              right: 10,
              bottom: 12,
              child: _buildBottomActions(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dragOpacity = (1 - (_verticalDragOffset / 260)).clamp(0.65, 1.0);
    final dragScale = (1 - (_verticalDragOffset / 800)).clamp(0.85, 1.0);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onVerticalDragUpdate: _onVerticalDragUpdate,
          onVerticalDragEnd: _onVerticalDragEnd,
          child: AnimatedContainer(
            duration: _isVerticalDragging
                ? Duration.zero
                : const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            transform: Matrix4.identity()
              ..translate(0.0, _verticalDragOffset, 0.0)
              ..scale(dragScale),
            transformAlignment: Alignment.topCenter,
            child: Opacity(
              opacity: dragOpacity,
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.stories.length,
                onPageChanged: _onPageChanged,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) => _buildCubePage(index),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopOverlay(BuildContext context, StoryDetailData story) {
    final isActive = story == _currentStory;
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            minHeight: 3,
            value: isActive ? _progress : 0,
            backgroundColor: Colors.white.withValues(alpha: 0.25),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 17,
                backgroundColor: story.avatarColor,
                child: Text(
                  story.userName[0],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          story.userName,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        story.timeAgo,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  if (story.sponsored)
                    Text(
                      'Sponsored',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'More',
              onPressed: () {},
              icon: const Icon(Icons.more_horiz, color: Colors.white),
            ),
            IconButton(
              tooltip: 'Close',
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close, color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomActions() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 42,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              'Send message...',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.95),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        _buildReaction('❤', const Color(0xFFF1425D)),
        const SizedBox(width: 6),
        _buildReaction('👍', const Color(0xFF1B74E4)),
        const SizedBox(width: 6),
        _buildReaction('😂', const Color(0xFFF7B125)),
      ],
    );
  }

  Widget _buildReaction(String emoji, Color color) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(emoji, style: const TextStyle(fontSize: 20)),
    );
  }
}
