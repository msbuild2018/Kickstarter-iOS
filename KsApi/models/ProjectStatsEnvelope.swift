import Foundation

public struct ProjectStatsEnvelope: Swift.Decodable {
  public let cumulativeStats: CumulativeStats
  public let fundingDistribution: [FundingDateStats]
  public let referralDistribution: [ReferrerStats]
  public let rewardDistribution: [RewardStats]
  public let videoStats: VideoStats?

  public struct CumulativeStats: Swift.Decodable {
    public let averagePledge: Int
    public let backersCount: Int
    public let goal: Int
    public let percentRaised: Double
    public let pledged: Int
  }

  public struct FundingDateStats: Swift.Decodable {
    public let backersCount: Int
    public let cumulativePledged: Int
    public let cumulativeBackersCount: Int
    public let date: TimeInterval
    public let pledged: Int
  }

  public struct ReferrerStats: Swift.Decodable {
    public let backersCount: Int
    public let code: String
    public let percentageOfDollars: Double
    public let pledged: Double
    public let referrerName: String
    public let referrerType: ReferrerType

    public enum ReferrerType: String, Swift.Decodable {
      case custom
      case external
      case `internal`
      case unknown
    }
  }

  public struct RewardStats: Swift.Decodable {
    public let backersCount: Int
    public let rewardId: Int
    public let minimum: Int?
    public let pledged: Int

    public static let zero = RewardStats(backersCount: 0, rewardId: 0, minimum: 0, pledged: 0)
  }

  public struct VideoStats: Swift.Decodable {
    public let externalCompletions: Int
    public let externalStarts: Int
    public let internalCompletions: Int
    public let internalStarts: Int
  }
}

extension ProjectStatsEnvelope {
  enum CodingKeys: String, CodingKey {
    case cumulativeStats = "cumulative",
    fundingDistribution = "funding_distribution",
    referralDistribution = "referral_distribution",
    rewardDistribution = "reward_distribution",
    videoStats = "video_stats"
  }

  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.cumulativeStats = try values.decode(CumulativeStats.self, forKey: .cumulativeStats)
    self.fundingDistribution = try values.decode([FundingDateStats].self, forKey: .fundingDistribution)
    self.referralDistribution = try values.decode([ReferrerStats].self, forKey: .referralDistribution)
    self.rewardDistribution = try values.decode([RewardStats].self, forKey: .rewardDistribution)
    self.videoStats = try? values.decode(VideoStats.self, forKey: .videoStats)
  }
}

extension ProjectStatsEnvelope.CumulativeStats {
  enum CodingKeys: String, CodingKey {
    case averagePledge = "average_pledge",
    backersCount = "backers_count",
    goal,
    percentRaised = "percent_raised",
    pledged
  }

  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    let averageDouble = try values.decode(Double.self, forKey: .averagePledge)
    self.averagePledge = Int(averageDouble)
    self.backersCount = try values.decode(Int.self, forKey: .backersCount)
    let goalString = try values.decode(String.self, forKey: .goal)
    self.goal = stringToIntOrZero(goalString)
    self.percentRaised = try values.decode(Double.self, forKey: .percentRaised)
    let pledgedString = try values.decode(String.self, forKey: .pledged)
    self.pledged = stringToIntOrZero(pledgedString)
  }
}

extension ProjectStatsEnvelope.CumulativeStats: Equatable {}
public func == (lhs: ProjectStatsEnvelope.CumulativeStats, rhs: ProjectStatsEnvelope.CumulativeStats)
  -> Bool {
    return lhs.averagePledge == rhs.averagePledge
}

extension ProjectStatsEnvelope.FundingDateStats {
  enum CodingKeys: String, CodingKey {
    case backersCount = "backers_count",
    cumulativePledged = "cumulative_pledged",
    cumulativeBackersCount = "cumulative_backers_count",
    date,
    pledged
  }

  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    do {
      self.backersCount = try values.decode(Int.self, forKey: .backersCount)
    } catch {
      self.backersCount = 0
    }

    do {
      let cumulativePledgedString = try values.decode(String.self, forKey: .cumulativePledged)
      self.cumulativePledged = stringToIntOrZero(cumulativePledgedString)
    } catch {
      self.cumulativePledged = try values.decode(Int.self, forKey: .cumulativePledged)
    }

    self.cumulativeBackersCount = try values.decode(Int.self, forKey: .cumulativeBackersCount)
    self.date = try values.decode(TimeInterval.self, forKey: .date)

    do {
      let pledgedString = try values.decode(String.self, forKey: .pledged)
      self.pledged = stringToIntOrZero(pledgedString)
    } catch {
      self.pledged = 0
    }
  }
}

extension ProjectStatsEnvelope.FundingDateStats: Equatable {}
public func == (lhs: ProjectStatsEnvelope.FundingDateStats, rhs: ProjectStatsEnvelope.FundingDateStats)
  -> Bool {
    return lhs.date == rhs.date
}

extension ProjectStatsEnvelope.ReferrerStats {
  enum CodingKeys: String, CodingKey {
    case backersCount = "backers_count",
    code,
    percentageOfDollars = "percentage_of_dollars",
    pledged,
    referrerName = "referrer_name",
    referrerType = "referrer_type"
  }

  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    
    self.backersCount = try values.decode(Int.self, forKey: .backersCount)
    self.code = try values.decode(String.self, forKey: .code)
    let percentageOfDollarsString = try values.decode(String.self, forKey: .percentageOfDollars)
    self.percentageOfDollars = stringToDouble(percentageOfDollarsString)
    let pledgedString = try values.decode(String.self, forKey: .pledged)
    self.pledged = stringToDouble(pledgedString)
    self.referrerName = try values.decode(String.self, forKey: .referrerName)
    let referrerTypeString = try values.decode(String.self, forKey: .referrerType)
    self.referrerType = ReferrerType.format(referrerTypeString)
  }
}

extension ProjectStatsEnvelope.ReferrerStats: Equatable {}
public func == (lhs: ProjectStatsEnvelope.ReferrerStats, rhs: ProjectStatsEnvelope.ReferrerStats) -> Bool {
  return lhs.code == rhs.code
}

extension ProjectStatsEnvelope.ReferrerStats.ReferrerType {
  public static func format(_ referrer: String) -> ProjectStatsEnvelope.ReferrerStats.ReferrerType {
      switch referrer.lowercased() {
      case "custom":
        return .custom
      case "external":
        return .external
      case "kickstarter":
        return .`internal`
      default:
        return .unknown
      }
  }
}

extension ProjectStatsEnvelope.RewardStats {
  enum CodingKeys: String, CodingKey {
    case backersCount = "backers_count",
    rewardId = "reward_id",
    minimum,
    pledged
  }

  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.backersCount = try values.decode(Int.self, forKey: .backersCount)
    self.rewardId = try values.decode(Int.self, forKey: .rewardId)

    do {
      let minimumString = try values.decode(String.self, forKey: .minimum)
      self.minimum = stringToInt(minimumString)
    } catch {
      self.minimum = try? values.decode(Int.self, forKey: .minimum)
    }

    let pledgedString = try values.decode(String.self, forKey: .pledged)
    self.pledged = stringToIntOrZero(pledgedString)
  }
}

extension ProjectStatsEnvelope.RewardStats: Equatable {}
public func == (lhs: ProjectStatsEnvelope.RewardStats, rhs: ProjectStatsEnvelope.RewardStats)
  -> Bool {
  return lhs.rewardId == rhs.rewardId
}

extension ProjectStatsEnvelope.VideoStats {
  enum CodingKeys: String, CodingKey {
    case externalCompletions = "external_completions",
    externalStarts = "external_starts",
    internalCompletions = "internal_completions",
    internalStarts = "internal_starts"
  }

  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.externalCompletions = try values.decode(Int.self, forKey: .externalCompletions)
    self.externalStarts = try values.decode(Int.self, forKey: .externalStarts)
    self.internalCompletions = try values.decode(Int.self, forKey: .internalCompletions)
    self.internalStarts = try values.decode(Int.self, forKey: .internalStarts)
  }
}

extension ProjectStatsEnvelope.VideoStats: Equatable {}
public func == (lhs: ProjectStatsEnvelope.VideoStats, rhs: ProjectStatsEnvelope.VideoStats) -> Bool {
  return
    lhs.externalCompletions == rhs.externalCompletions &&
    lhs.externalStarts == rhs.externalStarts &&
    lhs.internalCompletions == rhs.internalCompletions &&
    lhs.internalStarts == rhs.internalStarts
}

private func stringToIntOrZero(_ string: String) -> Int {
  return
    Double(string).flatMap(Int.init) ?? Int(string) ?? 0
}

private func stringToInt(_ string: String?) -> Int? {
  guard let string = string else { return nil }

  return
    Double(string).flatMap(Int.init) ?? Int(string) ?? nil
}

private func stringToDouble(_ string: String) -> Double {
  return Double(string) ?? 0
}
