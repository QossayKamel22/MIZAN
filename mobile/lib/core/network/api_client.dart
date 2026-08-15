import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Thin Dio wrapper for talking to the MIZAN backend
/// (docs/API_SPECIFICATION.md). Attaches the Firebase ID token from secure
/// storage to every request and normalizes error responses.
///
/// NOTE: In this build, feature repositories default to local mock data
/// sources (see each feature's `data/datasources/`) since no live backend
/// is deployed in this sandbox. `ApiClient` is the real integration point —
/// swapping a feature's binding from its mock datasource to
/// `<Feature>RemoteDataSource(ApiClient)` is the only change needed once a
/// backend URL is available. This keeps the pending work isolated and
/// documented rather than faked (docs/FINAL_TECHNICAL_REPORT.md).
class ApiClient {
  ApiClient({required this.baseUrl, FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ?? const FlutterSecureStorage() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ));
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _secureStorage.read(key: 'firebase_id_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
    ));
  }

  final String baseUrl;
  final FlutterSecureStorage _secureStorage;
  late final Dio _dio;

  Dio get client => _dio;
}
