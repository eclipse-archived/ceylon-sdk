import ceylon.json.stream {
    StreamParser,
    KeyEvent,
    ObjectStartEvent,
    ObjectEndEvent,
    ArrayStartEvent,
    ArrayEndEvent,
    LookAhead,
    Event
}
import ceylon.json {
    StringTokenizer
}
import ceylon.collection {
    ArrayList
}
class Order(address, items) {
    shared String address;
    shared Item[] items;
}
class Item(sku, quantity) {
    shared String sku;
    shared Integer quantity;
}
String exampleJson = 
"""
   {
     "address":"",
     "items":[
       {
         "sku":"123-456-789",
         "quantity":4
       },
       {
         "sku":"456-789",
         "quantity":20
       }
     ]
   }
""";

class OrderParser() {
    
    late variable LookAhead<Event> stream;

    String missingKey(String container, String key) {
        return "``container``: '``key``' missing at line ``stream.line``'";
    }
    String duplicateKey(String container, String key) {
        return "``container``: '``key``' occurs more than once at line ``stream.line``'";
    }
    String keyType(String container, String key, String expectedType) {
        return "``container``: '``key``' key is supposed to be of ``expectedType`` type at line ``stream.line``";
    }
    String unexpectedKey(String container, String key) {
        return "``container``: '``key``' key not supported at line ``stream.line``";
    }
    String unexpectedEvent(String container, Event|Finished event) {
        return "``container``: unexpected event ``event else "null"`` at line ``stream.line``";
    }
    
    "Parses an item from events read from the given parser.
     Returns the item or an error explanation."
    Item|String parseItem() {
        if (!(stream.next() is ObjectStartEvent)) {
            return "Item: should be a JSON object";
        }
        variable String? sku = null;
        variable Integer? quantity = null;
        while(true) {
            switch(event=stream.next())
            case (is KeyEvent) {
                switch(key=event.key) 
                case ("sku") {
                    if (is String s = stream.next()) {
                        if (sku exists) {
                            return duplicateKey("Item", "sku");
                        }
                        sku = s;
                    } else {
                        return keyType("Item", "sku", "String");
                    }
                }
                case ("quantity") {
                    if (is Integer s = stream.next()) {
                        if (quantity exists) {
                            return duplicateKey("Item", "quantity");
                        }
                        quantity = s;
                    } else {
                        return keyType("Item", "sku", "Integer");
                    }
                }
                else {
                    return unexpectedKey("Item", key);
                }
            }
            case (is ObjectEndEvent) {
                if (exists s=sku) {
                    if (exists q=quantity) {
                        return Item(s, q);
                    }
                    return missingKey("Item", "quantity");
                }
                return missingKey("Item", "sku");
            }
            else {
                return unexpectedEvent("Item", event);
            }
        }
    }
    
    "Parses an order from events read from the given parser.
     Returns the order or an error explanation."
    Order|String parseOrder() {
        if (!(stream.next() is ObjectStartEvent)) {
            return "Order: should be a JSON object";
        }
        variable String? address = null;
        value items = ArrayList<Item>();
        while(true) {
            switch(event=stream.next())
            case (is KeyEvent) {
                switch(key=event.key) 
                case ("address") {
                    if (is String s = stream.next()) {
                        if (address exists) {
                            return duplicateKey("Order", "address");
                        }
                        address = s;
                    } else {
                        return keyType("Order", "address", "String");
                    }
                }
                case ("items") {
                    if (!items.empty) {
                        return duplicateKey("Order", "items");
                    }
                    if (!stream.next() is ArrayStartEvent) {
                        return keyType("Order", "items", "Array");
                    }
                    while (stream.peek(1) is ObjectStartEvent) {
                        switch (item=parseItem())
                        case (is String) {
                            return item;
                        }
                        case (is Item) {
                            items.add(item);
                        }
                    }
                    assert(stream.next() is ArrayEndEvent);
                }
                else {
                    return unexpectedKey("Order", key);
                }
            }
            case (is ObjectEndEvent) {
                if (exists a=address) {
                    return Order(a, items.sequence());
                }
                return missingKey("Order", "address");
            }
            else {
                return unexpectedEvent("Item", event);
            }
        }
    }
    
    shared Order|String parse(String json) {
        stream = LookAhead(StreamParser(StringTokenizer(json)));
        return parseOrder();
    }
}
shared void run() {
    value op = OrderParser();
    print(op.parse(exampleJson));
    print(op.parse("""
                       {
                         "address":"",
                         "items":[
                           {
                             "sku":"123-456-789",
                             "quantity":4
                           },
                           {
                             "sku":"456-789",
                             "quantity":20
                           }
                         ]
                       }
                    """));
}
