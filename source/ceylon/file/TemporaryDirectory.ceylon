import ceylon.file.internal {
    createTemporaryDirectoryInternal=createTemporaryDirectory
}

import java.nio.file {
    NoSuchFileException,
    DirectoryNotEmptyException
}

"A temporary [[Directory]]. `TemporaryDirectory`s may be used within resource
 expressions:

     try (tempDirectory = TemporaryDirectory()) {
         // ...
     }

 If possible, a `TemporaryDirectory` will be deleted upon invocation of its
 [[destroy()]] method."
throws (`class Exception`,
    "If the prefix cannot be used to generate a directory name,
     an I/O error occurs, or the parent directory is not
     specified and a suitable temporary directory cannot be
     determined.")
shared class TemporaryDirectory(
        "The leading part of the temporary directory name to use,
         or `null` for the system default."
        String? prefix = null,
        "The parent directory for the new temporary directory, or `null`
         for the system default temporary directory."
        Directory? parentDirectory = null)
        satisfies Destroyable & Directory {

    Directory delegate
        =   createTemporaryDirectoryInternal(prefix, parentDirectory);

    name => delegate.name;

    childDirectories(String filter) => delegate.childDirectories(filter);

    childPaths(String filter) => delegate.childPaths(filter);

    childResource(Path|String subpath) => delegate.childResource(subpath);

    children(String filter) => delegate.children(filter);

    delete() => delegate.delete();

    files(String filter) => delegate.files(filter);

    linkedResource => delegate.linkedResource;

    move(Nil target) => delegate.move(target);

    shared actual String owner => delegate.owner;

    assign owner {
        delegate.owner = owner;
    }

    path => delegate.path;

    readAttribute(Attribute attribute) => delegate.readAttribute(attribute);

    writeAttribute(Attribute attribute, Object attributeValue)
        =>  delegate.writeAttribute(attribute, attributeValue);

    deleteOnExit() => delegate.deleteOnExit();

    "Attempt to delete this temporary directory. No action will
     be taken if the directory is not empty or no longer exists."
    shared actual void destroy(Throwable? error) {
        try {
            delete();
        }
        catch (NoSuchFileException | DirectoryNotEmptyException e) {
            // ignore
        }
    }
}
