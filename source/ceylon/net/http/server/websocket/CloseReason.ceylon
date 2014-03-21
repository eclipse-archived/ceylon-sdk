by("Matej Lazar")
shared class CloseReason(code, reason = null) {

    shared Integer code;

    shared String? reason;

    if (!isValid(code)) {
        throw Exception("Invalid close status code ``code``");
    }
}

/*
* For the exact meaning of the codes refer to the <a href="http://tools.ietf.org/html/rfc6455#section-7.4">WebSocket
* RFC Section 7.4</a>.
*/
shared class NoReason(String? reason = null) extends CloseReason(0) {}
shared class NormalClosure(String? reason = null) extends CloseReason(1000, reason) {}
shared class GoingAway(String? reason = null) extends CloseReason(1001, reason) {}
shared class ProtocolError(String? reason = null) extends CloseReason(1003, reason) {}
shared class MessageContainsInvalidData(String? reason = null) extends CloseReason(1007, reason) {}
shared class MessageViolatesPolicy(String? reason = null) extends CloseReason(1008, reason) {}
shared class MessageToBig(String? reason = null) extends CloseReason(1009, reason) {}
shared class MissingExtension(String? reason = null) extends CloseReason(1010, reason) {}
shared class UnexpectedError(String? reason = null) extends CloseReason(1011, reason) {}

Boolean isValid(Number code) {
    value intCode = code.integer;
    if (intCode > 0 && intCode <= 999 || intCode >= 1004 && intCode <= 1006
            || intCode >= 1012 && intCode <= 2999) {
        return false;
    }
    return true;
}
