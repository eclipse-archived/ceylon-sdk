doc "Classes satisfying this interface have direct access to log. Class name is used for logger name."
by "Matej Lazar"
shared interface LogSupport {
    shared Log log => logInstance(className(this));
}