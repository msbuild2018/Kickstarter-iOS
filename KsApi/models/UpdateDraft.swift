import Foundation

public struct UpdateDraft: Swift.Decodable {
  public let update: Update
  public let images: [Image]
  public let video: Video?

  public enum Attachment {
    case image(Image)
    case video(Video)
  }

  public struct Image: Swift.Decodable {
    public let id: Int
    public let thumb: String
    public let full: String
  }

  public struct Video: Swift.Decodable {
    public let id: Int
    public let status: Status
    public let frame: String

    public enum Status: String, Swift.Decodable {
      case processing
      case failed
      case successful
    }
  }
}

extension UpdateDraft: Equatable {}
public func == (lhs: UpdateDraft, rhs: UpdateDraft) -> Bool {
  return lhs.update.id == rhs.update.id
}

extension UpdateDraft.Attachment {
  public var id: Int {
    switch self {
    case let .image(image):
      return image.id
    case let .video(video):
      return video.id
    }
  }

  public var thumbUrl: String {
    switch self {
    case let .image(image):
      return image.full
    case let .video(video):
      return video.frame
    }
  }
}

extension UpdateDraft.Attachment: Equatable {}
public func == (lhs: UpdateDraft.Attachment, rhs: UpdateDraft.Attachment) -> Bool {
  return lhs.id == rhs.id
}

extension UpdateDraft.Video.Status: Argo.Decodable {
}
