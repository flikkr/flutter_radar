package com.flutter.detector.flutter_detect

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
        const val ARM_SPLIT_CONFIG = "split_config.arm"
        const val X86_SPLIT_CONFIG= "split_config.x86"
    }

    private var appLib: String? = null
    private var flutterLib: String? = null
    private var zipEntryPath: String? = null

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
                appLibPath = appLib ?: "aaaaa",
                label = packageInfo.applicationInfo?.loadLabel(packageManager).toString(),
                iconBytes = getIcon(packageInfo.applicationInfo?.loadIcon(packageManager)),
                dartVersion = "",
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
                } else if (name.contains(FLUTTER_APP_LIB)) {
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
                            } else if (entryName.contains(FLUTTER_APP_LIB)) {
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

    private fun getFlutterVersion(packageInfo: PackageInfo): String? {
        val appInfo = packageInfo.applicationInfo ?: return null

        // Try reading from nativeLibraryDir
        try {
            val nativeDir = appInfo.nativeLibraryDir ?: return null
            val flutterLibFile = File(nativeDir, FLUTTER_LIB)
            if (flutterLibFile.exists()) {
                val content = readFirstChunkOfFile(flutterLibFile)
                val version = extractVersionFromContent(content)
                if (version != null) return version
            }
        } catch (e: Exception) { /* ignore */
        }

        // Try reading from the sourceDir zip
        try {
            ZipFile(File(appInfo.sourceDir)).use { zipFile ->
                val entries = zipFile.entries()
                while (entries.hasMoreElements()) {
                    val entry = entries.nextElement()
                    if (entry.name.contains("lib") && entry.name.contains(FLUTTER_LIB)) {
                        zipFile.getInputStream(entry).use { input ->
                            val content = readFirstChunkOfStream(input)
                            val version = extractVersionFromContent(content)
                            if (version != null) return version
                        }
                    }
                }
            }
        } catch (e: Exception) { /* ignore */
        }

        // Try reading from splitSourceDirs if available
        val splitSourceDirs = appInfo.splitSourceDirs
        if (!splitSourceDirs.isNullOrEmpty()) {
            for (dir in splitSourceDirs) {
                if (dir.contains("split_config.arm") || dir.contains("split_config.x86")) continue
                try {
                    ZipFile(File(dir)).use { zipFile ->
                        val entries = zipFile.entries()
                        while (entries.hasMoreElements()) {
                            val entry = entries.nextElement()
                            if (entry.name.contains(FLUTTER_LIB)) {
                                zipFile.getInputStream(entry).use { input ->
                                    val content = readFirstChunkOfStream(input)
                                    val version = extractVersionFromContent(content)
                                    if (version != null) return version
                                }
                            }
                        }
                    }
                } catch (e: Exception) { /* ignore */
                }
            }
        }
        return null
    }

    private fun readFirstChunkOfFile(file: File, chunkSize: Int = 1048576): String {
        return file.inputStream().buffered().use { input ->
            val buffer = ByteArray(chunkSize)
            val bytesRead = input.read(buffer)
            if (bytesRead > 0) String(buffer, 0, bytesRead, Charsets.UTF_8) else ""
        }
    }

    private fun readFirstChunkOfStream(input: InputStream, chunkSize: Int = 1048576): String {
        val buffer = ByteArray(chunkSize)
        val bytesRead = input.read(buffer)
        return if (bytesRead > 0) String(buffer, 0, bytesRead, Charsets.UTF_8) else ""
    }

    private fun extractVersionFromContent(content: String): String? {
        val regex = Regex("[0-9]\\.[0-9]{1,2}\\.[0-9]\\S*\\s\\([a-z]*\\).{9}")
        return regex.find(content)?.value
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
