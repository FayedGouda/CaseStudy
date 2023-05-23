
import Foundation

public typealias JSON = [String:Any]

/// Specifying requirments for request as end point, http method, http headers .....
public protocol TargetType{
    
    ///Base URL for your target
    var baseUrl:String { get }
    ///Http method such as GET, POST
    var httpMethod:HttpMethod { get }
    ///Path to your api ex:api.your_domain.com/api/users
    var endPoint:String { get }
}


open class NetworkManger<X:TargetType> {
        
    /// Make remote API call to a server
    /// - Parameters:
    ///   - target: target information
    ///   - parameters: parameters of request
    ///   - completion: completion to get result back with success or failure
    func request<T: Codable>(for target:X, parameters: JSON? = nil, completion: @escaping(Result<T, Error>) -> Void) {
        
        guard let request = createRequest(for:target, parameters: parameters) else { return }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            var result: Result<Data, Error>?
            
            if let responseStatusCode = response as? HTTPURLResponse{
                let error = self.handleStatusCodes(for: responseStatusCode.statusCode)
                
                result = .failure(error)
            }
            
            if let data = data {
                result = .success(data)
            }
            
            DispatchQueue.main.async {
                self.decodeResponse(result: result, completion: completion)
            }
        }.resume()
    }
}

extension NetworkManger{
    
    /// Helps to create URLRequest
    /// - Parameters:
    ///   - target: target information
    ///   - parameters: parameters of request
    /// - Returns: optional URLRequest
    private func createRequest(for target:X, parameters: JSON? = nil) -> URLRequest? {
        let urlString = target.baseUrl + target.endPoint
        guard let url = URL(string: urlString) else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let httpMethod = target.httpMethod
        urlRequest.httpMethod = httpMethod.rawValue
        
        if let params = parameters {
            switch httpMethod {
            case .get, .delete:
                var urlComponent = URLComponents(string: urlString)
                urlComponent?.queryItems = params.map { URLQueryItem(name: $0, value: "\($1)") }
                urlRequest.url = urlComponent?.url
                
            case .post, .patch, .put:
                let bodyData = try? JSONSerialization.data(withJSONObject: params, options: [])
                urlRequest.httpBody = bodyData
            }
        }
        return urlRequest
    }
}

extension NetworkManger{
    /// Decod api call response from JSON to Swift object
    /// - Parameters:
    ///   - result: a result  to decode to Generic T:Codable type
    ///   - completion: completion to get result back with success or failure
    private func decodeResponse<T: Codable>(result: Result<Data, Error>?, completion: (Result<T, Error>) -> Void) {
        guard let result = result else { return }
        
        switch result {
        case .success(let data):
            let decoder = JSONDecoder()
            guard let response = try? decoder.decode(T.self, from: data) else {
                completion(.failure(NetworkError.errorDecoding))
                return
            }
            completion(.success(response))
        case .failure(let error):
            completion(.failure(error))
        }
    }
}

extension NetworkManger{
    
    /// Return custom error based on response status code
    /// - Parameter statusCode: An integer value
    /// - Returns: An enum that descripes error type
    private func handleStatusCodes(for statusCode:Int)->NetworkError {
        switch statusCode{
        case 500:
            return .InternalServerError
        case 504, 502:
            return .TimeOut
        case 400:
            return .BadRequest
        case 401:
            return .Unauthorized
        case 404:
            return .NotFound
        case 415:
            return .UnsupportedMediaType
        default:
            return .UnknownError
        }
    }
}
