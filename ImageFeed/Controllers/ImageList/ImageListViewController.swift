//
//  ViewController.swift
//  ImageFeed
//
//  Created by Leo Bonhart on 21.01.2023.
//

import Kingfisher
import UIKit

protocol ImageListViewControllerProtocol: AnyObject, ImageListCellDelegate {
    func updateTableViewAnimated(startIndex: Int, newCount: Int)
    func reloadRowFor(indexPath: IndexPath)
}

final class ImageListViewController: UIViewController, ImageListViewControllerProtocol {
    @IBOutlet private var tableView: UITableView!
    
    private let alertPresenter: AlertPresenter = AlertPresenterImplementation()
    private var presenter: ImageListPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        presenter?.fetchPhotosNextPage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.segueToSingleImageViewController {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            viewController.imageLink = presenter?.photos[indexPath.row].largeImageURL
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func updateTableViewAnimated(startIndex: Int, newCount: Int) {
        tableView.performBatchUpdates {
            let indexPaths = (startIndex..<newCount).map { i in
                IndexPath(row: i, section: 0)
            }
            tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }
    
    func configure(_ presenter: ImageListPresenterProtocol) {
        self.presenter = presenter
        self.presenter?.view = self
    }
    
    func reloadRowFor(indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
//MARK: - Private Extension
private extension ImageListViewController {
    func showNetworkErrorAlert() {
        let alertModel = AlertModel(title: "Что-то пошло не так(", message: "Попробуйте еще раз", buttonText: "ОК")
        alertPresenter.showAlert(alertModel)
    }
}
//MARK: - TableView Delegate methods
extension ImageListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: Constants.segueToSingleImageViewController, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row + 1 == presenter?.photos.count else { return }
        presenter?.fetchPhotosNextPage()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let presenter else { return tableView.rowHeight }
        let photo = presenter.photos[indexPath.row]
        
        return presenter.getCellHeight(for: photo, tableViewWidth: tableView.bounds.width)
    }
}
//MARK: - TableView DataSource Methods
extension ImageListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.photos.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImageListCell else {
            return UITableViewCell()
        }
        
        presenter?.configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
}
//MARK: - ImageListCellDelegate method
extension ImageListViewController: ImageListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImageListCell) {
        guard let indexPath = tableView.indexPath(for: cell),
              let photo = presenter?.photos[indexPath.row]
        else { return }
    
        presenter?.changeLike(for: photo) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                cell.setIsLiked(photo.isLiked)
                self.reloadRowFor(indexPath: indexPath)
            case .failure:
                self.showNetworkErrorAlert()
            }
        }
    }
}

