package com.flutter.detector.flutter_detect

import android.content.Context
import android.content.pm.PackageManager
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class ScanEventChannelImpl(private val context: Context) : StreamScanEventsStreamHandler() {
    private val pm = context.packageManager

    override fun onListen(p0: Any?, sink: PigeonEventSink<ScanEvent>) {
        CoroutineScope(Dispatchers.Default).launch {
            try {
                val apps = pm.getInstalledPackages(PackageManager.GET_SHARED_LIBRARY_FILES)
                apps.forEachIndexed { index, packageInfo ->
                    val detector = FlutterAppDetector(context.packageManager, packageInfo)
                    val flutterApp = detector.getFlutterApp()
                    withContext(Dispatchers.Main) {
                        sink.success(
                            ScanEvent(
                                totalApps = apps.size.toLong(),
                                currentCount = index.toLong() + 1,
                                app = flutterApp
                            )
                        )
                    }
                }
            } catch (error: Exception) {
                withContext(Dispatchers.Main) {
                    sink.error(
                        errorCode = ERROR_CODE,
                        errorMessage = error.localizedMessage,
                        errorDetails = error.cause
                    )
                }
            } finally {
                withContext(Dispatchers.Main) {
                    sink.endOfStream()
                }
            }
        }
    }

    companion object {
        const val ERROR_CODE = "scan_error"
    }
}
