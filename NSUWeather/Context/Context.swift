import Foundation

final class Context {
    let weatherService: WeatherService
    
    init() {
        self.weatherService = WeatherService()
    }
}
