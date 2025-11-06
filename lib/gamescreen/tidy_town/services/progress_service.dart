import 'package:shared_preferences/shared_preferences.dart';
import 'redis_cache_service.dart';

class ProgressService {
  static const String _recycleProgressKey = 'recycle_progress';
  static const String _compostProgressKey = 'compost_progress';
  static const String _landfillProgressKey = 'landfill_progress';

  // Get progress for a specific category with Redis caching
  static Future<int> getProgress(String category) async {
    // Try Redis cache first
    final cachedProgress = await RedisCacheService.instance.getCachedUserProgress('default_user');
    if (cachedProgress != null && cachedProgress.containsKey(category)) {
      return cachedProgress[category] as int;
    }

    // Fallback to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    int progress;
    switch (category) {
      case 'Recycle':
        progress = prefs.getInt(_recycleProgressKey) ?? 0;
        break;
      case 'Compost':
        progress = prefs.getInt(_compostProgressKey) ?? 0;
        break;
      case 'Landfill':
        progress = prefs.getInt(_landfillProgressKey) ?? 0;
        break;
      default:
        progress = 0;
    }

    // Cache the result in Redis
    await RedisCacheService.instance.cacheUserProgress('default_user', {
      'Recycle': progress,
      'Compost': progress,
      'Landfill': progress,
    });

    return progress;
  }

  // Update progress for a specific category with Redis caching
  static Future<void> updateProgress(String category, int progress) async {
    // Update SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    switch (category) {
      case 'Recycle':
        await prefs.setInt(_recycleProgressKey, progress);
        break;
      case 'Compost':
        await prefs.setInt(_compostProgressKey, progress);
        break;
      case 'Landfill':
        await prefs.setInt(_landfillProgressKey, progress);
        break;
    }

    // Update Redis cache
    final cachedProgress = await RedisCacheService.instance.getCachedUserProgress('default_user') ?? {};
    cachedProgress[category] = progress;
    await RedisCacheService.instance.cacheUserProgress('default_user', cachedProgress);
  }

  // Get total questions for a category
  static int getTotalQuestions(String category) {
    switch (category) {
      case 'Recycle':
        return 6; // Number of items in recyclableItems list
      case 'Compost':
        return 5; // Update this when implementing compost quiz
      case 'Landfill':
        return 5; // Update this when implementing landfill quiz
      default:
        return 0;
    }
  }
} 