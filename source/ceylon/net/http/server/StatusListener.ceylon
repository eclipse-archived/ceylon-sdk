"Listeners are called on httpd status changes. Statuses 
 are: [[starting]], [[started]], [[stoping]], [[stopped]]."
by("Matej Lazar")
//TODO see(Status)
shared interface StatusListener {
    
    "Called on status change with a new status."
    shared formal void onStatusChange(Status status);
    
}
