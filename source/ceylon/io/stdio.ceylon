import ceylon.io.impl {
    InputStreamAdapter,
    OutputStreamAdapter
}

import java.lang {
    System {
        javaIn=\iin,
        javaOut=\iout,
        javaErr=err
    }
}

"A [[ReadableFileDescriptor]] for the virtual machine's standard input"
ReadableFileDescriptor stdin = InputStreamAdapter(javaIn);

"A [[WritableFileDescriptor]] for the virtual machine's standard output stream."
WritableFileDescriptor stdout = OutputStreamAdapter(javaOut);

"A [[WritableFileDescriptor]] for the virtual machine's standard error stream."
WritableFileDescriptor stderr = OutputStreamAdapter(javaErr);
