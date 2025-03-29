package com.flutter.detector.flutter_detect

import android.util.Log
import java.util.regex.Pattern

class FlutterAppInspector {
    private val dartVersionPattern =
        Pattern.compile("(\\d+\\.\\d+\\.\\d+(?:-\\d+\\.\\d+)?\\.\\w*?)\\s\\((\\w+)\\)")
    private val packagePattern = Pattern.compile("package:([^/]+)/.*")

    fun getFlutterVersion(flutterLibPath: String, zipEntryPath: String?): Version? {
        val packages = Util.searchString(flutterLibPath, zipEntryPath, false, dartVersionPattern)
        val fullMatch = packages.firstOrNull() ?: return null

        val matcher = dartVersionPattern.matcher(fullMatch)
        return if (matcher.matches()) {
            Version(matcher.group(1)!!, matcher.group(2)!!)
        } else {
            null
        }
    }

    fun getPackagesFromPackageInfo(libPath: String, zipEntryPath: String?): Set<String> {
        val packages = Util.searchString(libPath, zipEntryPath, true, packagePattern)
            .mapNotNull { match ->
                // Extract the package name from the match
                val matcher = packagePattern.matcher(match)
                if (matcher.matches()) {
                    val packageName = matcher.group(1)
                    if (!packageName.isNullOrEmpty()) {
                        Log.d(tag, "Found package: $packageName")
                        packageName
                    } else null
                } else null
            }
            .toSet()

        return packages
    }
}
