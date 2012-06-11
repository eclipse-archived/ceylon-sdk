package ceylon.process;

import java.io.File;
import java.lang.ProcessBuilder.Redirect;

public class Util {
	public static Redirect redirectInherit = Redirect.INHERIT;
	/*public static Redirect redirectPipe = Redirect.PIPE;*/
	public static Redirect redirectToOverwrite(File file) { return Redirect.to(file); }
	public static Redirect redirectToAppend(File file) { return Redirect.appendTo(file); }
}
