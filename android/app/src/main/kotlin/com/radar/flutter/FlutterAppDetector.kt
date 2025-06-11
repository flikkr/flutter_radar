package com.radar.flutter

import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.drawable.Drawable
import android.util.Log
import androidx.core.graphics.drawable.toBitmapOrNull
import java.io.ByteArrayOutputStream
import java.io.File
import java.io.InputStream
import java.util.zip.ZipFile

class FlutterAppDetector(
    private val packageManager: PackageManager,
    private val packageInfo: PackageInfo
) {
    companion object {
        const val FLUTTER_LIB = "libflutter.so"
        const val FLUTTER_APP_LIB = "libapp.so"
        const val FLUTTER_ARTIFACTS_LIB = "flutter_artifacts.so"

        const val ARM_SPLIT_CONFIG = "split_config.arm"
        const val X86_SPLIT_CONFIG = "split_config.x86"
    }

    private var appLib: String? = null
    private var flutterLib: String? = null
    private var zipEntryPath: String? = null
    private val inspector = FlutterAppInspector()

    fun getFlutterApp(): FlutterApp? {
        Log.d(tag, "Checking ${packageInfo.packageName}")

        if (!areLibsDetected()) checkLibInNativeDir()
        if (!areLibsDetected()) checkLibInZipEntries()
        if (!areLibsDetected()) checkLibInSplitConfig()

        return if (areLibsDetected()) {
            FlutterApp(
                packageName = packageInfo.packageName,
                appVersion = packageInfo.versionName,
                flutterLibPath = flutterLib!!,
                appLibPath = appLib,
                label = packageInfo.applicationInfo?.loadLabel(packageManager).toString(),
                iconBytes = getIcon(packageInfo.applicationInfo?.loadIcon(packageManager)),
                version = inspector.getFlutterVersion(flutterLib!!, zipEntryPath),
                zipEntryPath = zipEntryPath
            )
        } else {
            null
        }
    }

    private fun checkLibInNativeDir() {
        val nativeDirPath = packageInfo.applicationInfo?.nativeLibraryDir ?: return

        val flutterLibFile = File(nativeDirPath, FLUTTER_LIB)
        flutterLib = flutterLib ?: if (flutterLibFile.exists()) flutterLibFile.path else null

        val appLibFile = File(nativeDirPath, FLUTTER_APP_LIB)
        appLib = appLib ?: if (appLibFile.exists()) appLibFile.path else null
    }

    private fun checkLibInZipEntries() {
        val source = packageInfo.applicationInfo?.sourceDir ?: return
        try {
            val zipFile = ZipFile(source)
            val entries = zipFile.entries()

            while (entries.hasMoreElements() && !areLibsDetected()) {
                val entry = entries.nextElement()
                val name = entry.name

                // Check for Flutter libraries in the zip entries
                if (name.contains(FLUTTER_LIB)) {
                    zipEntryPath = source
                    flutterLib = flutterLib ?: name
                } else if (
                    name.contains(FLUTTER_APP_LIB) ||
                    name.contains(FLUTTER_ARTIFACTS_LIB)
                ) {
                    zipEntryPath = source
                    appLib = appLib ?: name
                }
            }

            zipFile.close()
        } catch (e: Exception) {
            Log.e(tag, "Error checking zip entries: ${e.message}")
        }
    }

    private fun checkLibInSplitConfig() {
        val splitSourceDirs = packageInfo.applicationInfo?.splitSourceDirs
        if (!splitSourceDirs.isNullOrEmpty()) {
            for (dir in splitSourceDirs) {
                if (!dir.contains(ARM_SPLIT_CONFIG) && !dir.contains(X86_SPLIT_CONFIG)) continue
                try {
                    ZipFile(File(dir)).use { zipFile ->
                        val entries = zipFile.entries()
                        while (entries.hasMoreElements()) {
                            val entryName = entries.nextElement().name
                            if (entryName.contains(FLUTTER_LIB)) {
                                zipEntryPath = dir
                                flutterLib = flutterLib ?: entryName
                            } else if (
                                entryName.contains(FLUTTER_APP_LIB) ||
                                entryName.contains(FLUTTER_ARTIFACTS_LIB)
                            ) {
                                zipEntryPath = dir
                                appLib = appLib ?: entryName
                            }
                        }
                    }
                } catch (e: Exception) { /* ignore */
                }
            }
        }
    }

    private fun getIcon(drawable: Drawable?): ByteArray? {
        if (drawable == null) return null
        val bitmap = drawable.toBitmapOrNull() ?: return null
        val outputStream = ByteArrayOutputStream()
        bitmap.compress(Bitmap.CompressFormat.PNG, 100, outputStream)
        return outputStream.toByteArray()
    }

    private fun areLibsDetected() = flutterLib != null
}
