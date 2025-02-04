//
//  testViewModelTests.swift
//  DIBootcampTests
//
//  Created by Sachin Sharma on 04/02/25.
//

import XCTest
@testable import DIBootcamp

final class testViewModelTests: XCTestCase {
    
    var mockNetworkManager: MockNetworkManager!
    var viewModel: testViewModel!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockNetworkManager = MockNetworkManager()
        viewModel = testViewModel(networkService: mockNetworkManager)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        // Clean up resources after each test
        mockNetworkManager = nil
        viewModel = nil
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    //MARK: Fetch Data Tests Cases
    func testFetchData_Success() async throws {
        // Given
        mockNetworkManager.shouldThrowError = false
        
        // When
        await viewModel.fetchData()
        
        // Then
        XCTAssertEqual(viewModel.items.count, 2, "ViewModel should contain 2 test items")
        XCTAssertEqual(viewModel.items.first?.title, "Mock Title 1", "First test item title should match")
    }
    
    func testFetchData_Failure() async throws {
        // Given
        mockNetworkManager.shouldThrowError = true
        
        // When
        await viewModel.fetchData()
        
        // Then
        XCTAssertEqual(viewModel.items.count, 0, "ViewModel data should be empty on failure")
    }
    
    
    //MARK: Post Data Tests Cases
    // ✅ Test successful post (API returns true)
    func testPostData_Success() async throws {
        // Given
        let newData = testModel(id: UUID().uuidString, title: "New Data", desc: "Description")
        mockNetworkManager.shouldThrowError = false
        mockNetworkManager.shouldReturnFalse = false
        
        
        // When
        await viewModel.postData(with: newData)
        
        // Then
        XCTAssertTrue(viewModel.items.contains { $0.id == newData.id }, "New item should be added on successful post")
    }
    
    // ❌ Test API returning false (Post failed but no error thrown)
    func testPostData_ReturnsFalse() async throws {
        // Given
        let newData = testModel(id: UUID().uuidString, title: "New Data", desc: "Description")
        mockNetworkManager.shouldThrowError = false
        mockNetworkManager.shouldReturnFalse = true
        let initialCount = viewModel.items.count
        
        // When
        await viewModel.postData(with: newData)
        
        // Then
        XCTAssertEqual(viewModel.items.count, initialCount, "Item should not be added when API returns false")
    }
    
    // 🚨 Test Post Failure (Throws Error)
    func testPostData_ThrowsError() async throws {
        // Given
        let newData = testModel(id: UUID().uuidString, title: "New Data", desc: "Description")
        mockNetworkManager.shouldThrowError = true
        let initialCount = viewModel.items.count
        
        // When
        await viewModel.postData(with: newData)
        
        // Then
        XCTAssertEqual(viewModel.items.count, initialCount, "Item should not be added when an error is thrown")
    }
    
    
    //MARK: Delete Data Tests Cases
    // ✅ Test successful delete (API returns true)
    func testDeleteData_Success() async throws {
        // Given
        let existingData = testModel(id: "123", title: "Existing Data", desc: "Existing Desc")
        viewModel.items.append(existingData)
        mockNetworkManager.shouldThrowError = false
        mockNetworkManager.shouldReturnFalse = false
        let initialCount = viewModel.items.count
        
        // When
        await viewModel.deleteData(at: IndexSet(integer: 0)) // Deleting first item
        
        // Then
        XCTAssertEqual(viewModel.items.count, initialCount - 1, "Item should be removed on successful delete")
    }
    
    // ❌ Test API returning false (Delete failed but no error thrown)
    func testDeleteData_ReturnsFalse() async throws {
        // Given
        let existingData = testModel(id: "123", title: "Existing Data", desc: "Existing Desc")
        viewModel.items.append(existingData)
        mockNetworkManager.shouldThrowError = false
        mockNetworkManager.shouldReturnFalse = true
        let initialCount = viewModel.items.count
        
        // When
        await viewModel.deleteData(at: IndexSet(integer: 0)) // Attempting to delete first item
        
        // Then
        XCTAssertEqual(viewModel.items.count, initialCount, "Item should not be removed when API returns false")
    }
    
    // 🚨 Test Delete Failure (Throws Error)
    func testDeleteData_ThrowsError() async throws {
        // Given
        let existingData = testModel(id: "123", title: "Existing Data", desc: "Existing Desc")
        viewModel.items.append(existingData)
        mockNetworkManager.shouldThrowError = true
        let initialCount = viewModel.items.count
        
        // When
        await viewModel.deleteData(at: IndexSet(integer: 0)) // Attempting to delete first item
        
        // Then
        XCTAssertEqual(viewModel.items.count, initialCount, "Item should not be removed when an error is thrown")
    }
    
    
}
