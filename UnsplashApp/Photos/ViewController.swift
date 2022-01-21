//
//  ViewController.swift
//  UnsplashApp
//
//  Created by Jess Le on 1/19/22.
//

import UIKit
import Combine

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let rowHeight = CGFloat(300)
    var tableView: UITableView  =   UITableView()
    private var viewModel: PhotosViewModel!
    private var unsplashFetcher: UnsplashFetcher!
    private var networkService: NetworkService!
    private var subscribers = [AnyCancellable]()
    private var photoDescription: String = "Default State"

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = rowHeight

        networkService = NetworkService(urlSession: URLSession.shared)
        unsplashFetcher = UnsplashFetcher(networkService: networkService)
        viewModel = PhotosViewModel(unsplashFetcher: unsplashFetcher)

        // TODO: Diffable Datasource
        viewModel.$photoDescription
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { value in
                switch value {
                case .failure:
                    print("Failure")
                case .finished:
                    print("Failure")
                }
            }, receiveValue: { [weak self] value in
                guard let self = self else { return }
                    self.photoDescription = value
                    self.tableView.reloadData()
              })
              .store(in: &subscribers)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Get main screen bounds
        let screenSize: CGRect = UIScreen.main.bounds

        let screenWidth = screenSize.width
        let screenHeight = screenSize.height

        tableView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight);
        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PhotoCell")

        self.view.addSubview(tableView)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: Dynamic
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: diffable datasource
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath as IndexPath as IndexPath as IndexPath)

        cell.textLabel?.text = photoDescription
        cell.textLabel?.numberOfLines = 0

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }

    private func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("User selected table row \(indexPath.row) and item \(indexPath.row)")
    }
}

