import Foundation

func getData(urlRequest: String) {
    let urlRequest = URL(string: urlRequest)
    
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

getData(urlRequest: "https://api.spacexdata.com/v5/launches/latest")


