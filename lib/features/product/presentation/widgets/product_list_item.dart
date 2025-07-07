import 'package:flutter/material.dart';
import '../../../../core/models/product.dart';

/// Widget that displays a single product in the list with actions
class ProductListItem extends StatelessWidget {
  final Product product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProductListItem({
    super.key,
    required this.product,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: product.hasLowStock ? Colors.orange[300]! : Colors.transparent,
          width: product.hasLowStock ? 1.5 : 0,
        ),
      ),
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with product name and actions
              Row(
                children: [
                  // Product icon based on stock level
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getIconBackgroundColor(),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.inventory_2,
                      color: _getIconColor(),
                      size: 20,
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Product name
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (product.hasLowStock) ...[
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Icon(
                                Icons.warning,
                                size: 14,
                                color: Colors.orange[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Low Stock',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.orange[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  
                  // Action buttons
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Edit button
                      IconButton(
                        onPressed: onEdit,
                        icon: const Icon(Icons.edit),
                        color: Colors.blue[600],
                        tooltip: 'Edit Product',
                        iconSize: 20,
                        constraints: const BoxConstraints(
                          minWidth: 36,
                          minHeight: 36,
                        ),
                      ),
                      
                      // Delete button
                      IconButton(
                        onPressed: onDelete,
                        icon: const Icon(Icons.delete),
                        color: Colors.red[600],
                        tooltip: 'Delete Product',
                        iconSize: 20,
                        constraints: const BoxConstraints(
                          minWidth: 36,
                          minHeight: 36,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Product details
              Row(
                children: [
                  // Stock information
                  Expanded(
                    child: _buildInfoChip(
                      icon: Icons.numbers,
                      label: 'Stock',
                      value: '${product.stock} units',
                      backgroundColor: _getStockChipColor(),
                      textColor: _getStockTextColor(),
                    ),
                  ),
                  
                  if (product.price != null) ...[
                    const SizedBox(width: 12),
                    // Price information
                    Expanded(
                      child: _buildInfoChip(
                        icon: Icons.attach_money,
                        label: 'Price',
                        value: '\$${product.price!.toStringAsFixed(2)}',
                        backgroundColor: Colors.green[50]!,
                        textColor: Colors.green[700]!,
                      ),
                    ),
                  ],
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Last modified date
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 14,
                    color: Colors.grey[500],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Modified: ${_formatDate(product.lastModified)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build an information chip
  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required String value,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: textColor,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    color: textColor.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Get icon color based on stock level
  Color _getIconColor() {
    if (product.hasLowStock) {
      return Colors.orange[600]!;
    }
    return Colors.indigo[600]!;
  }

  /// Get icon background color based on stock level
  Color _getIconBackgroundColor() {
    if (product.hasLowStock) {
      return Colors.orange[50]!;
    }
    return Colors.indigo[50]!;
  }

  /// Get stock chip background color based on stock level
  Color _getStockChipColor() {
    if (product.hasLowStock) {
      return Colors.orange[50]!;
    }
    if (product.stock == 0) {
      return Colors.red[50]!;
    }
    return Colors.indigo[50]!;
  }

  /// Get stock text color based on stock level
  Color _getStockTextColor() {
    if (product.hasLowStock) {
      return Colors.orange[700]!;
    }
    if (product.stock == 0) {
      return Colors.red[700]!;
    }
    return Colors.indigo[700]!;
  }

  /// Format date for display
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        }
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}