import 'dart:math';

import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import 'post_image_grid.dart';
import 'post_layout.dart';

/// Facebook-style "Create Post" card that sits at the top of the feed,
/// plus a full-screen compose page opened when tapped.
class PostCreateCard extends StatelessWidget {
  final String currentUserName;
  final Color currentUserColor;
  final ValueChanged<PostItemData> onPostCreated;

  const PostCreateCard({
    super.key,
    required this.currentUserName,
    required this.currentUserColor,
    required this.onPostCreated,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);

    return InkWell(
      onTap: () => _openComposePage(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: currentUserColor,
              child: Text(
                currentUserName[0],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  t.translate('home_whats_on_your_mind'),
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.photo_library, color: Colors.green.shade600, size: 26),
          ],
        ),
      ),
    );
  }

  Future<void> _openComposePage(BuildContext context) async {
    final result = await Navigator.of(context).push<PostItemData>(
      MaterialPageRoute(
        builder: (_) => _ComposePostPage(
          currentUserName: currentUserName,
          currentUserColor: currentUserColor,
        ),
      ),
    );
    if (result != null) {
      onPostCreated(result);
    }
  }
}

class _ComposePostPage extends StatefulWidget {
  final String currentUserName;
  final Color currentUserColor;

  const _ComposePostPage({
    required this.currentUserName,
    required this.currentUserColor,
  });

  @override
  State<_ComposePostPage> createState() => _ComposePostPageState();
}

class _ComposePostPageState extends State<_ComposePostPage> {
  final _captionController = TextEditingController();
  final _random = Random();
  final List<PostImage> _selectedImages = [];
  bool _isPosting = false;

  bool get _canPost =>
      _captionController.text.trim().isNotEmpty || _selectedImages.isNotEmpty;

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  // Simulate picking images by randomly selecting from asset images.
  void _pickImages() {
    // Pick 1-4 random images
    final count = _random.nextInt(4) + 1;
    final picked = List.generate(
      count,
      (_) => PostImage(
        assetPath: 'assets/images/img_${_random.nextInt(30) + 1}.jpg',
      ),
    );
    setState(() {
      _selectedImages.addAll(picked);
    });
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _submitPost() async {
    if (!_canPost) return;
    setState(() => _isPosting = true);

    // Simulate a short network delay
    await Future.delayed(const Duration(milliseconds: 400));

    if (!mounted) return;

    final post = PostItemData(
      userName: widget.currentUserName,
      time: AppLocalizations.of(context).translate('post_now'),
      content: _captionController.text.trim(),
      likes: 0,
      commentsCount: 0,
      shares: 0,
      color: widget.currentUserColor,
      images: List.of(_selectedImages),
    );

    Navigator.of(context).pop(post);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.translate('post_create_title')),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilledButton(
              onPressed: _canPost && !_isPosting ? _submitPost : null,
              child: _isPosting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(t.translate('post_create_post_btn')),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── User header ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: widget.currentUserColor,
                  child: Text(
                    widget.currentUserName[0],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.currentUserName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.public,
                          size: 14,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          t.translate('post_create_public'),
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Caption text field ──
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: TextField(
                controller: _captionController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                style: const TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  hintText: t.translate('home_whats_on_your_mind'),
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 18,
                  ),
                  border: InputBorder.none,
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
          ),

          // ── Selected images preview ──
          if (_selectedImages.isNotEmpty) _buildImagePreview(),

          // ── Bottom toolbar ──
          const Divider(height: 1),
          _buildToolbar(t),
        ],
      ),
    );
  }

  Widget _buildImagePreview() {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: _selectedImages.length,
        itemBuilder: (context, index) {
          final img = _selectedImages[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: img.assetPath != null
                      ? Image.asset(
                          img.assetPath!,
                          width: 100,
                          height: 104,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 100,
                          height: 104,
                          color: img.color ?? Colors.grey.shade300,
                        ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () => _removeImage(index),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const Icon(
                        Icons.close,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildToolbar(AppLocalizations t) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          children: [
            _toolbarButton(
              icon: Icons.photo_library,
              color: Colors.green.shade600,
              label: t.translate('post_create_photo'),
              onTap: _pickImages,
            ),
            _toolbarButton(
              icon: Icons.camera_alt,
              color: Colors.blue.shade600,
              label: t.translate('post_create_camera'),
              onTap: _pickImages,
            ),
            _toolbarButton(
              icon: Icons.emoji_emotions_outlined,
              color: Colors.amber.shade700,
              label: t.translate('post_create_feeling'),
              onTap: () {},
            ),
            _toolbarButton(
              icon: Icons.location_on,
              color: Colors.red.shade600,
              label: t.translate('post_create_location'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _toolbarButton({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
