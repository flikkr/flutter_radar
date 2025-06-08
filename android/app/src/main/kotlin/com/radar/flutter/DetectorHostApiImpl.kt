package com.radar.flutter

import android.content.Context
import android.content.pm.PackageManager
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class DetectorHostApiImpl(
    private val context: Context,
    private val scanStreamChannel: ScanEventChannelImpl
) : DetectorHostApi {
    private val appInspector = FlutterAppInspector()

    override fun getApps(callback: (Result<List<FlutterApp>>) -> Unit) {
        CoroutineScope(Dispatchers.Default).launch {
            try {
                val result = withContext(Dispatchers.IO) {
                    analyseApps()
                }
                callback.invoke(result)
            } catch (e: Exception) {
                callback.invoke(Result.failure(e))
            }
        }
    }


    private fun analyseApps(): Result<List<FlutterApp>> {
        val pm = context.packageManager
        val apps = pm.getInstalledPackages(PackageManager.GET_SHARED_LIBRARY_FILES)
        val mapped = apps.mapNotNull { packageInfo ->
            val detector = FlutterAppDetector(context.packageManager, packageInfo)
            detector.getFlutterApp()
        }
        return Result.success(mapped)
    }

    override fun getPackages(
        appLibPath: String, zipEntryPath: String?,
        callback: (Result<List<String>>) -> Unit
    ) {
        CoroutineScope(Dispatchers.Main).launch {
            try {
                val result = withContext(Dispatchers.IO) {
                    val packages = appInspector.getPackagesFromPackageInfo(appLibPath, zipEntryPath)
                    Result.success(packages.toList())
                }
                callback.invoke(result)
            } catch (e: Exception) {
                callback.invoke(Result.failure(e))
            }
        }
    }
}
