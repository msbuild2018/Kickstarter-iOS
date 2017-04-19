public enum LiveApiError: Error {
  case timedOut
  case genericFailure
  case huzzaApi(HuzzaApiError)
  case firebase(FirebaseError)

  public enum HuzzaApiError: Error {
    case invalidJson
    case invalidRequest
  }

  public enum FirebaseError {
    case chatMessageDecodingFailed
    case failedToInitialize
    case anonymousAuthFailed
    case customTokenAuthFailed
    case sendChatMessageFailed
    case snapshotDecodingFailed(path: String)
  }
}


extension LiveApiError: Equatable {
  public static func == (lhs: LiveApiError, rhs: LiveApiError) -> Bool {
    switch (lhs, rhs) {
    case (.genericFailure, .genericFailure),
         (.timedOut, .timedOut):
      return true
    case (.huzzaApi(let lhs), .huzzaApi(let rhs)):
      return lhs == rhs
    case (.firebase(let lhs), .firebase(let rhs)):
      return lhs == rhs
    case (genericFailure, _), (timedOut, _), (.huzzaApi, _), (.firebase, _):
      return false
    }
  }
}

extension LiveApiError.HuzzaApiError: Equatable {
  public static func == (lhs: LiveApiError.HuzzaApiError, rhs: LiveApiError.HuzzaApiError) -> Bool {
    switch (lhs, rhs) {
    case (.invalidJson, .invalidJson),
         (.invalidRequest, .invalidRequest):
      return true
    case (.invalidJson, _), (invalidRequest, _):
      return false
    }
  }
}

extension LiveApiError.FirebaseError: Equatable {
  public static func == (lhs: LiveApiError.FirebaseError, rhs: LiveApiError.FirebaseError) -> Bool {
    switch (lhs, rhs) {
    case (.chatMessageDecodingFailed, .chatMessageDecodingFailed),
         (.failedToInitialize, .failedToInitialize),
         (.anonymousAuthFailed, .anonymousAuthFailed),
         (.customTokenAuthFailed, .customTokenAuthFailed),
         (.sendChatMessageFailed, .sendChatMessageFailed):
      return true
    case (.snapshotDecodingFailed(let lhsPath), .snapshotDecodingFailed(let rhsPath)):
      return lhsPath == rhsPath
    case (.chatMessageDecodingFailed, _),
         (.failedToInitialize, _),
         (.anonymousAuthFailed, _),
         (.customTokenAuthFailed, _),
         (.sendChatMessageFailed, _),
         (.snapshotDecodingFailed, _):
      return false
    }
  }
}
