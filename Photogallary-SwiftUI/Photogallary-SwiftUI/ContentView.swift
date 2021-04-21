//
//  ContentView.swift
//  Photogallary-SwiftUI
//
//  Created by Eugene Berezin on 4/20/21.
//

import SwiftUI
import Photos

struct ContentView: View {
    @State private var photos = [Photo]()
    
    var body: some View {
        VStack {
            List {
                
                ForEach(photos) { photo in
                    photo.photo
                        .resizable()
                        .aspectRatio(1, contentMode: .fill)
                        .border(Color.white)
                }
                
            }
        }
        .onAppear(perform: {
            requestAuthorizationAndFetchPhotos()
        })
    }
    
    func fetchPhotos() {
        let imgManager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        if fetchResult.count > 0 {
            
            for i in 0 ..< fetchResult.count {
                imgManager.requestImage(
                    for: fetchResult.object(at: i), targetSize: CGSize(width: 100, height: 200),
                    contentMode: .aspectFit,
                    options: requestOptions) { (image, _) in
                    
                    if let image = image {
                       
                            let photo = Photo(photo: Image(uiImage: image))
                            photos.append(photo)
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                //isPhotosEmpty = true
            }
        }
        
    }
    
    func requestAuthorizationAndFetchPhotos() {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            
            case .authorized:
                DispatchQueue.main.async {
                    fetchPhotos()
                }
                
            
            default:
                break
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
