import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';

interface Product {
  id: string;
  name: string;
  price: number;
  originalPrice?: number;
  rating: number;
  reviews: number;
  image: string;
  category: string;
}

@Component({
  selector: 'app-product-list',
  templateUrl: './product-list.component.html',
  styleUrls: ['./product-list.component.scss']
})
export class ProductListComponent implements OnInit {
  searchText = '';
  selectedCategory = 'All';
  selectedSort = 'Featured';
  isGridView = true;

  categories = ['All', 'Electronics', 'Fashion', 'Home', 'Sports'];
  sortOptions = [
    { value: 'featured', label: 'Featured' },
    { value: 'price-low', label: 'Price: Low to High' },
    { value: 'price-high', label: 'Price: High to Low' },
    { value: 'newest', label: 'Newest' }
  ];

  products: Product[] = [];
  filteredProducts: Product[] = [];

  constructor(private router: Router) {}

  ngOnInit() {
    this.generateProducts();
    this.filterProducts();
  }

  generateProducts() {
    this.products = Array.from({ length: 20 }, (_, index) => ({
      id: (index + 1).toString(),
      name: `Product ${index + 1}`,
      price: (index + 1) * 10.99,
      originalPrice: index % 3 === 0 ? (index + 1) * 15.99 : undefined,
      rating: 4.5,
      reviews: 120,
      image: `product_${index + 1}.jpg`,
      category: this.categories[Math.floor(Math.random() * (this.categories.length - 1)) + 1]
    }));
  }

  filterProducts() {
    this.filteredProducts = this.products.filter(product => {
      const matchesCategory = this.selectedCategory === 'All' || product.category === this.selectedCategory;
      const matchesSearch = !this.searchText ||
        product.name.toLowerCase().includes(this.searchText.toLowerCase());
      return matchesCategory && matchesSearch;
    });

    this.sortProducts();
  }

  sortProducts() {
    switch (this.selectedSort) {
      case 'price-low':
        this.filteredProducts.sort((a, b) => a.price - b.price);
        break;
      case 'price-high':
        this.filteredProducts.sort((a, b) => b.price - a.price);
        break;
      case 'newest':
        this.filteredProducts.sort((a, b) => parseInt(b.id) - parseInt(a.id));
        break;
      default:
        // Featured - keep original order
        break;
    }
  }

  onSearchChange(event: any) {
    this.searchText = event.target.value;
    this.filterProducts();
  }

  onCategoryChange(category: string) {
    this.selectedCategory = category;
    this.filterProducts();
  }

  onSortChange(event: any) {
    this.selectedSort = event.detail.value;
    this.sortProducts();
  }

  toggleView() {
    this.isGridView = !this.isGridView;
  }

  navigateToDetail(productId: string) {
    this.router.navigate(['/product-detail', productId]);
  }

  addToCart(product: Product, event: Event) {
    event.stopPropagation();
    console.log('Added to cart:', product);
    // Implement cart logic
  }

  navigateToCart() {
    this.router.navigate(['/cart']);
  }

  getStars(rating: number): boolean[] {
    return Array.from({ length: 5 }, (_, index) => index < Math.floor(rating));
  }

  calculateDiscount(price: number, originalPrice?: number): number {
    if (!originalPrice) return 0;
    return Math.round(((originalPrice - price) / originalPrice) * 100);
  }
}