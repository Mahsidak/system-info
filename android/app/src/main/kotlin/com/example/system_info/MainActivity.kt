package com.example.system_info

import android.app.ActivityManager
import android.content.Context
import android.os.Build
import android.os.StatFs
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.RandomAccessFile

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.system_info/device_info"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->
            if (call.method == "getDeviceInfo") {
                result.success(getDeviceInfo())
            } else {
                result.notImplemented()
            }
        }
    }


    private fun getDeviceInfo(): Map<String, String> {
        val deviceInfo = mutableMapOf<String, String>()

        // General device information
        deviceInfo["Device Name"] = Build.DEVICE
        deviceInfo["Model"] = Build.MODEL
        deviceInfo["Manufacturer"] = Build.MANUFACTURER
        deviceInfo["Android Version"] = Build.VERSION.RELEASE
        deviceInfo["SDK Version"] = Build.VERSION.SDK_INT.toString()

        deviceInfo["CPU ABI"] = Build.SUPPORTED_ABIS.joinToString(", ")
        deviceInfo["Number of Cores"] = Runtime.getRuntime().availableProcessors().toString()
        deviceInfo["CPU Frequency"] = getCpuFrequency() ?: "Unavailable"

        val memoryInfo = getMemoryInfo()
        deviceInfo["Total RAM"] = memoryInfo.first
        deviceInfo["Available RAM"] = memoryInfo.second

        val storageInfo = getStorageInfo()
        deviceInfo["Total Storage"] = storageInfo.first
        deviceInfo["Available Storage"] = storageInfo.second

        return deviceInfo
    }

    private fun getCpuFrequency(): String? {
        return try {
            val maxFreqFile = "/sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq"
            RandomAccessFile(maxFreqFile, "r").use { reader ->
                val freqKHz = reader.readLine()?.toLongOrNull()
                if (freqKHz != null) {
                    val freqGHz = freqKHz / 1_000_000.0
                    String.format("%.2f GHz", freqGHz)
                } else {
                    null
                }
            }
        } catch (e: Exception) {
            null
        }
    }

    private fun getMemoryInfo(): Pair<String, String> {
        val activityManager = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        val memoryInfo = ActivityManager.MemoryInfo()
        activityManager.getMemoryInfo(memoryInfo)

        val totalRAM = memoryInfo.totalMem / (1024 * 1024 * 1024)
        val availableRAM = memoryInfo.availMem / (1024 * 1024 * 1024)

        return Pair("$totalRAM GB", "$availableRAM GB")
    }

    private fun getStorageInfo(): Pair<String, String> {
        val statFs = StatFs(filesDir.absolutePath)

        val totalBytes = statFs.totalBytes
        val availableBytes = statFs.availableBytes

        val totalGB = totalBytes / (1024 * 1024 * 1024)
        val availableGB = availableBytes / (1024 * 1024 * 1024)

        return Pair("$totalGB GB", "$availableGB GB")
    }
}
