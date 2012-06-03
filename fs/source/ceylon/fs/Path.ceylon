import java.lang { System { getProperty } }
import ceylon.fs.internal { newPath=path, allRoots=roots }

shared abstract class Path() satisfies Comparable<Path> {
    shared formal Path parent;
    shared formal Path childPath(String|Path subpath);
    shared formal Path siblingPath(String|Path subpath);
    shared formal Path absolutePath;
    shared formal Path normalizedPath;
    shared formal Path relativePath(String|Path path);
    shared formal Path[] elementPaths;
    shared formal String[] elements;
    shared formal Boolean absolute;
    shared formal Resource resource;
    shared formal Boolean parentOf(Path path);
    shared formal Boolean childOf(Path path);
}

shared Path path(String pathString) = newPath;

shared Path home = path(getProperty("user.home"));

shared Path[] roots = allRoots;
