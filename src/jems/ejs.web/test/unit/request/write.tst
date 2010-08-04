/*
    Test write() 
 */
require ejs.web

const HTTP = ":" + (App.config.test.http_port || "6700")

server = new HttpServer
server.listen(HTTP)

server.observe("readable", function (event, request: Request) {
    write(1234)
    write(", a string, ")
    write(1, 2, 3, 4)

    ba = new ByteArray
    ba.write(", from byte array, ")
    write(ba)

    writeHtml("<p>html</p>")
    flush()
    finalize()
})

let http = new Http
http.get(HTTP + "/index.html")
do { App.eventLoop(10, true) } while(!http.wait())

//  Validate output
assert(http.response == "1234, a string, 1,2,3,4, from byte array, &lt;p&gt;html&lt;/p&gt;")
server.close()
