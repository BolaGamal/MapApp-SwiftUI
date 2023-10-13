//
//  Map_App_SwiftUIApp.swift
//  Map App-SwiftUI
//
//  Created by Bola Gamal on 12/10/2023.
//

import SwiftUI

@main
struct Map_App_SwiftUIApp: App {
    
    @StateObject private var viewModel = LocationsViewModel()
    
    var body: some Scene {
        WindowGroup {
           LocationsView()
                .environmentObject(viewModel)
        }
    }
}
