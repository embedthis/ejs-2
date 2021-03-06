/**
   GoogleConnector.es -- View connector for the Google Visualization library
 */

# Config.WEB
module ejs.web {

    /**
        @hide
     */
    # FUTURE
    class GoogleConnector {

        use default namespace module

        function GoogleConnector(controller) {
            // this.controller = controller
        }

//  TODO -- state should be stored in View.viewState. This should be stateless
//  TODO -- all methods must become static
        private var nextId: Number = 0

        private function scriptHeader(kind: String, id: String): Void {
            write('<script type="text/javascript" src="http://www.google.com/jsapi"></script>')
            write('<script type="text/javascript">')
            write('  google.load("visualization", "1", {packages:["' + kind + '"]});')
            write('  google.setOnLoadCallback(' + 'draw_' + id + ');')
        }

        //  TODO - must support Ejs options: bands, columns, data, onClick, refresh, pageSize, pivot, 
        //      sortColumn, sortOrder, style, styleHead, styleEvenRow, styleOddRow, styleCell, visible, widths
        //      Support @options
        function table(data, options: Object): Void {
            var id: String = "GoogleTable_" + nextId++

            if (data == null || data.length == 0) {
                write("<p>No Data</p>")
                return
            }
            let columns: Array = options["columns"]

            scriptHeader("table", id)
            
            write('  function ' + 'draw_' + id + '() {')
            write('    var data = new google.visualization.DataTable();')

            let firstLine: Object = data[0]
            if (columns) {
                if (columns[0] != "id") {
                    columns.insert(0, "id")
                }
                for (let i = 0; i < columns.length; ) {
                    if (firstLine[columns[i]]) {
                        i++
                    } else {
                        columns.remove(i, i)
                    }
                }
            } else {
                columns = []
                for (let name in firstLine) {
                    columns.append(name)
                }
            }

            for each (name in columns) {
                write('    data.addColumn("string", "' + name.toPascal() + '");')
            }
            write('    data.addRows(' + data.length + ');')

            for (let row: Object in data) {
                let col: Number = 0
                for each (name in columns) {
                    write('    data.setValue(' + row + ', ' + col + ', "' + data[row][name] + '");')
                    col++
                }
            }

            write('    var table = new google.visualization.Table(document.getElementById("' + id + '"));')

            let goptions = getOptions(options, { 
                height: null, 
                page: null,
                pageSize: null,
                showRowNumber: null,
                sort: null,
                title: null,
                width: null, 
            })

            write('    table.draw(data, ' + serialize(goptions) + ');')

            if (options.click) {
                write('    google.visualization.events.on(table, "select", function() {')
                write('        var row = table.getSelection()[0].row;')
                write('        window.location = "' + view.makeUrl(options.click, "", options) + '?id=" + ' + 
                    'data.getValue(row, 0);')
                write('    });')
            }

            write('  }')
            write('</script>')

            write('<div id="' + id + '"></div>')
        }

        //  TODO - must support Ejs options: columns, kind, onClick, refresh, style, visible
        //  TODO - use @options

        function chart(grid: Array?, options: Object): Void {
            var id: String = "GoogleChart_" + nextId++

            if (grid == null || grid.length == 0) {
                write("<p>No Data</p>")
                return
            }

            let columns: Array = options["columns"]

            scriptHeader("piechart", id)
            
            write('  function ' + 'draw_' + id + '() {')
            write('    var data = new google.visualization.DataTable();')

            let firstLine: Object = grid[0]
            let col: Number = 0
            //  TODO - need to get data types
            let dataType: String = "string"
            for (let name: String in firstLine) {
                if  (columns && columns.contains(name)) {
                    write('    data.addColumn("' + dataType + '", "' + name.toPascal() + '");')
                    col++
                    if (col >= 2) {
                        break
                    }
                    dataType = "number"
                }
            }
            write('    data.addRows(' + grid.length + ');')

            for (let row: Object in grid) {
                let col2: Number = 0
                //  TODO - workaround
                for (let name2: String in grid[row]) {
                    if  (columns && columns.contains(name2)) {
                        if (col2 == 0) {
                            write('    data.setValue(' + row + ', ' + col2 + ', "' + grid[row][name2] + '");')
                        } else if (col2 == 1) {
                            write('    data.setValue(' + row + ', ' + col2 + ', ' + grid[row][name2] + ');')
                        }
                        //  else break. TODO should do this but it is bugged
                        col2++
                    }
                }
            }

            //  PieChart, Table
            write('    var chart = new google.visualization.PieChart(document.getElementById("' + id + '"));')

            let goptions = getOptions(options, { width: 400, height: 400, is3D: true, title: null })
            write('    chart.draw(data, ' + serialize(goptions) + ');')

            write('  }')
            write('</script>')

            write('<div id="' + id + '"></div>')
        }

        private function getOptions(options: Object, defaults: Object): Object {
            var result: Object = {}
            for (let word: String in defaults) {
                if (options[word]) {
                    result[word] = options[word]
                } else if (defaults[word]) {
                    result[word] = defaults[word]
                }
            }
            return result
        }

        private function write(str: String): Void {
            view.write(str)
        }
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
