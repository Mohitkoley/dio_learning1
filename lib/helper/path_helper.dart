// path provider helper for storing downloaded files
import 'package:path_provider/path_provider.dart';

class PathHelper {
  String? _localPath;
  String? get localPath => _localPath;
  init() async {
    // Get the directory for the app
    final directory = await getApplicationDocumentsDirectory();
    _localPath = directory.path;
  }

  String get kiwiPath => '$_localPath/kiwi';
}
