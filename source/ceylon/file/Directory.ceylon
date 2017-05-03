import ceylon.file.internal {
    temporaryDirectoryInternal=temporaryDirectory
}

"Represents a directory in a hierarchical file system."
shared sealed interface Directory 
        satisfies ExistingResource {

    "The name of this directory."
    shared formal String name;

    "The files and subdirectories that directly belong
     to this directory."
    shared formal {ExistingResource*} children(
            "A filter to apply to the file names,
             expressed as a glob pattern."
            String filter="*");
    
    "The files that directly belong to this directory."
    shared formal {File*} files(
            "A filter to apply to the file names,
             expressed as a glob pattern."
            String filter="*");    
    
    "The subdirectories that directly belong to this 
     directory."
    shared formal {Directory*} childDirectories(
            "A filter to apply to the file names,
             expressed as a glob pattern."
            String filter="*");
    
    "The paths of all files and subdirectories that 
     directly belong to this directory."
    shared formal {Path*} childPaths(
            "A filter to apply to the file names,
             expressed as a glob pattern."
            String filter="*");
    
    "Obtain a resource belonging to this directory."
    shared formal Resource childResource(Path|String subpath);
    
    "Move this directory to the given location."
    shared formal Directory move(Nil target);

    "A new temporary [[Directory]]. `TemporaryDirectory`s may be used within resource
     expressions:

         try (tempDirectory = temporaryDirectory.TemporaryDirectory()) {
             // ...
         }

     If possible, a `TemporaryDirectory` will be deleted upon invocation of its
     [[destroy()]] method."
    throws (`class Exception`,
        "If the prefix cannot be used to generate a directory name,
         an I/O error occurs, or the parent directory is not
         specified and a suitable temporary directory cannot be
         determined.")
    shared formal class TemporaryDirectory(
        "The leading part of the temporary directory name to use,
         or `null` for the system default."
        String? prefix)
        satisfies Directory & Destroyable {}

    "A new temporary [[File]]. `TemporaryFile`s may be used within resource
     expressions:

         try (tempFile = temporaryDirectory.TemporaryFile()) {
             // ...
         }

     If possible, a `TemporaryFile` will be deleted upon invocation of its
     [[destroy()]] method."
    throws (`class Exception`,
        "If the prefix or suffix cannot be used to generate a file
         name, an I/O error occurs, or a parent directory is not
         specified and a suitable temporary directory cannot be
         determined.")
    shared formal class TemporaryFile(
            "The leading part of the temporary file name to use, or
             `null` for the system default."
            String? prefix,
            "The trailing part of the temporary file name to use, or
             `null` for the system default."
            String? suffix)
            satisfies Destroyable & File {}
}

"The `Directory`s representing the root directories of
 the default file system."
see(`value defaultSystem`)
shared Directory[] rootDirectories
    =>  [ for (p in rootPaths)
          if (is Directory r=p.resource)
          r ];

"The system default temporary directory."
shared Directory temporaryDirectory = temporaryDirectoryInternal();
