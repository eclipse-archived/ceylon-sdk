Module module {
    name='ceylon.file';
    version='0.3';
    doc="API for accessing hierarchical filesystems. Clients use `Path`s to
         obtain `Resource`s representing files or directories.
         
         `Path` contains many useful operations for manipulating paths:
         
             value path = parsePath(\"/Users/Trompon/Documents\");
             value child = path.childPath(\"hello.txt\");
             value sibling = child.siblingPath(\"goodbye.txt\");
             value parent = path.parent;
         
         The attribute `resource` of `Path` is used to obtain a `Resource`. It 
         is usally necessary to narrow a `Resource` to a `File`, `Directory`, 
         `Link`, or `Nil` before performing operations on it.
         
         To create a file named `hello.txt` in the home directory, we could do 
         the following:
         
             value filePath = home.childPath(\"hello.txt\");
             if (is Nil loc = filePath.resource) {
                 value file = loc.createFile();
                 value writer = file.writer();
                 try {
                     writer.writeLine(\"Hello, World!\");
                 }
                 finally {
                     writer.close();
                 }
             }
             else {
                 print(\"file already exists\");
             }
         
         To print the contents of the file we just created, we could do this:
         
             value filePath = home.childPath(\"hello.txt\");
             if (is File file = filePath.resource) {
                 value reader = file.reader();
                 try {
                     print(reader.readLine());
                 }
                 finally {
                     reader.close();
                 }
             }
             else {
                 print(\"file does not exist\");
             }
         
         Now, to move the file to a different directory:
         
             value newPath = home.childPath(\"goodbye.txt\");
             if (is Nil loc = newPath.resource) {
                 value filePath = home.childPath(\"hello.txt\");
                 if (is File file = filePath.resource()) {
                     file.move(loc);
                 }
                 else {
                     print(\"source file does not exist\");
                 }
             }
             else {
                 print(\"target file already exists\");
             }
         
         To list the contents of a directory, we have two possibilities.
         We can list just the direct contents:
         
             if (is Directory dir = home.resource) {
                 for (path in dir.childPaths()) {
                     print(path);
                 }
             }
             else {
                 print(\"directory does not exist\");
             }
         
         Alternatively, we can create a visitor that walks the whole directory
         tree rooted at a given path:
         
             object visitor extends Visitor() {
                 shared actual void file(File file) {
                     print(file.path);
                 }
             }
             home.visit(visitor);
         
         File systems other then the default file system are supported. For 
         example, a file system for a zip file may be created using the
         convenience function `createZipFileSystem()`.
         
             value zipPath = home.childPath(\"myzip.zip\");
             if (is Nil|File loc = zipPath.resource) {
                 value zipSystem = createZipFileSystem(loc);
                 value entryPath = zipSystem.parsePath(\"/hello.txt\");
                 if (is Nil entry = entryPath.resource) {
                     value filePath = home.childPath(\"hello.txt\");
                     if (is File file = filePath.resource) {
                         file.copy(entry);
                     }
                     else {
                         print(\"source file does not exist\");
                     }
                 }
                 else {
                     print(\"entry already exists\");
                 }
                 zipSystem.close();
             }
         ";
}