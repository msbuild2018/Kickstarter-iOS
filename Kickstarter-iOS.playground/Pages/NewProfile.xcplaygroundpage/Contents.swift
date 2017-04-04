@testable import Kickstarter_Framework
@testable import KsApi
import Library
import PlaygroundSupport
import Prelude
import Prelude_UIKit
import UIKit

initialize()

let apiService = MockService(
  fetchDiscoveryResponse:
    DiscoveryEnvelope.template
      |> DiscoveryEnvelope.lens.projects .~ [Project.cosmicSurgery, Project.anomalisa, Project.todayByScottThrift]
)
AppEnvironment.replaceCurrentEnvironment(
  apiService: apiService,
  language: .es
)

let vc = Storyboard.BackerDashboard.instantiate(BackerDashboardViewController.self)

let (parent, _) = playgroundControllers(device: .phone4_7inch, orientation: .portrait, child: vc)

PlaygroundPage.current.liveView = parent
