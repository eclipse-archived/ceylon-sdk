package ceylon.math.whole;

class WordsUtils {

    public static long get(long[] array, long index) {
        // faster than standard routine that performs an overflow check
        return array[(int) index];
    }

    public static void set(long[] array, long index, long value) {
        // faster than standard routine that performs an overflow check
        array[(int) index] = value;
    }

}
