public static final String OooO0O0(ApplicationInfo applicationInfo) {
    String[] strArr;
    boolean z;
    String str;
    ZipFile zipFile;
    o00O000o OooO00o2;
    boolean z2;
    Object obj;
    ZipEntry zipEntry;
    o00O000o OooO00o3;
    boolean z3;
    OooO0o0.OooOO0O.OooO0O0.Oooo0.OooO0o(applicationInfo, "applicationInfo");
    o00O00O o00o00o = new o00O00O("[0-9]\\.[0-9]{1,2}\\.[0-9]\\S*\\s\\([a-z]*\\).{9}");
    try {
        String str2 = applicationInfo.nativeLibraryDir;
        String[] list = new File(str2).list();
        OooO0o0.OooOO0O.OooO0O0.Oooo0.OooO0o0(list, "File(nativePath).list()");
        if (OooO0O0.OooO0O0(list, "libflutter.so")) {
            File file = new File(str2 + "/libflutter.so");
            o00Oo0 o00oo0 = new o00Oo0();
            OooO0o0.OooOO0.OooO00o.OooO00o(file, 1048576, new OooO00o(o00oo0, o00o00o));
            return (String) o00oo0.f2459OooO0o0;
        }
    } catch (Exception unused) {
    }
    try {
        zipFile = new ZipFile(new File(applicationInfo.sourceDir));
        try {
            Enumeration<? extends ZipEntry> entries = zipFile.entries();
            OooO0o0.OooOO0O.OooO0O0.Oooo0.OooO0o0(entries, "zipFile.entries()");
            Iterator it = oo0o0Oo.OooO0o0(oo0o0Oo.o00Oo0(entries)).iterator();
            while (true) {
                if (!it.hasNext()) {
                    obj = null;
                    break;
                }
                obj = it.next();
                ZipEntry zipEntry2 = (ZipEntry) obj;
                String name = zipEntry2.getName();
                OooO0o0.OooOO0O.OooO0O0.Oooo0.OooO0o0(name, "it.name");
                if (o00O0O00.OooO00o(name, "lib", false, 2)) {
                    String name2 = zipEntry2.getName();
                    OooO0o0.OooOO0O.OooO0O0.Oooo0.OooO0o0(name2, "it.name");
                    if (o00O0O00.OooO0O0(name2, "libflutter.so", false, 2)) {
                        z3 = true;
                        if (!z3) {
                            break;
                        }
                    }
                }
                z3 = false;
                if (!z3) {
                }
            }
            zipEntry = (ZipEntry) obj;
        } finally {
        }
    } catch (Exception unused2) {
    }
    if (zipEntry != null) {
        InputStream inputStream = zipFile.getInputStream(zipEntry);
        do {
            byte[] bArr = new byte[1048576];
            if (inputStream.read(bArr, 0, 1048576) <= 0) {
                inputStream.close();
                oo0o0Oo.OooOO0(zipFile, null);
                return null;
            }
            Charset defaultCharset = Charset.defaultCharset();
            OooO0o0.OooOO0O.OooO0O0.Oooo0.OooO0o0(defaultCharset, "defaultCharset()");
            OooO00o3 = o00o00o.OooO00o(new String(bArr, defaultCharset), 0);
        } while (OooO00o3 == null);
        String value = ((o00O00) OooO00o3).getValue();
        inputStream.close();
        oo0o0Oo.OooOO0(zipFile, null);
        return value;
    }
    oo0o0Oo.OooOO0(zipFile, null);
    try {
        strArr = applicationInfo.splitSourceDirs;
    } catch (Exception unused3) {
    }
    if (strArr != null) {
        if (!(strArr.length == 0)) {
            z = false;
            if (!z) {
                return null;
            }
            int length = strArr.length;
            int i = 0;
            while (true) {
                if (i >= length) {
                    str = null;
                    break;
                }
                str = strArr[i];
                OooO0o0.OooOO0O.OooO0O0.Oooo0.OooO0o0(str, "it");
                String str3 = File.separator;
                OooO0o0.OooOO0O.OooO0O0.Oooo0.OooO0o0(str3, "separator");
                String str4 = (String) OooO0O0.OooO0Oo(o00O0O00.OooOOo0(str, new String[] { str3 }, false, 0, 6));
                if (!o00O0O00.OooOOo(str4, "split_config.arm", false, 2)
                        && !o00O0O00.OooOOo(str4, "split_config.x86", false, 2)) {
                    z2 = false;
                    if (!z2) {
                        break;
                    }
                    i++;
                }
                z2 = true;
                if (!z2) {
                }
            }
            if (str != null) {
                zipFile = new ZipFile(new File(str));
                try {
                    Enumeration<? extends ZipEntry> entries2 = zipFile.entries();
                    while (entries2.hasMoreElements()) {
                        ZipEntry nextElement = entries2.nextElement();
                        OooO0o0.OooOO0O.OooO0O0.Oooo0.OooO0o0(nextElement, "entries.nextElement()");
                        ZipEntry zipEntry3 = nextElement;
                        String name3 = zipEntry3.getName();
                        OooO0o0.OooOO0O.OooO0O0.Oooo0.OooO0o0(name3, "next.name");
                        if (o00O0O00.OooO00o(name3, "libflutter.so", false, 2)) {
                            InputStream inputStream2 = zipFile.getInputStream(zipEntry3);
                            do {
                                byte[] bArr2 = new byte[1048576];
                                if (inputStream2.read(bArr2, 0, 1048576) <= 0) {
                                    inputStream2.close();
                                    oo0o0Oo.OooOO0(zipFile, null);
                                    return null;
                                }
                                Charset defaultCharset2 = Charset.defaultCharset();
                                OooO0o0.OooOO0O.OooO0O0.Oooo0.OooO0o0(defaultCharset2, "defaultCharset()");
                                OooO00o2 = o00o00o.OooO00o(new String(bArr2, defaultCharset2), 0);
                            } while (OooO00o2 == null);
                            String value2 = ((o00O00) OooO00o2).getValue();
                            inputStream2.close();
                            oo0o0Oo.OooOO0(zipFile, null);
                            return value2;
                        }
                    }
                    oo0o0Oo.OooOO0(zipFile, null);
                } finally {
                    try {
                        throw th;
                    } finally {
                    }
                }
            }
            return null;
        }
    }
    z = true;
    if (!z) {
    }
}
