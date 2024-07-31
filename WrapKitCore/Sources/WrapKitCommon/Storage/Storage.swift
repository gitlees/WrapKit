//
//  Storage.swift
//  WrapKit
//
//  Created by Stanislav Li on 17/9/23.
//

import Foundation
import Combine

public protocol Storage<Model>: Hashable {
    associatedtype Model
    
    var publisher: AnyPublisher<Model?, Never> { get }
    
    func get() -> Model?
    func set(model: Model?) -> AnyPublisher<Bool, Never>
}
