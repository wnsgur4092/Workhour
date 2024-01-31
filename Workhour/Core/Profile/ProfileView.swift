//
//  ProfileView.swift
//  Workhour
//
//  Created by JunHyuk Lim on 16/1/2024.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @Binding var showSignInView : Bool
    @Binding var selectedTab: Int
    
    var body: some View {
        VStack{
            
            //USER INFO
            HStack(spacing: 20){
                if let user = viewModel.user{
                    if let photoUrl = user.photoUrl{
                        URLImageView(urlString: photoUrl)
                        
                        
                        VStack(alignment: .leading){
                            Text("Good Morning")
                            if let name = user.name{
                                Text("\(name)")
                            }
                        }

                    }
                }
                Spacer()
            }


            Button("Go to Category View") {
                print("Current Tab: \(selectedTab)")  // 현재 탭 출력
                selectedTab = 1
                print("New Tab: \(selectedTab)")  // 변경된 탭 출력
            }
            
            
            
        }
        .task{
            try? await viewModel.loadCurrnetUser()
        }



        .navigationTitle("Profile")
        //        .toolbar{
        //            ToolbarItem(placement: .navigationBarTrailing) {
        //                NavigationLink {
        //                    SettingView(showSignInView: $showSignInView)
        //                } label: {
        //                    Image(systemName: "gear")
        //                        .font(.headline)
        //                }
        //            }
        //        }
    }
}

#Preview {
    NavigationStack{
        ProfileView(showSignInView: .constant(false), selectedTab: .constant(0))
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
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            } else {
                Text("Loading...")
            }
        }
        .onAppear {
            imageLoader.load(fromURLString: urlString)
        }
    }
}
