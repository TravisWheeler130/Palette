//
//  PaletteListViewController.swift
//  PaletteiOS29
//
//  Created by Travis Wheeler on 10/22/19.
//  Copyright © 2019 Darin Armstrong. All rights reserved.
//

// Step 1 - Declare our Views
// Step 2 - Add our subviews to their superview
// Step 3 - Constrain our views

import UIKit

class PaletteListViewController: UIViewController {
    
//MARK: - Properties
    var safeArea: UILayoutGuide {
        return self.view.safeAreaLayoutGuide
    }
    
    var buttons: [UIButton] {
        return [featuredButton, doubleRainbowButton, randomButton]
    }
    
    var photos: [UnsplashPhoto] = []
    
    override func loadView() {
        super.loadView()
        addAllSubviews()
        setUpStackView()
        constrainViews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        searchForCategory(.featured)
        activateButtons()
        selectButton(featuredButton)

        // Do any additional setup after loading the view.
    }
    
    //MARK: - API Helper Function
    
    func searchForCategory(_ route: UnsplashRoute) {
        UnsplashService.shared.fetchFromUnsplash(for: route) { (photos) in
            DispatchQueue.main.async {
                guard let photos = photos else {return}
                self.photos = photos
                self.paletteTableView.reloadData()
            }
        }
    }
    
//MARK: - Create Subviews (Part 1)
    
    let featuredButton: UIButton = {
        let button = UIButton()
        button.setTitle("Featured", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.contentHorizontalAlignment = .center
        return button
    }()
    
    let randomButton: UIButton = {
       let button = UIButton()
        button.setTitle("Random", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.contentHorizontalAlignment = .center
        return button
    }()
    
    let doubleRainbowButton: UIButton = {
        let button = UIButton()
        button.setTitle("Double Rainbow", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.contentHorizontalAlignment = .center
        return button
    }()
    
    let buttonStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.alignment = .fill
        
        return stackView
    }()
    
    let paletteTableView: UITableView = {
       let tableView = UITableView()
        return tableView
    }()
    
//MARK: - Add Subviews (Part 2)
    
    func addAllSubviews() {
        self.view.addSubview(featuredButton)
        self.view.addSubview(randomButton)
        self.view.addSubview(doubleRainbowButton)
        self.view.addSubview(buttonStackView)
        self.view.addSubview(paletteTableView)
    }
    
    func setUpStackView() {
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.addArrangedSubview(featuredButton)
        buttonStackView.addArrangedSubview(doubleRainbowButton)
        buttonStackView.addArrangedSubview(randomButton)
    }
    
    func configureTableView() {
        paletteTableView.delegate = self
        paletteTableView.dataSource = self
        paletteTableView.register(PaletteTableViewCell.self, forCellReuseIdentifier: "paletteCell")
        paletteTableView.allowsSelection = false
    }
    
    //MARK: - Constrain Views (Part 3)
    
    func constrainViews() {
        paletteTableView.anchor(top: buttonStackView.bottomAnchor, bottom: self.safeArea.bottomAnchor, leading: self.safeArea.leadingAnchor, trailing: self.safeArea.trailingAnchor, topPadding: (buttonStackView.frame.height/2), bottomPadding: 0, leadingPadding: 0, trailingPadding: 0)
        
        buttonStackView.anchor(top: self.safeArea.topAnchor, bottom: nil, leading: self.safeArea.leadingAnchor, trailing: self.safeArea.trailingAnchor, topPadding: 0, bottomPadding: 0, leadingPadding: 8, trailingPadding: 8)
    }
    
    //MARK: - IBAction for buttons
    func activateButtons() {
        buttons.forEach{ $0.addTarget(self, action: #selector(searchButtonTapped(sender:)), for: .touchUpInside)}
    }
    
    @objc func searchButtonTapped(sender: UIButton) {
        selectButton(sender)
        switch sender {
        case randomButton:
            searchForCategory(.random)
        case doubleRainbowButton:
            searchForCategory(.doubleRainbow)
        case featuredButton:
            searchForCategory(.featured)
        default:
            print("Error, button was not found")
        }
    }
    // when tapping a button it turns devmountainBlue and all the other buttons turn offwhite.
    func selectButton(_ button: UIButton) {
        buttons.forEach {$0.setTitleColor(UIColor(named: "offWhite"), for: .normal) }
        button.setTitleColor(UIColor(named: "devmountainBlue"), for: .normal)
    }
} // End of Class

//MARK: - TableView Conformance (Delegate & DataSource)

extension PaletteListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "paletteCell", for: indexPath) as! PaletteTableViewCell
        
        let photo = photos[indexPath.row]
        cell.photo = photo
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageViewSpace: CGFloat = (view.frame.width - (2 * SpacingConstants.outerHorizontalPadding))
        let textLabelSpace: CGFloat = SpacingConstants.oneLineElementHeight
        let colorPaletteSpacing = SpacingConstants.twoLineElementHeight
        let outerVerticalSpacing: CGFloat = (2 * SpacingConstants.outerVerticalPadding)
        let innerVerticalSpacing: CGFloat = (2 * SpacingConstants.verticalObjectBuffer)
        
        return imageViewSpace + textLabelSpace + colorPaletteSpacing + outerVerticalSpacing + innerVerticalSpacing
    }
}
