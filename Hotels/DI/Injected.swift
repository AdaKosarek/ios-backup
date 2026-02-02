//
//  Injected.swift
//  Hotels
//
//  Created by mp on 17.01.2026.
//

struct Injected<T> {
    let wrappedValue: T

    init() {
        wrappedValue = DIContainer.shared.resolve()
    }
}
