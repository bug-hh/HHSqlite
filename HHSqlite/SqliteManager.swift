//
//  SqliteManager.swift
//  HHSqlite
//
//  Created by 彭豪辉 on 2020/5/28.
//  Copyright © 2020 彭豪辉. All rights reserved.
//

import UIKit

class SqliteManager {
    static let sharedManager = SqliteManager()
    
    // 全局数据库句柄
    var db: OpaquePointer? = nil
    
    func openDB(dbName: String) {
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        path = (path as NSString).appendingPathComponent(dbName)
        
        /*
         path: 数据库的全路径
         db: 数据库操作句柄
         如果数据库不存在，那么会新建一个数据库，这个连接是个持久化连接
         */
        
        if sqlite3_open(path, &db) != SQLITE_OK {
            print("打开数据库失败")
            return
        }
        print("打开数据库成功")
        
    }
    
    func execSQL(sql: String) -> Bool {
        /*
         第一个参数：数据库句柄
         第二个参数：sql 语句
         第三个参数：callback，执行完 sql 后，调用的 C 语言函数指针，通常传 nil
         第四个参数：callback 函数参数的地址，通常传 nil
         第五个参数：errorMsg
         */
        return sqlite3_exec(db, sql, nil, nil, nil) == SQLITE_OK
    }
    
    func createTable(sql: String) -> Bool {
        return execSQL(sql: sql)
    }
    
    func createTableFromSQLFile() -> Bool {
        let path = Bundle.main.path(forResource: "db.sql", ofType: nil)!
        
        let sql = try! String(contentsOfFile: path)
        return execSQL(sql: sql)
    }
}
