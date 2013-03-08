package ceylon.net.http.server.internal;

import java.io.IOException;
import java.net.InetSocketAddress;

import org.xnio.ChannelListener;
import org.xnio.OptionMap;
import org.xnio.XnioWorker;
import org.xnio.channels.AcceptingChannel;
import org.xnio.channels.ConnectedChannel;
import org.xnio.channels.ConnectedStreamChannel;

/**
 * @author Matej Lazar
 */
//TODO remove me
public class JavaHelper {

    /**
     * Remove wildcard type from retun type.
     * Workaround for: type argument to invariant type parameter in assignability condition not yet supported (until we implement reified generics)
     */
    @SuppressWarnings("unchecked")
    public static AcceptingChannel<ConnectedChannel> createStreamServer(
            XnioWorker worker,
            InetSocketAddress bindAddress,
            ChannelListener<AcceptingChannel<ConnectedStreamChannel>> acceptListener,
            OptionMap optionMap) throws IOException {
    	
        @SuppressWarnings("rawtypes")
        AcceptingChannel acceptingChannel = worker.createStreamServer(bindAddress, acceptListener, optionMap);
        return acceptingChannel;
    }
}
