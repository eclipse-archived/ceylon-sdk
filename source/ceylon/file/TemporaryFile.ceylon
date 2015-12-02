import ceylon.file.internal {
    createTemporaryFileInternal=createTemporaryFile
}

import java.nio.file {
    NoSuchFileException
}

"A temporary [[File]]. `TemporaryFile`s may be used within resource
 expressions:

     try (tempFile = TemporaryFile()) {
         // ...
     }

 If possible, a `TemporaryFile` will be deleted upon invocation of its
 [[destroy()]] method."
throws (`class Exception`,
    "If the prefix or suffix cannot be used to generate a file
     name, an I/O error occurs, or a parent directory is not
     specified and a suitable temporary directory cannot be
     determined.")
shared class TemporaryFile(
        "The leading part of the temporary file name to use, or
         `null` for the system default."
        String? prefix = null,
        "The trailing part of the temporary file name to use, or
         `null` for the system default."
        String? suffix = null,
        "The parent directory for the new temporary file, or `null`
         for the system default temporary directory."
        Directory? parentDirectory = null,
        "If true, attempt to delete the temporary file upon
         termination of the current process if supported by
         the underlying virtual machine."
        Boolean deleteOnExit = false)
        satisfies Destroyable & File {

    File delegate
        =   createTemporaryFileInternal(
                prefix, suffix, parentDirectory, deleteOnExit);

    contentType => delegate.contentType;

    copy(Nil target, Boolean copyAttributes)
        =>  delegate.copy(target, copyAttributes);

    copyOverwriting(File|Nil target, Boolean copyAttributes)
        =>  delegate.copyOverwriting(target, copyAttributes);

    createLink(Nil target) => delegate.createLink(target);

    createSymbolicLink(Nil target) => delegate.createSymbolicLink(target);

    delete() => delegate.delete();

    directory => delegate.directory;

    executable => delegate.executable;

    hidden => delegate.hidden;

    shared actual Integer lastModifiedMilliseconds
        =>  delegate.lastModifiedMilliseconds;

    assign lastModifiedMilliseconds {
        delegate.lastModifiedMilliseconds = lastModifiedMilliseconds;
    }

    linkedResource => delegate.linkedResource;

    move(Nil target) => delegate.move(target);

    moveOverwriting(File|Nil target) => delegate.moveOverwriting(target);

    name => delegate.name;

    shared actual String owner => delegate.owner;

    assign owner {
        delegate.owner = owner;
    }

    path => delegate.path;

    readAttribute(Attribute attribute) => delegate.readAttribute(attribute);

    readable => delegate.readable;

    size => delegate.size;

    store => delegate.store;

    writable => delegate.writable;

    writeAttribute(Attribute attribute, Object attributeValue)
        =>  delegate.writeAttribute(attribute, attributeValue);

    shared actual class Appender(String? encoding, Integer bufferSize)
            extends super.Appender(encoding, bufferSize) {

        value delegate = outer.delegate.Appender(encoding, bufferSize);

        close() => delegate.close();

        flush() => delegate.flush();

        write(String string) => delegate.write(string);

        writeBytes({Byte*} bytes) => delegate.writeBytes(bytes);

        writeLine(String line) => delegate.writeLine(line);
    }

    shared actual class Overwriter(String? encoding, Integer bufferSize)
            extends super.Overwriter(encoding, bufferSize) {

        value delegate = outer.delegate.Overwriter(encoding, bufferSize);

        close() => delegate.close();

        flush() => delegate.flush();

        write(String string) => delegate.write(string);

        writeBytes({Byte*} bytes) => delegate.writeBytes(bytes);

        writeLine(String line) => delegate.writeLine(line);
    }

    shared actual class Reader(String? encoding, Integer bufferSize)
            extends super.Reader(encoding, bufferSize) {

        value delegate = outer.delegate.Reader(encoding, bufferSize);

        close() => delegate.close();

        readBytes(Integer max) => delegate.readBytes(max);

        readLine() => delegate.readLine();
    }

    "Delete this temporary file. No action will be taken
     if the file no longer exists."
    shared actual void destroy(Throwable? error) {
        try {
            delete();
        }
        catch (NoSuchFileException e) {
            // ignore
        }
    }
}
