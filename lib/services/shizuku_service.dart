import 'package:flutter/services.dart';

/// Service untuk berkomunikasi dengan Shizuku via MethodChannel
class ShizukuService {
  static const _channel = MethodChannel('com.xyroo.sensix/shizuku');

  /// Cek apakah Shizuku sedang aktif/berjalan
  static Future<bool> isAvailable() async {
    try {
      return await _channel.invokeMethod<bool>('isShizukuAvailable') ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Request permission dari Shizuku
  static Future<bool> requestPermission() async {
    try {
      return await _channel.invokeMethod<bool>('requestShizukuPermission') ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Set DPI layar menggunakan `wm density <dpi>`
  static Future<ShellResult> setDpi(int dpi) async {
    try {
      final out = await _channel.invokeMethod<String>('setDpi', {'dpi': dpi});
      return ShellResult(
        success: true,
        output: out ?? 'Done: wm density $dpi',
        command: 'wm density $dpi',
      );
    } on PlatformException catch (e) {
      return ShellResult(success: false, output: e.message ?? 'Error', command: 'wm density $dpi');
    }
  }

  /// Reset DPI ke default
  static Future<ShellResult> resetDpi() async {
    try {
      final out = await _channel.invokeMethod<String>('resetDpi');
      return ShellResult(success: true, output: out ?? 'Done: wm density reset', command: 'wm density reset');
    } on PlatformException catch (e) {
      return ShellResult(success: false, output: e.message ?? 'Error', command: 'wm density reset');
    }
  }

  /// Set resolusi layar menggunakan `wm size WxH`
  static Future<ShellResult> setScreenSize(int width, int height) async {
    try {
      final out = await _channel.invokeMethod<String>('setScreenSize', {'width': width, 'height': height});
      return ShellResult(
        success: true,
        output: out ?? 'Done: wm size ${width}x$height',
        command: 'wm size ${width}x$height',
      );
    } on PlatformException catch (e) {
      return ShellResult(success: false, output: e.message ?? 'Error', command: 'wm size ${width}x$height');
    }
  }

  /// Reset resolusi layar ke default
  static Future<ShellResult> resetScreenSize() async {
    try {
      final out = await _channel.invokeMethod<String>('resetScreenSize');
      return ShellResult(success: true, output: out ?? 'Done: wm size reset', command: 'wm size reset');
    } on PlatformException catch (e) {
      return ShellResult(success: false, output: e.message ?? 'Error', command: 'wm size reset');
    }
  }

  /// Reset overscan
  static Future<ShellResult> resetOverscan() async {
    try {
      final out = await _channel.invokeMethod<String>('resetOverscan');
      return ShellResult(success: true, output: out ?? 'Done: wm overscan reset', command: 'wm overscan reset');
    } on PlatformException catch (e) {
      return ShellResult(success: false, output: e.message ?? 'Error', command: 'wm overscan reset');
    }
  }

  /// Ambil info DPI dan resolusi saat ini
  static Future<Map<String, dynamic>> getDensityInfo() async {
    try {
      final result = await _channel.invokeMethod<Map>('getDensity');
      return Map<String, dynamic>.from(result ?? {});
    } catch (_) {
      return {};
    }
  }

  /// Jalankan perintah shell custom (untuk terminal/developer mode)
  static Future<ShellResult> runCommand(String command) async {
    try {
      final result = await _channel.invokeMethod<Map>('runCommand', {'command': command});
      final map = Map<String, dynamic>.from(result ?? {});
      return ShellResult(
        success: (map['exitCode'] ?? 1) == 0,
        output: map['output'] ?? '',
        error: map['error'] ?? '',
        command: command,
      );
    } on PlatformException catch (e) {
      return ShellResult(success: false, output: e.message ?? 'Error', command: command);
    }
  }
}

class ShellResult {
  final bool success;
  final String output;
  final String error;
  final String command;

  ShellResult({
    required this.success,
    required this.output,
    this.error = '',
    required this.command,
  });

  @override
  String toString() => 'Executing: $command\n${success ? output : "Error: $error"}';
}
