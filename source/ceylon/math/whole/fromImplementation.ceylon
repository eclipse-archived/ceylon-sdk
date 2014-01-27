import java.math {
    BigInteger
}

"Converts a platform-specific implementation object to a 
 `Whole` instance. This is provided for interoperation 
 with the runtime platform."
//see(Whole.implementation)
shared Whole fromImplementation(Object implementation) {
    assert (is BigInteger implementation);
    return WholeImpl(implementation);
}