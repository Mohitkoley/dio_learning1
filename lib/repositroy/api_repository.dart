import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_learning_1/core/constant/api_endpoint.dart';
import 'package:dio_learning_1/core/network/api_client.dart';
import 'package:dio_learning_1/model/post_list.dart';
import 'package:flutter/material.dart';

class ApiRepository {
  static final ApiRepository _instance = ApiRepository._internal();
  factory ApiRepository() => _instance;
  ApiRepository._internal();

  Future<List<PostListModel>> getPosts() async {
    try {
      final response =
          await ApiClient().get(ApiEndpoint.posts, isCache: true) as Response;
      if (response.extra[CacheResponse.cacheKey] != null) {
        // Cache hit
        debugPrint(
            'Fetched data from cache for ${response.requestOptions.uri}');
      } else {
        // Network response
        debugPrint(
            'Fetched data from server for ${response.requestOptions.uri}');
      }

      final postList = (response.data as List)
          .map((e) => PostListModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return postList;
    } on Exception {
      rethrow;
    }
  }

  Future<PostListModel> postPost(Map<String, dynamic> body) async {
    try {
      final response = await ApiClient().post(ApiEndpoint.posts, body);
      return PostListModel.fromJson(response.data);
    } on Exception {
      rethrow;
    }
  }
}
