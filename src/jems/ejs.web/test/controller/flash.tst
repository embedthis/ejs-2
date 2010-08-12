/*
    Test Controller.render*
 */
require ejs.web

const PORT = (App.config.test.http_port || 6700)
const HTTP = ":" + PORT

public class TestController extends Controller {
    use namespace action

    action function first() {
        error("one", 1)
        flash("two", 2)
        inform("three", 3)
        warn("four", 4)
        render()
    }
    action function second() {
        assert(request.flashMessages["one"] == 1)
        assert(request.flashMessages["two"] == 2)
        assert(request.flashMessages["three"] == 3)
        assert(request.flashMessages["four"] == 4)
        render()
    }
    action function third() {
        assert(Object.getOwnPropertyCount(request.flashMessages) == 0)
        render()
    }
} 

load("../utils.es")
server = controllerServer(HTTP)


//  first - Send a request to set flash messages and get a session cookie
let http = fetch(HTTP + "/test/first")
let cookie = http.sessionCookie
assert(cookie.contains("-ejs-session-="))
http.close()


//  second - test flash messages from first page and clear flash
let http = new Http
http.setCookie(cookie)
http.get(HTTP + "/test/second")
http.wait()
http.close()


//  third - verify flash is empty
let http = new Http
http.setCookie(cookie)
http.get(HTTP + "/test/third")
http.wait()
http.close()

server.close()
