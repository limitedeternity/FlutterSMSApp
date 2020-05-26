package com.limitedeternity.fluttersmsapp

import android.os.Bundle
import android.net.Uri
import android.content.ContentResolver

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)

    val channel = MethodChannel(flutterView, "channels.limitedeternity.com/main")
    channel.setMethodCallHandler { methodCall, result ->
      when (methodCall.method) {
        "deleteSMS" -> {
          val args = methodCall.arguments as Map<String, Int>
          val smsId: Int? = args.get("smsId")
          val smsUri: String = "content://sms/$smsId"
          val resolver: ContentResolver = contentResolver

          resolver.delete(Uri.parse(smsUri), null, null)
          result.success(smsId)
        }

        else -> result.notImplemented()
      }
    }
  }
}
