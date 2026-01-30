import 'package:flutter/material.dart';
import '../../../core/constants/admin_colors.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Column - Gallery & Reviews
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  const _ProductGalleryPanel(),
                  const SizedBox(height: 24),
                  const _ProductReviewsPanel(),
                ],
              ),
            ),
            const SizedBox(width: 24),
            // Right Column - Info, Stock, Meta
            const Expanded(
              flex: 3,
              child: Column(
                children: [
                  _ProductInfoPanel(),
                  SizedBox(height: 24),
                  _ProductStockPanel(),
                  SizedBox(height: 24),
                  _ProductMetaPanel(),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Text(
              'PRODUCT DETAILS',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 16),
            const Text(
              'Men Black Slim Fit T-shirt',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AdminColors.textPrimary),
            ),
             const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: AdminColors.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
              child: const Text('Active', style: TextStyle(color: AdminColors.success, fontSize: 11, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        Row(
          children: [
            OutlinedButton.icon(
              onPressed: () {}, 
              icon: const Icon(Icons.copy_rounded, size: 16),
              label: const Text('Duplicate'),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: () {}, 
              icon: const Icon(Icons.edit_rounded, size: 16),
              label: const Text('Edit Product'),
            ),
          ],
        ),
      ],
    );
  }
}

class _ProductGalleryPanel extends StatelessWidget {
  const _ProductGalleryPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AdminColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AdminColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 400,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AdminColors.background,
              borderRadius: BorderRadius.circular(8),
              image: const DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildThumb('https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?ixlib=rb-1.2.1&auto=format&fit=crop&w=150&q=80', true),
              const SizedBox(width: 12),
              _buildThumb('https://images.unsplash.com/photo-1583743814966-8936f5b7be1a?ixlib=rb-1.2.1&auto=format&fit=crop&w=150&q=80', false),
              const SizedBox(width: 12),
              _buildThumb('https://images.unsplash.com/photo-1576566588028-4147f3842f27?ixlib=rb-1.2.1&auto=format&fit=crop&w=150&q=80', false),
              const SizedBox(width: 12),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AdminColors.background.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AdminColors.divider),
                ),
                child: const Icon(Icons.add_a_photo_outlined, color: AdminColors.textMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildThumb(String url, bool isSelected) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AdminColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? AdminColors.primary : AdminColors.divider,
          width: isSelected ? 2 : 1,
        ),
        image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
      ),
    );
  }
}

class _ProductInfoPanel extends StatelessWidget {
  const _ProductInfoPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AdminColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AdminColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Price & Size', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _buildInfoItem('Price', '\$80.00', isLarge: true)),
              Expanded(child: _buildInfoItem('Discount', '10%')),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Size', style: TextStyle( fontSize: 13, color: AdminColors.textSecondary)),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildSizeItem('S', false),
              const SizedBox(width: 8),
              _buildSizeItem('M', true),
              const SizedBox(width: 8),
              _buildSizeItem('L', false),
              const SizedBox(width: 8),
              _buildSizeItem('XL', false),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Description', style: TextStyle( fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 8),
          const Text(
            'High quality slim fit t-shirt for casual occasions. Made from 100% cotton with breathable fabric. Features a round neck and short sleeves.',
            style: TextStyle(color: AdminColors.textMuted, fontSize: 13, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, {bool isLarge = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AdminColors.textMuted, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(
          fontSize: isLarge ? 20 : 16, 
          fontWeight: FontWeight.bold, 
          color: isLarge ? Colors.white : AdminColors.textPrimary
        )),
      ],
    );
  }

  Widget _buildSizeItem(String label, bool isSelected) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: isSelected ? AdminColors.primary : AdminColors.background,
        borderRadius: BorderRadius.circular(8),
        border: isSelected ? null : Border.all(color: AdminColors.divider),
      ),
      child: Center(
        child: Text(label, style: TextStyle(color: isSelected ? Colors.white : AdminColors.textMuted, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class _ProductStockPanel extends StatelessWidget {
  const _ProductStockPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AdminColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AdminColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Stock Information', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Stock Status', style: TextStyle(color: AdminColors.textSecondary, fontSize: 13)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AdminColors.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                child: const Text('In Stock', style: TextStyle(color: AdminColors.success, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildStockRow('Quantity', '485'),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: 0.65,
            backgroundColor: AdminColors.divider,
            color: AdminColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
          const SizedBox(height: 8),
          const Text('155 sold this month', style: TextStyle(fontSize: 11, color: AdminColors.textMuted)),
        ],
      ),
    );
  }

  Widget _buildStockRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AdminColors.textSecondary, fontSize: 13)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      ],
    );
  }
}

class _ProductMetaPanel extends StatelessWidget {
  const _ProductMetaPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AdminColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AdminColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Metadata', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 16),
          _buildMetaRow('Created At', '24 Apr 2024'),
          _buildMetaRow('Category', 'Fashion'),
          _buildMetaRow('SKU', 'TSH-001'),
          _buildMetaRow('Tags', 'T-shirt, Men, Cotton'),
        ],
      ),
    );
  }

  Widget _buildMetaRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AdminColors.textMuted, fontSize: 12)),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _ProductReviewsPanel extends StatelessWidget {
  const _ProductReviewsPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AdminColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AdminColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Reviews (33)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text('Average Rating: 4.5', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 24),
          _buildReviewItem('John Doe', 'Excellent quality and fit perfectly!', 5, '2 days ago'),
          _buildReviewItem('Mike Smith', 'Good material but slightly large.', 4, '1 week ago'),
        ],
      ),
    );
  }

  Widget _buildReviewItem(String user, String comment, int rating, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AdminColors.background,
            child: Text(user[0], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(user, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    Text(time, style: const TextStyle(color: AdminColors.textMuted, fontSize: 11)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: List.generate(5, (index) => Icon(
                    index < rating ? Icons.star_rounded : Icons.star_outline_rounded,
                    size: 14,
                    color: Colors.orange,
                  )),
                ),
                const SizedBox(height: 4),
                Text(comment, style: const TextStyle(color: AdminColors.textSecondary, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
