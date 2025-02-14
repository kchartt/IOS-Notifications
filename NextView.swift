//
//  NextView.swift
//  my-onarken-ios
//
//  Created by Kyle Chart on 14/02/2025.
//

import SwiftUI

///Values of the NextView from the notification interaction
enum NextView: String, Identifiable {
    case promo, renew
    
    //Allows a sheet to be preseneted from the Identifiable property
    var id: String {
        self.rawValue
    }
    
    ///Check what the value is and return the required view
    @ViewBuilder
    func view() -> some View {
        switch self {
        case .promo:
            //Add in custom views/sheets etc....
            Text("Promo")
        case .renew:
            Text("Renew")
        }
    }
}
