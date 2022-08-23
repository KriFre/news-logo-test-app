//
//  NewsReqUtil.swift
//  Logo
//
//  Created by Kristaps Freibergs on 16/08/2022.
//

import Foundation

let ARTICLE_PAGINATION: Int = 10

private enum NewsEndpoint {
    case topHeadlines
    case search
    
    static func baseEndpoint() -> String {
        return "https://gnews.io/api/v4"
    }
    
    func path(_ addParams: [String: String]) -> URL? {
        var url = NewsEndpoint.baseEndpoint()
        let params = addParams.merging(["token": API_KEY]) { (current, _) in current }
        switch self {
        case .topHeadlines:
            url += "/top-headlines"
        case .search:
            url += "/search"
        }
        
        guard var components = URLComponents(string: url) else {
            return nil
        }
        components.queryItems = params.map {
            URLQueryItem(name: $0, value: $1)
        }
        
        return components.url
    }
    
}

class NewsReqUtil {
    static func parseStatusCode(statusCode: Int) {
        switch(statusCode){
        case 403:
            print("⚠️⚠️ REQUEST LIMIT REACHED!!! ⚠️⚠️")
            break
        case 429:
            print("⚠️⚠️ REQUESTS TOO FAST, SLOW DOWN A BIT!! ⚠️⚠️")
            break
        case 401:
            print("⚠️⚠️ API TOKEN MISSING!!!! ⚠️⚠️")
            break
        default:
            print("statusCode: ", statusCode)
        }
    }
    
    static func getTopHeadlines(fromDate: Date) async -> [String: AnyObject]? {
        let fromDateStr = fromDate.toNewsApiDateString()
        let params: [String: String] = ["to": fromDateStr, "max": String(ARTICLE_PAGINATION)]
        guard let url = NewsEndpoint.topHeadlines.path(params) else {
            return nil
        }
        do {
            
            let result: (data: Data, response: URLResponse) = try await URLSession.shared.data(from: url)
            if let statusCode = (result.response as? HTTPURLResponse)?.statusCode {
                parseStatusCode(statusCode: statusCode)
            }
            let data = result.data
            let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [String: AnyObject]
            
            return json
        } catch {
            print(error)
        }
        return nil
    }
    
    static func getSearch(text: String,
                          fromDate: Date?,
                          toDate: Date,
                          searchIn: [SearchParamSearchIn],
                          sortOrder: SearchParamSorting) async -> [String: AnyObject]? {
        let toDateStr = toDate.toNewsApiDateString()
        var params: [String: String] = ["to": toDateStr, "max": String(ARTICLE_PAGINATION), "sortby": sortOrder.rawValue, "q": text]
        if let safeFromDate = fromDate {
            params["from"] = safeFromDate.toNewsApiDateString()
        }
        if (searchIn.count > 0) {
            params["in"] = searchIn.map{ $0.rawValue }.joined(separator: ",")
        }
        
        guard let url = NewsEndpoint.search.path(params) else {
            return nil
        }
        do {
            
            let result: (data: Data, response: URLResponse) = try await URLSession.shared.data(from: url)
            let data = result.data
            if let statusCode = (result.response as? HTTPURLResponse)?.statusCode {
                parseStatusCode(statusCode: statusCode)
            }
            let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [String: AnyObject]
            return json
        } catch {
            print(error)
        }
        return nil
    }
}

