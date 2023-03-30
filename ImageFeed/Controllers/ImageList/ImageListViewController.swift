//
//  ViewController.swift
//  ImageFeed
//
//  Created by Leo Bonhart on 21.01.2023.
//

import Kingfisher
import UIKit

class ImageListViewController: UIViewController {

    @IBOutlet private var tableView: UITableView!
    private let imageListService = ImageListService()
    private var photos = [Photo]()
    
    private var imageListServiceObserver: NSObjectProtocol?
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        addPhotosObserver()
        imageListService.fetchPhotosNextPage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.segueToSingleImageViewController {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            viewController.imageLink = photos[indexPath.row].largeImageURL
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

private extension ImageListViewController {
    func addPhotosObserver() {
        imageListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImageListService.didChangeNotification,
            object: nil,
            queue: .main
            )  { [weak self] _ in
                guard let self else { return }
                print("Image List NOTIFICATION TRIGGERED SUCCSESSFULLY")
                self.updateTableViewAnimated()
            }
    }
    
    func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imageListService.photos.count
        
//        TODO: guard issue
        photos = imageListService.photos
        guard oldCount != newCount else { return }
        tableView.performBatchUpdates {
            let indexPaths = (oldCount..<newCount).map { i in
                IndexPath(row: i, section: 0)
            }
            tableView.insertRows(at: indexPaths, with: .automatic)
        } completion: { _ in }
    }
    
    func configCell(for cell: ImageListCell, with indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        guard let photoURL = URL(string: photo.thumbImageURL) else {
            return
        }
        let likeImage = photo.isLiked ? UIImage(named: Constants.likeImageOn) : UIImage(named: Constants.likeImageOff)
        
        cell.cellImageView.kf.indicatorType = .activity
        cell.cellImageView.kf.setImage(
            with: photoURL,
            placeholder: UIImage(named: "Stub")
        ) { [weak self] _ in
            guard let self = self else {
                return
            }
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        cell.likeButton.setImage(likeImage, for: .normal)
        cell.dateLabel.text = dateFormatter.string(from: photo.createdAt ?? Date())
    }
}
//MARK: - TableView Delegate methods
extension ImageListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.segueToSingleImageViewController, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let photosize = photos[indexPath.row].size
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        
        let scale = imageViewWidth / photosize.width
        let cellHeight = photosize.height * scale + imageInsets.top + imageInsets.bottom
        
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row + 1 == imageListService.photos.count else { return }
        imageListService.fetchPhotosNextPage()
    }
}
//MARK: - TableView DataSource Methods
extension ImageListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImageListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
}

