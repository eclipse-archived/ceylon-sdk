"A future value."
by("Julien Viet")
shared interface Future<out Value> {

	"Returns the value if it is present otherwise it returns null.
	 This call does not block."
	shared formal <Value|Throwable>? peek();

	"Block until:
       - the value is available
       - the thread is interrupted
       - an optional timeout occurs
     When the timeout occurs an exception is thrown."
	shared formal Value|Throwable get(
		doc("The timeout in milliseconds, a negative value means no timeout")
		Integer timeOut = -1);

}
