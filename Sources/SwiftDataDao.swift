//
//  SwiftDataDao.swift
//  SwiftDataDao
//
//  Created by Fabian Gröger on 31.07.24.
//

import CoreData
import Foundation
import SwiftData

// TODO: Fix Sendable
public actor SwiftDataDao<T: PersistentModel & Sendable, Mapper: PersistentModelMapper>: Sendable where Mapper.SwiftDataModel == T {
    private let modelContext: ModelContext
    private let mapper: Mapper
    
    public init(modelContainer: ModelContainer, mapper: Mapper) {
        self.modelContext = ModelContext(modelContainer)
        self.mapper = mapper
    }
    
    public func getAll() throws -> [T] {
        let fetchDescriptor = FetchDescriptor<T>()
        return try modelContext.fetch(fetchDescriptor)
    }
    
    public func getAll() -> AsyncStream<[T]> {
        return AsyncStream { continuation in
            let task = Task {
                for await _ in NotificationCenter.default.notifications(
                    named: .NSPersistentStoreRemoteChange
                ).map({ _ in () }) {
                    do {
                        try updateContinuation(continuation)
                    } catch {
                        // log/ignore the error, or return an AsyncThrowingStream
                    }
                }
            }
            
            continuation.onTermination = { _ in
                task.cancel()
            }
            
            Task {
                do {
                    try updateContinuation(continuation)
                } catch {
                    // log/ignore the error, or return an AsyncThrowingStream
                }
            }
        }
    }
    
    public func insert(_ model: Mapper.DomainModel) {
        let swiftDataModel = mapper.fromDomainModel(model)
        modelContext.insert(swiftDataModel)
        try? modelContext.save()
    }
    
    public func update(_ model: Mapper.DomainModel) {
        // TODO: Need to implement
        try? modelContext.save()
    }
    
    public func removeAll() throws {
        try modelContext.delete(model: T.self)
    }
    
    private func updateContinuation(_ continuation: AsyncStream<[T]>.Continuation) throws {
        let fetchDescriptor = FetchDescriptor<T>()
        let models = try modelContext.fetch(fetchDescriptor)
        continuation.yield(models)
    }
}

public extension SwiftDataDao where Mapper == IdMapper<T> {
    init(modelContainer: ModelContainer) {
        self.init(modelContainer: modelContainer, mapper: IdMapper())
    }
}
