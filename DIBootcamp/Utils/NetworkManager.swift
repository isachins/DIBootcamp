//
//  NetworkManager.swift
//  DIBootcamp
//
//  Created by Sachin Sharma on 04/02/25.
//

import Foundation

protocol NetworkManagerProtocol {
    func getData() async throws -> [testModel]
    func postData(model: testModel) async throws -> Bool
    func deleteData(id: String) async throws -> Bool
}

actor NetworkManager: NetworkManagerProtocol {
    func getData() async throws -> [testModel] {
        return [
            testModel(id: UUID().uuidString, title: "Test 1", desc: "Description 1"),
            testModel(id: UUID().uuidString, title: "Test 2", desc: "Description 2")
        ]
    }
    
    func postData(model: testModel) async throws -> Bool {
        print("Posted: \(model)")
        return true
    }
    
    func deleteData(id: String) async throws -> Bool {
        print("Deleted: \(id)")
        return true
    }
    
}

class MockNetworkManager: NetworkManagerProtocol {
    var shouldThrowError = false
    var shouldReturnFalse = false
    
    func getData() async throws -> [testModel] {
        if shouldThrowError {
            throw NSError(domain: "TestError", code: 1, userInfo: nil)
        }
        return [
            testModel(id: "1", title: "Mock Title 1", desc: "Mock Desc 1"),
            testModel(id: "2", title: "Mock Title 2", desc: "Mock Desc 2")
        ]
    }
    
    func postData(model: testModel) async throws -> Bool {
        if shouldThrowError {
            throw NSError(domain: "TestError", code: 1, userInfo: nil)
        }
        return !shouldReturnFalse
    }
    
    func deleteData(id: String) async throws -> Bool {
        if shouldThrowError {
            throw NSError(domain: "TestError", code: 1, userInfo: nil)
        }
        return !shouldReturnFalse
    }
}
