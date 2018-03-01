import Foundation

public struct PushEnvelope: Swift.Decodable {
  public let activity: Activity?
  public let aps: ApsEnvelope
  public let forCreator: Bool?
  public let liveStream: LiveStream?
  public let message: Message?
  public let project: Project?
  public let survey: Survey?
  public let update: Update?

  public struct Activity: Swift.Decodable {
    public let category: KsApi.Activity.Category
    public let commentId: Int?
    public let id: Int
    public let projectId: Int?
    public let projectPhoto: String?
    public let updateId: Int?
    public let userPhoto: String?
  }

  public struct ApsEnvelope: Swift.Decodable {
    public let alert: String
  }

  public struct LiveStream: Swift.Decodable {
    public let id: Int
  }

  public struct Message: Swift.Decodable {
    public let messageThreadId: Int
    public let projectId: Int
  }

  public struct Project: Swift.Decodable {
    public let id: Int
    public let photo: String?
  }

  public struct Survey: Swift.Decodable {
    public let id: Int
    public let projectId: Int
  }

  public struct Update: Swift.Decodable {
    public let id: Int
    public let projectId: Int
  }
}

extension PushEnvelope {
  enum CodingKeys: String, CodingKey {
    case activity,
    aps,
    forCreator = "for_creator",
    liveStream = "live_stream",
    message,
    project,
    survey,
    update // check this  <*> optionalUpdate
  }

  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.activity = try? values.decode(Activity.self, forKey: .activity)
    self.aps = try values.decode(ApsEnvelope.self, forKey: .aps)
    self.forCreator = try? values.decode(Bool.self, forKey: .forCreator)
    self.liveStream = try? values.decode(LiveStream.self, forKey: .liveStream)
    self.message = try? values.decode(Message.self, forKey: .message)
    self.project = try? values.decode(Project.self, forKey: .project)
    self.survey = try? values.decode(Survey.self, forKey: .survey)
    self.update = try? values.decode(Update.self, forKey: .update)
  }
}

extension PushEnvelope.Activity {
  enum CodingKeys: String, CodingKey {
    case category,
    commentId = "comment_id",
    id,
    projectId = "project_id",
    projectPhoto = "project_photo",
    updateId = "update_id",
    userPhoto = "user_photo"
  }
}

extension PushEnvelope.Message {
  enum CodingKeys: String, CodingKey {
    case messageThreadId = "message_thread_id",
    projectId = "project_id"
  }
}

extension PushEnvelope.Survey {
  enum CodingKeys: String, CodingKey {
    case id,
    projectId = "project_id"
  }
}

extension PushEnvelope.Update {
  enum CodingKeys: String, CodingKey {
    case id,
    projectId = "project_id"
  }
}
