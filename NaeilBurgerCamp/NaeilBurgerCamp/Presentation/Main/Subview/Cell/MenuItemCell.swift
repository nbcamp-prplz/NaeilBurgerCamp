import UIKit

final class MenuItemCell: UICollectionViewCell {
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .bcBackground3
        view.layer.cornerRadius = 8

        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 0.05
        view.layer.masksToBounds = false

        return view
    }() // minimumInterSpacing과 별도의 Inset을 계산해서 주기보다 containerView를 통해 패딩을 좀 더 쉽게 구현

    private let itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "carrot.fill")
        imageView.backgroundColor = .bcBackground3

        return imageView
    }()

    private let itemTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .bcPrimary
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = UIFont.nanumSquareRound(ofSize: 14, weight: .heavy)

        return label
    }()

    private let itemPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .bcPrimary
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = UIFont.nanumSquareRound(ofSize: 11, weight: .heavy)

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable, message: "storyboard is not supported")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }

    func configure(image: UIImage, title: String, price: Int) {
        itemImageView.image = image
        itemTitleLabel.text = title
        itemPriceLabel.text = "\(price.numberFormatted)원"
    }

}

private extension MenuItemCell {
    func configure() {
        setLayout()
        setHierarchy()
        setConstraints()
    }

    func setLayout() {
        contentView.backgroundColor = .bcBackground1
    }

    func setHierarchy() {
        contentView.addSubview(containerView)
        containerView.addSubviews(itemImageView, itemTitleLabel, itemPriceLabel)
    }

    func setConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        itemImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.centerX.equalToSuperview()
            make.size.equalTo(112)
        }

        itemTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(itemImageView.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }

        itemPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(itemTitleLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
    }
}

extension MenuItemCell: BCReusableView {
    static var identifier: String {
        "MenuItemCell"
    }

    static var reusableViewType: ReusableViewType {
        .cell
    }
}
