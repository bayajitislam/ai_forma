import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ai_forma/core/constants/api_endpoint.dart';
import 'package:ai_forma/core/constants/app_images.dart';
import 'package:ai_forma/core/theme/app_colors.dart';

/// Reusable cached network image widget with disk/memory caching,
/// smooth neutral grey shimmer placeholder on first download, instant cached rendering,
/// and optional autoOrient to ensure vertical scans stay upright in portrait.
class AppCachedNetworkImage extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;
  final bool autoOrient;
  final bool useOldImageOnUrlChange;

  const AppCachedNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
    this.autoOrient = true,
    this.useOldImageOnUrlChange = false,
  });

  /// Helper to ensure relative URLs have full baseUrl prefix
  static String resolveUrl(String? url) {
    if (url == null || url.trim().isEmpty) return '';
    final trimmed = url.trim();
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    if (trimmed.startsWith('/')) {
      return '${ApiEndpoint.baseUrl}$trimmed';
    }
    return '${ApiEndpoint.baseUrl}/$trimmed';
  }

  /// Helper ImageProvider for CircleAvatar and BoxDecoration
  static ImageProvider provider(String? url) {
    final cleanUrl = resolveUrl(url);
    if (cleanUrl.isEmpty) {
      return const AssetImage(AppImages.logo);
    }
    return CachedNetworkImageProvider(cleanUrl);
  }

  @override
  State<AppCachedNetworkImage> createState() => _AppCachedNetworkImageState();
}

class _AppCachedNetworkImageState extends State<AppCachedNetworkImage> {
  ImageStream? _imageStream;
  ImageStreamListener? _streamListener;
  bool _isLandscape = false;

  @override
  void initState() {
    super.initState();
    if (widget.autoOrient) {
      _resolveOrientation();
    }
  }

  @override
  void didUpdateWidget(AppCachedNetworkImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.autoOrient &&
        (oldWidget.imageUrl != widget.imageUrl || !oldWidget.autoOrient)) {
      _stopListening();
      _isLandscape = false;
      _resolveOrientation();
    } else if (!widget.autoOrient && oldWidget.autoOrient) {
      _stopListening();
      _isLandscape = false;
    }
  }

  void _resolveOrientation() {
    final cleanUrl = AppCachedNetworkImage.resolveUrl(widget.imageUrl);
    if (cleanUrl.isEmpty) return;

    final provider = CachedNetworkImageProvider(cleanUrl);
    _imageStream = provider.resolve(const ImageConfiguration());
    _streamListener = ImageStreamListener(
      (ImageInfo info, bool _) {
        if (mounted) {
          final isLandscape = info.image.width > info.image.height;
          if (_isLandscape != isLandscape) {
            setState(() {
              _isLandscape = isLandscape;
            });
          }
        }
      },
      onError: (dynamic _, StackTrace? _) {},
    );
    _imageStream?.addListener(_streamListener!);
  }

  void _stopListening() {
    if (_imageStream != null && _streamListener != null) {
      _imageStream!.removeListener(_streamListener!);
    }
    _imageStream = null;
    _streamListener = null;
  }

  @override
  void dispose() {
    _stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cleanUrl = AppCachedNetworkImage.resolveUrl(widget.imageUrl);
    if (cleanUrl.isEmpty) {
      return _buildErrorWidget();
    }

    final bool shouldRotate = widget.autoOrient && _isLandscape;

    Widget imageWidget = CachedNetworkImage(
      imageUrl: cleanUrl,
      width: shouldRotate ? null : widget.width,
      height: shouldRotate ? null : widget.height,
      fit: widget.fit,
      fadeInDuration: Duration.zero,
      fadeOutDuration: Duration.zero,
      useOldImageOnUrlChange: widget.useOldImageOnUrlChange,
      placeholder: (context, url) =>
          widget.placeholder ??
          _ShimmerPlaceholder(
            width: widget.width,
            height: widget.height,
            borderRadius: widget.borderRadius,
          ),
      errorWidget: (context, url, error) =>
          widget.errorWidget ?? _buildErrorWidget(),
    );

    if (shouldRotate) {
      imageWidget = SizedBox(
        width: widget.width,
        height: widget.height,
        child: Center(
          child: RotatedBox(
            quarterTurns: 1,
            child: imageWidget,
          ),
        ),
      );
    }

    if (widget.borderRadius != null) {
      return ClipRRect(
        borderRadius: widget.borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  Widget _buildErrorWidget() {
    return Container(
      width: widget.width,
      height: widget.height,
      color: AppColors.surface,
      child: const Center(
        child: Icon(
          Icons.broken_image_rounded,
          color: AppColors.textSecondary,
          size: 24,
        ),
      ),
    );
  }
}

/// Smooth neutral grey pulse shimmer skeleton for first-time image downloading
class _ShimmerPlaceholder extends StatefulWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const _ShimmerPlaceholder({
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  State<_ShimmerPlaceholder> createState() => _ShimmerPlaceholderState();
}

class _ShimmerPlaceholderState extends State<_ShimmerPlaceholder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: Color.lerp(
              const Color(0xFFE0E0E0),
              const Color(0xFFF5F5F5),
              _animation.value,
            ),
            borderRadius: widget.borderRadius,
          ),
          child: const Center(
            child: Icon(
              Icons.image_outlined,
              color: Color(0xFFB0B0B0),
              size: 24,
            ),
          ),
        );
      },
    );
  }
}
