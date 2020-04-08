//
//  SQLiteManager.swift
//  SQLite
//
//  Created by pro648 on 2020/4/5.
//  Copyright © 2020 pro648. All rights reserved.
//

import UIKit
import SQLite3

class SQLiteManager {
    static let shared = SQLiteManager()
    
    private let dbName = "database.sql"
    private let tableName = "PersonInfo"
    private var db: OpaquePointer?
    
    private init() {
        db = openDatabase()
        createTable(tbName: tableName)
    }
    
    deinit {
        sqlite3_close(db)
    }
    
    private func openDatabase() -> OpaquePointer? {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let dbPath = documentsPath?.appendingPathComponent(dbName).path
        
        var db: OpaquePointer?
        if sqlite3_open(dbPath, &db) == SQLITE_OK {
            return db
        } else {
            defer {
                if db != nil {
                    sqlite3_close(db)
                }
            }
            
            let errorMes = String(cString: sqlite3_errmsg(db))
            print("Unable to open database  \(errorMes)")
            return nil
        }
    }
    
    private func createTable(tbName: String) {
        let queryString = """
        CREATE TABLE IF NOT EXISTS \(tbName)
        ( id INTEGER PRIMARY KEY AUTOINCREMENT,
        name char(255) NOT NULL,
        age char(255) NOT NULL,
        createTime timestamp TimeStamp NOT NULL DEFAULT (datetime('now','localtime')),
        updateTime timestamp TimeStamp NOT NULL DEFAULT (datetime('now','localtime'))
        );
        """
        
        var createTableStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, queryString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("\(tableName) table created")
            } else {
                print("\(tableName) is not created")
            }
        } else {
            print("Create table statement is not prepared")
        }
        
        sqlite3_finalize(createTableStatement)
    }
    
    func insert(contact: Contact) {
        let insertString = """
        INSERT INTO \(tableName) (name, age) VALUES(?, ?);
        """
        
        var insertStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, insertString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, strdup(contact.name), -1, free)
            sqlite3_bind_text(insertStatement, 2, strdup(contact.age), -1, free)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement is not prepared.")
        }
        
        sqlite3_finalize(insertStatement)
    }
    
    func query(uniqueId: Int32) -> ContactDetail? {
        let queryString = """
        SELECT id, name, age, createTime, updateTime FROM \(tableName)
        WHERE ID = '\(uniqueId)';
        """
        
        var queryStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, queryString, -1, &queryStatement, nil) == SQLITE_OK {
            if sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let queryResult2 = sqlite3_column_text(queryStatement, 1)
                let queryResult3 = sqlite3_column_text(queryStatement, 2)
                let queryResult4 = sqlite3_column_text(queryStatement, 3)
                let queryResult5 = sqlite3_column_text(queryStatement, 4)
                
                let name = String(cString: queryResult2!)
                let age = String(cString: queryResult3!)
                let insertDate = String(cString: queryResult4!)
                let updateDate = String(cString: queryResult5!)
                
                let detail = ContactDetail(id: id, name: name, age: age, insertDate: insertDate, updateDate: updateDate)
                sqlite3_finalize(queryStatement)
                return detail
            } else {
                print("Could not QUERY")
            }
        } else {
            print("QUERY is not prepared")
        }
        sqlite3_finalize(queryStatement)
        return nil;
    }
    
    func update(contact: Contact) {
        let updateString = """
        UPDATE \(tableName) SET name = '\(contact.name)', age = '\(contact.age)', updateTime = datetime('now','localtime')
        WHERE id = '\(contact.id)';
        """
        
        var updateStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, updateString, -1, &updateStatement, nil) == SQLITE_OK {
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully update row \(contact.name).")
            } else {
                print("Couldn't update row \(contact.name).")
            }
        } else {
            print("UPDATE is not prepared.")
        }
        
        sqlite3_finalize(updateStatement)
    }
    
    func delete(contact: Contact) {
        let deleteString = """
        DELETE FROM \(tableName) WHERE id = '\(contact.id)';
        """
        
        var deleteStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, deleteString, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully delete row \(contact.name).")
            } else {
                print("Couldn't delete row \(contact.name).")
            }
        } else {
            print("DELETE is not prepared.")
        }
        sqlite3_finalize(deleteStatement)
    }
    
    func queryAllContacts() -> [Contact] {
        let queryAllString = """
        SELECT id, name, age FROM \(tableName);
        """
        
        let retval = NSMutableArray.init()
        var queryAllStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, queryAllString, -1, &queryAllStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryAllStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryAllStatement, 0)
                let queryResult2 = sqlite3_column_text(queryAllStatement, 1)
                let queryResult3 = sqlite3_column_text(queryAllStatement, 2)
                
                let name = String(cString: queryResult2!)
                let age = String(cString: queryResult3!)
                let contact = Contact(id: id, name: name, age: age)
                
                retval.add(contact)
            }
        } else {
            print("SELECT ALL is not prepared.")
        }
        
        sqlite3_finalize(queryAllStatement)
        return retval as! [Contact]
    }
}
