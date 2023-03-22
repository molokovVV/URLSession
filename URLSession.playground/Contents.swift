import Foundation
import CryptoKit

let publicKey = "ab05bf3b748bba6fd68381c72d29f4d2"
let privateKey = "c0607a3b51d9e0478c798a2cac8d67d00e019d00"

//  Метод MD5-hash
func MD5(string: String) -> String {
    let digest = Insecure.MD5.hash(data: Data(string.utf8))

    return digest.map {
        String(format: "%02hhx", $0)
    }.joined()
}

// Получение URL
func creatingMarvelURL() -> URL? {
    let baseURL = "https://gateway.marvel.com/v1/public/characters"
    let ts = "\(Date().timeIntervalSince1970)"
    let hash = MD5(string: "\(ts)\(privateKey)\(publicKey)")
    
    var urlComponents = URLComponents(string: baseURL)
    
    var queryItems = [URLQueryItem(name: "apikey", value: publicKey),
                      URLQueryItem(name: "ts", value: ts),
                      URLQueryItem(name: "hash", value: hash)]
    
    urlComponents?.queryItems = queryItems
    
    return urlComponents?.url
}

func getData(urlRequest: URL?) {
    
    guard let url = urlRequest else { return }
    URLSession.shared.dataTask(with: url) { data, response, error in
        // Вывод ошибки, если имеется
        if let error = error {
            print("Ошибка:", error)
        }
        
        // Вывод кода ответа от сервера
        if let response = response as? HTTPURLResponse {
            let statusCode = response.statusCode
            switch statusCode {
            case 200:
                print("Код ответа с сервера:", statusCode)
                if let data = data, let dataAsString = String(data: data, encoding: .utf8) {
                    print("Данные, пришедшие с сервера:\n", dataAsString)
                }
            case 400...499:
                print("Ошибка клиента, код ответа:", statusCode)
            case 500...526:
                print("Ошибка сервера, код ответа:", statusCode)
            default:
                print("Неизвестная ошибка, код ответа:", statusCode)
            }
        }
    }.resume()
}

let marvilURL = creatingMarvelURL()
getData(urlRequest: marvilURL)


