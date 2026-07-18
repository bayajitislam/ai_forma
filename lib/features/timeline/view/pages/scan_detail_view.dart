import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/constants/app_images.dart';
import 'package:ai_forma/core/widgets/app_brand_text.dart';

class ScanDetailView extends StatefulWidget {
  final String date;

  const ScanDetailView({super.key, required this.date});

  @override
  State<ScanDetailView> createState() => _ScanDetailViewState();
}

class _ScanDetailViewState extends State<ScanDetailView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int _currentPhotoIndex = 0;

  final List<_PhotoViewItem> _photos = [
    _PhotoViewItem(title: 'Front View', imagePath: AppImages.frontView),
    _PhotoViewItem(title: 'Side View', imagePath: AppImages.sideView),
    _PhotoViewItem(title: 'Back View', imagePath: AppImages.backView),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _nextPhoto() {
    setState(() {
      _currentPhotoIndex = (_currentPhotoIndex + 1) % _photos.length;
    });
  }

  void _previousPhoto() {
    setState(() {
      _currentPhotoIndex =
          (_currentPhotoIndex - 1 + _photos.length) % _photos.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.textPrimary,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Center(child: AppBrandText(height: 22, width: 120)),
        actions: const [
          SizedBox(width: 48),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.brandTeal,
          indicatorWeight: 3,
          labelColor: AppColors.brandTeal,
          unselectedLabelColor: AppColors.textSecondary,
          dividerColor: AppColors.cardBorder,
          labelStyle: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          indicatorSize: TabBarIndicatorSize.label,
          tabs: const [
            Tab(text: 'Summary'),
            Tab(text: 'Photos'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildSummaryTab(), _buildPhotosTab()],
      ),
    );
  }

  Widget _buildSummaryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Overview',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildMetricCard(
            label: 'Body Fat',
            value: '18.2%',
            trendWidget: _buildTrendBadge('↓ 0.6%', isPositive: true),
          ),
          const SizedBox(height: 12),
          _buildMetricCard(
            label: 'Lean Muscle',
            value: '71.5 kg',
            trendWidget: _buildTrendBadge('↑ 0.8 kg', isPositive: true),
          ),
          const SizedBox(height: 12),
          _buildMetricCard(
            label: 'Weight',
            value: '87.4 kg',
            trendWidget: _buildTrendBadge('↓ 0.6 kg', isPositive: true),
          ),
          const SizedBox(height: 12),
          _buildMetricCard(
            label: 'Momentum',
            value: '82/100',
            trendWidget: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotosTab() {
    final photo = _photos[_currentPhotoIndex];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        children: [
          // Sub-header info
          Text(
            '${widget.date}, 2025',
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${_currentPhotoIndex + 1} of ${_photos.length}',
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          // Main Image Preview with overlaid arrows
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Image
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 33),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(photo.imagePath, fit: BoxFit.cover),
                  ),
                ),
                // Left arrow
                if (_currentPhotoIndex > 0)
                  Positioned(
                    left: 0,
                    child: _buildArrowButton(
                      icon: Icons.arrow_back_ios_rounded,
                      onPressed: _previousPhoto,
                    ),
                  ),
                // Right arrow
                if (_currentPhotoIndex < _photos.length - 1)
                  Positioned(
                    right: 0,
                    child: _buildArrowButton(
                      icon: Icons.arrow_forward_ios_rounded,
                      onPressed: _nextPhoto,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Caption label
          const Text(
            'Latest Body Scan',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            photo.title,
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          // Dot indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _photos.length,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: i == _currentPhotoIndex ? 20 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: i == _currentPhotoIndex
                      ? AppColors.brandTeal
                      : AppColors.cardBorder,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildArrowButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.insightConsistencyIncompleteBg.withValues(alpha: 0.5),
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.cardBorder.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          color: AppColors.brandTeal,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required String label,
    required String value,
    required Widget trendWidget,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.insightConsistencyIncompleteBg.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.cardBorder.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          trendWidget,
        ],
      ),
    );
  }

  Widget _buildTrendBadge(String label, {required bool isPositive}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.insightBadgePositiveBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Nunito',
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: AppColors.brandTealDark,
        ),
      ),
    );
  }
}

class _PhotoViewItem {
  final String title;
  final String imagePath;

  _PhotoViewItem({required this.title, required this.imagePath});
}