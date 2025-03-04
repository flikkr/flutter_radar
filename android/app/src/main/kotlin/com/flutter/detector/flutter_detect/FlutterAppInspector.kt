package com.flutter.detector.flutter_detect

import android.util.Log

class FlutterAppInspector {
    private val dartVersionRegex = Regex("[0-9]\\.[0-9]{1,2}\\.[0-9]\\S*\\s\\([a-z]*\\).{9}")

    fun getFlutterVersion(flutterLibPath: String, zipEntryPath: String?): String? {
        val packages = Util.searchString(flutterLibPath, zipEntryPath, false) {
            val res = dartVersionRegex.matches(it)
            return@searchString if (dartVersionRegex.matches(it)) it else null

        }
        return packages.firstOrNull()
    }

    fun getPackagesFromPackageInfo(libPath: String, zipEntryPath: String?): List<String> {
        val packages = Util.searchString(libPath, zipEntryPath) {
            // Idea from https://www.reddit.com/r/FlutterDev/comments/16s8q94/comment/k2967qb/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
            // Extract the package name (equivalent to cut -d / -f 1)
            val packageName = if (it.startsWith("package:")) {
                val packageName = it.substringBefore("/").removePrefix("package:")
                Log.d(tag, "Found package: $packageName")
                packageName
            } else {
                null
            }
            return@searchString packageName
        }
        return packages
    }
}