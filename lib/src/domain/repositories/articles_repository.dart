import '../../core/params/article_request.dart';
import '../../core/resources/data_state.dart';
import '../entities/article.dart';

abstract class ArticlesRepository {
  // API methods
  Future<DataState<List<Article>>> getBreakingNewsArticles(
      ArticlesRequestParams params);
}
