import 'dart:io';

import 'package:ai_forma/core/constants/api_endpoint.dart';
import 'package:ai_forma/core/constants/app_images.dart';
import 'package:ai_forma/core/services/app_image_cache_manager.dart';
import 'package:ai_forma/core/widgets/app_cached_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final tempDir = Directory.systemTemp.createTempSync('aiforma_cache_test_');

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    const pathChannel = MethodChannel('plugins.flutter.io/path_provider');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathChannel, (MethodCall methodCall) async {
      return tempDir.path;
    });
  });

  tearDownAll(() {
    try {
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    } catch (_) {}
  });

  group('AppCachedNetworkImage & AppImageCacheManager Tests', () {
    test('AppImageCacheManager singleton is configured properly', () {
      expect(AppImageCacheManager.instance, isNotNull);
      expect(AppImageCacheManager.key, equals('aiforma_image_cache_v2'));
    });

    test('resolveUrl correctly resolves full, relative, and empty URLs', () {
      expect(AppCachedNetworkImage.resolveUrl(null), equals(''));
      expect(AppCachedNetworkImage.resolveUrl(''), equals(''));
      expect(AppCachedNetworkImage.resolveUrl('   '), equals(''));

      // Full URLs
      expect(
        AppCachedNetworkImage.resolveUrl('https://example.com/photo.jpg'),
        equals('https://example.com/photo.jpg'),
      );
      expect(
        AppCachedNetworkImage.resolveUrl('http://example.com/photo.jpg'),
        equals('http://example.com/photo.jpg'),
      );

      // Relative URLs
      expect(
        AppCachedNetworkImage.resolveUrl('/media/scans/front.jpg'),
        equals('${ApiEndpoint.baseUrl}/media/scans/front.jpg'),
      );
      expect(
        AppCachedNetworkImage.resolveUrl('media/scans/front.jpg'),
        equals('${ApiEndpoint.baseUrl}/media/scans/front.jpg'),
      );
    });

    test('extractCacheKey correctly normalizes S3 presigned and query-based URLs', () {
      expect(AppCachedNetworkImage.extractCacheKey(null), equals(''));
      expect(AppCachedNetworkImage.extractCacheKey(''), equals(''));

      const s3Url1 =
          'https://aiforma.s3.amazonaws.com/scans/user1/front.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20261112T050000Z&X-Amz-Signature=sig1';
      const s3Url2 =
          'https://aiforma.s3.amazonaws.com/scans/user1/front.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20261112T053000Z&X-Amz-Signature=sig2';

      final key1 = AppCachedNetworkImage.extractCacheKey(s3Url1);
      final key2 = AppCachedNetworkImage.extractCacheKey(s3Url2);

      // Both must yield the exact same cache key despite different signatures!
      expect(key1, equals('https://aiforma.s3.amazonaws.com/scans/user1/front.jpg'));
      expect(key2, equals('https://aiforma.s3.amazonaws.com/scans/user1/front.jpg'));
      expect(key1, equals(key2));

      // Regular URL without query params remains identical
      expect(
        AppCachedNetworkImage.extractCacheKey('https://example.com/photo.jpg'),
        equals('https://example.com/photo.jpg'),
      );
    });

    test('provider returns fallback AssetImage for empty/null URL and CachedNetworkImageProvider for valid URL', () {
      final fallbackProvider = AppCachedNetworkImage.provider(null);
      expect(fallbackProvider, isA<AssetImage>());
      expect((fallbackProvider as AssetImage).assetName, equals(AppImages.logo));

      final networkProvider = AppCachedNetworkImage.provider('https://example.com/image.jpg');
      expect(networkProvider, isA<CachedNetworkImageProvider>());
      final cached = networkProvider as CachedNetworkImageProvider;
      expect(cached.url, equals('https://example.com/image.jpg'));
      expect(cached.cacheKey, equals('https://example.com/image.jpg'));
      expect(cached.cacheManager, equals(AppImageCacheManager.instance));
    });

    test('evict runs safely without throwing for empty or null URLs', () async {
      await expectLater(AppCachedNetworkImage.evict(null), completes);
      await expectLater(AppCachedNetworkImage.evict(''), completes);
      await expectLater(AppCachedNetworkImage.evict('   '), completes);
    });

    testWidgets('renders error widget when URL is empty', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppCachedNetworkImage(
              imageUrl: '',
              width: 100,
              height: 100,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.broken_image_rounded), findsOneWidget);
    });
  });
}
