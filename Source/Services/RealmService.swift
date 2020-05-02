//
//  RealmService.swift
//  Piggy
//
//  Created by Jakob Lierman on 05/04/2020.
//  Copyright © 2020 Jakob Lierman. All rights reserved.
//

import Foundation
import RealmSwift

class RealmService {
    
    private init() {}
    static let shared = RealmService()
    
    let realm = try! Realm(configuration: Realm.Configuration(deleteRealmIfMigrationNeeded: true))
    
    func create<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.add(object)
            }
        } catch {
            post(error)
        }
    }
    
    func update<T: Object>(_ object: T, with dictionary: [String: Any?]) {
        do {
            try realm.write {
                for (key, value) in dictionary {
                    object.setValue(value, forKey: key)
                }
            }
        } catch {
            post(error)
        }
    }
    
    func delete<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            post(error)
        }
    }
    
    func deleteAllOfType<T: Object>(_ type: T.Type) {
        do {
            let objects = realm.objects(type)
            try realm.write {
                realm.delete(objects)
            }
        } catch {
            post(error)
        }
    }
    
    func fill() {
        do {
            try realm.write {
                realm.add(User(name: "Saver", currency: "EUR"))
                realm.add(Category(id: nil, name: "Entertainment", icon: "dice"))
                realm.add(Category(id: nil, name: "Household", icon: "fridge"))
                realm.add(Category(id: nil, name: "Gifts", icon: "balloon"))
                realm.add(Category(id: nil, name: "Clothing", icon: "hanger"))
                realm.add(Category(id: nil, name: "Transportation", icon: "car"))
                realm.add(Category(id: nil, name: "Travelling", icon: "luggage"))
                realm.add(Category(id: nil, name: "Hobbies", icon: "gamer"))
            }
        } catch {
            post(error)
        }
    }
    
    func reset() {
        do {
            try realm.write {
                realm.deleteAll()
            }
            self.fill()
        } catch {
            post(error)
        }
    }
    
    func post(_ error: Error) {
        NotificationCenter.default.post(name: NSNotification.Name("RealmError"), object: error)
    }
    
    func observeRealmErrors(in viewController: UIViewController, completion: @escaping (Error?) -> Void) {
        NotificationCenter.default.addObserver(forName: NSNotification.Name("RealmError"), object: nil, queue: nil) { (notification) in
            completion(notification.object as? Error)
        }
    }
    
    func stopObservingErrors(in viewController: UIViewController) {
        NotificationCenter.default.removeObserver(viewController, name: NSNotification.Name("RealmError"), object: nil)
    }
    
}
