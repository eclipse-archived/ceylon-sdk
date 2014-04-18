package com.redhat.ceylon.testjvm;

import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.net.Socket;
import java.net.UnknownHostException;
import java.util.NoSuchElementException;
import java.util.Scanner;

// workarounds for java interoperability
public class Util {
    
	public static Socket createSocket(String host, int port) throws UnknownHostException, IOException {
		return new Socket(host, port);
	}

	public static PrintWriter createPrintWriter(Socket socket) throws IOException {
		return new PrintWriter(socket.getOutputStream());
	}
    
    public static void setColor(int colorCode) {
        try (InputStream is = Runtime.getRuntime().exec("tput setaf " + colorCode).getInputStream();
             Scanner scanner = new Scanner(is)) {
            scanner.useDelimiter("\\A");
            System.out.print(scanner.next());
        } catch (IOException | NoSuchElementException e) {
            // no terminal support for colors
        }
    }
	
}