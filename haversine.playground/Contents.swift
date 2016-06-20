import Foundation

class location {
    var name: String
    var longitude: Double
    var latitude: Double
    var longitudeSinHalf: Double?
    var latitudeSinHalf: Double?
    
    init(name: String, longitude: Double, latitude: Double) {
        self.name = name
        self.longitude = longitude
        self.latitude = latitude
    }
    
    /**
     * These functions are added to our location for performance reasons to avoid duplication
     */
    func getLongitudeSinHalf() -> Double {
        if (self.longitudeSinHalf == nil) {
            self.longitudeSinHalf = sin(self.longitude / 2)
        }
        return self.longitudeSinHalf!
    }
    
    func getLatitudeSinHalf() -> Double {
        if (self.latitudeSinHalf == nil) {
            self.latitudeSinHalf = sin(self.latitude / 2)
        }
        return self.latitudeSinHalf!
    }
}

class distance {
    let kmToMiles: Double = 0.621371192
    
    func sphericalDistanceInMiles(locationFrom: location, locationTo: location) -> Double {
        return sphericalDistanceInKm(locationFrom, locationTo: locationTo) * self.kmToMiles
    }
    
    func sphericalDistanceInKm(locationFrom: location, locationTo: location) -> Double {
        let haversineFormulae = haversine()
        return haversineFormulae.calculateSphericalDistance(locationFrom, locationTo: locationTo)
    }
}

class haversine {
    let earthRadius: Double = 6371
    
    func calculateSphericalDistance(locationFrom: location, locationTo: location) -> Double {
        let locationDelta = calculateDeltaLocation(locationFrom, locationTo: locationTo)
        
        let a = locationDelta.getLatitudeSinHalf() * locationDelta.getLatitudeSinHalf() +
            cos(locationFrom.latitude * (M_PI / 180)) * cos(locationTo.latitude * (M_PI / 180)) *
            locationDelta.getLongitudeSinHalf() * locationDelta.getLongitudeSinHalf()
        let c = 2 * atan2(sqrt(a), sqrt(1-a))
        
        return self.earthRadius * c
    }
    
    func calculateDeltaLocation(locationFrom: location, locationTo: location) -> location {
        let deltaLatitude = (locationTo.latitude - locationFrom.latitude) * (M_PI / 180)
        let deltaLongitude = (locationTo.longitude - locationFrom.longitude) * (M_PI / 180)
        
        return location(name: "Delta", longitude: deltaLongitude, latitude: deltaLatitude)
    }
}

let locationFrom = location(name: "York", longitude: 1.0803, latitude: 53.9583)
let locationTo = location(name: "Bristol", longitude: 2.5833, latitude: 51.4500)

let distanceCalculator = distance()
let distanceBetweenPoints = distanceCalculator.sphericalDistanceInMiles(locationFrom, locationTo: locationTo)

print("Distance between \(locationFrom.name) and \(locationTo.name) is approximately \(round(distanceBetweenPoints)) miles")