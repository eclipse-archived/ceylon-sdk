"""Defines a platform-neutral API for writing and reading
   application preferences.  
   
   The default implementation for the JVM (Java Virtual Machine) 
   uses [[package java.util.prefs]] and the default (or other) 
   backing store defined by the JVM.
   
   The alternate (currently Javascript) implementation does not
   back on to a store and is entirely within the process context
   and memory (e.g. a browser session).
   
   Two maps are provided: 
   * [[userPreferences]] 
   * [[systemPreferences]].
   
   Operating systems and backing stores may limit write access to one
   or both of these stores.
   
   The following preference types are supported: 
   * [[String]] 
   * [[Boolean]]
   * [[Integer]]
   * [[Float]]  
   
   Preferences are stored under a module's
   full name and a "/" at the beginning of a key will be ignored.
      
   Usage: 
       userPreferences(`module hello`).put(...);"""
module ceylon.preference "1.0.0" {
    import java.prefs "7";
    shared import ceylon.collection "1.0.0";
}
