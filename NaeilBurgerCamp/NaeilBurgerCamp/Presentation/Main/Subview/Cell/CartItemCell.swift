import UIKit

final class CartItemCell: UICollectionViewCell {
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .bcBackground3
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.bcBlack.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 0.05
        view.layer.masksToBounds = false

        return view
    }()

    private let itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .dummyBurger
        imageView.backgroundColor = .bcBackground3

        return imageView
    }()

    private let itemTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumSquareRound(ofSize: 12, weight: .heavy)
        label.textAlignment = .left
        label.textColor = .bcPrimary

        return label
    }()

    private let itemPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumSquareRound(ofSize: 10, weight: .heavy)
        label.textAlignment = .left
        label.textColor = .bcPrimary

        return label
    }()

    private let minusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "minus.circle"), for: .normal)
        button.tintColor = .bcPrimary
        button.backgroundColor = .bcBackground3

        return button
    }()

    private let itemQuantityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .bcPrimary
        label.font = .nanumSquareRound(ofSize: 12, weight: .heavy)
        label.textAlignment = .center

        return label
    }()

    private let plusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        button.tintColor = .bcPrimary
        button.backgroundColor = .bcBackground3

        return button
    }()

    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .bcDivider

        return view
    }()

    private let totalPriceLabel: UILabel = { // cell 단위 totalPrice
        let label = UILabel()
        label.textColor = .bcRed
        label.font = .nanumSquareRound(ofSize: 14, weight: .heavy)

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

    func configure(with detail: Cart.Detail) {
        itemImageView.image = .dummyBurger
        itemTitleLabel.text = detail.menuItem.title
        itemPriceLabel.text = String(.menuItemPrice, with: detail.menuItem.price.numberFormatted)
        itemQuantityLabel.text = "\(detail.quantity)"
        totalPriceLabel.text = String(.menuItemPrice, with: detail.totalPrice.numberFormatted)
    }
}

private extension CartItemCell {
    func configure() {
        setLayout()
        setHierarchy()
        setConstraints()
    }

    func setLayout() {
        contentView.backgroundColor = .bcBackground1
        isUserInteractionEnabled = false
    }

    func setHierarchy() {
        contentView.addSubview(containerView)
        containerView.addSubviews(
            itemImageView,
            itemTitleLabel,
            itemPriceLabel,
            divider,
            minusButton,
            itemQuantityLabel,
            plusButton,
            totalPriceLabel
        )
    }

    func setConstraints() {
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.directionalHorizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        itemImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(4)
            make.leading.equalToSuperview().inset(12)
            make.size.equalTo(72)
        }

        itemTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(itemImageView.snp.trailing).offset(8)
            make.centerY.equalTo(itemImageView.snp.centerY)
        }

        itemPriceLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalTo(itemImageView.snp.centerY)
        }

        divider.snp.makeConstraints { make in
            make.top.equalTo(itemImageView.snp.bottom).offset(4)
            make.leading.equalTo(itemImageView.snp.leading)
            make.trailing.equalTo(itemPriceLabel.snp.trailing)
            make.height.equalTo(2)
        }

        minusButton.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom).offset(4)
            make.leading.equalTo(divider.snp.leading)
            make.size.equalTo(28)
        }

        itemQuantityLabel.snp.makeConstraints { make in
            make.leading.equalTo(minusButton.snp.trailing)
            make.centerY.equalTo(minusButton.snp.centerY)
            make.width.equalTo(20)
        }

        plusButton.snp.makeConstraints { make in
            make.leading.equalTo(itemQuantityLabel.snp.trailing)
            make.centerY.equalTo(minusButton.snp.centerY)
            make.size.equalTo(28)
        }

        totalPriceLabel.snp.makeConstraints { make in
            make.trailing.equalTo(itemPriceLabel.snp.trailing)
            make.centerY.equalTo(minusButton.snp.centerY)
        }
    }
}

extension CartItemCell: BCReusableView {
    static var identifier: String {
        "CartItemCell"
    }

    static var reusableViewType: ReusableViewType {
        .cell
    }
}
