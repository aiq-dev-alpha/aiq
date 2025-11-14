import React, { useState } from 'react';
import {
  View,
  Text,
  TextInput,
  FlatList,
  TouchableOpacity,
  Image,
  StyleSheet,
  ScrollView,
  Dimensions,
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';

const { width } = Dimensions.get('window');

interface Product {
  id: string;
  name: string;
  price: number;
  rating: number;
  reviews: number;
  image: string;
}

const ProductListScreen: React.FC = () => {
  const [searchText, setSearchText] = useState('');
  const [selectedCategory, setSelectedCategory] = useState('All');
  const [isGridView, setIsGridView] = useState(true);
  const [selectedSort, setSelectedSort] = useState('Featured');

  const categories = ['All', 'Electronics', 'Fashion', 'Home', 'Sports'];
  const sortOptions = ['Featured', 'Price: Low to High', 'Price: High to Low', 'Newest'];

  const products: Product[] = Array.from({ length: 20 }, (_, index) => ({
    id: (index + 1).toString(),
    name: `Product ${index + 1}`,
    price: (index + 1) * 10.99,
    rating: 4.5,
    reviews: 120,
    image: `product_${index + 1}.jpg`,
  }));

  const ProductCard: React.FC<{ item: Product }> = ({ item }) => (
    <TouchableOpacity style={styles.productCard}>
      <View style={styles.productImage}>
        <Ionicons name="image" size={50} color="#999" />
      </View>
      <View style={styles.productInfo}>
        <Text style={styles.productName} numberOfLines={2}>
          {item.name}
        </Text>
        <View style={styles.ratingRow}>
          <Ionicons name="star" size={16} color="#FFB000" />
          <Text style={styles.ratingText}>{item.rating}</Text>
          <Text style={styles.reviewsText}>({item.reviews})</Text>
        </View>
        <View style={styles.priceRow}>
          <Text style={styles.price}>${item.price}</Text>
          <TouchableOpacity style={styles.addButton}>
            <Ionicons name="add" size={16} color="white" />
          </TouchableOpacity>
        </View>
      </View>
    </TouchableOpacity>
  );

  const ProductListItem: React.FC<{ item: Product }> = ({ item }) => (
    <TouchableOpacity style={styles.productListItem}>
      <View style={styles.productImageSmall}>
        <Ionicons name="image" size={40} color="#999" />
      </View>
      <View style={styles.productDetails}>
        <Text style={styles.productNameList} numberOfLines={2}>
          {item.name}
        </Text>
        <View style={styles.ratingRow}>
          <Ionicons name="star" size={16} color="#FFB000" />
          <Text style={styles.ratingText}>{item.rating} ({item.reviews})</Text>
        </View>
        <Text style={styles.priceList}>${item.price}</Text>
      </View>
      <TouchableOpacity style={styles.cartButton}>
        <Ionicons name="cart" size={20} color="#007AFF" />
      </TouchableOpacity>
    </TouchableOpacity>
  );

  const CategoryChip: React.FC<{ category: string }> = ({ category }) => (
    <TouchableOpacity
      style={[
        styles.categoryChip,
        selectedCategory === category && styles.selectedChip,
      ]}
      onPress={() => setSelectedCategory(category)}
    >
      <Text
        style={[
          styles.chipText,
          selectedCategory === category && styles.selectedChipText,
        ]}
      >
        {category}
      </Text>
    </TouchableOpacity>
  );

  return (
    <View style={styles.container}>
      {/* Header */}
      <View style={styles.header}>
        <Text style={styles.headerTitle}>Products</Text>
        <View style={styles.headerActions}>
          <TouchableOpacity onPress={() => setIsGridView(!isGridView)}>
            <Ionicons
              name={isGridView ? "list" : "grid"}
              size={24}
              color="#000"
            />
          </TouchableOpacity>
          <TouchableOpacity style={{ marginLeft: 16 }}>
            <Ionicons name="cart" size={24} color="#000" />
          </TouchableOpacity>
        </View>
      </View>

      {/* Search Bar */}
      <View style={styles.searchContainer}>
        <View style={styles.searchBar}>
          <Ionicons name="search" size={20} color="#999" />
          <TextInput
            style={styles.searchInput}
            placeholder="Search products..."
            value={searchText}
            onChangeText={setSearchText}
          />
        </View>
      </View>

      {/* Category Filter */}
      <ScrollView
        horizontal
        showsHorizontalScrollIndicator={false}
        contentContainerStyle={styles.categoryContainer}
      >
        {categories.map((category) => (
          <CategoryChip key={category} category={category} />
        ))}
      </ScrollView>

      {/* Products */}
      {isGridView ? (
        <FlatList
          data={products}
          numColumns={2}
          renderItem={({ item }) => <ProductCard item={item} />}
          keyExtractor={(item) => item.id}
          contentContainerStyle={styles.gridContainer}
          columnWrapperStyle={styles.gridRow}
        />
      ) : (
        <FlatList
          data={products}
          renderItem={({ item }) => <ProductListItem item={item} />}
          keyExtractor={(item) => item.id}
          contentContainerStyle={styles.listContainer}
        />
      )}
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: 16,
    paddingVertical: 12,
    backgroundColor: '#fff',
    borderBottomWidth: 1,
    borderBottomColor: '#f0f0f0',
  },
  headerTitle: {
    fontSize: 20,
    fontWeight: 'bold',
  },
  headerActions: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  searchContainer: {
    paddingHorizontal: 16,
    paddingVertical: 12,
  },
  searchBar: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#f5f5f5',
    borderRadius: 10,
    paddingHorizontal: 12,
    paddingVertical: 8,
  },
  searchInput: {
    flex: 1,
    marginLeft: 8,
    fontSize: 16,
  },
  categoryContainer: {
    paddingHorizontal: 16,
    paddingVertical: 8,
  },
  categoryChip: {
    paddingHorizontal: 16,
    paddingVertical: 8,
    backgroundColor: '#f0f0f0',
    borderRadius: 20,
    marginRight: 8,
  },
  selectedChip: {
    backgroundColor: '#007AFF',
  },
  chipText: {
    fontSize: 14,
    color: '#333',
  },
  selectedChipText: {
    color: 'white',
  },
  gridContainer: {
    padding: 16,
  },
  gridRow: {
    justifyContent: 'space-between',
  },
  productCard: {
    width: (width - 48) / 2,
    backgroundColor: '#fff',
    borderRadius: 12,
    marginBottom: 16,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
    elevation: 3,
  },
  productImage: {
    height: 120,
    backgroundColor: '#f5f5f5',
    borderTopLeftRadius: 12,
    borderTopRightRadius: 12,
    justifyContent: 'center',
    alignItems: 'center',
  },
  productInfo: {
    padding: 12,
  },
  productName: {
    fontSize: 14,
    fontWeight: '600',
    marginBottom: 4,
  },
  ratingRow: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 8,
  },
  ratingText: {
    fontSize: 12,
    marginLeft: 2,
  },
  reviewsText: {
    fontSize: 12,
    color: '#999',
    marginLeft: 4,
  },
  priceRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  price: {
    fontSize: 16,
    fontWeight: 'bold',
    color: '#FF3B30',
  },
  addButton: {
    backgroundColor: '#007AFF',
    borderRadius: 6,
    padding: 4,
  },
  listContainer: {
    padding: 16,
  },
  productListItem: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#fff',
    borderRadius: 12,
    padding: 16,
    marginBottom: 16,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.1,
    shadowRadius: 2,
    elevation: 2,
  },
  productImageSmall: {
    width: 80,
    height: 80,
    backgroundColor: '#f5f5f5',
    borderRadius: 8,
    justifyContent: 'center',
    alignItems: 'center',
  },
  productDetails: {
    flex: 1,
    marginLeft: 16,
  },
  productNameList: {
    fontSize: 16,
    fontWeight: '600',
    marginBottom: 4,
  },
  priceList: {
    fontSize: 16,
    fontWeight: 'bold',
    color: '#FF3B30',
    marginTop: 8,
  },
  cartButton: {
    padding: 8,
  },
});

export default ProductListScreen;