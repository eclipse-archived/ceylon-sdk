by "Matej Lazar"
doc "Listeners are called on httpd status changes. Statuses are: staring, started, stoping, stopped."
see (HttpdStatus)
shared interface HttpdStatusListerner {
    
    doc "Called on status change with a new status parameter."
    shared formal void onStatusChange(HttpdStatus status);
}