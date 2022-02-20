// Created by 丰源天下 on 2021/11/30.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.

import Foundation

public enum Environment: String, CaseIterable {
    case development 
    case production
}

extension Environment {
    /// postman mock server.
    var serviceBaseUrl: String {
        switch self {
        case .development:
            return "https://7a5fffa1-b400-4b2a-bf47-2e36ce89bf99.mock.pstmn.io/api"
        case .production:
            return "https://7a5fffa1-b400-4b2a-bf47-2e36ce89bf99.mock.pstmn.io/api"
        }
    }
}
