import ceylon.net.iop { eq }
import ceylon.collection { StringBuilder }

"Represents a URI Authority part (user, password, host and port)"
by("Stéphane Épardaud")
shared class Authority(user = null, password = null, host = null, port = null){
    
    "The optional user"
    shared variable String? user;

    "The optional password"
    shared variable String? password;

    "The optional host"
    shared variable String? host;

    "True if the host name is an ipLiteral (IPV6 or later) and has to be represented 
     surrounded by [] (square brackets)"
    shared variable Boolean ipLiteral = false;
    
    "The optional port number"
    shared variable Integer? port;
    
    "Returns true if the authority part is present (if the host is not null)"
    shared Boolean specified {
        return host exists;
    }
    
    "Returns an externalisable (percent-encoded) representation of this part"    
    shared actual String string {
        return toRepresentation(false);
    }

    "Returns a human (non parseable) representation of this part"    
    shared String humanRepresentation {
        return toRepresentation(true);
    }

    "Returns either an externalisable (percent-encoded) or human (non parseable) representation of this part"    
    shared String toRepresentation(Boolean human) {
        if(exists String host = host){
            StringBuilder b = StringBuilder();
            if(exists String user = user){
                b.append(human then user else percentEncoder.encodeUser(user));
                if(exists String password = password){
                    b.appendCharacter(':');
                    b.append(human then password else percentEncoder.encodePassword(password));
                }
                b.appendCharacter('@');
            }
            if(ipLiteral){
                b.append("[");
                b.append(host);
                b.append("]");
            }else{
                b.append(human then host else percentEncoder.encodeRegName(host));
            }
            if(exists Integer port = port){
                b.appendCharacter(':');
                b.append(port.string);
            }
            return b.string;
        }
        return "";
    }
    
    "Returns true if the given object is the same as this object"
    shared actual Boolean equals(Object that) {
        if(is Authority that){
            if(this === that){
                return true;
            }
            return eq(user, that.user)
                && eq(password, that.password)
                && eq(host, that.host)
                && eq(port, that.port)
                && ipLiteral == that.ipLiteral;
        }
        return false;
    }
    
    shared actual Integer hash {
        variable value hash = 1;
        hash = 31*hash + (user?.hash else 0);
        hash = 31*hash + (password?.hash else 0);
        hash = 31*hash + (host?.hash else 0);
        hash = 31*hash + (port?.hash else 0);
        hash = 31*hash + ipLiteral.hash;
        return hash;
    }
}
