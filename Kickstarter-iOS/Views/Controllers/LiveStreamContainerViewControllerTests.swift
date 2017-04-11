import Prelude
import Result
@testable import Kickstarter_Framework
@testable import KsApi
@testable import Library
@testable import LiveStream

internal final class LiveStreamContainerViewControllerTests: TestCase {
  fileprivate var cosmicSurgery: Project!

  override func setUp() {
    super.setUp()

    let deadline = self.dateType.init().timeIntervalSince1970 + 60.0 * 60.0 * 24.0 * 14.0
    let launchedAt = self.dateType.init().timeIntervalSince1970 - 60.0 * 60.0 * 24.0 * 14.0
    let project = Project.cosmicSurgery
      |> Project.lens.photo.full .~ ""
      |> (Project.lens.creator.avatar • User.Avatar.lens.small) .~ ""
      |> Project.lens.dates.deadline .~ deadline
      |> Project.lens.dates.launchedAt .~ launchedAt

    self.cosmicSurgery = project

    AppEnvironment.pushEnvironment(
      config: .template |> Config.lens.countryCode .~ self.cosmicSurgery.country.countryCode,
      mainBundle: Bundle.framework
    )

    UIView.setAnimationsEnabled(false)
  }

  override func tearDown() {
    AppEnvironment.popEnvironment()
    UIView.setAnimationsEnabled(true)
    super.tearDown()
  }

  func testReplay() {
    let liveStreamEvent = .template
      |> LiveStreamEvent.lens.hasReplay .~ true
      |> LiveStreamEvent.lens.liveNow .~ false
      |> LiveStreamEvent.lens.startDate .~ (MockDate().addingTimeInterval(-86_400)).date
      |> LiveStreamEvent.lens.replayUrl .~ "http://www.replay.com"
      |> LiveStreamEvent.lens.name .~ "Title of the live stream goes here and can be 60 chr max"
      |> LiveStreamEvent.lens.description .~ ("175 char max. 175 char max 175 char max message with " +
        "a max character count. Hi everyone! We’re doing an exclusive performance of one of our new tracks!")

    let devices = [Device.phone4_7inch, .phone4inch, .pad]
    let orientations = [Orientation.landscape, .portrait]

    let liveStreamService = MockLiveStreamService(fetchEventResult: Result(liveStreamEvent))

    combos(Language.allLanguages, devices, orientations).forEach { lang, device, orientation in
      withEnvironment(apiDelayInterval: .seconds(3), language: lang, liveStreamService: liveStreamService) {
        let vc = LiveStreamContainerViewController.configuredWith(project: .template,
                                                                  liveStreamEvent: liveStreamEvent,
                                                                  refTag: .projectPage,
                                                                  presentedFromProject: false)

        let (parent, _) = traitControllers(device: device, orientation: orientation, child: vc)
        self.scheduler.advance(by: .seconds(3))
        vc.liveVideoViewControllerPlaybackStateChanged(controller: nil, state: .loading)

        FBSnapshotVerifyView(
          parent.view, identifier: "lang_\(lang)_device_\(device)_orientation_\(orientation)"
        )
      }
    }
  }

  func testLive() {
    let liveStreamEvent = .template
      |> LiveStreamEvent.lens.startDate .~ (MockDate().addingTimeInterval(-86_400)).date
      |> LiveStreamEvent.lens.liveNow .~ true
      |> LiveStreamEvent.lens.name .~ "Title of the live stream goes here and can be 60 chr max"
      |> LiveStreamEvent.lens.description .~ ("175 char max. 175 char max 175 char max message with " +
        "a max character count. Hi everyone! We’re doing an exclusive performance of one of our new tracks!")

    let devices = [Device.phone4_7inch, .phone4inch, .pad]
    let orientations = [Orientation.landscape, .portrait]

    let liveStreamService = MockLiveStreamService(fetchEventResult: Result(liveStreamEvent))

    combos(Language.allLanguages, devices, orientations).forEach { lang, device, orientation in
      withEnvironment(apiDelayInterval: .seconds(3), language: lang, liveStreamService: liveStreamService) {
        let vc = LiveStreamContainerViewController.configuredWith(project: .template,
                                                                  liveStreamEvent: liveStreamEvent,
                                                                  refTag: .projectPage,
                                                                  presentedFromProject: false)

        let (parent, _) = traitControllers(device: device, orientation: orientation, child: vc)
        self.scheduler.advance(by: .seconds(3))

        FBSnapshotVerifyView(
          parent.view, identifier: "lang_\(lang)_device_\(device)_orientation_\(orientation)"
        )
      }
    }
  }

  func testFreshLiveStreamEventFetchFailed() {
    let liveStreamEvent = .template
      |> LiveStreamEvent.lens.startDate .~ (MockDate().addingTimeInterval(-86_400)).date
      |> LiveStreamEvent.lens.liveNow .~ true
      |> LiveStreamEvent.lens.name .~ "Title of the live stream goes here and can be 60 chr max"
      |> LiveStreamEvent.lens.description .~ ("175 char max. 175 char max 175 char max message with " +
        "a max character count. Hi everyone! We’re doing an exclusive performance of one of our new tracks!")

    let devices = [Device.phone4_7inch, .phone4inch, .pad]
    let orientations = [Orientation.landscape, .portrait]

    let liveStreamService = MockLiveStreamService(fetchEventResult: Result(error: .genericFailure))

    combos(Language.allLanguages, devices, orientations).forEach { lang, device, orientation in
      withEnvironment(apiDelayInterval: .seconds(3), language: lang, liveStreamService: liveStreamService) {
        let vc = LiveStreamContainerViewController.configuredWith(project: .template,
                                                                  liveStreamEvent: liveStreamEvent,
                                                                  refTag: .projectPage,
                                                                  presentedFromProject: false)

        let (parent, _) = traitControllers(device: device, orientation: orientation, child: vc)
        self.scheduler.advance(by: .seconds(3))

        FBSnapshotVerifyView(
          parent.view, identifier: "lang_\(lang)_device_\(device)_orientation_\(orientation)"
        )
      }
    }
  }

  func testPlaybackStates() {
    let liveStreamEvent = .template
      |> LiveStreamEvent.lens.startDate .~ (MockDate().addingTimeInterval(-86_400)).date
      |> LiveStreamEvent.lens.liveNow .~ true
      |> LiveStreamEvent.lens.name .~ "Title of the live stream goes here and can be 60 chr max"
      |> LiveStreamEvent.lens.description .~ ("175 char max. 175 char max 175 char max message with " +
        "a max character count. Hi everyone! We’re doing an exclusive performance of one of our new tracks!")

    let playbackStates: [LiveVideoPlaybackState] = [
      .loading,
      .playing
    ]

    let liveStreamService = MockLiveStreamService(fetchEventResult: Result(liveStreamEvent))

    combos(Language.allLanguages, playbackStates).forEach { lang, state in
      withEnvironment(apiDelayInterval: .seconds(3), language: lang, liveStreamService: liveStreamService) {
        let vc = LiveStreamContainerViewController.configuredWith(project: .template,
                                                                  liveStreamEvent: liveStreamEvent,
                                                                  refTag: .projectPage,
                                                                  presentedFromProject: false)

        let (parent, _) = traitControllers(device: .phone4_7inch, orientation: .portrait, child: vc)
        self.scheduler.advance(by: .seconds(3))

        vc.liveVideoViewControllerPlaybackStateChanged(controller: nil, state: .loading)

        let stateIdentifier = state == .playing ? "playing" : "loading"

        FBSnapshotVerifyView(
          parent.view, identifier: "lang_\(lang)_state_\(stateIdentifier)"
        )
      }
    }

    Language.allLanguages.forEach { lang in
      withEnvironment(apiDelayInterval: .seconds(3), language: lang,
                      liveStreamService: MockLiveStreamService(
                        greenRoomOffStatusResult: Result([false]),
                        fetchEventResult: Result(liveStreamEvent)
      )) {
        let vc = LiveStreamContainerViewController.configuredWith(project: .template,
                                                                  liveStreamEvent: liveStreamEvent,
                                                                  refTag: .projectPage,
                                                                  presentedFromProject: false)

        let (parent, _) = traitControllers(device: .phone4_7inch, orientation: .portrait, child: vc)
        self.scheduler.advance(by: .seconds(3))

        FBSnapshotVerifyView(
          parent.view, identifier: "lang_\(lang)_state_greenRoom"
        )
      }
    }
  }

  func testPresentedFromProject() {
    let liveStreamEvent = .template
      |> LiveStreamEvent.lens.hasReplay .~ true
      |> LiveStreamEvent.lens.liveNow .~ false
      |> LiveStreamEvent.lens.startDate .~ (MockDate().addingTimeInterval(-86_400)).date
      |> LiveStreamEvent.lens.replayUrl .~ "http://www.replay.com"
      |> LiveStreamEvent.lens.name .~ "Title of the live stream"
      |> LiveStreamEvent.lens.description .~ "Short description of live stream"

    let liveStreamService = MockLiveStreamService(fetchEventResult: Result(liveStreamEvent))

    withEnvironment(liveStreamService: liveStreamService) {
      let vc = LiveStreamContainerViewController.configuredWith(project: .template,
                                                                liveStreamEvent: liveStreamEvent,
                                                                refTag: .projectPage,
                                                                presentedFromProject: true)

      let (parent, _) = traitControllers(device: .phone4_7inch, orientation: .portrait, child: vc)
      self.scheduler.advance()
      vc.liveVideoViewControllerPlaybackStateChanged(controller: nil, state: .loading)

      FBSnapshotVerifyView(parent.view)
    }
  }

  func testSubscribed() {
    let liveStreamEvent = .template
      |> LiveStreamEvent.lens.hasReplay .~ true
      |> LiveStreamEvent.lens.user .~ LiveStreamEvent.User(isSubscribed: true)
      |> LiveStreamEvent.lens.liveNow .~ false
      |> LiveStreamEvent.lens.startDate .~ (MockDate().addingTimeInterval(-86_400)).date
      |> LiveStreamEvent.lens.replayUrl .~ "http://www.replay.com"
      |> LiveStreamEvent.lens.name .~ "Title of the live stream"
      |> LiveStreamEvent.lens.description .~ "Short description of live stream"

    let liveStreamService = MockLiveStreamService(fetchEventResult: Result(liveStreamEvent))

    withEnvironment(liveStreamService: liveStreamService) {
      let vc = LiveStreamContainerViewController.configuredWith(project: .template,
                                                                liveStreamEvent: liveStreamEvent,
                                                                refTag: .projectPage,
                                                                presentedFromProject: true)

      let (parent, _) = traitControllers(device: .phone4_7inch, orientation: .portrait, child: vc)
      self.scheduler.advance()
      vc.liveVideoViewControllerPlaybackStateChanged(controller: nil, state: .loading)

      FBSnapshotVerifyView(parent.view)
    }
  }

  func testChat_Live() {
    let liveStreamEvent = .template
      |> LiveStreamEvent.lens.startDate .~ (MockDate().addingTimeInterval(-86_400)).date
      |> LiveStreamEvent.lens.liveNow .~ true
      |> LiveStreamEvent.lens.name .~ "Title of the live stream goes here and can be 60 chr max"
      |> LiveStreamEvent.lens.description .~ ("175 char max. 175 char max 175 char max message with " +
        "a max character count. Hi everyone! We’re doing an exclusive performance of one of our new tracks!")

    let devices = [Device.phone4_7inch, .phone4inch, .pad]
    let orientations = [Orientation.landscape, .portrait]

    let chatMessages = (1...50)
      .map(String.init)
      .map { .template |> LiveStreamChatMessage.lens.id .~ $0 }

    let liveStreamService = MockLiveStreamService(
      fetchEventResult: Result(liveStreamEvent),
      initialChatMessagesResult: Result([chatMessages])
    )

    combos(Language.allLanguages, devices, orientations).forEach { lang, device, orientation in
      withEnvironment(apiDelayInterval: .seconds(3), language: lang, liveStreamService: liveStreamService) {
        let vc = LiveStreamContainerViewController.configuredWith(project: .template,
                                                                  liveStreamEvent: liveStreamEvent,
                                                                  refTag: .projectPage,
                                                                  presentedFromProject: false)

        let (parent, _) = traitControllers(device: device, orientation: orientation, child: vc)

        vc.liveStreamContainerPageViewController?.chatButtonTapped()

        self.scheduler.advance(by: .seconds(3))

        FBSnapshotVerifyView(
          parent.view, identifier: "lang_\(lang)_device_\(device)_orientation_\(orientation)"
        )
      }
    }
  }

  func testChat_Replay() {
    let liveStreamEvent = .template
      |> LiveStreamEvent.lens.startDate .~ (MockDate().addingTimeInterval(-86_400)).date
      |> LiveStreamEvent.lens.hasReplay .~ true
      |> LiveStreamEvent.lens.replayUrl .~ "http://www.replay.com"
      |> LiveStreamEvent.lens.liveNow .~ false
      |> LiveStreamEvent.lens.name .~ "Title of the live stream goes here and can be 60 chr max"
      |> LiveStreamEvent.lens.description .~ ("175 char max. 175 char max 175 char max message with " +
        "a max character count. Hi everyone! We’re doing an exclusive performance of one of our new tracks!")

    let devices = [Device.phone4_7inch, .phone4inch, .pad]
    let orientations = [Orientation.landscape, .portrait]

    let chatMessages = (1...50)
      .map(String.init)
      .map { .template |> LiveStreamChatMessage.lens.id .~ $0 }

    let liveStreamService = MockLiveStreamService(
      fetchEventResult: Result(liveStreamEvent),
      initialChatMessagesResult: Result([chatMessages])
    )

    combos(Language.allLanguages, devices, orientations).forEach { lang, device, orientation in
      withEnvironment(apiDelayInterval: .seconds(3), language: lang, liveStreamService: liveStreamService) {
        let vc = LiveStreamContainerViewController.configuredWith(project: .template,
                                                                  liveStreamEvent: liveStreamEvent,
                                                                  refTag: .projectPage,
                                                                  presentedFromProject: false)

        let (parent, _) = traitControllers(device: device, orientation: orientation, child: vc)

        vc.liveStreamContainerPageViewController?.chatButtonTapped()

        self.scheduler.advance(by: .seconds(3))
        vc.liveVideoViewControllerPlaybackStateChanged(controller: nil, state: .loading)

        FBSnapshotVerifyView(
          parent.view, identifier: "lang_\(lang)_device_\(device)_orientation_\(orientation)"
        )
      }
    }
  }

  func testRewards() {
    let project = self.cosmicSurgery!

    let liveStreamEvent = .template
      |> LiveStreamEvent.lens.startDate .~ (MockDate().addingTimeInterval(-86_400)).date
      |> LiveStreamEvent.lens.liveNow .~ true
      |> LiveStreamEvent.lens.name .~ "Title of the live stream goes here and can be 60 chr max"
      |> LiveStreamEvent.lens.description .~ ("175 char max. 175 char max 175 char max message with " +
        "a max character count. Hi everyone! We’re doing an exclusive performance of one of our new tracks!")

    let devices = [Device.phone4_7inch, .phone4inch, .pad]
    let orientations = [Orientation.landscape, .portrait]

    let liveStreamService = MockLiveStreamService(
      fetchEventResult: Result(liveStreamEvent)
    )

    combos(Language.allLanguages, devices, orientations).forEach { lang, device, orientation in
      withEnvironment(apiDelayInterval: .seconds(3), language: lang, liveStreamService: liveStreamService) {
        let vc = LiveStreamContainerViewController.configuredWith(project: project,
                                                                  liveStreamEvent: liveStreamEvent,
                                                                  refTag: .projectPage,
                                                                  presentedFromProject: false)

        let (parent, _) = traitControllers(device: device, orientation: orientation, child: vc)
        parent.view.frame.size.height = device == .pad ? 2_400 : 2_000

        vc.liveStreamContainerPageViewController?.rewardsButtonTapped()

        self.scheduler.advance(by: .seconds(3))

        FBSnapshotVerifyView(
          parent.view, identifier: "lang_\(lang)_device_\(device)_orientation_\(orientation)"
        )
      }
    }
  }
}
