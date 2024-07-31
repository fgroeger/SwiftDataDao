//
//  PersistentModelMapper.swift
//  SwiftDataDao
//
//  Created by Fabian Gröger on 31.07.24.
//

import SwiftData

public protocol PersistentModelMapper {
    associatedtype SwiftDataModel
    associatedtype DomainModel
    
    func fromDomainModel(_ domainModel: DomainModel) -> SwiftDataModel
    func toDomainModel(_ swiftDataModel: SwiftDataModel) -> DomainModel
}

public struct IdMapper<T: PersistentModel>: PersistentModelMapper {
    public typealias SwiftDataModel = T
    public typealias DomainModel = T
    
    public func fromDomainModel(_ domainModel: T) -> T {
        return domainModel
    }
    
    public func toDomainModel(_ swiftDataModel: T) -> T {
        return swiftDataModel
    }
}
