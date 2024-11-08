import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

class DioCustomCacheInterceptor extends DioCacheInterceptor {
  DioCustomCacheInterceptor({CacheOptions? options})
      : super(
          options: options ??
              CacheOptions(
                store: MemCacheStore(),
                policy: CachePolicy.request,
                hitCacheOnErrorExcept: [401, 403],
                priority: CachePriority.normal,
                maxStale: const Duration(days: 7),
                keyBuilder: CacheOptions.defaultCacheKeyBuilder,
                allowPostMethod: false,
              ),
        );
}
