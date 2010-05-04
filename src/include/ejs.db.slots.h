/*
   ejs.db.slots.h -- Native property slot definitions for the "ejs.db" module
  
   This file is generated by ejsmod
  
   Slot definitions. Version 1.1.0.
 */

#ifndef _h_SLOTS_EjsDbSlots
#define _h_SLOTS_EjsDbSlots 1


/*
   Slots for the "ejs.db" module 
 */

/*
 * Instance slots for "global" type 
 */


/*
    Class property slots for the "Database" type 
 */
#define ES_ejs_db_Database__origin                                     0
#define ES_ejs_db_Database_defaultDb                                   0
#define ES_ejs_db_Database_defaultDatabase                             1
#define ES_ejs_db_Database_quote                                       2

#define ES_ejs_db_Database_NUM_CLASS_PROP                              3

/*
 * Instance slots for "Database" type 
 */
#define ES_ejs_db_Database_Database                                    12
#define ES_ejs_db_Database__adapter                                    13
#define ES_ejs_db_Database__connection                                 14
#define ES_ejs_db_Database__name                                       15
#define ES_ejs_db_Database__traceAll                                   16
#define ES_ejs_db_Database_addColumn                                   17
#define ES_ejs_db_Database_addIndex                                    18
#define ES_ejs_db_Database_changeColumn                                19
#define ES_ejs_db_Database_close                                       20
#define ES_ejs_db_Database_commit                                      21
#define ES_ejs_db_Database_connect                                     22
#define ES_ejs_db_Database_connection                                  23
#define ES_ejs_db_Database_createDatabase                              24
#define ES_ejs_db_Database_createTable                                 25
#define ES_ejs_db_Database_dataTypeToSqlType                           26
#define ES_ejs_db_Database_destroyDatabase                             27
#define ES_ejs_db_Database_destroyTable                                28
#define ES_ejs_db_Database_endTransaction                              29
#define ES_ejs_db_Database_getColumns                                  30
#define ES_ejs_db_Database_getTables                                   31
#define ES_ejs_db_Database_getNumRows                                  32
#define ES_ejs_db_Database_name                                        33
#define ES_ejs_db_Database_query                                       34
#define ES_ejs_db_Database_removeColumns                               35
#define ES_ejs_db_Database_removeIndex                                 36
#define ES_ejs_db_Database_renameColumn                                37
#define ES_ejs_db_Database_renameTable                                 38
#define ES_ejs_db_Database_rollback                                    39
#define ES_ejs_db_Database_sql                                         40
#define ES_ejs_db_Database_sqlTypeToDataType                           41
#define ES_ejs_db_Database_sqlTypeToEjsType                            42
#define ES_ejs_db_Database_startTransaction                            43
#define ES_ejs_db_Database_trace                                       44
#define ES_ejs_db_Database_transaction                                 45
#define ES_ejs_db_Database_NUM_INSTANCE_PROP                           58

/*
    Local slots for methods in type "Database" 
 */
#define ES_ejs_db_Database_quote_str                                   0

#define ES_ejs_db_DatabaseConnector_NUM_CLASS_PROP                     0

/*
 * Instance slots for "DatabaseConnector" type 
 */
#define ES_ejs_db_DatabaseConnector_addColumn                          0
#define ES_ejs_db_DatabaseConnector_addIndex                           1
#define ES_ejs_db_DatabaseConnector_changeColumn                       2
#define ES_ejs_db_DatabaseConnector_close                              3
#define ES_ejs_db_DatabaseConnector_commit                             4
#define ES_ejs_db_DatabaseConnector_connect                            5
#define ES_ejs_db_DatabaseConnector_createDatabase                     6
#define ES_ejs_db_DatabaseConnector_createTable                        7
#define ES_ejs_db_DatabaseConnector_dataTypeToSqlType                  8
#define ES_ejs_db_DatabaseConnector_destroyDatabase                    9
#define ES_ejs_db_DatabaseConnector_destroyTable                       10
#define ES_ejs_db_DatabaseConnector_getColumns                         11
#define ES_ejs_db_DatabaseConnector_getTables                          12
#define ES_ejs_db_DatabaseConnector_removeColumns                      13
#define ES_ejs_db_DatabaseConnector_removeIndex                        14
#define ES_ejs_db_DatabaseConnector_renameColumn                       15
#define ES_ejs_db_DatabaseConnector_renameTable                        16
#define ES_ejs_db_DatabaseConnector_rollback                           17
#define ES_ejs_db_DatabaseConnector_sql                                18
#define ES_ejs_db_DatabaseConnector_sqlTypeToDataType                  19
#define ES_ejs_db_DatabaseConnector_sqlTypeToEjsType                   20
#define ES_ejs_db_DatabaseConnector_startTransaction                   21
#define ES_ejs_db_DatabaseConnector_NUM_INSTANCE_PROP                  22

#define _ES_CHECKSUM_ejs_db   134809

#endif
