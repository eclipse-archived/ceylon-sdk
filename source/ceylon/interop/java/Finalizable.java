package ceylon.interop.java;

/**
 * An interface implemented by Ceylon objects that respond
 * to JVM finalization.
 *
 * @see Object#finalize()
 */
public interface Finalizable {
    /**
     * Called by the garbage collector when it determines
     * that there are no more references to this object.
     */
    void finalize();
}
