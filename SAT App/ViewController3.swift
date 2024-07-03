import UIKit

class ViewController3: UIViewController {
    
    // Properties to store reward information
    var rewards: [Reward] = [] {
        didSet {
            saveRewards()
            updateUI()
        }
    }
    
    var totalElapsed: TimeInterval = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // Load saved rewards
        loadRewards()
        
        // Create "Add Reward" button
        let addButton = UIButton(type: .system)
        addButton.setTitle("Add Reward", for: .normal)
        addButton.setTitleColor(.white, for: .normal)
        addButton.backgroundColor = UIColor(hex: "#3A4563")
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        addButton.layer.cornerRadius = 10
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.addTarget(self, action: #selector(addRewardButtonTapped), for: .touchUpInside)
        
        view.addSubview(addButton)
        
        // Create "Points" button
        let pointsButton = UIButton(type: .system)
        pointsButton.setTitle("Points: \(Int(totalElapsed))", for: .normal)
        pointsButton.setTitleColor(.white, for: .normal)
        pointsButton.backgroundColor = UIColor(hex: "#3A4563")
        pointsButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        pointsButton.layer.cornerRadius = 10
        pointsButton.translatesAutoresizingMaskIntoConstraints = false
        pointsButton.addTarget(self, action: #selector(pointsButtonTapped), for: .touchUpInside)
        
        view.addSubview(pointsButton)
        
        // Configure the scroll view and stack view
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        
        // Layout constraints for the buttons, scroll view, and stack view
        NSLayoutConstraint.activate([
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            addButton.widthAnchor.constraint(equalToConstant: 150),
            addButton.heightAnchor.constraint(equalToConstant: 50),
            
            pointsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pointsButton.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 20),
            pointsButton.widthAnchor.constraint(equalToConstant: 150),
            pointsButton.heightAnchor.constraint(equalToConstant: 50),
            
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scrollView.topAnchor.constraint(equalTo: pointsButton.bottomAnchor, constant: 20),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        updateUI()
    }
    
    @objc func addRewardButtonTapped() {
        // Create an alert controller with text fields
        let alertController = UIAlertController(title: "Add Reward",
                                                message: nil,
                                                preferredStyle: .alert)
        
        alertController.addTextField { (nameTextField) in
            nameTextField.placeholder = "Reward Name"
        }
        
        alertController.addTextField { (descriptionTextField) in
            descriptionTextField.placeholder = "Description (optional)"
        }
        
        alertController.addTextField { (numberTextField) in
            numberTextField.placeholder = "Assign a Number"
            numberTextField.keyboardType = .numberPad
        }
        
        // Add action for "Add" button
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] (_) in
            guard let nameTextField = alertController.textFields?[0],
                  let descriptionTextField = alertController.textFields?[1],
                  let numberTextField = alertController.textFields?[2],
                  let rewardName = nameTextField.text, !rewardName.isEmpty else {
                return
            }
            
            let rewardDescription = descriptionTextField.text ?? ""
            let assignedNumberText = numberTextField.text ?? ""
            if let assignedNumber = Int(assignedNumberText) {
                // Create a reward object and store it
                let reward = Reward(name: rewardName, description: rewardDescription, number: assignedNumber)
                self?.rewards.append(reward)
            }
        }
        alertController.addAction(addAction)
        
        // Add cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }
    
    // Function to update UI with rewards
    func updateUI() {
        // Remove previous reward views
        view.subviews.forEach { subview in
            if subview is RewardView {
                subview.removeFromSuperview()
            }
        }
        
        // Display rewards
        var yOffset: CGFloat = 20.0
        for reward in rewards {
            let rewardView = RewardView(reward: reward)
            rewardView.delegate = self
            rewardView.frame = CGRect(x: 20, y: yOffset, width: view.frame.width - 40, height: 100)
            rewardView.backgroundColor = UIColor(hex: "#8B9FBB")
            rewardView.layer.cornerRadius = 10
            view.addSubview(rewardView)
            
            yOffset += 120.0 // Increase yOffset for next reward view
        }
    }
    
    // Function to save rewards to UserDefaults
    func saveRewards() {
        let defaults = UserDefaults.standard
        if let savedData = try? JSONEncoder().encode(rewards) {
            defaults.set(savedData, forKey: "rewards")
        }
    }
    
    // Function to load rewards from UserDefaults
    func loadRewards() {
        let defaults = UserDefaults.standard
        if let savedData = defaults.data(forKey: "rewards"),
           let savedRewards = try? JSONDecoder().decode([Reward].self, from: savedData) {
            rewards = savedRewards
        }
    }
    
    @objc func pointsButtonTapped() {
        let alertController = UIAlertController(title: "Points",
                                                message: "Current Points: \(Int(totalElapsed))",
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

// Reward struct to hold reward information
struct Reward: Codable {
    let name: String
    let description: String
    let number: Int
}

// Custom UIView subclass to represent each reward view
class RewardView: UIView {
    
    weak var delegate: ViewController3?
    var reward: Reward
    
    init(reward: Reward) {
        self.reward = reward
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        // Add tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(rewardTapped))
        self.addGestureRecognizer(tapGesture)
        
        // Setup reward view UI
        let titleLabel = UILabel()
        titleLabel.text = reward.name
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = reward.description
        descriptionLabel.textColor = .darkGray
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(descriptionLabel)
        
        let numberLabel = UILabel()
        numberLabel.text = "Cost: \(reward.number) points"
        numberLabel.textColor = .blue
        numberLabel.font = UIFont.boldSystemFont(ofSize: 18)
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(numberLabel)
        
        // Constraints
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            numberLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5),
            numberLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            numberLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            numberLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
        
        // Styling
        backgroundColor = UIColor(hex: "#8B9FBB")
        layer.cornerRadius = 10
    }
    
    @objc func rewardTapped() {
        delegate?.buyReward(self.reward)
    }
}

extension UIColor {
    convenience init(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

extension ViewController3: RewardDelegate {
    func buyReward(_ reward: Reward) {
        let alertController = UIAlertController(title: "Buy Reward",
                                                message: "Do you want to buy \(reward.name) for \(reward.number) points?",
                                                preferredStyle: .alert)
        
        let buyAction = UIAlertAction(title: "Buy", style: .default) { [weak self] _ in
            guard let self = self else { return }
            if self.totalElapsed >= TimeInterval(reward.number) {
                self.totalElapsed -= TimeInterval(reward.number)
                if let index = self.rewards.firstIndex(where: { $0.name == reward.name }) {
                    self.rewards.remove(at: index)
                    self.updateUI()
                    self.updatePointsButton()
                }
            } else {
                let insufficientPointsAlert = UIAlertController(title: "Insufficient Points",
                                                                message: "You don't have enough points to buy this reward.",
                                                                preferredStyle: .alert)
                insufficientPointsAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(insufficientPointsAlert, animated: true, completion: nil)
            }
        }
        alertController.addAction(buyAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

protocol RewardDelegate: AnyObject {
    func buyReward(_ reward: Reward)
}
