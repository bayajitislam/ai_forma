import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:ai_forma/features/insights/constants/insights_strings.dart';
import 'package:ai_forma/features/insights/controllers/muscle_growth_controller.dart';
import 'package:ai_forma/features/insights/controllers/fat_loss_controller.dart';
import 'package:ai_forma/features/insights/controllers/posture_controller.dart';
import 'package:ai_forma/features/insights/controllers/symmetry_controller.dart';
import 'package:ai_forma/features/insights/controllers/consistency_controller.dart';
import 'package:ai_forma/features/insights/models/muscle_growth_detail_model.dart';
import 'package:ai_forma/features/insights/models/fat_loss_detail_model.dart';
import 'package:ai_forma/features/insights/models/posture_detail_model.dart';
import 'package:ai_forma/features/insights/models/symmetry_detail_model.dart';
import 'package:ai_forma/features/insights/models/consistency_detail_model.dart';
import 'package:ai_forma/features/insights/repositories/insights_repository.dart';
import 'package:ai_forma/features/insights/view/pages/muscle_growth_view.dart';
import 'package:ai_forma/features/insights/view/pages/fat_loss_view.dart';
import 'package:ai_forma/features/insights/view/pages/posture_analysis_view.dart';
import 'package:ai_forma/features/insights/view/pages/symmetry_score_view.dart';
import 'package:ai_forma/features/insights/view/pages/consistency_view.dart';
import 'package:dartz/dartz.dart';
import 'package:ai_forma/core/failure/failure.dart';
import 'package:ai_forma/features/insights/view/widgets/insight_analysis_section.dart';
import 'package:ai_forma/features/insights/view/widgets/insight_score_section.dart';
import 'package:ai_forma/core/network/dio_client.dart';

class FakeInsightsRepository extends InsightsRepository {
  FakeInsightsRepository() : super(DioClient());

  MuscleGrowthDetailResponseModel? muscleGrowthDetail;
  FatLossDetailResponseModel? fatLossDetail;
  PostureDetailResponseModel? postureDetail;
  SymmetryDetailResponseModel? symmetryDetail;
  ConsistencyDetailResponseModel? consistencyDetail;

  @override
  Future<Either<Failure, MuscleGrowthDetailResponseModel>> getMuscleGrowthDetail() async {
    if (muscleGrowthDetail != null) return Right(muscleGrowthDetail!);
    return Left(ServerFailure());
  }

  @override
  Future<Either<Failure, FatLossDetailResponseModel>> getFatLossDetail() async {
    if (fatLossDetail != null) return Right(fatLossDetail!);
    return Left(ServerFailure());
  }

  @override
  Future<Either<Failure, PostureDetailResponseModel>> getPostureDetail() async {
    if (postureDetail != null) return Right(postureDetail!);
    return Left(ServerFailure());
  }

  @override
  Future<Either<Failure, SymmetryDetailResponseModel>> getSymmetryDetail() async {
    if (symmetryDetail != null) return Right(symmetryDetail!);
    return Left(ServerFailure());
  }

  @override
  Future<Either<Failure, ConsistencyDetailResponseModel>> getConsistencyDetail() async {
    if (consistencyDetail != null) return Right(consistencyDetail!);
    return Left(ServerFailure());
  }
}

void main() {
  setUp(() {
    Get.reset();
  });

  group('InsightAnalysisSection Widget Tests', () {
    testWidgets('renders single coach narrative with multi-paragraph support',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InsightAnalysisSection(
              analysis:
                  'Paragraph 1: Visible muscular development is present.\n\nParagraph 2: Your current scan provides a solid baseline.',
            ),
          ),
        ),
      );

      expect(find.text(InsightsStrings.aiFormaAnalysis), findsOneWidget);
      expect(
        find.text('Paragraph 1: Visible muscular development is present.'),
        findsOneWidget,
      );
      expect(
        find.text('Paragraph 2: Your current scan provides a solid baseline.'),
        findsOneWidget,
      );
    });

    testWidgets(
        'renders locked preview when analysis is null and headings provided',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InsightAnalysisSection(
              analysis: null,
              analysisHeadings: ['Upper Body Development', 'Symmetry Alignment'],
            ),
          ),
        ),
      );

      expect(find.text(InsightsStrings.aiFormaAnalysis), findsOneWidget);
      expect(find.text('Upper Body Development'), findsOneWidget);
      expect(find.text('Symmetry Alignment'), findsOneWidget);
      expect(find.text(InsightsStrings.analysisPreviewLocked), findsOneWidget);
    });
  });

  group('First Scan vs Scan 2+ Tests for Key Insights', () {
    testWidgets(
        'MuscleGrowthView shows first scan baseline and no trend deltas on scan 1',
        (tester) async {
      final repo = FakeInsightsRepository();
      repo.muscleGrowthDetail = const MuscleGrowthDetailResponseModel(
        accessLevel: 'full',
        scanId: 'scan_1',
        scanDate: 'May 18, 2026',
        checkinNumber: 1,
        score: 78,
        status: '',
        statusTone: 'positive',
        summary: '',
        weeklyPriorities: [],
        metrics: MuscleGrowthMetricsModel(
          muscleMassKg: ValueDeltaItemModel(value: 68.0, delta: 0.0),
          muscleMassPercent: ValueDeltaItemModel(value: 75.0, delta: 0.0),
        ),
      );
      Get.put(MuscleGrowthController(repository: repo));

      await tester.pumpWidget(
        const GetMaterialApp(
          home: MuscleGrowthView(),
        ),
      );
      await tester.pumpAndSettle();

      // Verify analysis section header
      expect(find.text(InsightsStrings.aiFormaAnalysis), findsOneWidget);

      // Verify no change deltas like ↑ 0.0 kg, but '—'
      expect(find.text(InsightsStrings.noChangePlaceholder), findsNWidgets(2));

      // Verify first scan baseline explanation
      expect(
        find.text(InsightsStrings.muscleGrowthSummaryFirstScan),
        findsOneWidget,
      );
    });

    testWidgets(
        'FatLossView shows first scan baseline and no trend deltas on scan 1',
        (tester) async {
      final repo = FakeInsightsRepository();
      repo.fatLossDetail = const FatLossDetailResponseModel(
        accessLevel: 'full',
        scanId: 'scan_1',
        scanDate: 'May 18, 2026',
        checkinNumber: 1,
        score: 60,
        status: '',
        statusTone: 'positive',
        summary: '',
        weeklyPriorities: [],
        metrics: FatLossMetricsModel(
          bodyFatPercent: FatLossValueDeltaModel(value: 16.5, delta: 0.0),
          fatMassKg: FatLossValueDeltaModel(value: 12.0, delta: 0.0),
        ),
      );
      Get.put(FatLossController(repository: repo));

      await tester.pumpWidget(
        const GetMaterialApp(
          home: FatLossView(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(InsightsStrings.aiFormaAnalysis), findsOneWidget);
      expect(find.text(InsightsStrings.noChangePlaceholder), findsNWidgets(2));
      expect(find.text(InsightsStrings.fatLossSummaryFirstScan), findsOneWidget);
    });

    testWidgets('ConsistencyView shows first scan baseline on scan 1',
        (tester) async {
      final repo = FakeInsightsRepository();
      repo.consistencyDetail = const ConsistencyDetailResponseModel(
        accessLevel: 'full',
        scanId: 'scan_1',
        scanDate: 'May 18, 2026',
        checkinNumber: 1,
        score: 100,
        status: 'Excellent',
        statusTone: 'excellent',
        summary: '',
        weeklyPriorities: [],
        grid: [
          ConsistencyGridItemModel(date: 'May 18, 2026', checkinNumber: 1),
        ],
        metrics: ConsistencyMetricsModel(
          currentStreakWeeks: 1,
          onTimePercent: 100,
          momentumGained: null,
        ),
      );
      Get.put(ConsistencyController(repository: repo));

      await tester.pumpWidget(
        const GetMaterialApp(
          home: ConsistencyView(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(InsightsStrings.aiFormaAnalysis), findsOneWidget);
      expect(find.text(InsightsStrings.initialReading), findsOneWidget);
      expect(find.text('1 scan'), findsOneWidget);
      expect(
          find.text(InsightsStrings.consistencySummaryFirstScan), findsOneWidget);
    });

    testWidgets('PostureAnalysisView shows first scan baseline on scan 1',
        (tester) async {
      final repo = FakeInsightsRepository();
      repo.postureDetail = const PostureDetailResponseModel(
        accessLevel: 'full',
        scanId: 'scan_1',
        scanDate: 'May 18, 2026',
        checkinNumber: 1,
        score: 70,
        status: 'Needs Attention',
        statusTone: 'warning',
        summary: '',
        weeklyPriorities: [],
      );
      Get.put(PostureController(repository: repo));

      await tester.pumpWidget(
        const GetMaterialApp(
          home: PostureAnalysisView(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(InsightsStrings.aiFormaAnalysis), findsOneWidget);
      expect(
          find.text(InsightsStrings.postureSummaryFirstScan), findsOneWidget);
    });

    testWidgets('SymmetryScoreView shows first scan baseline on scan 1',
        (tester) async {
      final repo = FakeInsightsRepository();
      repo.symmetryDetail = const SymmetryDetailResponseModel(
        accessLevel: 'full',
        scanId: 'scan_1',
        scanDate: 'May 18, 2026',
        checkinNumber: 1,
        score: 85,
        status: 'Good',
        statusTone: 'good',
        summary: '',
        weeklyPriorities: [],
      );
      Get.put(SymmetryController(repository: repo));

      await tester.pumpWidget(
        const GetMaterialApp(
          home: SymmetryScoreView(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(InsightsStrings.aiFormaAnalysis), findsOneWidget);
      expect(
          find.text(InsightsStrings.symmetrySummaryFirstScan), findsOneWidget);
    });

    test('InsightScoreBadgeType resolves correctly from tone and text', () {
      expect(
        InsightScoreBadgeType.fromTone('warning', 'Needs attention'),
        InsightScoreBadgeType.warning,
      );
      expect(
        InsightScoreBadgeType.fromTone('needs_attention', ''),
        InsightScoreBadgeType.warning,
      );
      expect(
        InsightScoreBadgeType.fromTone('', 'Pelvic imbalance'),
        InsightScoreBadgeType.warning,
      );
      expect(
        InsightScoreBadgeType.fromTone('good', 'Good'),
        InsightScoreBadgeType.good,
      );
      expect(
        InsightScoreBadgeType.fromTone('excellent', 'Excellent'),
        InsightScoreBadgeType.excellent,
      );
      expect(
        InsightScoreBadgeType.fromTone('positive', 'Balanced'),
        InsightScoreBadgeType.positive,
      );
    });
  });
}
