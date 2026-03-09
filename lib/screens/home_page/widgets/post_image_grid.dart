import 'package:flutter/material.dart';

/// Facebook-style image grid layouts for 1–5+ images.
class PostImageGrid extends StatelessWidget {
  final List<PostImage> images;
  final double spacing;

  const PostImageGrid({super.key, required this.images, this.spacing = 2});

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) return const SizedBox.shrink();

    return ClipRRect(
      borderRadius: BorderRadius.circular(0),
      child: switch (images.length) {
        1 => _layout1(),
        2 => _layout2(),
        3 => _layout3(),
        4 => _layout4(),
        _ => _layout5Plus(),
      },
    );
  }

  /// Style 1: Single image, full width, aspect ratio ~1:0.75
  Widget _layout1() {
    return AspectRatio(aspectRatio: 1200 / 900, child: _imageCell(images[0]));
  }

  /// Style 2: Two equal images side by side (1:1 each)
  Widget _layout2() {
    return AspectRatio(
      aspectRatio: 2 / 1,
      child: Row(
        children: [
          Expanded(child: _imageCell(images[0])),
          SizedBox(width: spacing),
          Expanded(child: _imageCell(images[1])),
        ],
      ),
    );
  }

  /// Style 3: One tall image left + two stacked right
  Widget _layout3() {
    return AspectRatio(
      aspectRatio: 1,
      child: Row(
        children: [
          Expanded(flex: 1, child: _imageCell(images[0])),
          SizedBox(width: spacing),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Expanded(child: _imageCell(images[1])),
                SizedBox(height: spacing),
                Expanded(child: _imageCell(images[2])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Style 4: 2×2 grid
  Widget _layout4() {
    return AspectRatio(
      aspectRatio: 1,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(child: _imageCell(images[0])),
                SizedBox(width: spacing),
                Expanded(child: _imageCell(images[1])),
              ],
            ),
          ),
          SizedBox(height: spacing),
          Expanded(
            child: Row(
              children: [
                Expanded(child: _imageCell(images[2])),
                SizedBox(width: spacing),
                Expanded(child: _imageCell(images[3])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Style 5+: 2 on top, 3 on bottom (last has +N overlay if >5)
  Widget _layout5Plus() {
    final remaining = images.length - 5;
    return AspectRatio(
      aspectRatio: 0.9,
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Expanded(child: _imageCell(images[0])),
                SizedBox(width: spacing),
                Expanded(child: _imageCell(images[1])),
              ],
            ),
          ),
          SizedBox(height: spacing),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Expanded(child: _imageCell(images[2])),
                SizedBox(width: spacing),
                Expanded(child: _imageCell(images[3])),
                SizedBox(width: spacing),
                Expanded(
                  child: remaining > 0
                      ? _overlayCell(images[4], '+$remaining')
                      : _imageCell(images[4]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageCell(PostImage img) {
    return GestureDetector(
      onTap: img.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: img.color ?? Colors.grey.shade300,
          image: img.url != null
              ? DecorationImage(
                  image: NetworkImage(img.url!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: img.url == null
            ? Center(
                child: Icon(
                  img.isVideo ? Icons.play_circle_fill : Icons.image,
                  size: 40,
                  color: Colors.white70,
                ),
              )
            : null,
      ),
    );
  }

  Widget _overlayCell(PostImage img, String text) {
    return GestureDetector(
      onTap: img.onTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _imageCell(img),
          Container(
            color: Colors.black54,
            child: Center(
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PostImage {
  final String? url;
  final Color? color;
  final bool isVideo;
  final VoidCallback? onTap;

  const PostImage({this.url, this.color, this.isVideo = false, this.onTap});
}
