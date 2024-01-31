//
//  CategoryView.swift
//  Workhour
//
//  Created by JunHyuk Lim on 31/1/2024.
//

import SwiftUI

@MainActor
final class CategoryViewModel: ObservableObject {
    @Published private(set) var user: DBUser? = nil

    func loadUserData(userId: String) {
        Task {
            self.user = try? await UserManager.shared.getUser(userId: userId)
        }
    }

    func addWorkplace(userId: String, workplace: String) {
        Task {
            do {
                try await UserManager.shared.addWorkplace(userId: userId, newWorkplace: workplace)
                self.user?.workplaces?.append(workplace)
            } catch {
                print("Error adding workplace: \(error)")
            }
        }
    }
}


struct CategoryView: View {
    @StateObject var viewModel = CategoryViewModel()
    @State private var showAddWorkLocationSheet = false

    var body: some View {
        VStack {
            List(viewModel.user?.workplaces ?? [], id: \.self) { workplace in
                Text(workplace)
            }
            Button("Add Workplace") {
                showAddWorkLocationSheet = true
            }
        }
        .sheet(isPresented: $showAddWorkLocationSheet) {
            AddWorkLocationView(viewModel: viewModel)
        }
        .onAppear {
            viewModel.loadUserData(userId: "currentUserId")
        }
    }
}


struct AddWorkLocationView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: CategoryViewModel
    @State private var workplace: String = ""

    var body: some View {
        NavigationView {
            Form {
                TextField("Workplace Name", text: $workplace)
                Button("Save") {
                    viewModel.addWorkplace(userId: "currentUserId", workplace: workplace)
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationBarTitle("Add Workplace", displayMode: .inline)
        }
    }
}

#Preview {
    CategoryView()
}
