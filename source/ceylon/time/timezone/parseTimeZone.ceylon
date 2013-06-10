
shared TimeZone parseTimeZone(String zoneId) {
    variable State state = initial;
    while ()
    return nothing;
}

abstract class State() of initial | zulu | sign | hours | colon | minutes | final | error {
    shared formal [Integer, State] next(Character character);
}

object initial extends State() {
    shared actual [Integer, State] next(Character character) {
        if (character == 'Z') {
            return [0, zulu];
        }
        if (character == '+') {
            return [+1, sign];
        }
        if (character == '-') {
            return [-1, sign];
        }
    }
}

object zulu extends State() {}
object sign extends State() {}
object hours extends State() {}
object colon extends State() {}
object minutes extends State() {}
object final extends State() {}
object error extends State() {}
