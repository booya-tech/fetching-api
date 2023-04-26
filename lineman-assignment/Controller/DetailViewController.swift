//
//  ViewController.swift
//  lineman-assignment
//
//  Created by Panachai Sulsaksakul on 4/17/23.
//

import UIKit

// MARK: - ViewController

class DetailViewController: UIViewController {
    
    @IBOutlet weak var noInternet: UILabel!
    @IBOutlet weak var table: UITableView!
    private var dataManager = DataManager()
    private var postsList: [Photo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataManager.delegate = self
        table.dataSource = self
        dataManager.fetchData()
        
        self.noInternet.isHidden = true
        self.table.refreshControl = UIRefreshControl()
        self.table.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
    }
    
    @objc private func didPullToRefresh() {
        dataManager.fetchData()
    }
}

// MARK: - DataManagerDelegate Protocol

extension DetailViewController: DataManagerDelegate {
    func didUpdateData(_ DataManger: DataManager, wongnai: WongnaiData) {
        postsList = wongnai.photos
        
        DispatchQueue.main.async {
            self.table.refreshControl?.endRefreshing()
            self.table.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        let err = (error as? URLError)?.code
        var errorMessage = ""
        switch err {
        case URLError.timedOut: errorMessage = K.timeOutMessage
        case URLError.notConnectedToInternet: errorMessage = K.noConnection
        default: errorMessage = K.errorFetchData
        }
        DispatchQueue.main.async {
            self.noInternet.isHidden = false
            self.noInternet.text = errorMessage
        }
    }
}

// MARK: - TableView

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! DetailTableViewCell
        let detail = postsList[indexPath.row]
        
        cell.ImageView.downloaded(from: "\(detail.image_url[0])")
        cell.ImageView.contentMode = .scaleToFill
        cell.topicName.text = detail.name
        cell.countVote.text = String(detail.positive_votes_count.formatted())
        cell.descriptionText.text = detail.description
        
        
        return cell
    }
}

// MARK: - UIImageView Extension

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

