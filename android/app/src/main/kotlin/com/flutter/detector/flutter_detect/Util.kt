package com.flutter.detector.flutter_detect

import android.util.Log
import com.flutter.detector.flutter_detect.FlutterAppDetector.Companion.FLUTTER_LIB
import java.io.File
import java.io.InputStream
import java.util.zip.ZipFile

object Util {
    private const val TAG = "LibStringSearch"

    fun searchString(
        libPath: String,
        zipEntryPath: String?,
        accumulate: Boolean = true,
        searchPredicate: (value: String) -> String?
    ): List<String> {

        val results = mutableListOf<String>()
        try {
            val fileInputStream = if (zipEntryPath.isNullOrEmpty()) {
                val file = File(libPath)
                if (!file.exists()) return emptyList()
                file.inputStream()
            } else {
                val zipFile = ZipFile(zipEntryPath)
                val entries = zipFile.entries()
                var inputStream: InputStream? = null
                while (entries.hasMoreElements()) {
                    val entry = entries.nextElement()
                    if (entry.name == libPath) {
                        inputStream = zipFile.getInputStream(entry)
                    }
                }
                if (inputStream == null) return emptyList()
                inputStream
            }
            fileInputStream.use { input ->
                val res = processInputStream(input, accumulate, searchPredicate)
                results.addAll(res)
            }
            Log.d(TAG, "Number of matches: ${results.size}")
        } catch (e: Exception) {
            Log.e(TAG, "Error reading lib in path: $libPath", e)
        }
        return results
    }

    private fun processInputStream(
        input: InputStream,
        accumulate: Boolean,
        searchPredicate: (value: String) -> String?
    ): List<String> {
        val results = mutableListOf<String>()
        val buffer = ByteArray(4096)
        val stringBuilder = StringBuilder()

        var bytesRead: Int
        while (input.read(buffer).also { bytesRead = it } != -1) {
            for (i in 0 until bytesRead) {
                val byte = buffer[i]
                // If printable ASCII character
                if (byte in 32..126) {
                    stringBuilder.append(byte.toInt().toChar())
                } else if (stringBuilder.isNotEmpty()) {
                    // End of a string
                    val str = stringBuilder.toString()
                    val needle = searchPredicate(str)
                    if (needle != null) {
                        results.add(needle)
                        if (!accumulate) return results
                    }
                    stringBuilder.clear()
                }
            }
        }

        Log.d(TAG, "Number of matches: ${results.size}")
        return results
    }
}
