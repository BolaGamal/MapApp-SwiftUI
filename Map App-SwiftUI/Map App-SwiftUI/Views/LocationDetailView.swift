//
//  LocationDetailView.swift
//  Map App-SwiftUI
//
//  Created by Bola Gamal on 12/10/2023.
//

import SwiftUI
import MapKit

struct LocationDetailView: View {
    
    @EnvironmentObject private var viewModel: LocationsViewModel
    let location: Location
    
    var body: some View {
        
        ScrollView {
            VStack {
                imageSection
                
                VStack(alignment: .leading, spacing: 16.0) {
                    VStack(alignment: .leading, spacing: 8.0) {
                       titleSection
                        Divider()
                        descriptionSection
                        Divider()
                        mapLayer
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
        }
        .ignoresSafeArea()
        .background(.ultraThinMaterial)
        .overlay(alignment: .topLeading) { backButton }
    }
}

#Preview {
    LocationDetailView(location: LocationsDataService.locations.first!)
        .environmentObject(LocationsViewModel())
}


extension LocationDetailView {
    
    private var imageSection: some View {
        TabView {
            ForEach(location.imageNames, id: \.self) { imageName in
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? nil : UIScreen.main.bounds.width)
                    .clipped()
            }
        }
        .tabViewStyle(.page)
        .frame(height: 500)
        .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
    }
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 8.0) {
            Text(location.name)
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
            Text(location.cityName)
                .font(.title3)
                .foregroundStyle(.secondary)
        }
    }
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(location.description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            if let url = URL(string: location.link) {
                Link("Read more in Wikipedia", destination: url)
                    .font(.headline)
                    .foregroundStyle(.blue)
            }
        }
    }
    
    private var backButton: some View {
        Button(action: {
            viewModel.sheetLocation = nil
        }, label: {
           Image(systemName: "xmark")
                .font(.headline)
                .padding()
                .foregroundStyle(.primary)
                .background(.thickMaterial)
                .clipShape(.buttonBorder)
                .shadow(radius: 4)
                .padding()
        })
    }
    
    private var mapLayer: some View {
        let region = MKCoordinateRegion(
            center: location.coordinates,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//        return Map(bounds: MapCameraBounds(centerCoordinateBounds: region))
//            .allowsHitTesting(false)
//            .aspectRatio(1.5, contentMode: .fit)
//            .clipShape(.rect(cornerRadius: 10))
//        
        return Map(coordinateRegion: .constant(region),
                   annotationItems: [location],
                   annotationContent: { location in
            MapAnnotation(coordinate: location.coordinates) {
                LocationMapAnnotationView()
                    .shadow(radius: 10)
            }
        })
        .allowsHitTesting(false)
        .aspectRatio(1.5, contentMode: .fit)
        .clipShape(.rect(cornerRadius: 20))
    }
}
