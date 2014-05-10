import ceylon.test.core { DefaultLoggingListener }

deprecated("use [[DefaultLoggingListener]]")
shared class SimpleLoggingListener(void write(String line) => print(line)) => DefaultLoggingListener(write);