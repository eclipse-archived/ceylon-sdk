"Represents the type of the `null` value in JSON."
shared abstract class NullInstance() of nil {}

"The singleton that represents the `null` value in JSON`."
shared object nil extends NullInstance() {
    shared actual String string = "null";
}