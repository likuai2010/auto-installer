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
        MethodChannel(flutterEngine?.dartExecutor, CHANNEL).setMethodCallHandler { call, result ->
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

    // 处理新打开的 Intent
    override fun onNewIntent(intent: Intent?) {
        super.onNewIntent(intent)
        this.intent = intent ?: return
        val filePath = intent?.dataString 
        if (filePath != null) {
            sendMessageToFlutter(filePath)
        }
    }
    private fun sendMessageToFlutter(message: String) {
        MethodChannel(flutterEngine?.dartExecutor, CHANNEL).invokeMethod("handleFileOpen", message)
    }
}
