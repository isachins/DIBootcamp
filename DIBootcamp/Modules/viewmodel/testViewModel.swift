//
//  testViewModel.swift
//  DIBootcamp
//
//  Created by Sachin Sharma on 04/02/25.
//

import Foundation

class testViewModel: ObservableObject {
    let networkService: NetworkManagerProtocol
    
    @Published var items: [testModel] = []
    
    
    init(networkService: NetworkManagerProtocol) {
        self.networkService = networkService
    }
    
    func fetchData() async {
        do {
            let data = try await networkService.getData()
            await MainActor.run {
                items = data
            }
            print("Fetched Data: \(data)")
        } catch {
            print("Error: \(error)")
        }
    }
    
    func postData(with data: testModel) async {
        do {
            let dataPosted = try await networkService.postData(model: data)
            if dataPosted {
                await MainActor.run {
                    items.append(data)
                    print("Posted Data: \(data)")
                }
            }
            
        } catch {
            print("Error: \(error)")
        }
    }
    
    func deleteData(at offsets: IndexSet) async {
        guard let index = offsets.first else { return }
        let data = items[index] // Get the item at the given index
        do {
            let dataDeleted = try await networkService.deleteData(id: data.id)
            if dataDeleted {
                await MainActor.run() {
                    items.remove(atOffsets: offsets)
                    print("Deleted Data: \(data)")
                }
            }
        } catch {
            print("Error: \(error)")
        }
    }
    
}
