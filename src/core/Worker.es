/*
    Worker -- Worker classes

    Copyright (c) All Rights Reserved. See details at the end of the file.
 */

module ejs {

    /**
        Worker Class. Worker threads are medium-weight thread-based virtual machine instances. They run separate 
        interpreters with tightly controlled data interchange. This class is currently being specified by the
        WebWorker task group (See http://www.whatwg.org/specs/web-workers/current-work/#introduction).
        This class is prototype and highly likely to change
        @spec WebWorker
        @stability prototype.
     */
    class Worker {
        use default namespace public

        /**
            Callback function invoked when the worker exits. 
            The "this" object is set to the worker object.
         */
        var onclose: Function

        /**
            Callback function to receive incoming messages. This is invoked when postMessage is called in another Worker. 
            The "this" object is set to the worker object.
            This is invoked as: function (event) { }
         */
        var onmessage: Function

        /**
            Callback function to receive incoming error events. This is invoked when the Worker thows an exception. 
            The "this" object is set to the worker object.
         */
        var onerror: Function

        /**
            Worker name. This name is initialized but workers can update as required.
            @spec ejs
         */
        var name: String

//  TODO -- should the worker exit when the script completes. Same question for terminate
        /**
            Create a new Worker instance. This call returns an outside worker object for using in the calling interpreter.
                Inside the worker interpreter, a corresponding "inside" worker object is created that is paired to the
                outside worker.
            @params script Optional path to a script or module to execute. If supplied, then a new Worker instance will
                invoke load() to execute the script.
            @params options Options hash
            @options search Search path
            @options name Name of the Worker instance.
            @spec WebWorker and ejs
         */
        native function Worker(script: Path? = null, options: Object? = null)

        /** 
            Clone the worker and underlying interpreter
            @param deep Ignored
            @spec ejs
         */
        native function clone(deep: Boolean = true): Worker

        /** 
            Create a new worker by cloning the current interpreter
            @spec ejs
         */
        native static function fork(): Worker

        /**
            Load the script. The literal script is compiled as a JavaScript program and loaded and run.
            This is similar to the global eval() command but the script is run in its own interpreter and does not
            share any data the the invoking interpreter. The result is serialized in the worker and then deserialized
            (using JSON) in the current interpreter. The call returns undefined if the timeout expires.
            @param script Literal JavaScript program string.
            @param timeout If the timeout is non-zero, this call blocks and will return the value of the last expression in
                the script. Otherwise, this call will not block and join() can be used to wait for completion. Set the
                timeout to -1 to block until the script completes. The default is -1.
            @returns The value of the last expression evaluated in the script. Returns undefined if the timeout 
                expires before the script completes.
            @throws an exception if the script can't be compiled or if it thows a run-time exception.
            @spec ejs
         */
        native function eval(script: String, timeout: Number = -1): Object?

        /**
            Exit the worker.
            @spec ejs
         */
        native static function exit(): Void

        /**
            Wait for Workers to exit.
            @param workers Set of Workers to wait for. Can be a single Worker object or an array of Workers. If null or 
                if the array is empty, then all workers are waited for.
            @param timeout Timeout to wait in milliseconds. The value -1 disables the timeout.
            @spec ejs
         */
        native static function join(workers: Object? = null, timeout: Number = -1): Boolean

        /**
            Load and run a script in a dedicated worker thread. 
            @params script Filename of a script or module to load and run. 
            @param timeout If the timeout is non-zero, this call blocks and will return the value of the last expression in
                the script. Otherwise, this call will not block and join() can be used to wait for completion. Set the
                timeout to -1 to block until the script completes. The default is to not block.
            @spec ejs
         */
        native function load(script: Path, timeout: Number = 0): Void

        /**
            Preload the specified script or module file to initialize the worker. This will run a script using the current
            thread.  This call will load the script/module and initialize and run global code. The call will block until 
            all global code has completed and the script/module is initialized.  To run a worker using its own thread, 
            use load() or Worker(script) instead.
            @param path Filename path for the module or script to load. This should include the file extension.
            @returns the value of the last expression in the script or module.
            @throws an exception if the script or module can't be loaded or initialized or if it thows an exception.
            @spec ejs
         */
        native function preload(path: Path): Object

        /** @hide TODO */
        native function preeval(script: String): Object

        /**
            Lookup a Worker by name
            @param name Lookup a Worker
            @spec ejs
         */
        native static function lookup(name: String): Worker

        /**
            Post a message to the Worker's parent
            @param data Data to pass to the worker's onmessage callback.
            @param ports Not implemented
         */
        native function postMessage(data: Object, ports: Array? = null): Void

        //  TODO - more description?
        /**
            Terminate the worker
         */
        native function terminate(): Void

        /**
            Wait for receipt of a message
            @param timeout Timeout to wait in milliseconds
            @returns True if a message was received
            @stability prototype
         */
        native function waitForMessage(timeout: Number = -1): Boolean
    }

    /** 
        Event for Web Workers
        @spec WebWorker
     */
    class Event extends Error {}

    /** 
        Error event for Web Workers
        @spec WebWorker
     */
    class ErrorEvent extends Error { }


    /*
        Globals for inside workers.
     */
    use default namespace "ejs.worker"

    /**
        Reference to the Worker object for use inside a worker script
        This is only present inside Worker scripts.
     */
    var self: Worker

    /**
        Exit the worker. This is only valid inside Worker scripts.
        @spec ejs
     */
    function exit(): Void
        Worker.exit()

    /**
        Post a message to the Worker's parent. This is only valid inside Worker scripts.
        @param data Data to pass to the worker's onmessage callback.
        @param ports Not implemented
     */
    function postMessage(data: Object, ports: Array? = null): Void
        self.postMessage(data, ports)

    /**
        The error callback function.  This is the callback function to receive incoming data from postMessage() calls.
        This is only present inside Worker scripts.
     */
    function get onerror(): Function
        self.onerror

    function set onerror(fun: Function): Void
        self.onerror = fun

    /**
        The callback function configured to receive incoming messages. 
        This is the callback function to receive incoming data from postMessage() calls.
        This is only present inside Worker scripts.
     */
    function get onmessage(): Function
        self.onmessage

    function set onmessage(fun: Function): Void
        self.onmessage = fun

    # WebWorker         // Only relevant in browsers 
    var location: WorkerLocation
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
