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
shared ReadableFileDescriptor standardInput = InputStreamAdapter(javaIn);

"A [[WritableFileDescriptor]] for the virtual machine's standard output stream."
aliased("stdout")
shared WritableFileDescriptor standardOutput = OutputStreamAdapter(javaOut);

"A [[WritableFileDescriptor]] for the virtual machine's standard error stream."
aliased("stderr")
shared WritableFileDescriptor standardError = OutputStreamAdapter(javaErr);
