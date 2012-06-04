Module module {
    name='ceylon.file';
    version='1.0.0';
    doc="API for accessing hierarchical filesystems. Clients use `Path`s to
         obtain `Resource`s representing files or directories. It is usally
         necessary to narrow a `Resource` to a `File`, `Directory`, or `Nil`
         before performing operations on it.
         
         To create a file named `hello.txt` in the home directory, we could 
         do the following:
         
             value filePath = home.childPath(\"hello.txt\");
             if (is Nil loc = filePath.resource()) {
                 value file = loc.createFile();
                 value writer = file.writer();
                 try {
                     writer.writeLine(\"Hello, World!\");
                 }
                 finally {
                     writer.close();
                 }
             }
         
         To print the contents of the file we just created, we could do this:
         
             value filePath = home.childPath(\"hello.txt\");
             if (is File file = filePath.resource()) {
                 value reader = file.reader();
                 try {
                     print(reader.readLine());
                 }
                 finally {
                     reader.close();
                 }
             }
         
         Now, to move the file to a different directory:
         
             value newPath = path(\"/Users/Trompon/Documents/hello.txt\");
             if (is Nil loc = newPath.resource()) {
                 value filePath = home.childPath(\"hello.txt\");
                 if (is File file = filePath.resource()) {
                     file.move(loc);
                 }
             }
         ";
}