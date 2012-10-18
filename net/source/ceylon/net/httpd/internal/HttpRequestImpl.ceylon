import ceylon.net.httpd { HttpRequest }
import io.undertow.server { HttpServerExchange }
import java.util { Deque }
import java.lang { JString = String }

shared class HttpRequestImpl(HttpServerExchange exchange) satisfies HttpRequest {
	
	Map<String,String> paramaters = parseQueryParameters(exchange.queryString);
	
	shared actual String? header(String name) {
		return exchange.requestHeaders.getFirst(name);
	}

	shared actual String[] headers(String name) {
		Deque<JString> headers = exchange.requestHeaders.get(name);
		SequenceBuilder<String> sequenceBuilder = SequenceBuilder<String>();

		value it = headers.iterator();
		while (exists header = it.next()) {
			sequenceBuilder.append(header.string);
		}
		
		return sequenceBuilder.sequence;
	}

	shared actual String? parameter(String name) {
		return paramaters.item(name);
	}

	shared actual String url() {
		return exchange.requestURL;
	}
	
	shared actual String path() {
		return exchange.requestPath;
	}

	
}