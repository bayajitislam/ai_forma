import 'dart:async';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// Custom FileService that wraps HttpFileService and enforces a 60-day minimum
/// cache validity on all downloaded image responses.
///
/// By default, HttpFileService respects server Cache-Control headers (such as no-cache,
/// no-store, or missing max-age), which causes flutter_cache_manager to mark the file
/// as expired and re-download it from the network every time the app opens.
/// This FileService guarantees downloaded images stay valid on disk across app restarts.
class AppHttpFileService extends HttpFileService {
  AppHttpFileService({super.httpClient});

  @override
  Future<FileServiceResponse> get(String url, {Map<String, String>? headers}) async {
    final response = await super.get(url, headers: headers);
    return _AppPersistentFileServiceResponse(response);
  }
}

class _AppPersistentFileServiceResponse implements FileServiceResponse {
  final FileServiceResponse _inner;
  _AppPersistentFileServiceResponse(this._inner);

  @override
  Stream<List<int>> get content => _inner.content;

  @override
  int? get contentLength => _inner.contentLength;

  @override
  int get statusCode => _inner.statusCode;

  @override
  String? get eTag => _inner.eTag;

  @override
  String get fileExtension => _inner.fileExtension;

  @override
  DateTime get validTill {
    // Guarantees cached images remain valid locally for 60 days.
    // This prevents re-downloading on every app launch even if the backend
    // sends no-cache or short max-age headers.
    final innerValid = _inner.validTill;
    final minValid = DateTime.now().add(const Duration(days: 60));
    return innerValid.isAfter(minValid) ? innerValid : minValid;
  }
}

/// Dedicated singleton CacheManager for AiFORMA network images.
/// Ensures persistent local disk caching across app restarts, automatic
/// eviction of least-recently-used images, and fast cache-busting.
class AppImageCacheManager extends CacheManager with ImageCacheManager {
  static const String key = 'aiforma_image_cache_v2';

  static final AppImageCacheManager _instance = AppImageCacheManager._();
  factory AppImageCacheManager() => _instance;
  static AppImageCacheManager get instance => _instance;

  AppImageCacheManager._()
      : super(
          Config(
            key,
            stalePeriod: const Duration(days: 60),
            maxNrOfCacheObjects: 400,
            fileService: AppHttpFileService(),
          ),
        ) {
    _cleanupLegacyCache();
  }

  /// Silently purges the old v1 cache in the background to free disk space.
  void _cleanupLegacyCache() {
    scheduleMicrotask(() async {
      try {
        final legacyCache = CacheManager(Config('aiforma_image_cache'));
        await legacyCache.emptyCache();
      } catch (_) {}
    });
  }

  /// Evicts a specific image URL or key from the local disk cache.
  static Future<void> evict(String? url) async {
    if (url == null || url.trim().isEmpty) return;
    try {
      await _instance.removeFile(url.trim());
    } catch (_) {}
  }

  /// Clears all cached images from the local disk cache.
  static Future<void> clearCache() async {
    try {
      await _instance.emptyCache();
    } catch (_) {}
  }
}
