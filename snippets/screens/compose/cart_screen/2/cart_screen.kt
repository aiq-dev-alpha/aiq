package com.example.ecommerce.compose.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

data class CartItem(
    val id: String,
    val name: String,
    val price: Double,
    var quantity: Int,
    val size: String?,
    val color: String?,
    val image: String
)

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun CartScreen() {
    var cartItems by remember {
        mutableStateOf(
            listOf(
                CartItem(
                    id = "1",
                    name = "Premium Cotton T-Shirt",
                    price = 29.99,
                    quantity = 2,
                    size = "M",
                    color = "Blue",
                    image = "tshirt.jpg"
                ),
                CartItem(
                    id = "2",
                    name = "Wireless Headphones",
                    price = 89.99,
                    quantity = 1,
                    size = null,
                    color = "Black",
                    image = "headphones.jpg"
                ),
                CartItem(
                    id = "3",
                    name = "Running Shoes",
                    price = 129.99,
                    quantity = 1,
                    size = "9",
                    color = "White",
                    image = "shoes.jpg"
                )
            )
        )
    }

    var promoCode by remember { mutableStateOf("") }

    val subtotal = cartItems.sumOf { it.price * it.quantity }
    val shipping = 9.99
    val tax = subtotal * 0.08
    val total = subtotal + shipping + tax

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(Color.White)
    ) {
        // App Bar
        TopAppBar(
            title = { Text("Shopping Cart (${cartItems.size})") },
            navigationIcon = {
                IconButton(onClick = { /* Navigate back */ }) {
                    Icon(Icons.Default.ArrowBack, contentDescription = "Back")
                }
            },
            actions = {
                if (cartItems.isNotEmpty()) {
                    TextButton(
                        onClick = { cartItems = emptyList() }
                    ) {
                        Text("Clear All", color = Color.Red)
                    }
                }
            }
        )

        if (cartItems.isEmpty()) {
            EmptyCartView()
        } else {
            Column(modifier = Modifier.weight(1f)) {
                LazyColumn(
                    contentPadding = PaddingValues(16.dp),
                    verticalArrangement = Arrangement.spacedBy(16.dp),
                    modifier = Modifier.weight(1f)
                ) {
                    items(cartItems) { item ->
                        CartItemCard(
                            item = item,
                            onQuantityChange = { newQuantity ->
                                cartItems = cartItems.map {
                                    if (it.id == item.id) it.copy(quantity = maxOf(1, newQuantity))
                                    else it
                                }
                            },
                            onRemove = {
                                cartItems = cartItems.filter { it.id != item.id }
                            }
                        )
                    }
                }

                OrderSummary(
                    promoCode = promoCode,
                    onPromoCodeChange = { promoCode = it },
                    subtotal = subtotal,
                    shipping = shipping,
                    tax = tax,
                    total = total,
                    onCheckout = { /* Navigate to checkout */ }
                )
            }
        }
    }
}

@Composable
fun CartItemCard(
    item: CartItem,
    onQuantityChange: (Int) -> Unit,
    onRemove: () -> Unit
) {
    Card(
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(12.dp),
        elevation = CardDefaults.cardElevation(defaultElevation = 2.dp)
    ) {
        Row(
            modifier = Modifier.padding(16.dp),
            verticalAlignment = Alignment.Top
        ) {
            // Product Image
            Box(
                modifier = Modifier
                    .size(80.dp)
                    .background(
                        Color.Gray.copy(alpha = 0.2f),
                        shape = RoundedCornerShape(8.dp)
                    ),
                contentAlignment = Alignment.Center
            ) {
                Icon(
                    imageVector = Icons.Default.Image,
                    contentDescription = "Product Image",
                    tint = Color.Gray,
                    modifier = Modifier.size(40.dp)
                )
            }

            Spacer(modifier = Modifier.width(16.dp))

            // Product Details
            Column(modifier = Modifier.weight(1f)) {
                Text(
                    text = item.name,
                    fontWeight = FontWeight.Bold,
                    fontSize = 16.sp,
                    maxLines = 2
                )

                if (item.size != null || item.color != null) {
                    Text(
                        text = listOfNotNull(item.size, item.color).joinToString(" • "),
                        color = Color.Gray,
                        fontSize = 14.sp,
                        modifier = Modifier.padding(top = 4.dp)
                    )
                }

                Text(
                    text = "$${String.format("%.2f", item.price)}",
                    fontWeight = FontWeight.Bold,
                    fontSize = 16.sp,
                    color = MaterialTheme.colorScheme.primary,
                    modifier = Modifier.padding(top = 8.dp)
                )
            }

            // Quantity Controls and Actions
            Column(horizontalAlignment = Alignment.End) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    IconButton(
                        onClick = { onQuantityChange(item.quantity - 1) },
                        enabled = item.quantity > 1
                    ) {
                        Icon(
                            imageVector = Icons.Default.RemoveCircleOutline,
                            contentDescription = "Decrease",
                            tint = if (item.quantity > 1) MaterialTheme.colorScheme.primary else Color.Gray
                        )
                    }

                    Text(
                        text = item.quantity.toString(),
                        fontWeight = FontWeight.Bold,
                        modifier = Modifier
                            .background(
                                Color.Gray.copy(alpha = 0.1f),
                                shape = RoundedCornerShape(6.dp)
                            )
                            .padding(horizontal = 12.dp, vertical = 6.dp)
                    )

                    IconButton(
                        onClick = { onQuantityChange(item.quantity + 1) }
                    ) {
                        Icon(
                            imageVector = Icons.Default.AddCircleOutline,
                            contentDescription = "Increase",
                            tint = MaterialTheme.colorScheme.primary
                        )
                    }
                }

                Spacer(modifier = Modifier.height(8.dp))

                Row {
                    IconButton(
                        onClick = { /* Add to wishlist */ }
                    ) {
                        Icon(
                            imageVector = Icons.Default.FavoriteBorder,
                            contentDescription = "Add to Wishlist",
                            tint = Color.Gray,
                            modifier = Modifier.size(20.dp)
                        )
                    }

                    IconButton(
                        onClick = onRemove
                    ) {
                        Icon(
                            imageVector = Icons.Default.DeleteOutline,
                            contentDescription = "Remove",
                            tint = Color.Red,
                            modifier = Modifier.size(20.dp)
                        )
                    }
                }
            }
        }
    }
}

@Composable
fun OrderSummary(
    promoCode: String,
    onPromoCodeChange: (String) -> Unit,
    subtotal: Double,
    shipping: Double,
    tax: Double,
    total: Double,
    onCheckout: () -> Unit
) {
    Card(
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(topStart = 16.dp, topEnd = 16.dp),
        elevation = CardDefaults.cardElevation(defaultElevation = 8.dp)
    ) {
        Column(
            modifier = Modifier.padding(20.dp)
        ) {
            // Promo Code
            Row(
                modifier = Modifier.fillMaxWidth(),
                verticalAlignment = Alignment.CenterVertically
            ) {
                OutlinedTextField(
                    value = promoCode,
                    onValueChange = onPromoCodeChange,
                    placeholder = { Text("Enter promo code") },
                    modifier = Modifier.weight(1f),
                    shape = RoundedCornerShape(8.dp)
                )

                Spacer(modifier = Modifier.width(12.dp))

                Button(
                    onClick = { /* Apply promo code */ },
                    colors = ButtonDefaults.buttonColors(
                        containerColor = Color.Gray.copy(alpha = 0.8f)
                    ),
                    shape = RoundedCornerShape(8.dp)
                ) {
                    Text("Apply")
                }
            }

            Spacer(modifier = Modifier.height(20.dp))

            // Summary rows
            SummaryRow("Subtotal", "$${String.format("%.2f", subtotal)}")
            SummaryRow("Shipping", "$${String.format("%.2f", shipping)}")
            SummaryRow("Tax", "$${String.format("%.2f", tax)}")

            HorizontalDivider(modifier = Modifier.padding(vertical = 8.dp))

            SummaryRow(
                label = "Total",
                value = "$${String.format("%.2f", total)}",
                isTotal = true
            )

            Spacer(modifier = Modifier.height(20.dp))

            Button(
                onClick = onCheckout,
                modifier = Modifier.fillMaxWidth(),
                shape = RoundedCornerShape(8.dp)
            ) {
                Text(
                    text = "PROCEED TO CHECKOUT",
                    fontWeight = FontWeight.Bold,
                    modifier = Modifier.padding(vertical = 4.dp)
                )
            }
        }
    }
}

@Composable
fun SummaryRow(
    label: String,
    value: String,
    isTotal: Boolean = false
) {
    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween
    ) {
        Text(
            text = label,
            fontSize = if (isTotal) 18.sp else 16.sp,
            fontWeight = if (isTotal) FontWeight.Bold else FontWeight.Normal
        )
        Text(
            text = value,
            fontSize = if (isTotal) 18.sp else 16.sp,
            fontWeight = if (isTotal) FontWeight.Bold else FontWeight.SemiBold,
            color = if (isTotal) MaterialTheme.colorScheme.primary else Color.Black
        )
    }
}

@Composable
fun EmptyCartView() {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(24.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        Icon(
            imageVector = Icons.Default.ShoppingCart,
            contentDescription = "Empty Cart",
            tint = Color.Gray,
            modifier = Modifier.size(100.dp)
        )

        Spacer(modifier = Modifier.height(24.dp))

        Text(
            text = "Your cart is empty",
            fontSize = 24.sp,
            fontWeight = FontWeight.Bold
        )

        Text(
            text = "Add some items to get started",
            color = Color.Gray,
            modifier = Modifier.padding(top = 12.dp)
        )

        Spacer(modifier = Modifier.height(32.dp))

        Button(
            onClick = { /* Navigate to products */ },
            shape = RoundedCornerShape(8.dp)
        ) {
            Text(
                text = "Continue Shopping",
                fontWeight = FontWeight.Bold,
                modifier = Modifier.padding(horizontal = 16.dp, vertical = 4.dp)
            )
        }
    }
}