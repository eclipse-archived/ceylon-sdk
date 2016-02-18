"Provides a ServletContextListener for initializing the
 Ceylon runtime when a Ceylon WAR is loaded by a Servlet
 container. This module will automatically be added to a
 WAR when it is created - you should never need to import
 this module directly."
native("jvm")
module com.redhat.ceylon.war "1.2.2" {
    import java.base "7";
    import com.redhat.ceylon.common "1.2.2";
    import com.redhat.ceylon.tool.provider "1.2.2";
    import javax.servlet "3.1.0";
}
