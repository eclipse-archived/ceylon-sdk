/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import java.io {
    IOException,
    OutputStreamWriter
}
import java.lang {
    InterruptedException,
    Thread
}
import java.net {
    Socket
}

native
SocketFacade? connectSocket(Integer? port);

native("jvm")
SocketFacade? connectSocket(Integer? port) {
    return if (exists port) then SocketFacadeJvm.connect(port) else null;
}

native("js")
SocketFacade? connectSocket(Integer? port) {
    return if (exists port) then SocketFacadeJs.connect(port) else null;
}

interface SocketFacade {
    
    shared formal void write(String data);
    
    shared formal void close();
    
}

native("jvm")
class SocketFacadeJvm satisfies SocketFacade {
    
    Socket socket;
    OutputStreamWriter writer;
    
    shared new connect(Integer port) {
        String? host = null;
        variable Exception? lastException = null;
        
        for (value i in 0..10) {
            try {
                value s = Socket(host, port);
                value w = OutputStreamWriter(s.outputStream, "UTF-8");
                socket = s;
                writer = w;
                break;
            } catch (IOException e) {
                lastException = e;
            }
            try {
                Thread.sleep(1000);
            } catch (InterruptedException e) {
                // noop
            }
        }
        else {
            throw Exception("failed connect to port ``port``", lastException);
        }
        
    }
    
    shared actual void write(String data) {
        writer.write(data);
        writer.write('\{END OF TRANSMISSION}'.integer);
        writer.flush();
    }
    
    shared actual void close() {
        try {
            writer.close();
        } catch (IOException e) {
            // noop
        }
        try {
            socket.close();
        } catch (IOException e) {
            // noop
        }
    }
    
}

native("js")
class SocketFacadeJs satisfies SocketFacade {
    
    dynamic socket;
    
    shared new connect(Integer port) {
        dynamic {
            dynamic net = require("net");
            socket = net.connect(port);
            socket.setNoDelay(true);
        }
    }
    
    shared actual void write(String data) {
        dynamic {
            socket.write(data);
            socket.write("\{END OF TRANSMISSION}");
        }
    }
    
    shared actual void close() {
        dynamic {
            if (socket exists) {
                socket.end();
            }
        }
    }
    
}
