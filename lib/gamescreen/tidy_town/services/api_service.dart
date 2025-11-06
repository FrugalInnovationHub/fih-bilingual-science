import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'dart:convert';

class ApiService {
  static ApiService? _instance;
  static ApiService get instance => _instance ??= ApiService._internal();
  ApiService._internal();

  final Dio _dio = Dio();
  final String _baseUrl = 'https://api.tidytown.com'; // Example API endpoint

  // HTTP client for simple requests
  final http.Client _httpClient = http.Client();

  // Initialize API service with interceptors
  Future<void> initialize() async {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    
    // Add request interceptor for logging
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print('API Request: ${options.method} ${options.path}');
        handler.next(options);
      },
      onResponse: (response, handler) {
        print('API Response: ${response.statusCode}');
        handler.next(response);
      },
      onError: (error, handler) {
        print('API Error: ${error.message}');
        handler.next(error);
      },
    ));
  }

  // Deploy application using REST API
  Future<bool> deployApplication(String environment, String version) async {
    try {
      final response = await _dio.post('/api/deploy', data: {
        'environment': environment,
        'version': version,
        'platform': 'flutter',
        'timestamp': DateTime.now().toIso8601String(),
      });

      if (response.statusCode == 200) {
        print('Deployment initiated successfully');
        return true;
      }
      return false;
    } catch (e) {
      print('Deployment failed: $e');
      return false;
    }
  }

  // Check deployment status
  Future<Map<String, dynamic>> getDeploymentStatus(String deploymentId) async {
    try {
      final response = await _dio.get('/api/deploy/$deploymentId/status');
      
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      return {'status': 'unknown', 'progress': 0};
    } catch (e) {
      print('Failed to get deployment status: $e');
      return {'status': 'error', 'progress': 0};
    }
  }

  // Upload build artifacts
  Future<bool> uploadBuildArtifacts(Map<String, dynamic> artifacts) async {
    try {
      final formData = FormData.fromMap({
        'android_apk': await MultipartFile.fromBytes(
          utf8.encode('mock_android_build.apk'),
          filename: 'app-release.apk',
        ),
        'ios_ipa': await MultipartFile.fromBytes(
          utf8.encode('mock_ios_build.ipa'),
          filename: 'app-release.ipa',
        ),
        'web_build': await MultipartFile.fromBytes(
          utf8.encode('mock_web_build.zip'),
          filename: 'web-build.zip',
        ),
        'metadata': jsonEncode(artifacts),
      });

      final response = await _dio.post('/api/artifacts/upload', data: formData);
      
      if (response.statusCode == 200) {
        print('Build artifacts uploaded successfully');
        return true;
      }
      return false;
    } catch (e) {
      print('Failed to upload build artifacts: $e');
      return false;
    }
  }

  // Trigger CI/CD pipeline
  Future<bool> triggerPipeline(String branch, String commitHash) async {
    try {
      final response = await _dio.post('/api/pipeline/trigger', data: {
        'branch': branch,
        'commit_hash': commitHash,
        'project': 'tidy_town',
        'platforms': ['android', 'ios', 'web'],
      });

      if (response.statusCode == 200) {
        print('CI/CD pipeline triggered successfully');
        return true;
      }
      return false;
    } catch (e) {
      print('Failed to trigger pipeline: $e');
      return false;
    }
  }

  // Get build logs
  Future<List<Map<String, dynamic>>> getBuildLogs(String buildId) async {
    try {
      final response = await _dio.get('/api/builds/$buildId/logs');
      
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data);
      }
      return [];
    } catch (e) {
      print('Failed to get build logs: $e');
      return [];
    }
  }

  // Health check for deployment
  Future<bool> healthCheck(String environment) async {
    try {
      final response = await _httpClient.get(
        Uri.parse('$_baseUrl/api/health/$environment'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['status'] == 'healthy';
      }
      return false;
    } catch (e) {
      print('Health check failed: $e');
      return false;
    }
  }

  // Rollback deployment
  Future<bool> rollbackDeployment(String environment, String previousVersion) async {
    try {
      final response = await _dio.post('/api/deploy/rollback', data: {
        'environment': environment,
        'previous_version': previousVersion,
        'reason': 'Performance issues detected',
      });

      if (response.statusCode == 200) {
        print('Rollback initiated successfully');
        return true;
      }
      return false;
    } catch (e) {
      print('Rollback failed: $e');
      return false;
    }
  }

  // Get deployment metrics
  Future<Map<String, dynamic>> getDeploymentMetrics() async {
    try {
      final response = await _dio.get('/api/metrics/deployment');
      
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      return {};
    } catch (e) {
      print('Failed to get deployment metrics: $e');
      return {};
    }
  }

  void dispose() {
    _httpClient.close();
    _dio.close();
  }
} 