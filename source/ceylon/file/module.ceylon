/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"API for accessing hierarchical file systems. Clients use 
 [[Path]]s to obtain [[Resource]]s representing files or 
 directories.
 
 `Path` contains many useful operations for manipulating 
 paths:
 
     value path = parsePath(\"/Users/Trompon/Documents\");
     value child = path.childPath(\"hello.txt\");
     value sibling = child.siblingPath(\"goodbye.txt\");
     value parent = path.parent;
 
 The attribute [[resource|Path.resource]] of `Path` is used 
 to obtain a `Resource`. It is usually necessary to narrow a 
 `Resource` to one of the following enumerated subtypes 
 before performing operations on it:
 
 - a [[File]] contains data,
 - a [[Directory]] contains other resources, 
 - a [[Link]] is a symbolic link to another resource, or 
 - a [[Nil]] is an unoccupied location in the filesystem 
   where a resource may safely be created.
 
 To create a file named `hello.txt` in the home directory, 
 we could do the following:
 
     value filePath = home.childPath(\"hello.txt\");
     if (is Nil loc = filePath.resource) {
         value file = loc.createFile();
         try (writer = file.Overwriter()) {
             writer.writeLine(\"Hello, World!\");
         }
     }
     else {
         print(\"file already exists\");
     }
 
 Note the difference between a [[File.Overwriter]], which 
 destroys the existing contents of the file, if any, and a 
 [[File.Appender]], which leaves them intact.
 
 To print the contents of the file we just created, we could 
 do this:
 
     value filePath = home.childPath(\"hello.txt\");
     if (is File file = filePath.resource) {
         try (reader = file.Reader()) {
             print(reader.readLine());
         }
     }
     else {
         print(\"file does not exist\");
     }
 
 Now, to rename the file:
 
     value filePath = home.childPath(\"hello.txt\");
     if (is File file = filePath.resource) {
         value newPath = filePath.siblingPath(\"goodbye.txt\");
         if (is Nil loc = newPath.resource) {
            file.move(loc);
         }
         else {
             print(\"target file already exists\");
         }
     }
     else {
         print(\"source file does not exist\");
     }
 
 To list the contents of a directory, we have two 
 possibilities. We can list just the direct contents:
 
     if (is Directory dir = home.resource) {
         for (path in dir.childPaths()) {
             print(path);
         }
     }
     else {
         print(\"directory does not exist\");
     }
 
 Alternatively, we can create a [[Visitor]] that walks the
 whole directory tree rooted at a given path:
 
     object visitor extends Visitor() {
         file(File file) => print(file.path);
     }
     home.visit(visitor);
 
 File systems other than the default file system are 
 supported. For example, a file system for a zip file may be 
 created using the convenience function [[createZipFileSystem]].
 
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
 "
by("Gavin King")
native("jvm")
label("Ceylon Hierarchical Filesystem API")
module ceylon.file maven:"org.ceylon-lang" "1.3.4-SNAPSHOT" {
    import java.base "7";
}
