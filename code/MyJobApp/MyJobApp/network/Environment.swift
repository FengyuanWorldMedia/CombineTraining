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
            return "https://yourpostman-host.mock.pstmn.io/webapi"
        case .production:
            return "https://yourpostman-host.mock.pstmn.io/webapi"
        }
    }
}
