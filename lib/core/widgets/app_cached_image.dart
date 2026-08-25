import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ai_forma/core/constants/api_endpoint.dart';
import 'package:ai_forma/core/theme/app_colors.dart';

/// Reusable cached network image widget with disk/memory caching,
/// smooth neutral grey shimmer placeholder on first download, and instant cached rendering.
class AppCachedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;

  const AppCachedNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
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
      return const AssetImage('assets/images/user.png');
    }
    return CachedNetworkImageProvider(cleanUrl);
  }

  @override
  Widget build(BuildContext context) {
    final cleanUrl = resolveUrl(imageUrl);
    if (cleanUrl.isEmpty) {
      return _buildErrorWidget();
    }

    Widget imageWidget = CachedNetworkImage(
      imageUrl: cleanUrl,
      width: width,
      height: height,
      fit: fit,
      fadeInDuration: Duration.zero,
      fadeOutDuration: Duration.zero,
      useOldImageOnUrlChange: true,
      placeholder: (context, url) =>
          placeholder ??
          _ShimmerPlaceholder(
            width: width,
            height: height,
            borderRadius: borderRadius,
          ),
      errorWidget: (context, url, error) =>
          errorWidget ?? _buildErrorWidget(),
    );

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  Widget _buildErrorWidget() {
    return Container(
      width: width,
      height: height,
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
