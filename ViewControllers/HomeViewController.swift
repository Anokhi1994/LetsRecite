import UIKit

protocol HomeViewControllerDelegate: AnyObject {
    func didTapMenuButton()
}

class HomeViewController: UIViewController {
    
    weak var delegate: HomeViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Home"
        
        setupUI()
    }
    
    private func setupUI() {
        // Create and configure the label
        let descriptionLabel = UILabel()
        descriptionLabel.text = """
        The seven gems are the essence of The Bhagavad Gita. As per the revelation to Pujya Babuji Maharaj, these were the only words conveyed by Lord Shri Krishna to Arjun. This makes logical sense as well. In the midst of the battlefield, at the time of war, there couldn't have possibly been enough time for Lord Krishna and Arjun to have a dialogue consisting of 700 verses. Tune into the entire talk by Revered Daaji on this topic:
        """
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        
        // Create and configure the button
        let reciteButton = UIButton(type: .system)
        reciteButton.setTitle("Let's Recite", for: .normal)
        reciteButton.backgroundColor = UIColor(red: 0.0, green: 0.5, blue: 0.5, alpha: 1.0) // Example color, adjust based on your web app
        reciteButton.setTitleColor(.white, for: .normal)
        reciteButton.layer.cornerRadius = 10
        reciteButton.translatesAutoresizingMaskIntoConstraints = false
        reciteButton.addTarget(self, action: #selector(didTapReciteButton), for: .touchUpInside)
        view.addSubview(reciteButton)
        
        // Set up constraints
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            reciteButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            reciteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            reciteButton.widthAnchor.constraint(equalToConstant: 200),
            reciteButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func didTapReciteButton() {
        // Handle button tap, navigate to the recite screen
        let reciteVC = ReciteViewController()
        navigationController?.pushViewController(reciteVC, animated: true)
    }
}
