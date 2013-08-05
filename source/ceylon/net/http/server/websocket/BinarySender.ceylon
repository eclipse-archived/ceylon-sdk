import ceylon.io.buffer { ByteBuffer }

by("Matej Lazar")
shared interface FragmentedBinarySender {

    shared formal void sendBinary(ByteBuffer payload, Boolean finalFrame = false);

    shared formal void sendBinaryAsynchronous(ByteBuffer payload, SendCallback? sendCallback, Boolean finalFrame = false);
}
