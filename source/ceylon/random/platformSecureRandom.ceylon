import java.security {
    JSecureRandom=SecureRandom
}

"Returns an instance of [[Random]] backed by a platform
 specific secure random number generator.

 For the JVM, this function returns a [[Random]] that
 uses `java.security.SecureRandom` for random values.

 For the JavaScript VM, this function returns [[null]]."
shared native
Random? platformSecureRandom();

shared native("jvm")
Random? platformSecureRandom() => object
        satisfies Random {

    "The backing delegate."
    JSecureRandom delegate = JSecureRandom();

    shared actual Integer nextBits(Integer bits) {
        if (bits == 0) {
            return 0;
        } else if (bits < 31) {
            return delegate.nextInt(2 ^ bits);
        } else {
            return delegate.nextLong().rightLogicalShift(64 - bits);
        }
    }
};

shared native("js")
// TODO https://developer.mozilla.org/en-US/docs/Web/API/RandomSource
Random? platformSecureRandom() => null;
