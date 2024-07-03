import UIKit

class ViewController3: UIViewController {
    
    var rewards: [Reward] = [] {
        didSet {
            saveRewards()
        }
    }
    
    var totalElapsed: TimeInterval = 0 {
        didSet {
            updatePointsButton()
        }
    }
    
    let addRewardButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Reward", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 58/255, green: 69/255, blue: 99/255, alpha: 1.0)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(addRewardButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let pointsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Points: 0", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 58/255, green: 69/255, blue: 99/255, alpha: 1.0)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(pointsButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        loadRewards()
        
        totalElapsed = UserDefaults.standard.double(forKey: "totalElapsed")
        
        view.addSubview(addRewardButton)
        view.addSubview(pointsButton)
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            pointsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pointsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            pointsButton.widthAnchor.constraint(equalToConstant: 200),
            pointsButton.heightAnchor.constraint(equalToConstant: 50),
            
            addRewardButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addRewardButton.topAnchor.constraint(equalTo: pointsButton.bottomAnchor, constant: 20),
            addRewardButton.widthAnchor.constraint(equalToConstant: 200),
            addRewardButton.heightAnchor.constraint(equalToConstant: 50),
            
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scrollView.topAnchor.constraint(equalTo: addRewardButton.bottomAnchor, constant: 40),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        updatePointsButton()
        updateUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(totalElapsedChanged(_:)), name: .totalElapsedDidChange, object: nil)
    }
    
    @objc func addRewardButtonTapped() {
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
                let reward = Reward(name: rewardName, description: rewardDescription, number: assignedNumber)
                self?.rewards.append(reward)
                
                self?.updateUI()
            }
        }
        alertController.addAction(addAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func updateUI() {
        view.subviews.forEach { subview in
            if subview.tag == 100 {
                subview.removeFromSuperview()
            }
        }
        
        var yOffset: CGFloat = 250.0 // Increased to provide more space above for the text and button
        for (index, reward) in rewards.enumerated() {
            let rewardView = UIView(frame: CGRect(x: 20, y: yOffset, width: view.frame.width - 40, height: 100)) // Shortened height
            rewardView.backgroundColor = UIColor(red: 139/255, green: 159/255, blue: 187/255, alpha: 1.0)
            rewardView.layer.cornerRadius = 10
            rewardView.tag = 100
            
            let titleLabel = UILabel(frame: CGRect(x: 10, y: 10, width: rewardView.frame.width - 20, height: 30))
            titleLabel.text = reward.name
            titleLabel.textColor = .black
            titleLabel.font = UIFont.systemFont(ofSize: 25)
            rewardView.addSubview(titleLabel)
            
            let descriptionLabel = UILabel(frame: CGRect(x: 10, y: 40, width: rewardView.frame.width - 20, height: 30)) // Adjusted height
            descriptionLabel.text = reward.description
            descriptionLabel.textColor = .darkGray
            descriptionLabel.font = UIFont.systemFont(ofSize: 18)
            descriptionLabel.numberOfLines = 0
            rewardView.addSubview(descriptionLabel)
            
            let numberLabel = UILabel(frame: CGRect(x: 10, y: 70, width: rewardView.frame.width - 20, height: 20)) // Adjusted position and height
            numberLabel.text = "Points: \(reward.number)"
            numberLabel.textColor = UIColor(red: 58/255, green: 69/255, blue: 99/255, alpha: 1.0)
            numberLabel.font = UIFont.boldSystemFont(ofSize: 18)
            rewardView.addSubview(numberLabel)
            
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
            rewardView.addGestureRecognizer(panGesture)
            
            view.addSubview(rewardView)
            
            yOffset += 120 // Adjusted spacing
        }
    }
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard let rewardView = gesture.view else { return }
        let translation = gesture.translation(in: view)
        
        switch gesture.state {
        case .changed:
            rewardView.center.x = rewardView.center.x + translation.x
            gesture.setTranslation(.zero, in: view)
        case .ended:
            if rewardView.frame.origin.x < -view.frame.width * 0.3 {
                UIView.animate(withDuration: 0.3, animations: {
                    rewardView.frame.origin.x = -self.view.frame.width
                }) { _ in
                    let alertController = UIAlertController(title: "Delete Reward",
                                                            message: "Are you sure you want to delete this reward?",
                                                            preferredStyle: .alert)
                    
                    let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
                        let index = Int((rewardView.frame.minY - 250) / 120) // Adjusted for new yOffset
                        self?.rewards.remove(at: index)
                        self?.updateUI()
                    }
                    alertController.addAction(deleteAction)
                    
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                        UIView.animate(withDuration: 0.3) {
                            rewardView.frame.origin.x = 20
                        }
                    }
                    alertController.addAction(cancelAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    rewardView.frame.origin.x = 20
                }
            }
        default:
            break
        }
    }
    
    func saveRewards() {
        let defaults = UserDefaults.standard
        if let savedData = try? JSONEncoder().encode(rewards) {
            defaults.set(savedData, forKey: "rewards")
        }
    }
    
    func loadRewards() {
        let defaults = UserDefaults.standard
        if let savedData = defaults.data(forKey: "rewards"),
           let savedRewards = try? JSONDecoder().decode([Reward].self, from: savedData) {
            rewards = savedRewards
        }
    }
    
    @objc func totalElapsedChanged(_ notification: Notification) {
        if let newTotalElapsed = notification.userInfo?["totalElapsed"] as? TimeInterval {
            totalElapsed = newTotalElapsed
        }
    }
    
    @objc func pointsButtonTapped() {
        totalElapsed = UserDefaults.standard.double(forKey: "totalElapsed")
        updatePointsButton()
    }
    
    func updatePointsButton() {
        pointsButton.setTitle("Points: \(Int(totalElapsed))", for: .normal)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

struct Reward: Codable {
    let name: String
    let description: String
    let number: Int
}

extension Notification.Name {
    static let totalElapsedDidChange = Notification.Name("totalElapsedDidChange")
}
