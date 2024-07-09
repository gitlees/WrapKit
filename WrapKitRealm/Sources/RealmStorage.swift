//
//  RealmStorage.swift
//  WrapKitRealm
//
//  Created by Stanislav Li on 14/3/24.
//

#if canImport(RealmSwift)
import Foundation
import RealmSwift
import WrapKit

public protocol ObjectDTO<Object>: Hashable where Object == RealmSwift.Object {
    associatedtype Object
    var object: Object { get }
}

public class RealmStorage<Object: RealmSwift.Object & ViewModelDTO, Model: ObjectDTO>: Storage, Hashable where Model == Object.ViewModel {
    public static func == (lhs: RealmStorage, rhs: RealmStorage) -> Bool {
        return lhs.model == rhs.model
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(model)
    }
    
    private let realmQueue = DispatchQueue(label: "com.wrapkit.storage.realmQueue")
    private var observers = [ObserverWrapper]()
    private let realm: Realm
    
    private var model: Model? {
        didSet {
            notifyObservers()
        }
    }
    
    public init(realm: Realm) {
        self.realm = realm
        realmQueue.async {
            let result = realm.objects(Object.self).first?.viewModel
            DispatchQueue.main.async {
                self.model = result
            }
        }
    }
    
    public func addObserver(for client: AnyObject, observer: @escaping Observer) {
        let wrapper = ObserverWrapper(client: client, observer: observer)
        wrapper.observer(model)
        observers.append(wrapper)
    }
    
    public func get() -> Model? {
        return model
    }
    
    public func set(model: Model?, completion: ((Bool) -> Void)?) {
        realmQueue.async {
            do {
                try self.realm.write {
                    if let model = model {
                        self.realm.add(model.object, update: .modified)
                    } else {
                        self.realm.delete(self.realm.objects(Object.self))
                    }
                    DispatchQueue.main.async {
                        self.model = model
                        completion?(true)
                    }
                }
            } catch {
                print("Error setting object in Realm: \(error)")
                DispatchQueue.main.async {
                    completion?(false)
                }
            }
        }
    }

    public func clear(completion: ((Bool) -> Void)?) {
        realmQueue.async {
            do {
                try self.realm.write {
                    self.realm.delete(self.realm.objects(Object.self))
                    
                    DispatchQueue.main.async {
                        self.model = nil
                        completion?(true)
                    }
                }
            } catch {
                print("Error clearing Realm: \(error)")
                DispatchQueue.main.async {
                    completion?(false)
                }
            }
        }
    }
    
    private func notifyObservers() {
        observers = observers.filter { $0.client != nil }
        for observerWrapper in observers {
            observerWrapper.observer(model)
        }
    }
    
    class ObserverWrapper {
        weak var client: AnyObject?
        let observer: Observer
        
        init(client: AnyObject, observer: @escaping Observer) {
            self.client = client
            self.observer = observer
        }
    }
}

#endif
