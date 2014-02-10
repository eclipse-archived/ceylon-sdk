"""Defines a platform-neutral API for writing and reading
   application preferences.  
   
   The default implementation is only for the JVM 
   (Java Virtual Machine) and uses the backing store defined
   through the [[package java.util.prefs]] API.  By default, this
   API uses the Windows(TM) registry on Windows and uses a 
   directory- and file-based store on other operating systems.
   
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
       userPreferences(`module hello`).put("key.something", pref);
       userPreferences(`module hello`).get("key.something");"""
module ceylon.preference "1.0.0" {
    import java.prefs "7";
    shared import ceylon.collection "1.0.0";
}
