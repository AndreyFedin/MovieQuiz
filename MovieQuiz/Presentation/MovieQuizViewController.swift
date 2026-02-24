import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    // MARK: - Outlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    
    // MARK: - Properties
    private var presenter: MovieQuizPresenter!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoadingIndicator()
        presenter = MovieQuizPresenter(viewController: self)
    }
    
    // MARK: - Actions
    @IBAction private func noButtonClicked(_ sender: Any) {
        lockButtons()
        presenter.noButtonClicked()
    }
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        lockButtons()
        presenter.yesButtonClicked()
    }
    
    // MARK: - MovieQuizViewControllerProtocol
    func show(quiz step: QuizStepViewModel) {
        imageView.image = UIImage(data: step.imageData) ?? UIImage()
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        resetLayer()
    }
    
    func show(quiz result: QuizResultsViewModel) {
        let message = presenter.makeResultsMessage()
        
        let alert = UIAlertController(
            title: result.title,
            message: message,
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.presenter.restartGame()
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let alert = UIAlertController(
            title: "Ошибка",
            message: message,
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(
            title: "Попробовать ещё раз",
            style: .default
        ) { [weak self] _ in
            guard let self = self else { return }
            self.presenter.restartGame()
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func showLoadingIndicator() {
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
    }
    
    func lockButtons() {
        yesButton.isEnabled = false
        noButton.isEnabled = false
    }
    
    func unlockButtons() {
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    // MARK: - UI Helpers
    private func resetLayer() {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 0
        imageView.layer.cornerRadius = 20
    }
}
