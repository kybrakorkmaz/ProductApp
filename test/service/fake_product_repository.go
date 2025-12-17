package service

import (
	"productApp/domain"
	"productApp/persistence"
)

type FakeProductRepository struct {
	products []domain.Product
}

func NewFakeProductRepository(initialProducts []domain.Product) persistence.IProductRepository {
	return &FakeProductRepository{
		products: initialProducts,
	}
}
func (fakeRepository *FakeProductRepository) GetAllProducts() []domain.Product {
	return fakeRepository.products
}
func (fakeRepository *FakeProductRepository) GetAllProductsByStore(storeName string) []domain.Product {
	//todo implement
	return []domain.Product{}
}

func (fakeRepository *FakeProductRepository) AddProduct(product domain.Product) error {
	fakeRepository.products = append(fakeRepository.products, domain.Product{
		Id:       int64(len(fakeRepository.products) + 1),
		Name:     product.Name,
		Price:    product.Price,
		Discount: product.Discount,
		Store:    product.Store,
	})
	return nil
}

func (fakeRepository *FakeProductRepository) GetById(productId int64) (domain.Product, error) {
	//todo implement
	return domain.Product{}, nil
}
func (fakeRepository *FakeProductRepository) DeleteByID(productId int64) error {
	//todo implement
	return nil
}
func (fakeRepository *FakeProductRepository) UpdatePrice(productId int64, newPrice float32) error {
	//todo implement
	return nil
}
