//
//  CoinsApiService.swift
//  crypto-ios
//
//  Created by Patrick Ngo on 2024-08-11.
//  Copyright © 2024 patrickngo. All rights reserved.
//

import Alamofire

protocol CoinsApiService {
  func fetchCoinList(for page: Int,
                     pageSize: Int,
                     searchText: String?,
                     completion: @escaping (Swift.Result<CoinListResponse, Error>) -> Void)
  func fetchCoinDetail(for coinId: String,
                       completion: @escaping (Swift.Result<CoinDetailResponse, Error>) -> Void)
}

final class CoinsApiServiceImp: CoinsApiService {

  private enum Constants {
    static let API_KEY = "coinrankinga44fe0b9022456831a84eb33eb4945fec78f3467df4f263a" // TODO: Move this to secure storage
    static let BASE_URL = "https://api.coinranking.com/v2/"
  }

  init() {}

  func fetchCoinList(for page: Int,
                     pageSize: Int,
                     searchText: String?,
                     completion: @escaping (Swift.Result<CoinListResponse, Error>) -> Void) {
    let endPoint = "coins"
    let url = URL(string: "\(Constants.BASE_URL)\(endPoint)")!
    let offset = page == 0 ? 1 : page*pageSize
    var parameters: Parameters = [
      "limit" : pageSize,
      "offset": offset
    ]
    if let searchText {
      parameters["search"] = searchText
    }

    request(url,
            parameters: parameters,
            headers: getHeaders()).response { response in
      if let result = response.data,
         let coinListResponse = try? JSONDecoder().decode(CoinListResponse.self, from: result) {
        completion(.success(coinListResponse))
      } else if let error = response.error {
        completion(.failure(error))
      }
    }
  }

  func fetchCoinDetail(for coinId: String,
                       completion: @escaping (Swift.Result<CoinDetailResponse, Error>) -> Void) {
    let endPoint = "coin/\(coinId)"
    let url = URL(string: "\(Constants.BASE_URL)\(endPoint)")!
    let parameters: Parameters = [:]

    request(url,
            parameters: parameters,
            headers: getHeaders()).response { response in
      if let result = response.data,
         let coinDetailResponse = try? JSONDecoder().decode(CoinDetailResponse.self, from: result) {
        completion(.success(coinDetailResponse))
      } else if let error = response.error {
        completion(.failure(error))
      }
    }
  }

  private func getHeaders() -> HTTPHeaders {
    let headers: HTTPHeaders = [
      "x-access-token": Constants.API_KEY
    ]
    return headers
  }
}
