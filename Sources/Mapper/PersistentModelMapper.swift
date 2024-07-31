//
//  PersistentModelMapper.swift
//  SwiftDataDao
//
//  Created by Fabian Gröger on 31.07.24.
//

public protocol PersistentModelMapper {
    associatedtype SwiftDataModel
    associatedtype DomainModel
    
    func fromDomainModel(_ domainModel: DomainModel) -> SwiftDataModel
    func toDomainModel(_ swiftDataModel: SwiftDataModel) -> DomainModel
}
