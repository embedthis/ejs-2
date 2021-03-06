/*
    Socket.es -- Socket I/O class
    Copyright (c) All Rights Reserved. See details at the end of the file.
 */

module ejs {

    /** 
        Client and server side TCP/IP support for IPv4 and IPv6 communications. This class supports broadcast, datagram and
        byte-stream socket sevices for both client and server endpoints. Aynchronous and asynchronous operation is supported.
        @spec ejs
        @stability prototype
     */
    class Socket implements Stream {

        use default namespace public

        /** 
            Create a socket object
         */
        native function Socket()

        /** 
            Receive a client socket. Accept must be called after invoking $listen.
            @returns A socket connected to the client endpoint.
         */
        native function accept(): Socket

        /** 
            Local IP address bound to this socket. Set to the address in dot notation or empty string if it is not bound.
         */
        native function get address(): String 

        /** @duplicate Stream.async */
        native function get async(): Boolean
        native function set async(enable: Boolean): Void

        /** @duplicate Stream.close */
        native function close(): Void

        //  TODO - what about ipv6
        /** 
            Establish a connection to a client from this socket to the supplied address. After a successful call to 
            connect() the socket may be used for sending and receiving.
            @param address The endpoint address on which to listen. The address can be either a port number, an IP address
                string, a composite "IP:PORT" string or a port number string. If only a port number is provided, 
                the socket will listen on all interfaces.
            @throws IOError if the connection fails. Reasons may include the socket is already bound or the host is unknown.
            @events Issues a "writable" event when the connection is complete.
         */
        native function connect(address: Object): Void

        /** 
            Current encoding scheme for serializing strings. Defaults to "utf-8"
         */
        function get encoding(): String
            "utf-8"

        function set encoding(enc: String): Void {
            throw "Not yet implemented"
        }

        /** @duplicate Stream.flush */
        function flush(dir: Number = Stream.BOTH): Void {}

        /**
            Is the socket at end of input. i.e. Is closed or has the other end sent a FIN packet.
         */
        native function get isEof(): Boolean

        /** 
            Listen on a socket for client connections. This will put the socket into a server role for communcations.
            If the socket is in sync mode, the listen call will block until a client connection is received after which
            accept() should be called to receive the socket instance for the new connection.
            If a the listening socket is in async mode, the listen call will return immediately and 
            client connections will be notified via "accept" events. 
            @param address The endpoint address on which to listen. The address can be either a port number, an IP address
                string or a composite "IP:PORT" string. If only a port number is provided, the socket will listen on
                all interfaces.
            @throws ArgError if the specified listen address is not valid, and IOError for network errors.
            @event Issues a "accept" event when there is a new connection available. In response, the $accept method
                should be called.
         */
        native function listen(address): Void

        /** @duplicate Stream.off */
        native function off(name: Object, observer: Function): Void

        /** 
            @duplicate Stream.on 
            @event readable Issued when the response headers have been fully received and some body content is available.
            @event writable Issued when the connection is writable to accept body data (PUT, POST).
         */
        native function on(name, observer: Function): Socket

        /** 
            The port bound to this socket. Set to the integer port number or zero if not bound.
         */
        native function get port(): Number 

        /** @duplicate Stream.read */
        native function read(buffer: ByteArray, offset: Number = 0, count: Number = -1): Number?

        //  FUTURE - readString, readBytes, readXML

        /** 
            The remote address bound to this socket. Set to the remote address in dot notation or empty string if it 
            is not bound.
         */
        native function get remoteAddress(): String 

        /** 
            @duplicate Stream.write 
         */
        native function write(...data): Number
    }
}


/*
    @copy   default

    Copyright (c) Embedthis Software. All Rights Reserved.

    This software is distributed under commercial and open source licenses.
    You may use the Embedthis Open Source license or you may acquire a 
    commercial license from Embedthis Software. You agree to be fully bound
    by the terms of either license. Consult the LICENSE.md distributed with
    this software for full details and other copyrights.

    Local variables:
    tab-width: 4
    c-basic-offset: 4
    End:
    vim: sw=4 ts=4 expandtab

    @end
 */
