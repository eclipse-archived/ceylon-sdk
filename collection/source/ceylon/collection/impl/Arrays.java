package ceylon.collection.impl;

import java.lang.reflect.Array;

public class Arrays {
	public static <T> T[] makeCellArray(int length) throws ClassNotFoundException{
		Class<T> klass = (Class<T>) Class.forName("ceylon.collection.Cell");
		return (T[]) Array.newInstance(klass, length);
	}
}
