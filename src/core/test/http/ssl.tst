/*
    SSL tests
 */

const HTTPS = App.config.uris.ssl
var http: Http = new Http

if (App.config.bld_ssl) {
    http.verify = false
    http.get(HTTPS + "/index.html")
    assert(http.status == 200)
    assert(http.isSecure)
    http.close()

} else {
    test.skip("SSL not enabled")
}
