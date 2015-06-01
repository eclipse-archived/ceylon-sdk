"A JSON value, a [[String]], [[Boolean]], [[Integer]],
 [[Float]], JSON [[Object]], JSON [[Array]], or 
 [[Null]]."
shared alias Value 
        => ObjectValue|Null;

"A JSON value, a [[String]], [[Boolean]], [[Integer]],
 [[Float]], JSON [[Object]], or JSON [[Array]].
 
 This means [[Value]] except [[Null]]."
shared alias ObjectValue
		=> String | Boolean | Integer | Float |
		Object | Array;