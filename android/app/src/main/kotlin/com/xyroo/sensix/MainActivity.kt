package com.xyroo.sensix

import android.content.pm.PackageManager
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import rikka.shizuku.Shizuku
import rikka.shizuku.Shizuku.OnRequestPermissionResultListener

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.xyroo.sensix/shizuku"
    private val SHIZUKU_CODE = 100

    private val requestListener = OnRequestPermissionResultListener { requestCode, grantResult ->
        if (requestCode == SHIZUKU_CODE) {
            val granted = grantResult == PackageManager.PERMISSION_GRANTED
            // Handle result jika perlu
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        Shizuku.addRequestPermissionResultListener(requestListener)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {

                "isShizukuAvailable" -> {
                    try {
                        val available = Shizuku.pingBinder()
                        result.success(available)
                    } catch (e: Exception) {
                        result.success(false)
                    }
                }

                "requestShizukuPermission" -> {
                    try {
                        if (Shizuku.isPreV11() || Shizuku.getVersion() < 11) {
                            result.error("OLD_VERSION", "Shizuku version too old", null)
                            return@setMethodCallHandler
                        }
                        if (Shizuku.checkSelfPermission() == PackageManager.PERMISSION_GRANTED) {
                            result.success(true)
                        } else {
                            Shizuku.requestPermission(SHIZUKU_CODE)
                            result.success(false)
                        }
                    } catch (e: Exception) {
                        result.error("ERROR", e.message, null)
                    }
                }

                "runCommand" -> {
                    val command = call.argument<String>("command") ?: run {
                        result.error("NO_COMMAND", "Command is null", null)
                        return@setMethodCallHandler
                    }
                    try {
                        if (Shizuku.checkSelfPermission() != PackageManager.PERMISSION_GRANTED) {
                            result.error("NO_PERMISSION", "Shizuku permission not granted", null)
                            return@setMethodCallHandler
                        }
                        val process = Shizuku.newProcess(arrayOf("sh", "-c", command), null, null)
                        process.waitFor()
                        val output = process.inputStream.bufferedReader().readText()
                        val error = process.errorStream.bufferedReader().readText()
                        result.success(mapOf("output" to output, "error" to error, "exitCode" to process.exitValue()))
                    } catch (e: Exception) {
                        result.error("EXEC_ERROR", e.message, null)
                    }
                }

                "setDpi" -> {
                    val dpi = call.argument<Int>("dpi") ?: run {
                        result.error("NO_DPI", "DPI value is null", null)
                        return@setMethodCallHandler
                    }
                    runShellCommand("wm density $dpi", result)
                }

                "resetDpi" -> {
                    // Reset DPI ke default
                    runShellCommand(
                        "settings delete system display_density_forced && wm density reset",
                        result
                    )
                }

                "setScreenSize" -> {
                    val w = call.argument<Int>("width") ?: 0
                    val h = call.argument<Int>("height") ?: 0
                    runShellCommand("wm size ${w}x${h}", result)
                }

                "resetScreenSize" -> {
                    runShellCommand("wm size reset", result)
                }

                "resetOverscan" -> {
                    runShellCommand("wm overscan reset", result)
                }

                "getDensity" -> {
                    try {
                        val dm = resources.displayMetrics
                        result.success(mapOf(
                            "densityDpi" to dm.densityDpi,
                            "widthPixels" to dm.widthPixels,
                            "heightPixels" to dm.heightPixels,
                            "density" to dm.density
                        ))
                    } catch (e: Exception) {
                        result.error("ERROR", e.message, null)
                    }
                }

                else -> result.notImplemented()
            }
        }
    }

    private fun runShellCommand(command: String, result: MethodChannel.Result) {
        try {
            if (Shizuku.checkSelfPermission() != PackageManager.PERMISSION_GRANTED) {
                result.error("NO_PERMISSION", "Izin Shizuku diperlukan", null)
                return
            }
            val process = Shizuku.newProcess(arrayOf("sh", "-c", command), null, null)
            process.waitFor()
            val output = process.inputStream.bufferedReader().readText()
            result.success(output.ifEmpty { "Done: $command" })
        } catch (e: Exception) {
            result.error("EXEC_ERROR", e.message, null)
        }
    }

    override fun onDestroy() {
        Shizuku.removeRequestPermissionResultListener(requestListener)
        super.onDestroy()
    }
}
