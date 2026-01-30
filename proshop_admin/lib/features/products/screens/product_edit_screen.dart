import 'package:flutter/material.dart';
import '../../../core/constants/admin_colors.dart';

class ProductEditScreen extends StatelessWidget {
  const ProductEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Product Edit',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                   OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AdminColors.textPrimary,
                      side: const BorderSide(color: AdminColors.divider),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AdminColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      elevation: 0,
                    ),
                    child: const Text('Save Changes'),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 24),
          
          // Main Form Container
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AdminColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AdminColors.divider),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Pricing Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 24),
                
                // Row 1: Price, Discount, Tax
                Row(
                  children: [
                    Expanded(child: _buildInputField('Price', '\$100.00')),
                    const SizedBox(width: 24),
                    Expanded(child: _buildInputField('Discount', '20%')),
                    const SizedBox(width: 24),
                    Expanded(child: _buildInputField('Tax (15%)', '\$15.00')),
                  ],
                ),
                const SizedBox(height: 24),

                // Row 2: Brand, Weight, Gender
                Row(
                  children: [
                    Expanded(child: _buildInputField('Brand', 'Larkon Fashion')),
                    const SizedBox(width: 24),
                    Expanded(child: _buildInputField('Weight', '300gm')),
                    const SizedBox(width: 24),
                    Expanded(child: _buildSelectField('Gender', 'Men')),
                  ],
                ),
                const SizedBox(height: 24),

                // Row 3: Description
                _buildTextArea('Description', 'Top in sweatshirt fabric made from a cotton blend with a soft brushed inside. Relaxed fit with dropped shoulders, long sleeves and ribbing around the neckline, cuffs and hem. Small metal text applique.'),
                const SizedBox(height: 24),

                // Row 4: Tag Number, Stock, Tag
                Row(
                  children: [
                    Expanded(child: _buildInputField('Tag Number', '36294007')),
                    const SizedBox(width: 24),
                    Expanded(child: _buildInputField('Stock', '485')),
                    const SizedBox(width: 24),
                    Expanded(child: _buildTagField('Tag', 'Fashion')),
                  ],
                ),
                const SizedBox(height: 24),

                // Row 5: Colors
                const Text('Colors:', style: TextStyle(color: AdminColors.textSecondary, fontSize: 13)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildColorCircle(const Color(0xFF141419), true), // Black
                    const SizedBox(width: 12),
                    _buildColorCircle(Colors.white, false),
                    const SizedBox(width: 12),
                    _buildColorCircle(Colors.orange, false),
                    const SizedBox(width: 12),
                    _buildColorCircle(Colors.red, false),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AdminColors.textSecondary, fontSize: 13)),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: value,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AdminColors.divider)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AdminColors.primary)),
            filled: true,
            fillColor: AdminColors.background.withValues(alpha: 0.3),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AdminColors.textSecondary, fontSize: 13)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: (val) {},
          items: [DropdownMenuItem(value: value, child: Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)))],
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AdminColors.divider)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AdminColors.primary)),
            filled: true,
            fillColor: AdminColors.background.withValues(alpha: 0.3),
          ),
        ),
      ],
    );
  }

  Widget _buildTextArea(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AdminColors.textSecondary, fontSize: 13)),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: value,
          maxLines: 3,
          style: const TextStyle(color: AdminColors.textSecondary, fontSize: 14, height: 1.5),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(16),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AdminColors.divider)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AdminColors.primary)),
            filled: true,
            fillColor: AdminColors.background.withValues(alpha: 0.3),
          ),
        ),
      ],
    );
  }

  Widget _buildTagField(String label, String tag) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AdminColors.textSecondary, fontSize: 13)),
        const SizedBox(height: 8),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: AdminColors.divider),
            borderRadius: BorderRadius.circular(8),
            color: AdminColors.background.withValues(alpha: 0.3),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AdminColors.primary, borderRadius: BorderRadius.circular(4)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(tag, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 6),
                    const Icon(Icons.close, size: 10, color: Colors.white),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildColorCircle(Color color, bool isSelected) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: isSelected ? AdminColors.primary : Colors.transparent, width: 2),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 2, offset: Offset(0, 1))],
      ),
    );
  }
}
