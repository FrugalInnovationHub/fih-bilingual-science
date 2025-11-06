import 'dart:convert';
import 'package:http/http.dart' as http;

class RedisCacheService {
  static RedisCacheService? _instance;
  static RedisCacheService get instance => _instance ??= RedisCacheService._internal();
  RedisCacheService._internal();

  // In-memory cache to simulate Redis
  final Map<String, dynamic> _cache = {};
  final Map<String, DateTime> _expiryTimes = {};
  bool _isConnected = true;

  // Cache keys
  static const String _userProgressKey = 'user_progress';
  static const String _audioCacheKey = 'audio_cache';
  static const String _storyContentKey = 'story_content';
  static const String _gameDataKey = 'game_data';

  Future<void> initialize() async {
    try {
      _isConnected = true;
      print('Redis cache service initialized successfully');
    } catch (e) {
      print('Failed to initialize cache: $e');
      _isConnected = false;
    }
  }

  Future<void> cacheUserProgress(String userId, Map<String, dynamic> progress) async {
    if (!_isConnected) return;
    
    try {
      final key = '$_userProgressKey:$userId';
      _cache[key] = jsonEncode(progress);
      _expiryTimes[key] = DateTime.now().add(const Duration(hours: 24));
      print('User progress cached successfully');
    } catch (e) {
      print('Failed to cache user progress: $e');
    }
  }

  Future<Map<String, dynamic>?> getCachedUserProgress(String userId) async {
    if (!_isConnected) return null;
    
    try {
      final key = '$_userProgressKey:$userId';
      if (_cache.containsKey(key) && !_isExpired(key)) {
        return jsonDecode(_cache[key]) as Map<String, dynamic>;
      }
    } catch (e) {
      print('Failed to retrieve cached user progress: $e');
    }
    return null;
  }

  Future<void> cacheAudioData(String audioId, String audioUrl) async {
    if (!_isConnected) return;
    
    try {
      final key = '$_audioCacheKey:$audioId';
      _cache[key] = audioUrl;
      _expiryTimes[key] = DateTime.now().add(const Duration(hours: 1));
      print('Audio data cached successfully');
    } catch (e) {
      print('Failed to cache audio data: $e');
    }
  }

  Future<String?> getCachedAudioData(String audioId) async {
    if (!_isConnected) return null;
    
    try {
      final key = '$_audioCacheKey:$audioId';
      if (_cache.containsKey(key) && !_isExpired(key)) {
        return _cache[key];
      }
    } catch (e) {
      print('Failed to retrieve cached audio data: $e');
    }
    return null;
  }

  Future<void> cacheStoryContent(String storyId, Map<String, dynamic> content) async {
    if (!_isConnected) return;
    
    try {
      final key = '$_storyContentKey:$storyId';
      _cache[key] = jsonEncode(content);
      _expiryTimes[key] = DateTime.now().add(const Duration(hours: 2));
      print('Story content cached successfully');
    } catch (e) {
      print('Failed to cache story content: $e');
    }
  }

  Future<Map<String, dynamic>?> getCachedStoryContent(String storyId) async {
    if (!_isConnected) return null;
    
    try {
      final key = '$_storyContentKey:$storyId';
      if (_cache.containsKey(key) && !_isExpired(key)) {
        return jsonDecode(_cache[key]) as Map<String, dynamic>;
      }
    } catch (e) {
      print('Failed to retrieve cached story content: $e');
    }
    return null;
  }

  Future<void> cacheGameData(String gameId, Map<String, dynamic> gameData) async {
    if (!_isConnected) return;
    
    try {
      final key = '$_gameDataKey:$gameId';
      _cache[key] = jsonEncode(gameData);
      _expiryTimes[key] = DateTime.now().add(const Duration(minutes: 30));
      print('Game data cached successfully');
    } catch (e) {
      print('Failed to cache game data: $e');
    }
  }

  Future<Map<String, dynamic>?> getCachedGameData(String gameId) async {
    if (!_isConnected) return null;
    
    try {
      final key = '$_gameDataKey:$gameId';
      if (_cache.containsKey(key) && !_isExpired(key)) {
        return jsonDecode(_cache[key]) as Map<String, dynamic>;
      }
    } catch (e) {
      print('Failed to retrieve cached game data: $e');
    }
    return null;
  }

  Future<void> clearCache() async {
    if (!_isConnected) return;
    
    try {
      _cache.clear();
      _expiryTimes.clear();
      print('Cache cleared successfully');
    } catch (e) {
      print('Failed to clear cache: $e');
    }
  }

  Future<void> disconnect() async {
    if (_isConnected) {
      _cache.clear();
      _expiryTimes.clear();
      _isConnected = false;
      print('Cache service disconnected');
    }
  }

  bool _isExpired(String key) {
    if (!_expiryTimes.containsKey(key)) return true;
    return DateTime.now().isAfter(_expiryTimes[key]!);
  }

  bool get isConnected => _isConnected;
} 