import Foundation
import CoreLocation
import Combine

class QiblaManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var currentLocation: CLLocation?
    @Published var qiblaDirection: Double = 0
    @Published var rotationNeeded: Double = 0
    @Published var locationStatus: LocationStatus = .unknown
    @Published var compassHeading: Double = 0
    
    private var locationManager = CLLocationManager()
    private var settings: AppSettings?
    private var compassManager: CompassManager?
    private var isCompassPipelineConnected = false
    
    let meccaLocation = CLLocation(latitude: 21.4225, longitude: 39.8262)
    
    enum LocationStatus: String {
        case unknown = "unknown"
        case loading = "loading"
        case authorized = "authorized"
        case denied = "denied"
        case error = "error"
        
        var localizedKey: String {
            switch self {
            case .unknown: return "location_unknown"
            case .loading: return "location_loading"
            case .authorized: return "location_authorized"
            case .denied: return "location_denied"
            case .error: return "location_error"
            }
        }
    }
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }
    
    func setSettings(_ settings: AppSettings) {
        self.settings = settings
    }
    
    func setCompassManager(_ compassManager: CompassManager) {
        self.compassManager = compassManager
        guard !isCompassPipelineConnected else { return }
        isCompassPipelineConnected = true
        
        compassManager.$heading
            .receive(on: RunLoop.main)
            .sink { [weak self] heading in
                self?.compassHeading = heading
                self?.updateRotationNeeded()
            }
            .store(in: &cancellables)
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    func requestLocation() {
        let status = locationManager.authorizationStatus
        
        switch status {
        case .notDetermined:
            locationStatus = .loading
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationStatus = .loading
            locationManager.requestLocation()
        case .denied, .restricted:
            locationStatus = .denied
        @unknown default:
            locationStatus = .unknown
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationStatus = .loading
            manager.requestLocation()
        case .denied, .restricted:
            locationStatus = .denied
        case .notDetermined:
            locationStatus = .unknown
        @unknown default:
            locationStatus = .unknown
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        currentLocation = location
        locationStatus = .authorized
        
        calculateQiblaDirection(from: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationStatus = .error
    }
    
    private func calculateQiblaDirection(from location: CLLocation) {
        let userLat = location.coordinate.latitude * .pi / 180
        let userLon = location.coordinate.longitude * .pi / 180
        let meccaLat = meccaLocation.coordinate.latitude * .pi / 180
        let meccaLon = meccaLocation.coordinate.longitude * .pi / 180
        
        let deltaLon = meccaLon - userLon
        
        let y = sin(deltaLon) * cos(meccaLat)
        let x = cos(userLat) * sin(meccaLat) - sin(userLat) * cos(meccaLat) * cos(deltaLon)
        
        var bearing = atan2(y, x) * 180 / .pi
        bearing = (bearing + 360).truncatingRemainder(dividingBy: 360)
        
        qiblaDirection = bearing
        updateRotationNeeded()
    }
    
    private func updateRotationNeeded() {
        var diff = qiblaDirection - compassHeading
        
        while diff < -180 {
            diff += 360
        }
        while diff > 180 {
            diff -= 360
        }
        
        rotationNeeded = diff
    }
    
    var qiblaDirectionText: String {
        guard let settings = settings else { return "" }
        let index = Int((qiblaDirection / 22.5) + 0.5) % 16
        let directions = [
            "direction_n", "direction_nne", "direction_ne", "direction_ene",
            "direction_e", "direction_ese", "direction_se", "direction_sse",
            "direction_s", "direction_ssw", "direction_sw", "direction_wsw",
            "direction_w", "direction_wnw", "direction_nw", "direction_nnw"
        ]
        return settings.localizedString(directions[index])
    }
    
    var formattedQiblaDirection: String {
        return String(format: "%.0f°", qiblaDirection)
    }
    
    var formattedCompassHeading: String {
        return String(format: "%.0f°", compassHeading)
    }
    
    var rotationDirectionText: String {
        guard let settings = settings else { return "" }
        if abs(rotationNeeded) < 5 {
            return settings.localizedString("qibla_aligned")
        }
        return rotationNeeded > 0 
            ? settings.localizedString("rotate_clockwise")
            : settings.localizedString("rotate_counterclockwise")
    }
}
