//
//  ProfileView.swift
//  Workhour
//
//  Created by JunHyuk Lim on 16/1/2024.
//

import SwiftUI

@MainActor
final class ProfileViewModel: ObservableObject{
    
    @Published private(set) var user : DBUser? = nil
    
    func loadCurrnetUser() async throws {
        guard let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser() else { return }
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
}


struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @Binding var showSignInView : Bool
    
    var body: some View {
        List{
            if let user = viewModel.user{
                Text("UserId: \(user.userId)")
                
                if let email = user.email{
                    Text("email: \(email.description)")
                }
                
                if let photoUrl = user.photoUrl{
                    URLImageView(urlString: photoUrl)
                }
                
            }
        }
        .task{
            try? await viewModel.loadCurrnetUser()
        }
        .navigationTitle("Profile")
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    SettingView(showSignInView: $showSignInView)
                } label: {
                    Image(systemName: "gear")
                        .font(.headline)
                }
            }
        }
    }
}

#Preview {
    NavigationStack{
        ProfileView(showSignInView: .constant(false))
    }
}

import SwiftUI
import Combine

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private var cancellable: AnyCancellable?

    func load(fromURLString urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }

        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.image = $0 }
    }

    deinit {
        cancellable?.cancel()
    }
}

struct URLImageView: View {
    @StateObject private var imageLoader = ImageLoader()
    let urlString: String

    var body: some View {
        Group {
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Text("Loading...")
            }
        }
        .onAppear {
            imageLoader.load(fromURLString: urlString)
        }
    }
}
