package com.ganeshkulfi.app.data.repository

import com.ganeshkulfi.app.data.model.Flavor
import com.ganeshkulfi.app.data.model.InventoryItem
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class InventoryRepository @Inject constructor() {
    
    private val _inventory = MutableStateFlow<List<InventoryItem>>(emptyList())
    val inventoryFlow: Flow<List<InventoryItem>> = _inventory.asStateFlow()

    init {
        // Initialize inventory from flavors
        initializeInventory()
    }

    private fun initializeInventory() {
        val flavors = Flavor.getDefaultFlavors()
        _inventory.value = flavors.map { flavor ->
            InventoryItem(
                flavorId = flavor.key,
                flavorName = flavor.nameEn,
                totalStock = flavor.stock,
                availableStock = flavor.stock,
                stockGivenToRetailers = 0,
                soldToday = 0,
                soldThisWeek = 0,
                soldThisMonth = 0,
                soldQuantity = 0,
                costPrice = flavor.price * 0.6, // 40% profit margin
                sellingPrice = flavor.price.toDouble(),
                reorderLevel = 20
            )
        }
    }

    suspend fun getAllInventory(): Result<List<InventoryItem>> {
        return try {
            Result.success(_inventory.value)
        } catch (e: Exception) {
            Result.failure(e)
        }
    }

    suspend fun getInventoryByFlavor(flavorId: String): Result<InventoryItem> {
        return try {
            val item = _inventory.value.find { it.flavorId == flavorId }
            if (item != null) {
                Result.success(item)
            } else {
                Result.failure(Exception("Inventory item not found"))
            }
        } catch (e: Exception) {
            Result.failure(e)
        }
    }

    suspend fun updateStock(flavorId: String, quantity: Int): Result<Unit> {
        return try {
            _inventory.value = _inventory.value.map { item ->
                if (item.flavorId == flavorId) {
                    item.copy(
                        totalStock = item.totalStock + quantity,
                        availableStock = item.availableStock + quantity,
                        lastRestockedAt = System.currentTimeMillis(),
                        updatedAt = System.currentTimeMillis()
                    )
                } else {
                    item
                }
            }
            Result.success(Unit)
        } catch (e: Exception) {
            Result.failure(e)
        }
    }

    suspend fun giveStockToRetailer(flavorId: String, quantity: Int): Result<Unit> {
        return try {
            _inventory.value = _inventory.value.map { item ->
                if (item.flavorId == flavorId) {
                    if (item.availableStock >= quantity) {
                        item.copy(
                            availableStock = item.availableStock - quantity,
                            stockGivenToRetailers = item.stockGivenToRetailers + quantity,
                            updatedAt = System.currentTimeMillis()
                        )
                    } else {
                        throw Exception("Insufficient stock available")
                    }
                } else {
                    item
                }
            }
            Result.success(Unit)
        } catch (e: Exception) {
            Result.failure(e)
        }
    }

    suspend fun recordSale(flavorId: String, quantity: Int): Result<Unit> {
        return try {
            _inventory.value = _inventory.value.map { item ->
                if (item.flavorId == flavorId) {
                    item.copy(
                        availableStock = item.availableStock - quantity,
                        soldToday = item.soldToday + quantity,
                        soldThisWeek = item.soldThisWeek + quantity,
                        soldThisMonth = item.soldThisMonth + quantity,
                        soldQuantity = item.soldQuantity + quantity,
                        updatedAt = System.currentTimeMillis()
                    )
                } else {
                    item
                }
            }
            Result.success(Unit)
        } catch (e: Exception) {
            Result.failure(e)
        }
    }

    fun getLowStockItems(threshold: Int = 20): List<InventoryItem> {
        return _inventory.value.filter { it.availableStock <= threshold }
    }

    suspend fun getLowStockItemsAsync(): Result<List<InventoryItem>> {
        return try {
            Result.success(_inventory.value.filter { it.needsRestock })
        } catch (e: Exception) {
            Result.failure(e)
        }
    }

    suspend fun getTotalInventoryValue(): Double {
        return _inventory.value.sumOf { it.totalStock * it.costPrice }
    }

    suspend fun getTotalPotentialRevenue(): Double {
        return _inventory.value.sumOf { it.availableStock * it.sellingPrice }
    }

    suspend fun updatePrice(flavorId: String, costPrice: Double, sellingPrice: Double): Result<Unit> {
        return try {
            val currentInventory = _inventory.value.toMutableList()
            val index = currentInventory.indexOfFirst { it.flavorId == flavorId }
            
            if (index != -1) {
                currentInventory[index] = currentInventory[index].copy(
                    costPrice = costPrice,
                    sellingPrice = sellingPrice,
                    updatedAt = System.currentTimeMillis()
                )
                _inventory.value = currentInventory
                Result.success(Unit)
            } else {
                Result.failure(Exception("Flavor not found"))
            }
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
}
