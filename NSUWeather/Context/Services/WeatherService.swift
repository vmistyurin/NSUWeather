import Foundation

final class WeatherService {
    private static let url = URL(string: "http://weather.nsu.ru/loadata.php")!
    private let urlSession = URLSession.shared
}

// MARK: - getTemperature method

extension WeatherService {
    func getTemperature(completion: @escaping (Result<String, Error>) -> ()) {
        let task = urlSession.dataTask(with: WeatherService.url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            
            guard let data = data, let string = String(data: data, encoding: .utf8) else {
                completion(.failure(WeatherServiceError.emptyResponse))
                return
            }
            
            guard let jsRange = string.range(of: "cnv.innerHTML = '") else {
                completion(.failure(WeatherServiceError.incorrectResponse))
                return
            }
            
            let beginTemperature = jsRange.upperBound
            guard let endTemperature = string.nextOccurance(of: "'", afterIndex: beginTemperature) else {
                completion(.failure(WeatherServiceError.incorrectResponse))
                return
            }
            
            let result = string[beginTemperature..<endTemperature]            
            completion(.success(String(result).withReplacedDegreeSymbol))
        }
        
        task.resume()
    }
}

// MARK: - String helpers

private extension String {
    func nextOccurance(of character: Character, afterIndex: String.Index) -> String.Index? {
        return suffix(from: afterIndex).firstIndex(of: character)
    }
    
    var withReplacedDegreeSymbol: String {
        return replacingOccurrences(of: "&deg;", with: "°")
    }
}
