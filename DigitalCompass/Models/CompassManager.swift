import Foundation
import CoreLocation
import Combine
import SwiftUI
import UIKit
import AudioToolbox

class CompassManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var heading: Double = 0
    @Published var directionText: String = ""
    @Published var accuracy: CLHeadingAccuracy = .unknown
    @Published var accuracyStatus: AccuracyStatus = .unknown
    @Published var isCalibrating = false
    @Published var calibrationProgress: Double = 0
    @Published var magneticFieldStrength: Double = 0
    
    private var locationManager = CLLocationManager()
    private var settings: AppSettings?
    
    enum AccuracyStatus: String {
        case good = "good"
        case fair = "fair"
        case poor = "poor"
        case unknown = "unknown"
        
        var localizedKey: String {
            switch self {
            case .good: return "accuracy_good"
            case .fair: return "accuracy_fair"
            case .poor: return "accuracy_poor"
            case .unknown: return "accuracy_unknown"
            }
        }
        
        var color: Color {
            switch self {
            case .good: return AppColors.dark.accentPrimary
            case .fair: return AppColors.dark.accentOrange
            case .poor: return AppColors.dark.accentWarning
            case .unknown: return AppColors.dark.textTertiary
            }
        }
    }
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.headingFilter = kCLHeadingFilterNone
    }
    
    func setSettings(_ settings: AppSettings) {
        self.settings = settings
    }
    
    func startUpdates() {
        guard CLLocationManager.headingAvailable() else {
            accuracyStatus = .unknown
            return
        }
        
        let status = locationManager.authorizationStatus
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.startUpdatingHeading()
    }
    
    func stopUpdates() {
        locationManager.stopUpdatingHeading()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let headingValue = newHeading.magneticHeading
        
        withAnimation(.linear(duration: 0.1)) {
            self.heading = headingValue
        }
        
        self.directionText = directionText(for: headingValue)
        self.accuracy = newHeading.headingAccuracy
        self.accuracyStatus = determineAccuracyStatus(newHeading.headingAccuracy)
        
        if settings?.isSoundFeedbackEnabled == true {
            playFeedbackSound()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, shouldDisplayHeadingCalibration calibration: CLLocationManager) -> Bool {
        return true
    }
    
    private func determineAccuracyStatus(_ accuracy: CLLocationAccuracy) -> AccuracyStatus {
        if accuracy < 0 {
            return .unknown
        } else if accuracy <= 15 {
            return .good
        } else if accuracy <= 30 {
            return .fair
        } else {
            return .poor
        }
    }
    
    func directionText(for heading: Double) -> String {
        let directions = [
            "direction_n", "direction_nne", "direction_ne", "direction_ene",
            "direction_e", "direction_ese", "direction_se", "direction_sse",
            "direction_s", "direction_ssw", "direction_sw", "direction_wsw",
            "direction_w", "direction_wnw", "direction_nw", "direction_nnw"
        ]
        let index = Int((heading / 22.5) + 0.5) % 16
        return directions[index]
    }
    
    func directionDisplayName() -> String {
        guard let settings = settings else { return directionText }
        return settings.localizedString(directionText)
    }
    
    func startCalibration() {
        isCalibrating = true
        calibrationProgress = 0
    }
    
    func updateCalibrationProgress(_ progress: Double) {
        calibrationProgress = min(progress, 1.0)
        
        if calibrationProgress >= 1.0 {
            accuracyStatus = .good
        } else if calibrationProgress >= 0.6 {
            accuracyStatus = .fair
        }
    }
    
    func finishCalibration() {
        isCalibrating = false
        calibrationProgress = 1.0
        accuracyStatus = .good
    }
    
    private var lastFeedbackHeading: Double = 0
    private func playFeedbackSound() {
        let cardinalDirections: [Double] = [0, 90, 180, 270]
        
        for cardinal in cardinalDirections {
            let diff = abs(heading - cardinal)
            let normalizedDiff = min(diff, 360 - diff)
            
            if normalizedDiff < 3 && normalizedDiff != lastFeedbackHeading {
                AudioServicesPlaySystemSound(1519)
                lastFeedbackHeading = normalizedDiff
                break
            }
        }
    }
}

extension CompassManager {
    var accuracyPercentage: Double {
        switch accuracyStatus {
        case .good: return 1.0
        case .fair: return 0.6
        case .poor: return 0.3
        case .unknown: return 0
        }
    }
}
