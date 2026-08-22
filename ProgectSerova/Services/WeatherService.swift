import Foundation

final class WeatherService: WeatherServiceable {
    
    private var units: String {
        StorageService.shared.getUnits()
    }
    
    func fetchCurrentWeather(
        city: String,
        completion: @escaping (Result<WeatherResponse, NetworkError>) -> Void
    ) {
        let safeCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city
        
        let urlString = Constants.baseURL
        + WeatherEndpoint.weather.rawValue
        + "?q=\(safeCity)&units=\(units)&appid=\(Constants.apiKey)&lang=ru"
        
        request(urlString: urlString, completion: completion)
    }
    
    func fetchForecast(
        city: String,
        completion: @escaping (Result<ForecastResponse, NetworkError>) -> Void
    ) {
        
        let safeCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city
        
        let urlString = Constants.baseURL
        + WeatherEndpoint.forecast.rawValue
        + "?q=\(safeCity)&units=\(units)&appid=\(Constants.apiKey)&lang=ru"
        
        request(urlString: urlString, completion: completion)
    }
    
    func fetchCurrentWeather(
        lat: Double,
        lon: Double,
        completion: @escaping (Result<WeatherResponse, NetworkError>) -> Void
    ) {
        let urlString = Constants.baseURL
        + WeatherEndpoint.weather.rawValue
        + "?lat=\(lat)&lon=\(lon)&units=\(units)&appid=\(Constants.apiKey)&lang=ru"
        
        request(urlString: urlString, completion: completion)
    }
    
    private func request<T: Decodable>(
        urlString: String,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        guard let url = URL(string: urlString) else {
            print("❌ ОШИБКА: Неправильный URL - \(urlString)")
            completion(.failure(.invalidURL))
            return
        }
        
        print("🌐 ОТПРАВЛЯЮ ЗАПРОС: \(url.absoluteString)")
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                print("❌ ОШИБКА СЕТИ: \(error.localizedDescription)")
                completion(.failure(.requestFailed(error)))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.invalidStatusCode))
                return
            }
            
            if !(200...299).contains(response.statusCode) {
                print("❌ СЕРВЕР ОТВЕТИЛ ОШИБКОЙ: Код \(response.statusCode)")
                if let data = data, let errorMessage = String(data: data, encoding: .utf8) {
                    print("❌ ТЕКСТ ОШИБКИ СЕРВЕРА: \(errorMessage)")
                }
                
                completion(.failure(.invalidStatusCode))
                return
            }
            
            guard let data = data else { return }
            
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                print("❌ ОШИБКА ДЕКОДИРОВАНИЯ: \(error)")
                completion(.failure(.decodingError))
            }
            
        }.resume()
    }
}
