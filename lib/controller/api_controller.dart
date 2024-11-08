import 'package:dio_learning_1/model/post_list.dart';
import 'package:dio_learning_1/repositroy/api_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ApiController extends StateNotifier<List<PostListModel>> {
  ApiController(this._apiRepository) : super(const []);
  // KResponse<PostListModel> _response = KResponse<PostListModel>();

  // KResponse<PostListModel> get response => _response;

  final ApiRepository _apiRepository;

  Future<void> getPosts() async {
    try {
      state = const [];
      final result = await _apiRepository.getPosts();
      state = result;
    } on Exception catch (e) {
      state = [];
      debugPrint('Error: $e');
    }
  }

  Future<void> postPost() async {
    try {
      state = const [];
      Map<String, dynamic> body = {
        'title': 'foo',
        'body': 'bar',
        'userId': 1,
      };
      final result = await _apiRepository.postPost(body);
      state = [result];
    } on Exception catch (e) {
      state = [];
      debugPrint('Error: $e');
    }
  }
}
