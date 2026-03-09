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
  static const Duration _storyTransitionDuration = Duration(milliseconds: 240);
  static const double _swipeVelocityThreshold = 250;
  static const double _dismissDragDistance = 140;
  static const double _dismissVelocityThreshold = 900;

  late int _currentIndex;
  int _storyDirection = 1;
  int _progressTicker = 0;
  double _progress = 0;
  double _verticalDragOffset = 0;
  bool _isVerticalDragging = false;

  StoryDetailData get _currentStory => widget.stories[_currentIndex];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _startAutoCloseProgress();
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
        _goToStory(isNext: true);
        return false;
      }

      await Future<void>.delayed(const Duration(milliseconds: 16));
      return true;
    });
  }

  void _goToStory({required bool isNext}) {
    final delta = isNext ? 1 : -1;
    final target = _currentIndex + delta;

    if (target < 0) {
      Navigator.of(context).pop();
      return;
    }

    if (target >= widget.stories.length) {
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      _storyDirection = isNext ? 1 : -1;
      _currentIndex = target;
    });
    _startAutoCloseProgress();
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    final next = (_verticalDragOffset + details.delta.dy).clamp(0.0, 320.0);
    setState(() {
      _isVerticalDragging = true;
      _verticalDragOffset = next;
    });
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    final shouldClose =
        _verticalDragOffset >= _dismissDragDistance ||
        velocity >= _dismissVelocityThreshold;

    if (shouldClose) {
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      _isVerticalDragging = false;
      _verticalDragOffset = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dragOpacity = (1 - (_verticalDragOffset / 260)).clamp(0.65, 1.0);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragEnd: (details) {
            final velocity = details.primaryVelocity ?? 0;
            if (velocity <= -_swipeVelocityThreshold) {
              _goToStory(isNext: true);
            } else if (velocity >= _swipeVelocityThreshold) {
              _goToStory(isNext: false);
            }
          },
          onVerticalDragUpdate: _onVerticalDragUpdate,
          onVerticalDragEnd: _onVerticalDragEnd,
          child: AnimatedContainer(
            duration: _isVerticalDragging
                ? Duration.zero
                : const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            transform: Matrix4.translationValues(0, _verticalDragOffset, 0),
            child: Opacity(
              opacity: dragOpacity,
              child: AnimatedSwitcher(
                duration: _storyTransitionDuration,
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) {
                  final beginOffset = Offset(_storyDirection * 0.14, 0);
                  final slide = Tween<Offset>(
                    begin: beginOffset,
                    end: Offset.zero,
                  ).animate(animation);

                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(position: slide, child: child),
                  );
                },
                child: Stack(
                  key: ValueKey<int>(_currentIndex),
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        _currentStory.imagePath,
                        fit: BoxFit.cover,
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
                      child: _buildTopOverlay(context),
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
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopOverlay(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            minHeight: 3,
            value: _progress,
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
                backgroundColor: _currentStory.avatarColor,
                child: Text(
                  _currentStory.userName[0],
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
                          _currentStory.userName,
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
                        _currentStory.timeAgo,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  if (_currentStory.sponsored)
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
