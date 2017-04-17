//
//  RealmManager.swift
//
//  Created by Willian Ramos on 17/04/17.
//  Copyright © 2017 Willia Ramos. All rights reserved.
//

import RealmSwift
import SwiftyJSON

class RealmManager: NSObject {
    
    static var currentRealmVersion: UInt64 = 1
    
    static func getFileURL() -> URL? {
        return Realm.Configuration.defaultConfiguration.fileURL
    }
    
    static func checkMigrations(){
        checkIncrementMigration()
    }
    
    static func checkIncrementMigration(){
        Realm.Configuration.defaultConfiguration = Realm.Configuration(
            schemaVersion: currentRealmVersion,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < currentRealmVersion) {
                }
        })
    }
    
    static func nextID(table: Object.Type) -> Int {
        let realm = try! Realm()
        return (realm.objects(table).max(ofProperty: "id") as Int? ?? 0) + 1
    }
    
    static func add(object: Object) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(object, update: true)
        }
    }
    
    static func update(object: Object, withValue value: Any, forKeyPath path: String) {
        let realm = try! Realm()
        try! realm.write {
            object.setValue(value, forKeyPath: path)
        }
    }
    
    static func remove(object: Object) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(object)
        }
    }
    
    static func removeAll(inTable table: Object.Type) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(realm.objects(table))
        }
    }
    
    static func removeAll(objects: [Object]) {
        let realm = try! Realm()
        
        try! realm.write {
            realm.delete(objects)
        }
    }
    
    static func findBy(id: Any, inThe table: Object.Type) -> Object? {
        let realm = try! Realm()
        let allObjects = realm.objects(table).filter("id = \(id)")
        if allObjects.count > 0 {
            return allObjects.first
        }
        return nil
    }
    
    static func findBy(predicate: NSPredicate, inThe table: Object.Type) -> Object? {
        let realm = try! Realm()
        let allObjects = realm.objects(table).filter(predicate)
        if allObjects.count > 0 {
            return allObjects.first
        }
        return nil
    }
    
    static func updateAll(table: Object.Type, withValue value: Any, forKeyPath path: String) {
        let realm = try! Realm()
        let objects = realm.objects(table)
        try! realm.write {
            objects.setValue(value, forKeyPath: path)
        }
    }
    
    static func list(table: Object.Type) -> [Object] {
        let realm = try! Realm()
        let objects = realm.objects(table)
        
        return Array(objects)
    }
    
    static func list(table: Object.Type, fiteredBy predicate: String) -> [Object] {
        let realm = try! Realm()
        let objects = realm.objects(table).filter(predicate)
        
        return Array(objects)
    }
    
    static func list(table: Object.Type, fiteredBy predicate: String, andSortedBy sorted: String) -> [Object] {
        let realm = try! Realm()
        let objects = realm.objects(table).filter(predicate).sorted(byKeyPath: sorted)
        
        return Array(objects)
    }
}
