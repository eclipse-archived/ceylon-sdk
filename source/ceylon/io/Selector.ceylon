/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.io.impl {
    SelectorImpl
}

"Supports registration of listeners that are notified of 
 events raised directly by the operating system, of the 
 following kinds:
 
 - read,
 - write,
 - connect, and
 - accept.
 
 A listener may be registered for:
 
 - read/write events on [[SelectableFileDescriptor]],
 - accept events on [[ServerSocket]], or
 - connect events on [[SocketConnector]].
 
 The listener will then be notified by this selector when 
 you invoke [[process]] until there are no more listeners.
 
 Every listener can signal the selector object that it is no 
 longer interested in notifications by returning `false` 
 when invoked, except for `connect` listeners which are only 
 notified once (since a given [[Socket]] is connected once
 at most ). 
 
 Listeners should be registered with:
 
 - [[addConsumer]] for `read` events,
 - [[addProducer]] for `write` events,
 - [[addConnectListener]] for `connect` events, and
 - [[addAcceptListener]] for `accept` events.
 
 A new instance of `Selector` may be obtained by calling
 [[newSelector]]."
see(`function newSelector`)
by("Stéphane Épardaud")
shared sealed interface Selector {
    
    "Invokes all the listeners that are ready to be notified, 
     until there are no more listeners. This method will 
     block until every registered listener has signaled to 
     this selector that it is no longer interested in events 
     by returning `false` when invoked, except for `connect` 
     listeners which are only notified once (since you can 
     only connect a [[Socket]] once).
     
     Listeners should be registered with:
     
     - [[addConsumer]] for `read` events,
     - [[addProducer]] for `write` events,
     - [[addConnectListener]] for `connect` events, and
     - [[addAcceptListener]] for `accept` events.
     "
    shared formal void process();
    
    "Registers a `read` listener on the given 
     [[SelectableFileDescriptor]].
     
     The given [[callback]] will be invoked by [[process]] 
     whenever there is data ready to be read from the 
     specified [[socket]] without blocking.
     
     If your listener is no longer interested in `read` 
     events from this selector, it should return `false`."
    shared formal void addConsumer(FileDescriptor socket, 
        Boolean callback(FileDescriptor s));

    "Registers a `write` listener on the given 
     [[SelectableFileDescriptor]]. The given [[callback]] 
     will be invoked by [[process]] whenever there is data 
     ready to be written to the specified [[socket]] without 
     blocking.
     
     If the callback is no longer interested in `write` 
     events from this selector, it should return `false`."
    shared formal void addProducer(FileDescriptor socket, 
        Boolean callback(FileDescriptor s));

    "Registers a `connect` listener on the given 
     [[SocketConnector]]. The given [[callback function|connect]] 
     will be invoked by [[process]] as soon as the given 
     [[socketConnector]] can be connected without blocking. 
     If [[callback function|failureCallback]] is given, it 
     is called if the connection attempt fails.
     
     Only either callback function will be invoked, exactly once."
    shared formal void addConnectListener(SocketConnector socketConnector,
        void connect(Socket s), Anything(Exception)? failureCallback = null);

    "Registers an `accept` listener on the given 
     [[ServerSocket]]. The given [[callback function|accept]] 
     will be invoked by [[process]] whenever there is a
     [[Socket]] ready to be accepted from the specified 
     [[socketAcceptor]] without blocking.
     
     If the callback is no longer interested in `accept` 
     events from this selector, it should return `false`.
     "
    shared formal void addAcceptListener(ServerSocket socketAcceptor, 
        Boolean accept(Socket s));
}

"Creates a new [[Selector]]."
see(`interface Selector`)
shared Selector newSelector() => SelectorImpl();
