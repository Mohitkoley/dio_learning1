import 'package:context_extension/num_extension/num_extension.dart';
import 'package:dio_learning_1/controller/api_controller.dart';
import 'package:dio_learning_1/model/post_list.dart';
import 'package:dio_learning_1/repositroy/api_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  HomeScreen({super.key});

  final apiController =
      StateNotifierProvider<ApiController, List<PostListModel>>((ref) {
    ApiRepository apiRepository = ApiRepository();
    return ApiController(apiRepository);
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<PostListModel> posts = ref.watch(apiController);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: ListView(
        children: [
          ElevatedButton(
              onPressed: () {
                ref.read(apiController.notifier).getPosts();
              },
              child: const Text('Get Posts')),
          10.hBox,
          ElevatedButton(
              onPressed: () {
                ref.read(apiController.notifier).postPost();
              },
              child: const Text('Post Post')),
          10.hBox,
          if (posts.isEmpty)
            const Center(
              child: Text('Loading ...'),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(posts[index].title),
                  subtitle: Text(posts[index].body),
                );
              },
            ),
        ],
      ),
    );
  }
}
