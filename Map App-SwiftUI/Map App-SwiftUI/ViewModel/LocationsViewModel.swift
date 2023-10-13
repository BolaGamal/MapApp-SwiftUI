//
//  LocationsViewModel.swift
//  Map App-SwiftUI
//
//  Created by Bola Gamal on 11/10/2023.
//

import Foundation
import MapKit
import SwiftUI

class LocationsViewModel: ObservableObject {
    
    @Published var locations: [Location]
    @Published var mapLocation: Location {
        didSet {
            updateMapPosition(location: mapLocation)
        }
    }
    //ios17
//    @Published var mapPosition = MapCameraPosition.region(MKCoordinateRegion())
    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    @Published var mapRegion = MKCoordinateRegion()
    @Published var showLocationsList: Bool = false
    @Published var sheetLocation: Location? = nil
    
    init() {
        let locations = LocationsDataService.locations
        self.locations = locations
        self.mapLocation = locations.first!
        self.updateMapPosition(location: locations.first!)
    }
    
    private func updateMapPosition(location: Location) {
        withAnimation(.easeInOut) {
            mapRegion = MKCoordinateRegion(
                center: location.coordinates,
                span: mapSpan)
            //ios17
//            mapPosition = MapCameraPosition
//                .region(MKCoordinateRegion(
//                    center: location.coordinates,
//                    span: mapSpan))
        }
    }
    
    func toggleLocationsList() {
        withAnimation(.easeInOut) {
            showLocationsList.toggle()
        }
    }
    
    func showNextLocation(location: Location) {
        withAnimation(.easeInOut) {
            mapLocation = location
            showLocationsList = false
        }
    }
    
    
    func nextButtonPressed() {
        guard let currentIndex = locations.firstIndex(where: { $0 == mapLocation })
        else {return}
        
        let nextIndex = currentIndex + 1
        guard locations.indices.contains(nextIndex) else {
            
            guard let firstLocation = locations.first else {return}
            showNextLocation(location: firstLocation)
            return
        }
        let nextLocation = locations[nextIndex]
        showNextLocation(location: nextLocation)
    }
}
