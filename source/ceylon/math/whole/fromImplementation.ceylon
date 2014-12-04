import java.math {
    BigInteger
}

"Converts a platform-specific implementation object to a
 `Whole` instance. This is provided for interoperation
 with the runtime platform."
//see(Whole.implementation)
shared Whole fromImplementation(Object implementation) {
    // FIXME move to Java interop?
    assert (is BigInteger implementation);
    return nothing;
}
