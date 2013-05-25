package ceylon.logging.internal;

import java.util.logging.Level;

public class JLevelAdapter extends Level {

    private static final long serialVersionUID = 1L;

    public JLevelAdapter(String name, int value) {
        super(name, value);
    }
}
