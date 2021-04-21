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
                
            }
        }
        .onAppear(perform: {
            requestAuthorizationAndFetchPhotos()
        })
    }
    
    func requestAuthorizationAndFetchPhotos() {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            
            case .authorized:
                break
            
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
