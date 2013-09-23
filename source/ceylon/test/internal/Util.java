package ceylon.test.internal;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

public class Util {

	// temporary workaround, until metamodel will not support "unsafe invoke"
	public void invoke(Object instance, String methodName) {
		try {
			Method method = instance.getClass().getMethod(methodName, new Class[] {});
			method.invoke(instance);
		} catch (InvocationTargetException e) {
			if (e.getTargetException() instanceof RuntimeException) {
				throw (RuntimeException) e.getTargetException();
			} else {
				throw new RuntimeException(e.getTargetException());
			}
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}

}