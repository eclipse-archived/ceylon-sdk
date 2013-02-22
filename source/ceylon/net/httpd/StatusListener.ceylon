by "Matej Lazar"
doc "Listeners are called on httpd status changes. Statuses 
     are: staring, started, stoping, stopped."
see (Status)
shared interface StatusListener {
    
    doc "Called on status change with a new status."
    shared formal void onStatusChange(Status status);
    
}
