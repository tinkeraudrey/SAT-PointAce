import UIKit

class ViewController3: UIViewController {
    
    // Properties to store reward information
    var rewards: [Reward] = [] {
        didSet {
            saveRewards()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // Load saved rewards
        loadRewards()
        
        // Create "Add Reward" button
        let addButton = UIButton(type: .system)
        addButton.setTitle("Add Reward", for: .normal)
        addButton.setTitleColor(.black, for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.addTarget(self, action: #selector(addRewardButtonTapped), for: .touchUpInside)
        
        view.addSubview(addButton)
        
        // Configure the scroll view and stack view
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        
        // Layout constraints for the button and scroll view
        NSLayoutConstraint.activate([
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -720),
            
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            
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
                
                // Update UI to display the rewards
                self?.updateUI()
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
        // Remove previous reward labels
        view.subviews.forEach { subview in
            if subview.tag == 100 {
                subview.removeFromSuperview()
            }
        }
        
        // Display rewards
        var yOffset: CGFloat = 150.0
        for (index, reward) in rewards.enumerated() {
            let rewardView = UIView(frame: CGRect(x: 20, y: yOffset, width: view.frame.width - 40, height: 130))
            rewardView.backgroundColor = UIColor(red: 139/255, green: 159/255, blue: 187/255, alpha: 1.0)
            rewardView.layer.cornerRadius = 10
            rewardView.tag = 100
            
            let titleLabel = UILabel(frame: CGRect(x: 10, y: 10, width: rewardView.frame.width - 20, height: 30))
            titleLabel.text = reward.name
            titleLabel.textColor = .black
            titleLabel.font = UIFont.systemFont(ofSize: 25)
            rewardView.addSubview(titleLabel)
            
            let descriptionLabel = UILabel(frame: CGRect(x: 10, y: 40, width: rewardView.frame.width - 20, height: 50))
            descriptionLabel.text = reward.description
            descriptionLabel.textColor = .darkGray
            descriptionLabel.font = UIFont.systemFont(ofSize: 18)
            descriptionLabel.numberOfLines = 0
            rewardView.addSubview(descriptionLabel)
            
            let numberLabel = UILabel(frame: CGRect(x: 10, y: 90, width: rewardView.frame.width - 20, height: 30))
            numberLabel.text = "Points: \(reward.number)"
            numberLabel.textColor = UIColor(red: 58/255, green: 69/255, blue: 99/255, alpha: 1.0)
            numberLabel.font = UIFont.boldSystemFont(ofSize: 18)
            rewardView.addSubview(numberLabel)
            
            // Add swipe gesture recognizer for deletion
            let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft(_:)))
            swipeLeft.direction = .left
            rewardView.addGestureRecognizer(swipeLeft)
            
            view.addSubview(rewardView)
            
            yOffset += 150 // Increase yOffset for next reward
        }
    }
    
    @objc func handleSwipeLeft(_ gesture: UISwipeGestureRecognizer) {
        guard let rewardView = gesture.view else { return }
        let index = (rewardView.frame.minY - 150) / 150
        let reward = rewards[Int(index)]
        
        let alertController = UIAlertController(title: "Delete Reward",
                                                message: "Are you sure you want to delete the reward: \(reward.name)?",
                                                preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.rewards.remove(at: Int(index))
            self?.updateUI()
        }
        alertController.addAction(deleteAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
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
}

// Reward struct to hold reward information
struct Reward: Codable {
    let name: String
    let description: String
    let number: Int
}
