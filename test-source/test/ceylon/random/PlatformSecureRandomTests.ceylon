import ceylon.random {
    platformSecureRandom,
    Random
}
import ceylon.test.engine {
    TestSkippedException
}

shared
class PlatformSecureRandomTests() extends StandardTests(
        newSecureRandom, 32, 3.890592) {}

Random newSecureRandom() {
    if (exists result = platformSecureRandom()) {
        return result;
    }
    else {
        throw TestSkippedException("Platform secure random not available");
    }
}
