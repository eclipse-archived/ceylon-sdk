package ceylon.net.impl;

import java.io.UnsupportedEncodingException;
import java.util.BitSet;

public class JavaURLEncoder {
	
	public static String encodePart(final String part, final String charset, final BitSet allowed) throws UnsupportedEncodingException {
		if (part == null) {
			return null;
		}
		// start at *3 for the worst case when everything is %encoded on one byte
		final StringBuffer encoded = new StringBuffer(part.length() * 3);
		// FIXME: make this work with code points (how?)
		final int[] toEncode = toCodePointArray(part);
		for (final int c : toEncode) {
			if (allowed.get(c)) {
				encoded.append(Character.toChars(c));
			}
			else {
				final byte[] bytes = String.valueOf(Character.toChars(c)).getBytes(charset);
				for (final byte b : bytes) {
					// make it unsigned
					final int u8 = b & 0xFF;
					encoded.append(String.format("%%%1$02X", u8));
				}
			}
		}
		return encoded.toString();
	}

	private static int[] toCodePointArray(String part) {
		int length = part.codePointCount(0, part.length());
		int[] codePoints = new int[length];
        for (int offset = 0, i = 0; offset < length; i++) {
            int codePoint = part.codePointAt(offset);
            codePoints[i] = codePoint;
            offset += java.lang.Character.charCount(codePoint);
        }
        return codePoints;
	}

}
