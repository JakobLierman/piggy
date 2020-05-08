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
    
    func fill(initialFill: Bool = true, dummyData: Bool = false) {
        if initialFill {
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

        if dummyData {
            self.addDummyData()
        }
    }
    
    private func addDummyData() {
        UserDefaults.standard.set(true, forKey: "forceDataInject")
        do {
            let oldObjects = realm.objects(SavingsTarget.self)
            
            let categories: Results<Category> = realm.objects(Category.self)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd"
            
            try realm.write {
                realm.delete(oldObjects)
                
                realm.add(try! SavingsTarget(
                    name: "Cat adoptation fund",
                    price: 100.0,
                    balance: 100.0,
                    category: nil,
                    deadline: nil)
                )
                realm.add(try! SavingsTarget(
                    name: "Rome",
                    price: 700.0,
                    balance: 700.0,
                    category: categories.first(where: {$0.name == "Travelling"}),
                    deadline: dateFormatter.date(from: "2019/09/15"))
                )
                realm.add(try! SavingsTarget(
                    name: "Car",
                    price: 25000.0,
                    balance: 25000.0,
                    category: categories.first(where: {$0.name == "Transportation"}),
                    deadline: nil)
                )
                realm.add(try! SavingsTarget(
                    name: "Concert ticket fund",
                    price: 250.0,
                    balance: 0.0,
                    category: nil,
                    deadline: nil)
                )
                realm.add(try! SavingsTarget(
                    name: "Jean jacket",
                    price: 50.0,
                    balance: 0.0,
                    category: categories.first(where: {$0.name == "Clothing"}),
                    deadline: nil)
                )
                realm.add(try! SavingsTarget(
                    name: "Father's day gift",
                    price: 20.0,
                    balance: 10.0,
                    category: categories.first(where: {$0.name == "Gifts"}),
                    deadline: dateFormatter.date(from: "2020/06/14"))
                )
                realm.add(try! SavingsTarget(
                    name: "Microwave",
                    price: 500.0,
                    balance: 130.0,
                    category: categories.first(where: {$0.name == "Household"}),
                    deadline: dateFormatter.date(from: "2020/05/01"))
                )
                realm.add(try! SavingsTarget(
                    name: "PC",
                    price: 2000.0,
                    balance: 1200.0,
                    category: categories.first(where: {$0.name == "Entertainment"}),
                    deadline: nil)
                )
            }
        } catch {
            post(error)
        }
        UserDefaults.standard.removeObject(forKey: "forceDataInject")
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
