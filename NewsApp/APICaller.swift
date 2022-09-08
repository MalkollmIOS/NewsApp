//
//  APICaller.swift
//  NewsApp
//
//  Created by Марсель Фаткуллин on 07.09.2022.
//

import Foundation

final class APICaller{
    static let shared = APICaller()
    
    struct Constants{
        static let topHeadLinesURL = URL(string:
                                            "https://newsapi.org/v2/everything?q=Apple&from=2022-09-07&sortBy=popularity&apiKey=3148680f05f74198916b6076237d5708"
        )
    }
    
    private init(){}
    
    public func getTopStories(completion: @escaping(Result<[Article], Error>) -> Void){
        guard let url = Constants.topHeadLinesURL else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do{
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    print("Articles: \(result.articles.count)")
                    
                    completion(.success(result.articles))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}

//Models
struct APIResponse: Codable{
    let articles: [Article]
}

struct Article: Codable{
    let source: Source
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
}

struct Source: Codable{
    let name: String
}
