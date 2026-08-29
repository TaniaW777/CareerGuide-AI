import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class ModelService {
  static const String modelUrl =
      "https://github.com/TaniaW777/CareerGuide-AI/releases/download/v1.0/gemma3-1B-it-int4.task";
  static const String modelName = "gemma3-1B-it-int4.task";

  CancelToken? _cancelToken;

  Future<String> getModelPath() async {
    final dir = await getApplicationDocumentsDirectory();
    final modelDir = Directory("${dir.path}/models");
    if (!await modelDir.exists()) {
      await modelDir.create(recursive: true);
    }
    return "${modelDir.path}/$modelName";
  }

  Future<bool> modelExists() async {
    try {
      final path = await getModelPath();
      final file = File(path);
      if (!file.existsSync()) return false;
      final size = await file.length();
      return size > 100 * 1024 * 1024;
    } catch (_) {
      return false;
    }
  }

  Future<void> downloadModel({
    required Function(int progress, double speed, String eta) onProgress,
    required Function() onComplete,
    required Function(String error) onError,
  }) async {
    _cancelToken = CancelToken();
    final path = await getModelPath();
    final tempPath = "$path.tmp";

    final dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(minutes: 30),
    ));

    int lastReceived = 0;
    DateTime lastTime = DateTime.now();

    try {
      await dio.download(
        modelUrl,
        tempPath,
        cancelToken: _cancelToken,
        onReceiveProgress: (received, total) {
          if (total <= 0) return;
          final now = DateTime.now();
          final elapsed = now.difference(lastTime).inMilliseconds;
          if (elapsed >= 500) {
            final bytesDiff = received - lastReceived;
            final speedBps = bytesDiff / (elapsed / 1000);
            final remaining = total - received;
            final etaSecs =
                speedBps > 0 ? (remaining / speedBps).toInt() : 0;
            final etaStr = etaSecs > 60
                ? "${etaSecs ~/ 60}m ${etaSecs % 60}s"
                : "${etaSecs}s";
            final speedStr = speedBps > 1024 * 1024
                ? "${(speedBps / 1024 / 1024).toStringAsFixed(1)} MB/s"
                : "${(speedBps / 1024).toStringAsFixed(0)} KB/s";
            onProgress(
              ((received / total) * 100).toInt(),
              speedBps,
              "$speedStr • ETA $etaStr",
            );
            lastReceived = received;
            lastTime = now;
          }
        },
      );
      await File(tempPath).rename(path);
      onComplete();
    } on DioException catch (e) {
      if (File(tempPath).existsSync()) await File(tempPath).delete();
      if (e.type == DioExceptionType.cancel) {
        onError("Téléchargement annulé");
      } else {
        onError("Erreur réseau : ${e.message}");
      }
    } catch (e) {
      if (File(tempPath).existsSync()) await File(tempPath).delete();
      onError("Erreur : $e");
    }
  }

  void cancelDownload() {
    _cancelToken?.cancel();
  }

  Future<void> deleteModel() async {
    try {
      final path = await getModelPath();
      final file = File(path);
      if (file.existsSync()) await file.delete();
    } catch (_) {}
  }
}