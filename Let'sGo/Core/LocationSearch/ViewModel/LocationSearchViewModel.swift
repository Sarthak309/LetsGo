//
//  LocationSearchViewModel.swift
//  Let'sGo
//
//  Created by Sarthak Agrawal on 03/09/23.
//

import Foundation
import MapKit

class LocationSearchViewModel: NSObject, ObservableObject{
    
    // MARK: - Properties
    
    @Published var results = [MKLocalSearchCompletion]()
    @Published var selectedLocation: GoLocation?
    @Published var pickupTime: String?
    @Published var dropOffTime: String?
    
    
    private let searchCompleter = MKLocalSearchCompleter()
    var queryFragment: String = ""{
        didSet{
            searchCompleter.queryFragment = queryFragment
        }
    }
    
    var userLocation: CLLocationCoordinate2D?
    
    
    override init() {
        super.init()
        searchCompleter.delegate = self
        searchCompleter.queryFragment = queryFragment
        
    }
    
    //MARK: - helpers
    func selectLocation(_ localSearch: MKLocalSearchCompletion){
        locationSearch(forLocalSearchCompletion: localSearch){ response, error in
            if let error = error{
                print("Error: \(error.localizedDescription)")
                return
            }
            guard let item = response?.mapItems.first else {return}
            let coordinate = item.placemark.coordinate
            self.selectedLocation = GoLocation(title: localSearch.title,
                                               coordinate: coordinate)
            
//            print(coordinate)
        }
    }
    
    
    func getDestinationRoute(from userLocation: CLLocationCoordinate2D,
                             to destination: CLLocationCoordinate2D,
                             completion: @escaping(MKRoute) -> Void) {
        let userPlacemark = MKPlacemark(coordinate: userLocation)
        let destinationPlacemark = MKPlacemark(coordinate: destination)
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: userPlacemark)
        request.destination = MKMapItem(placemark: destinationPlacemark )
        let directions = MKDirections(request: request)
        
        directions.calculate{ response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let route = response?.routes.first else {return}
            self.configurePickupAndDropOffTime(with: route.expectedTravelTime)
            completion(route)
        }
    }
    
    func configurePickupAndDropOffTime(with expectedTravelTime: Double){
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        
        pickupTime = formatter.string(from: Date())
        dropOffTime = formatter.string(from: Date() + expectedTravelTime)
    }
    
    func locationSearch(forLocalSearchCompletion localSearch: MKLocalSearchCompletion, completion: @escaping MKLocalSearch.CompletionHandler){
        let searchRequest = MKLocalSearch.Request()
        
        searchRequest.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
        let search = MKLocalSearch(request: searchRequest)
        search.start(completionHandler: completion)
    }
    
    func computeRidePrice(forType type: RideType) -> Double{
        guard let coordinate = selectedLocation?.coordinate else {return 0.0 }
        guard let userLocation = self.userLocation else {return 0.0}
        
        let userlocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let destination = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        let tripDistanceInMeters = userlocation.distance(from: destination)
        return type.computePrice(for: tripDistanceInMeters)
    }
    
    func computeDistanceInMeters() -> CLLocationDistance{
        guard let coordinate = selectedLocation?.coordinate else {return 0.0 }
        guard let userLocation = self.userLocation else {return 0.0}
        
        let userlocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let destination = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        let tripDistanceInMeters = userlocation.distance(from: destination)
        
        return tripDistanceInMeters
        
        
    }
    
    
}

// MARK: -  MKLocalSearchCompleterDelegate

extension LocationSearchViewModel: MKLocalSearchCompleterDelegate{
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
        
    }
}
