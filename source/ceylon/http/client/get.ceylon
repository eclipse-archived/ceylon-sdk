import ceylon.uri { Uri }

"Returns an HTTP GET request for the given Uri"
shared Request get(Uri uri) => Request(uri);
