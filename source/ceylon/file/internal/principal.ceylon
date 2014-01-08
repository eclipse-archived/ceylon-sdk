import ceylon.file {
    NoSuchPrincipalException
}

import java.nio.file {
    JPath=Path
}
import java.nio.file.attribute {
    UserPrincipalNotFoundException,
    UserPrincipal
}

UserPrincipal jprincipal(JPath jpath, String name) {
    value upls = jpath.fileSystem.userPrincipalLookupService;
    try {
        return upls.lookupPrincipalByName(name);
    }
    catch (UserPrincipalNotFoundException e) {
        throw NoSuchPrincipalException(name, e);
    }
}


