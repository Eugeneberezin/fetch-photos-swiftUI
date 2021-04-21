//
//  PhotoModel.swift
//  Photogallary-SwiftUI
//
//  Created by Eugene Berezin on 4/20/21.
//

import Foundation
import SwiftUI

struct Photo: Identifiable {
    var id = UUID()
    var photo: Image
}
