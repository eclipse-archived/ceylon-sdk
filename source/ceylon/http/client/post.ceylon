import ceylon.buffer.charset {
	utf8
}
import ceylon.http.client {
	Request
}
import ceylon.http.common {
	p=post
}
import ceylon.uri {
	Uri,
	Parameter
}

"Returns an HTTP POST request for the given Uri"
shared Request post(Uri uri, {Parameter*} parameters = empty) => Request(uri, p, null, "application/octet-stream", utf8, parameters);
