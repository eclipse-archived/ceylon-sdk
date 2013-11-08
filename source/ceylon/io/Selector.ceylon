import ceylon.io.impl { SelectorImpl }

"Represents a listener that can listen for read/write/connect/accept events
 directly from the operating system. 
 
 You can register listeners for :
 
 - read/write events on [[SelectableFileDescriptor]],
 - accept events on [[ServerSocket]],
 - connect events on [[SocketConnector]].
 
 Those listeners will then be called by this selector when you invoke [[process]] until
 there are no more listeners.
 
 Every listener can signal the selector object that it is no longer interested in
 notifications by returning `false` when invoked, except for `connect` listeners which
 are only notified once (since you can only connect a [[Socket]] once). 
 
 Listeners should be registered with:
 
 - [[addConsumer]] for `read` events,
 - [[addProducer]] for `write` events,
 - [[addConnectListener]] for `connect` events, and
 - [[addAcceptListener]] for `accept` events.
 
 You can instantiate new selectors with [[newSelector]].
 "
by("Stéphane Épardaud")
shared interface Selector {
    
    "Invokes all the listeners that are ready to be notified, until there are no more
     listeners. This method will block until every registered listener has signaled
     to this selector that it is no longer interested in events by returning `false`
     when invoked, except for `connect` listeners which are only notified once (since
     you can only connect a [[Socket]] once).
     
     Listeners should be registered with:
     
     - [[addConsumer]] for `read` events,
     - [[addProducer]] for `write` events,
     - [[addConnectListener]] for `connect` events, and
     - [[addAcceptListener]] for `accept` events.
     "
    shared formal void process();
    
    "Registers a `read` listener on the given [[SelectableFileDescriptor]].
     
     The given [[callback]] will be invoked by [[process]] whenever there is data
     ready to be read from the specified [[socket]] without blocking.
     
     If your listener is no longer interested in `read` events from this selector,
     it should return `false`.
     "
    shared formal void addConsumer(FileDescriptor socket, Boolean callback(FileDescriptor s));

    "Registers a `write` listener on the given [[SelectableFileDescriptor]].
     
     The given [[callback]] will be invoked by [[process]] whenever there is data
     ready to be written to the specified [[socket]] without blocking.
     
     If your listener is no longer interested in `write` events from this selector,
     it should return `false`.
     "
    shared formal void addProducer(FileDescriptor socket, Boolean callback(FileDescriptor s));

    "Registers a `connect` listener on the given [[SocketConnector]].
     
     The given [[connect]] will be invoked by [[process]] as soon as the
     specified [[socketConnector]] can be connected without blocking.
     
     Your listener will only be invoked once.
     "
    shared formal void addConnectListener(SocketConnector socketConnector, void connect(Socket s));

    "Registers an `accept` listener on the given [[ServerSocket]].
     
     The given [[accept]] will be invoked by [[process]] whenever there is a
     [[Socket]] ready to be accepted from the specified [[socketAcceptor]] without blocking.
     
     If your listener is no longer interested in `accept` events from this selector,
     it should return `false`.
     "
    shared formal void addAcceptListener(ServerSocket socketAcceptor, Boolean accept(Socket s));
}

"Returns a new selector object."
see(`interface Selector`)
shared Selector newSelector(){
    return SelectorImpl();
}
