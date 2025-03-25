package com.example.hap_installer

import io.flutter.embedding.android.FlutterActivity
import android.content.Intent
import android.os.Bundle
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.hap_installer/openFile"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // MethodChannel 实现
        flutterEngine?.dartExecutor?.let {
            MethodChannel(it, CHANNEL).setMethodCallHandler { call, result ->
                if (call.method == "handleFileOpen") {
                    val filePath = intent?.dataString // 获取文件路径
                    if (filePath != null) {
                        result.success(filePath)
                    } else {
                        result.error("UNAVAILABLE", "File path not available", null)
                    }
                } else {
                    result.notImplemented()
                }
            }
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        val filePath = intent.dataString
        if (filePath != null) {
            sendMessageToFlutter(filePath)
        }
    }

    private fun sendMessageToFlutter(message: String) {
        flutterEngine?.dartExecutor?.let { MethodChannel(it, CHANNEL).invokeMethod("handleFileOpen", message) }
    }
}
