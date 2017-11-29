/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.file {
    AbstractReader=Reader,
    AbstractWriter=Writer
}
import ceylon.file.internal {
    sameFileInternal=sameFile
}

"Represents a file in a hierarchical file system."
shared sealed interface File 
        satisfies ExistingResource {
    
    "The directory containing this file."
    shared formal Directory directory;
    
    "Move this file to the given location."
    shared formal File move(Nil target);
    
    "Move this file to the given location,
     overwriting the target if it already exists."
    shared formal File moveOverwriting(File|Nil target);
    
    "Copy this file to the given location."
    shared formal File copy(Nil target,
            "Copy attributes of the original file."
            Boolean copyAttributes=false);
    
    "Copy this file to the given location,
     overwriting the target if it already exists."
    shared formal File copyOverwriting(File|Nil target,
            "Copy attributes of the original file."
            Boolean copyAttributes=false);
    
    "Create a hard link to this file."
    shared formal File createLink(Nil target);
    
    "Create a symbolic link to this file."
    shared formal Link createSymbolicLink(Nil target);
    
    "Determine if this file may be written to."
    shared formal Boolean writable;
    
    "Determine if this file may be read from."
    shared formal Boolean readable;
    
    "Determine if this file may be executed."
    shared formal Boolean executable;
    
    "The name of this file."
    shared formal String name;
    
    "The size of this file, in bytes."
    shared formal Integer size;
    
    "Determine if this file is considered hidden."
    shared formal Boolean hidden;
    
    "Determine the content type of this file, if
     possible."
    shared formal String? contentType;
    
    "The timestamp of the last modification of this 
     file."
    shared formal variable Integer lastModifiedMilliseconds;
    
    "The store to which this file belongs."
    shared formal Store store;
    
    "A `Reader` for reading lines of text from this
     file."
    shared formal class Reader(
            "The character encoding to use, where
             `null` indicates that the platform 
             default character encoding should be
             used."
            String? encoding = null,
            Integer bufferSize = 8192)
                satisfies AbstractReader {}
    
    "A `Writer` for writing text to this file, after
     truncating the file to length 0."
    shared formal class Overwriter(
            "The character encoding to use, where
             `null` indicates that the platform 
             default character encoding should be
             used."
            String? encoding=null,
            Integer bufferSize = 8192) 
                satisfies AbstractWriter {}
    
    "A `Writer` for appending text to this file"
    shared formal class Appender(
            "The character encoding to use, where
             `null` indicates that the platform 
             default character encoding should be
             used."
            String? encoding = null,
            Integer bufferSize = 8192) 
                satisfies AbstractWriter {}
    
    "A `Reader` for reading lines of text from this
     file."
    deprecated ("Use [[Reader]] instead.")
    shared AbstractReader reader(
            "The character encoding to use, where
             `null` indicates that the platform 
             default character encoding should be
             used."
            String? encoding=null)
                => Reader(encoding);
    
    "A `Writer` for writing text to this file, after
     truncating the file to length 0."
    deprecated ("Use [[Overwriter]] instead.")
    shared AbstractWriter writer(
            "The character encoding to use, where
             `null` indicates that the platform 
             default character encoding should be
             used."
            String? encoding=null)
                => Overwriter(encoding);
    
    "A `Writer` for appending text to this file"
    deprecated ("Use [[Appender]] instead.")
    shared AbstractWriter appender(
            "The character encoding to use, where
             `null` indicates that the platform 
             default character encoding should be
             used."
            String? encoding=null)
                => Appender(encoding);
    
}

"All lines of text in the given file."
shared String[] lines(File file) {
    try (reader = file.Reader()) {
        return { reader.readLine() }.cycled
            .takeWhile((line) => line exists)
            .coalesced
            .sequence();
    }
}

"Call the given function for each line of 
 text in the given file. 
 
 For example, to print the contents of the
 file:
 
     forEachLine(file, print);
 
 Or:
 
     forEachLine(file, (line) {
         print(line);
     });
 "
shared void forEachLine(File file, void do(String line)) {
    try (reader = file.Reader()) {
        while (exists line = reader.readLine()) {
            do(line);
        }
    }
}

"Return a [[File]], creating a new file if the given 
 resource is [[Nil]], or returning the given [[File]]
 otherwise."
shared File createFileIfNil(File|Nil res) { 
    switch (res)
    case (File) { return res; }
    case (Nil) { return res.createFile(); }
}

"Copy lines from [[one file|from]] to [[a second file|to]],
 appending to the second file."
shared void readAndAppendLines(File from, File to,
        "A transformation to apply to each line of text."
        String replacing(String line) => line) {
    try (reader = from.Reader(), writer = to.Appender()) {
        copyLines(reader, writer, replacing);
    }
}

"Copy lines from [[one file|from]] to [[a second file|to]],
 overwriting the second file."
shared void readAndOverwriteLines(File from, File to, 
        "A transformation to apply to each line of text."
        String replacing(String line) => line) {
    try (reader = from.Reader(), writer = to.Overwriter()) {
        copyLines(reader, writer, replacing);
    }
}

void copyLines(Reader reader, Writer writer, 
        String replacing(String line)) {
    while (exists line = reader.readLine()) {
        writer.writeLine(replacing(line));
    }
}

"Determines if the two given [[File]] objects represent the
 same file."
shared Boolean sameFile(File x, File y) => sameFileInternal(x, y);