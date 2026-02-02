//
//  DIManager.swift
//  Hotels
//
//  Created by mp on 17.01.2026.
//

import Foundation
import Combine

final class DIContainer: ObservableObject {
    typealias Resolver = () -> Any

    private var resolvers = [String: Resolver]()
    private var cache = [String: Any]()

    static let shared = DIContainer()

    init() {
        registerDependencies()
    }

    func register<T, R>(_ type: T.Type, cached: Bool = false, service: @escaping () -> R) {
        let key = String(reflecting: type)
        resolvers[key] = service

        if cached {
            cache[key] = service()
        }
    }

    func resolve<T>() -> T {
        let key = String(reflecting: T.self)

        if let cachedService = cache[key] as? T {
            print("🥣 Resolving cached instance of \(T.self).")

            return cachedService
        }

        if let resolver = resolvers[key], let service = resolver() as? T {
            print("🥣 Resolving new instance of \(T.self).")

            return service
        }

        fatalError("🥣 \(key) has not been registered.")
    }
}

extension DIContainer {
    func registerDependencies() {
        register(DataManaging.self, cached: true) {
            CoreDataManager()
        }
        
        register(GeocodingManaging.self, cached: true) {
            GeocodingManager()
        }
        
        register(LocationManaging.self, cached: true) {
            LocationManager()
        }
        #if os(iOS)
        register(WatchConnecting.self, cached: false) {
            WatchConnector(dataManager: DIContainer.shared.resolve())
        }
        #endif
        #if os(watchOS)
        register(PhoneConnecting.self, cached: false) {
            PhoneConnector(dataManager: DIContainer.shared.resolve())
        }
        #endif
    }
}
