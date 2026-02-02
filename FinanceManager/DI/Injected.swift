//
//  Injected.swift
//  FinanceManager
//
//  Created by mp on 11.06.2025.
//

@propertyWrapper
struct Injected<T> {
    let wrappedValue: T

    init() {
        wrappedValue = DIContainer.shared.resolve()
    }
}
