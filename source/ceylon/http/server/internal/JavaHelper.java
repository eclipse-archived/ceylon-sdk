package ceylon.http.server.internal;

import java.io.File;

import io.undertow.server.handlers.form.FormData;

public class JavaHelper {
    private JavaHelper() {}
    
    public static boolean paramIsFile(FormData.FormValue param) {
        return param.isFile();
    }

    @SuppressWarnings("deprecation")
    public static File paramFile(FormData.FormValue param) {
        return param.getFile();
    }

    public static String paramValue(FormData.FormValue param) {
        return param.getValue();
    }
}
