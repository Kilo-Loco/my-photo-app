//
//  GalleryView.swift
//  My-Photo-App
//
//  Created by Kyle Lee on 7/10/20.
//

import Amplify
import Combine
import SwiftUI

struct GalleryView: View {
    
    let columns = [GridItem(.adaptive(minimum: 100))]
    
    @State var observationToken: AnyCancellable?
    @State var shouldShowPhotoPicker = false
    @State var isUploading = false
    
    @State var photographer: Photographer?
    var photos: [Photo] { photographer?.photos?.map { $0 } ?? []}
    
    let userId: String
    let shouldLogOut: () -> Void
    
    
    init(userId: String, shouldLogOut: @escaping () -> Void) {
        self.userId = userId
        self.shouldLogOut = shouldLogOut
    }
    
    var body: some View {
        NavigationView {
            
            ZStack {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(photos) { photo in
                            AsyncImage(imageKey: photo.key)
                        }
                    }
                }
                
                VStack {
                    Spacer()
                    
                    Button(action: showPhotoPicker, label: {
                        if isUploading {
                            ProgressView()
                                .padding()
                                .background(Color.purple)
                                .clipShape(Circle())
                            
                        } else {
                            Image(systemName: "plus")
                                .font(.largeTitle)
                                .padding()
                                .background(Color.purple)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                        }
                    })
                } //vstack
            } //zstack
            .navigationTitle("Photos")
            .navigationBarItems(
                trailing: Button("Log Out", action: logOut)
            )
            .sheet(isPresented: $shouldShowPhotoPicker) {
                PhotoPicker(
                    isPresented: $shouldShowPhotoPicker,
                    didProvideImage: upload
                )
            }
            
        } //navigationView
        .onAppear {
            getCurrentPhotographer()
        }
        
    } //body
    
    func getCurrentPhotographer() {
        Amplify.DataStore.query(Photographer.self, byId: userId) { result in
            switch result {
            case .success(let photographer):
                if let photographer = photographer {
                    DispatchQueue.main.async {
                        self.photographer = photographer
                    }
                    
                } else {
                    self.saveNewPhotographer()
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func saveNewPhotographer() {
        let photographer = Photographer(id: userId)
        Amplify.DataStore.save(photographer) { result in
            switch result {
            case .success:
                print("Photographer saved")
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func showPhotoPicker() {
        guard !isUploading else { return }
        shouldShowPhotoPicker.toggle()
    }
    
    func upload(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 1) else { return }
        let key = UUID().uuidString + "jpg"
        
        isUploading = true
        
        _ = Amplify.Storage.uploadData(key: key, data: imageData) { result in
            isUploading = false
            
            switch result {
            case .success(let imageKey):
                print("uploaded")
                savePhoto(with: imageKey)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func savePhoto(with key: String) {
        guard let photographer = self.photographer else { return }
        let photo = Photo(key: key, photographer: photographer)
          
        Amplify.DataStore.save(photo) { savePhotoResult in
            switch savePhotoResult {
            case .success:
                getCurrentPhotographer()

            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func logOut() {
        let options = AuthSignOutRequest.Options(globalSignOut: true)
        _ = Amplify.Auth.signOut(options: options) { result in
            switch result {
            case .success:
                shouldLogOut()
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

struct GalleryView_Previews: PreviewProvider {
    static var previews: some View {
        GalleryView(userId: "") {}
    }
}
