package com.flutter.detector.flutter_detect

import android.content.Context
import android.content.pm.PackageManager

class DetectorHostApiImpl(private val context: Context) : DetectorHostApi {
    private val appInspector = FlutterAppInspector()

    override fun getApps(): List<FlutterApp> {
        val pm = context.packageManager
        val apps = pm.getInstalledPackages(PackageManager.GET_SHARED_LIBRARY_FILES)
        val mapped = apps.mapNotNull { packageInfo ->
            val detector = FlutterAppDetector(pm, packageInfo)
            detector.getFlutterApp()
        }
        return mapped
    }

    override fun getPackages(appLibPath: String, zipEntryPath: String?): List<String> =
        appInspector.getPackagesFromPackageInfo(appLibPath, zipEntryPath)
}
