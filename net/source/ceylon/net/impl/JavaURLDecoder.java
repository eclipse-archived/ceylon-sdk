package ceylon.net.impl;

import java.io.UnsupportedEncodingException;

public class JavaURLDecoder {
	
	public static String decodeURL(String string) throws UnsupportedEncodingException {
		if (string == null) {
			return null;
		}
		byte[] array = string.getBytes("ASCII");
		int w = 0;
		for(int r=0;r<array.length;r++, w++){
			byte b = array[r];
			if(b == '%'){
				// must read next two chars
				if(r+2 >= array.length)
					throw new RuntimeException("Missing hex numbers");
				byte first = array[++r];
				byte second = array[++r];
				array[w] = (byte)(fromHex(first) * 16 + fromHex(second));
			}else
				array[w] = b;
		}
		return new String(array, 0, w, "ASCII");
	}

	private static byte fromHex(byte b) {
		if(b >= '0' && b <= '9')
			return (byte)(b - '0');
		if(b >= 'A' && b <= 'F')
			return (byte)(10 + b - 'A');
		if(b >= 'a' && b <= 'f')
			return (byte)(10 + b - 'a');
		throw new RuntimeException("Invalid hex number: "+b);
	}

}
