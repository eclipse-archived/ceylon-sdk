package com.redhat.ceylon.test.eclipse;

import java.io.IOException;
import java.io.ObjectOutputStream;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.net.Socket;
import java.net.UnknownHostException;
import java.util.List;

// workarounds for java interoperability
public class Util {

	public static Socket createSocket(String host, int port) throws UnknownHostException, IOException {
		return new Socket(host, port);
	}

	public static ObjectOutputStream createObjectOutputStream(Socket socket) throws IOException {
		return new ObjectOutputStream(socket.getOutputStream());
	}
	
    public static String convertThrowable(Throwable t) {
        if (t != null) {
            StringWriter sw = new StringWriter();
            PrintWriter pw = new PrintWriter(sw);
            t.printStackTrace(pw);
            return sw.toString();
        }
        return null;
    }
    
    public static TestElement[] convertToArray(List<TestElement> testElements) {
    	return testElements.toArray(new TestElement[] {});
    }
	
}