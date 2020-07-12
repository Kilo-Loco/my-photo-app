//
//  AsyncImage.swift
//  My-Photo-App
//
//  Created by Kyle Lee on 7/11/20.
//

import SwiftUI

struct AsyncImage: View {
    
    @ObservedObject var imageLoader = ImageLoader()
    
    let imageKey: String
    
    var body: some View {
        Group {
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 130, height: 130)
                    .clipped()
            } else {
                ProgressView()
                    .font(.largeTitle)
                    .padding()
            }
        }
        .onAppear {
            imageLoader.loadImage(with: imageKey)
        }
    }
}
