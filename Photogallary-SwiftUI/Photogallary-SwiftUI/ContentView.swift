//
//  ContentView.swift
//  Photogallary-SwiftUI
//
//  Created by Eugene Berezin on 4/20/21.
//

import SwiftUI
import Photos

enum SelectedPhotos: Int {
    case all = 1
    case favorites = 0
}

struct ContentView: View {
    @State private var photos = [Photo]()
    @State private var selectedPhotos = SelectedPhotos.favorites
    
    var body: some View {
        VStack {
            Picker("Select Photos", selection: $selectedPhotos) {
                Text("Favorites").tag(SelectedPhotos.favorites)
                Text("All").tag(SelectedPhotos.all)
            }
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: selectedPhotos, perform: { selectedPhotos in
                
                switch selectedPhotos {
                
                case .all:
                    photos = []
                    requestAuthorizationAndFetchPhotos(selectedPhotos: .all)
                case .favorites:
                    photos = []
                    requestAuthorizationAndFetchPhotos(selectedPhotos: .favorites)
                }
                
            })
            
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
            requestAuthorizationAndFetchPhotos(selectedPhotos: .favorites)

        })
    }
    
    func fetchFavorites() {
        let fetchOptions = PHFetchOptions()
        let imgManager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        fetchOptions.predicate = NSPredicate(format: "title = %@", "Favorites")
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        let favorites :PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumFavorites, options: nil)
        var assetCollection = PHAssetCollection()
        
        if let firstObject = favorites.firstObject {
            assetCollection = firstObject
        }
        
        let photoAssets = PHAsset.fetchAssets(in: assetCollection, options: nil)
        
        photoAssets.enumerateObjects { (asset, num, pointer) in
            imgManager.requestImage(
                for: asset,
                targetSize: CGSize(width: 100, height: 200), contentMode: .aspectFit,
                options: requestOptions) { (image, _) in
                
                let photo = Photo(photo: Image(uiImage: image ?? UIImage()))
                
                    photos.append(photo)
                
            }
        }
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
    
    func requestAuthorizationAndFetchPhotos(selectedPhotos: SelectedPhotos) {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            
            case .authorized:
                DispatchQueue.main.async {
                    switch selectedPhotos {
                    
                    case .all:
                        fetchPhotos()
                    case .favorites:
                        fetchFavorites()
                    }
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
