import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';
// import 'package:retrofit/http.dart' as he;

import '../../../core/utils/constants.dart';
import '../../models/breaking_news_response_model.dart';

part 'news_api_service.g.dart';

@RestApi(baseUrl: kBaseUrl)
abstract class NewsApiService {
  factory NewsApiService(Dio dio, {String baseUrl}) = _NewsApiService;

  static const headers = <String, dynamic>{"Content-Type": "application/json"};
  @GET('/top-headlines')
  @Headers(headers)
  Future<HttpResponse<BreakingNewsResponseModel>> getBreakingNewsArticles({
    @Query("apiKey") String? apiKey,
    @Query("country") String? country,
    @Query("category") String? category,
    @Query("page") int? page,
    @Query("pageSize") int? pageSize,
  });
}
