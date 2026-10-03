import 'package:ai_forma/core/network/dio_client.dart';
import 'package:ai_forma/features/insights/controllers/compare_scans_controller.dart';
import 'package:ai_forma/features/insights/controllers/consistency_controller.dart';
import 'package:ai_forma/features/insights/controllers/fat_loss_controller.dart';
import 'package:ai_forma/features/insights/controllers/insights_controller.dart';
import 'package:ai_forma/features/insights/controllers/muscle_growth_controller.dart';
import 'package:ai_forma/features/insights/controllers/posture_controller.dart';
import 'package:ai_forma/features/insights/controllers/symmetry_controller.dart';
import 'package:ai_forma/features/insights/repositories/insights_repository.dart';
import 'package:get/get.dart';

/// Registered on the /app_shell route — keeps InsightsController alive
/// for the lifetime of the shell session.
class InsightsBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<InsightsRepository>()) {
      Get.put<InsightsRepository>(
        InsightsRepository(Get.find<DioClient>()),
        permanent: true,
      );
    }
    if (!Get.isRegistered<InsightsController>()) {
      Get.put<InsightsController>(
        InsightsController(repository: Get.find<InsightsRepository>()),
        permanent: true,
      );
    }
  }
}

/// Lazily injects MuscleGrowthController when /muscle_growth is pushed.
class MuscleGrowthBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<MuscleGrowthController>()) {
      Get.put<MuscleGrowthController>(
        MuscleGrowthController(repository: Get.find<InsightsRepository>()),
      );
    }
  }
}

/// Lazily injects FatLossController when /fat_loss is pushed.
class FatLossBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<FatLossController>()) {
      Get.put<FatLossController>(
        FatLossController(repository: Get.find<InsightsRepository>()),
      );
    }
  }
}

/// Lazily injects PostureController when /posture_analysis is pushed.
class PostureBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<PostureController>()) {
      Get.put<PostureController>(
        PostureController(repository: Get.find<InsightsRepository>()),
      );
    }
  }
}

/// Lazily injects SymmetryController when /symmetry_score is pushed.
class SymmetryBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<SymmetryController>()) {
      Get.put<SymmetryController>(
        SymmetryController(repository: Get.find<InsightsRepository>()),
      );
    }
  }
}

/// Lazily injects ConsistencyController when /consistency is pushed.
class ConsistencyBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ConsistencyController>()) {
      Get.put<ConsistencyController>(
        ConsistencyController(repository: Get.find<InsightsRepository>()),
      );
    }
  }
}

/// Lazily injects CompareScansController when /compare_scans is pushed.
class CompareScansBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<CompareScansController>()) {
      Get.put<CompareScansController>(
        CompareScansController(repository: Get.find<InsightsRepository>()),
      );
    }
  }
}
