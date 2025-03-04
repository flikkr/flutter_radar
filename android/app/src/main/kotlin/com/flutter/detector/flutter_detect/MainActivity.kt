package com.flutter.detector.flutter_detect

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        DetectorHostApi.setUp(
            flutterEngine.dartExecutor.binaryMessenger,
            DetectorHostApiImpl(applicationContext)
        )
    }
}
