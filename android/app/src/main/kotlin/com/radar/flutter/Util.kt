package com.radar.flutter

import android.util.Log
import java.io.File
import java.io.InputStream
import java.nio.charset.Charset
import java.util.zip.ZipFile
import java.util.regex.Pattern

object Util {
    private const val TAG = "LibStringSearch"

    fun searchString(
        libPath: String,
        zipEntryPath: String?,
        accumulate: Boolean = true,
        pattern: Pattern
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
                val res = processInputStream(input, accumulate, pattern)
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
        pattern: Pattern
    ): List<String> {
        val results = mutableListOf<String>()
        val buffer = ByteArray(1048576) // Use 1MB buffer size like in the obfuscated function

        while (true) {
            val bytesRead = input.read(buffer, 0, buffer.size)
            if (bytesRead <= 0) {
                break // End of stream reached
            }

            // Convert the bytes to a string using default charset
            val content = String(buffer, 0, bytesRead, Charset.defaultCharset())

            // Use Matcher to find pattern matches
            val matcher = pattern.matcher(content)
            if (matcher.find()) {
                val match = matcher.group()
                results.add(match)
                if (!accumulate) {
                    return results
                }
                
                // Continue searching for more matches in the same buffer if accumulating
                while (matcher.find() && accumulate) {
                    results.add(matcher.group())
                }
            }
        }
        
        return results
    }
}
