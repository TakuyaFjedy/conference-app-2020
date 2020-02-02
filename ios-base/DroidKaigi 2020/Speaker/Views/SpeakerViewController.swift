import Foundation
import ios_combined
import Nuke
import UIKit

final class SpeakerViewController: UIViewController {
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var userImageView: UIImageView! {
        didSet {
            userImageView.clipsToBounds = true
            userImageView.layer.cornerRadius = userImageView.bounds.width / 2
        }
    }

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var biographyLabel: UILabel!

    private var speaker: AppSpeaker!
    private var sessions: [AppBaseSession]!

    static func instantiate(speaker: AppSpeaker, sessions: [AppBaseSession]) -> SpeakerViewController {
        guard let viewController = UIStoryboard(name: "SpeakerViewController", bundle: .main).instantiateInitialViewController() as? SpeakerViewController else { fatalError() }
        viewController.speaker = speaker
        viewController.sessions = sessions
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = .black
    }

    private func setupUI() {
        if
            let imageUrl = speaker.imageUrl,
            let url = URL(string: imageUrl) {
            Nuke.loadImage(with: url, into: userImageView)
        }
        userNameLabel.text = speaker.name
        tagLabel.text = speaker.tagLine
        biographyLabel.text = speaker.bio

        sessions.forEach { session in
            let sessionView = SpeakerSessionView.instantiate()
            sessionView.sessionTitleLabel.text = session.title?.ja ?? ""
            sessionView.sessionDateLabel.text = session.shortSummary(lang: .ja)
            stackView.insertArrangedSubview(sessionView, at: stackView.arrangedSubviews.count)
        }
    }
}
