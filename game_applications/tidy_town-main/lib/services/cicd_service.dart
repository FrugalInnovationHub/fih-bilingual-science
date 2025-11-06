import 'api_service.dart';
import 'dart:convert';

class CICDService {
  static CICDService? _instance;
  static CICDService get instance => _instance ??= CICDService._internal();
  CICDService._internal();

  final ApiService _apiService = ApiService.instance;

  // Automated deployment pipeline
  Future<bool> runDeploymentPipeline({
    required String environment,
    required String version,
    required String branch,
    required String commitHash,
  }) async {
    try {
      print('Starting CI/CD pipeline for $environment...');

      // Step 1: Trigger CI/CD pipeline
      final pipelineTriggered = await _apiService.triggerPipeline(branch, commitHash);
      if (!pipelineTriggered) {
        print('Failed to trigger CI/CD pipeline');
        return false;
      }

      // Step 2: Upload build artifacts
      final artifacts = {
        'version': version,
        'environment': environment,
        'timestamp': DateTime.now().toIso8601String(),
        'platforms': ['android', 'ios', 'web'],
      };

      final artifactsUploaded = await _apiService.uploadBuildArtifacts(artifacts);
      if (!artifactsUploaded) {
        print('Failed to upload build artifacts');
        return false;
      }

      // Step 3: Deploy application
      final deploymentSuccess = await _apiService.deployApplication(environment, version);
      if (!deploymentSuccess) {
        print('Failed to deploy application');
        return false;
      }

      // Step 4: Health check
      final healthCheck = await _apiService.healthCheck(environment);
      if (!healthCheck) {
        print('Health check failed, initiating rollback...');
        await _apiService.rollbackDeployment(environment, 'previous_version');
        return false;
      }

      print('CI/CD pipeline completed successfully');
      return true;
    } catch (e) {
      print('CI/CD pipeline failed: $e');
      return false;
    }
  }

  // Automated testing pipeline
  Future<bool> runTestingPipeline({
    required String branch,
    required String commitHash,
  }) async {
    try {
      print('Starting testing pipeline...');

      // Trigger automated tests
      final testTriggered = await _apiService.triggerPipeline(branch, commitHash);
      if (!testTriggered) {
        print('Failed to trigger testing pipeline');
        return false;
      }

      // Wait for test results and check logs
      await Future.delayed(const Duration(seconds: 5)); // Simulate test execution
      
      final buildLogs = await _apiService.getBuildLogs('test_build_$commitHash');
      final testResults = _analyzeTestResults(buildLogs);

      if (testResults['passed'] == true) {
        print('All tests passed');
        return true;
      } else {
        print('Tests failed: ${testResults['errors']}');
        return false;
      }
    } catch (e) {
      print('Testing pipeline failed: $e');
      return false;
    }
  }

  // Automated rollback mechanism
  Future<bool> automatedRollback({
    required String environment,
    required String reason,
  }) async {
    try {
      print('Initiating automated rollback for $environment...');

      // Get deployment metrics to assess performance
      final metrics = await _apiService.getDeploymentMetrics();
      
      // Check if rollback is necessary based on metrics
      if (_shouldRollback(metrics)) {
        final rollbackSuccess = await _apiService.rollbackDeployment(
          environment, 
          metrics['previous_version'] ?? 'unknown'
        );
        
        if (rollbackSuccess) {
          print('Automated rollback completed successfully');
          return true;
        } else {
          print('Automated rollback failed');
          return false;
        }
      }
      
      print('Rollback not necessary based on current metrics');
      return true;
    } catch (e) {
      print('Automated rollback failed: $e');
      return false;
    }
  }

  // Monitor deployment status
  Future<Map<String, dynamic>> monitorDeployment(String deploymentId) async {
    try {
      final status = await _apiService.getDeploymentStatus(deploymentId);
      
      // Log deployment progress
      print('Deployment Status: ${status['status']} - Progress: ${status['progress']}%');
      
      return status;
    } catch (e) {
      print('Failed to monitor deployment: $e');
      return {'status': 'error', 'progress': 0};
    }
  }

  // Continuous monitoring
  Future<void> startContinuousMonitoring(String environment) async {
    print('Starting continuous monitoring for $environment...');
    
    // Simulate continuous monitoring
    while (true) {
      try {
        final healthStatus = await _apiService.healthCheck(environment);
        final metrics = await _apiService.getDeploymentMetrics();
        
        // Log monitoring data
        print('Health Status: $healthStatus');
        print('Performance Metrics: ${jsonEncode(metrics)}');
        
        // Check for issues and trigger automated responses
        if (!healthStatus || _shouldRollback(metrics)) {
          await automatedRollback(environment: environment, reason: 'Performance degradation detected');
        }
        
        // Wait before next check
        await Future.delayed(const Duration(minutes: 5));
      } catch (e) {
        print('Monitoring error: $e');
        await Future.delayed(const Duration(minutes: 1));
      }
    }
  }

  // Helper methods
  Map<String, dynamic> _analyzeTestResults(List<Map<String, dynamic>> logs) {
    int passed = 0;
    int failed = 0;
    List<String> errors = [];

    for (final log in logs) {
      if (log['type'] == 'test_result') {
        if (log['status'] == 'passed') {
          passed++;
        } else {
          failed++;
          errors.add(log['message'] ?? 'Unknown error');
        }
      }
    }

    return {
      'passed': failed == 0,
      'total_tests': passed + failed,
      'passed_tests': passed,
      'failed_tests': failed,
      'errors': errors,
    };
  }

  bool _shouldRollback(Map<String, dynamic> metrics) {
    // Simple rollback logic based on performance metrics
    final errorRate = metrics['error_rate'] ?? 0.0;
    final responseTime = metrics['avg_response_time'] ?? 0.0;
    final availability = metrics['availability'] ?? 100.0;

    return errorRate > 5.0 || responseTime > 2000 || availability < 95.0;
  }
} 