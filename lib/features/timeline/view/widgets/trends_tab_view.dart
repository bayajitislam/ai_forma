import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';

class TrendsTabView extends StatefulWidget {
  const TrendsTabView({super.key});

  @override
  State<TrendsTabView> createState() => _TrendsTabViewState();
}

class _TrendsTabViewState extends State<TrendsTabView> {
  String _selectedTimeframe = '4W';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 24, bottom: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Title & Timeframe selectors
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Body Fat %',
                  style: AppTextStyles.featureTitle.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.insightAnalysisTitle,
                  ),
                ),
                Row(
                  children: ['7D', '4W', '3M', '1Y'].map((timeframe) {
                    final isSelected = timeframe == _selectedTimeframe;
                    return Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTimeframe = timeframe;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.brandTealDark
                                : AppColors.border,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            timeframe,
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Large metric & subtitle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '18.2%',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '-2.3% vs last 4 weeks',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.brandTeal,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Trend Chart
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              height: 200,
              width: double.infinity,
              child: CustomPaint(painter: _BodyFatChartPainter()),
            ),
          ),
          const SizedBox(height: 32),
          // Trend Summary Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.dashboardBackground.withValues(alpha: 0.5),
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
                        'Trend',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Losing Body Fat',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: const [
                          Text(
                            'Current Rate',
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.trending_down,
                            size: 18,
                            color: AppColors.brandTeal,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '-0.58% / week',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BodyFatChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = AppColors.brandTeal
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final pointPaint = Paint()
      ..color = AppColors.brandTeal
      ..style = PaintingStyle.fill;

    // Y axis labels & values
    final yLabels = ['22', '20', '18', '14'];
    final yValues = [22.0, 20.0, 18.0, 14.0];

    // Data: (date, value)
    final data = [
      _TrendDataPoint(date: 'Apr 27', value: 20.0),
      _TrendDataPoint(date: 'May 4', value: 19.0),
      _TrendDataPoint(date: 'May 11', value: 18.2),
      _TrendDataPoint(date: 'May 18', value: 17.5),
    ];

    const leftPadding = 36.0;
    const rightPadding = 16.0;
    const bottomPadding = 30.0;
    const topPadding = 10.0;

    final chartWidth = size.width - leftPadding - rightPadding;
    final chartHeight = size.height - bottomPadding - topPadding;

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    // Draw Y axis labels
    for (int i = 0; i < yLabels.length; i++) {
      final val = yValues[i];
      final ratio = (val - 14.0) / (22.0 - 14.0); // normalize between 14 and 22
      final y = topPadding + chartHeight * (1.0 - ratio);

      textPainter.text = TextSpan(
        text: yLabels[i],
        style: TextStyle(
          color: AppColors.textSecondary.withValues(alpha: 0.5),
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: 'Nunito',
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(8, y - textPainter.height / 2));
    }

    final path = Path();
    final points = <Offset>[];

    // Draw Line and Points
    for (int i = 0; i < data.length; i++) {
      final dp = data[i];
      final xRatio = i / (data.length - 1);
      final x = leftPadding + chartWidth * xRatio;

      final yRatio = (dp.value - 14.0) / (22.0 - 14.0);
      final y = topPadding + chartHeight * (1.0 - yRatio);
      final point = Offset(x, y);
      points.add(point);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, linePaint);

    for (int i = 0; i < data.length; i++) {
      final point = points[i];
      final dp = data[i];

      // Draw point
      canvas.drawCircle(point, 7.0, pointPaint);

      // Draw X label (date)
      textPainter.text = TextSpan(
        text: dp.date,
        style: TextStyle(
          color: AppColors.textSecondary.withValues(alpha: 0.5),
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: 'Nunito',
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(point.dx - textPainter.width / 2, size.height - 20),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TrendDataPoint {
  final String date;
  final double value;

  _TrendDataPoint({required this.date, required this.value});
}
