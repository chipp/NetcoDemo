//
// Created by Vladimir Burdukov on 11/6/17.
// Copyright (c) 2017 NetcoSports. All rights reserved.
//

import Astrolabe

class LoaderViewController<View: UIScrollView & AccessorView>: ContainerViewController<View>, Loader
where View.Source: LoaderReusableSource {

  let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)

  let refreshControl: UIRefreshControl = {
    let control = UIRefreshControl()
    control.tintColor = .black
    return control
  }()

  override func loadView() {
    super.loadView()

    containerView.source.loader = self

    refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
    containerView.addSubview(refreshControl)
    view.addSubview(activityIndicator)
    activityIndicator.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }

    activityIndicator.hidesWhenStopped = true

    source.startProgress = { [weak self] intent in
      guard let `self` = self else { return }

      switch intent {
      case .initial, .force:
        self.activityIndicator.superview?.bringSubview(toFront: self.activityIndicator)
        self.activityIndicator.startAnimating()
      default: break
      }
    }

    source.stopProgress = { [weak self] intent in
      switch intent {
      case .initial, .force:
        self?.activityIndicator.stopAnimating()
      case .pullToRefresh:
        self?.refreshControl.endRefreshing()
      default: break
      }
    }
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    containerView.source.appear()
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)

    containerView.source.disappear()
  }

  func performLoading(intent: LoaderIntent) -> SectionObservable? {
    fatalError("метод для переопределения")
  }

  @objc private func pullToRefresh() {
    source.pullToRefresh()
  }

}

class GenericLoaderCollectionViewController<T: LoaderReusableSource>: LoaderViewController<CollectionView<T>>
where T.Container == UICollectionView {

  override func loadView() {
    super.loadView()
    containerView.collectionViewLayout = collectionViewLayout()
  }

  func collectionViewLayout() -> UICollectionViewFlowLayout {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    return layout
  }

}

// swiftlint:disable:next line_length
class LoaderCollectionViewController: GenericLoaderCollectionViewController<LoaderDecoratorSource<CollectionViewSource>> {}

class GenericLoaderTableViewController<T: LoaderReusableSource>: LoaderViewController<TableView<T>>
where T.Container == UITableView {}

class LoaderTableViewController: GenericLoaderTableViewController<LoaderDecoratorSource<TableViewSource>> {}
