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

"A [[ReadableFileDescriptor]] for the virtual machine's standard input stream."
aliased("stdin")
ReadableFileDescriptor standardInput = InputStreamAdapter(javaIn);

"A [[WritableFileDescriptor]] for the virtual machine's standard output stream."
aliased("stdout")
WritableFileDescriptor standardOutput = OutputStreamAdapter(javaOut);

"A [[WritableFileDescriptor]] for the virtual machine's standard error stream."
aliased("stderr")
WritableFileDescriptor standardError = OutputStreamAdapter(javaErr);
