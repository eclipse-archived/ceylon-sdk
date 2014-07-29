
"Represents an Internet socket address, consisting of
 an [[IP address or host name|address]] together with
 a [[TCP port|port]]."
by("Stéphane Épardaud")
shared class SocketAddress(address, port) {
    
    "The host name or IP part of that internet socket 
     address."
    shared String address;

    "The TCP port part of that internet socket address."
    shared Integer port;
}