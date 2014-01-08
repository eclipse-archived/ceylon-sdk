import java.nio.charset {
    Charset {
        defaultCharset,
        forName
    }
}

Charset parseCharset(String? encoding) {
    if (exists encoding) {
        return forName(encoding);
    }
    else {
        return defaultCharset();
    }
}