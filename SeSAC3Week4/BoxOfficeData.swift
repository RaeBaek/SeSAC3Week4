//
//  BoxOfficeData.swift
//  SeSAC3Week4
//
//  Created by 백래훈 on 2023/08/14.
//

import Foundation

// MARK: - Welcome
struct BoxOffice: Codable {
    let boxOfficeResult: BoxOfficeResult
}

// MARK: - BoxOfficeResult
struct BoxOfficeResult: Codable {
    let boxofficeType, showRange: String
    let dailyBoxOfficeList: [DailyBoxOfficeList]
}

// MARK: - DailyBoxOfficeList
struct DailyBoxOfficeList: Codable {
    let audiAcc, salesAcc, movieCD, openDt: String
    let rank, audiChange: String
    let rankOldAndNew: RankOldAndNew
    let audiCnt, movieNm, rankInten, showCnt: String
    let audiInten, salesChange, rnum, salesAmt: String
    let salesShare, salesInten, scrnCnt: String

    enum CodingKeys: String, CodingKey {
        case audiAcc, salesAcc
        case movieCD = "movieCd"
        case openDt, rank, audiChange, rankOldAndNew, audiCnt, movieNm, rankInten, showCnt, audiInten, salesChange, rnum, salesAmt, salesShare, salesInten, scrnCnt
    }
}

enum RankOldAndNew: String, Codable {
    case old = "OLD"
}
