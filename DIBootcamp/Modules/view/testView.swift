//
//  testView.swift
//  DIBootcamp
//
//  Created by Sachin Sharma on 04/02/25.
//

import SwiftUI

struct testView: View {
    
    @StateObject var viewModel: testViewModel
    
    init(network: NetworkManagerProtocol) {
        _viewModel = StateObject(wrappedValue: testViewModel(networkService: network))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.items.isEmpty {
                    ProgressView()
                } else {
                    List {
                        ForEach(viewModel.items, id: \.self) { item in
                            Text(item.title)
                        }
                        .onDelete { indexSet in
                            Task {
                                await viewModel.deleteData(at: indexSet)
                            }
                        }
                    }
                    .refreshable {
                        await viewModel.fetchData()
                    }
                }
            }
            .task {
                await viewModel.fetchData()
            }
            .navigationTitle("List")
            .toolbar {
                ToolbarItem {
                    Button {
                        Task {
                            let dummyData = testModel(id: UUID().uuidString, title: "Added Data", desc: "Hloooooooooo")
                            await viewModel.postData(with: dummyData)
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        
    }
}

#Preview {
    testView(network: NetworkManager())
}
