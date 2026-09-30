import CoreLocation

final class LocationService {
    
    private let geocoder = CLGeocoder()
    
    func getCityName(from coordinate: CLLocationCoordinate2D, completion: @escaping (String) -> Void) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                completion("Выбранная точка")
                return
            }
            
            let cityName = placemarks?.first?.locality
                ?? placemarks?.first?.name
                ?? "Выбранная точка"
            
            completion(cityName)
        }
    }
}
