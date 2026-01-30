import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/admin_colors.dart';
import '../../../routes/admin_routes.dart';
import '../../../providers/navigation_provider.dart';

class AdminSidebar extends StatelessWidget {
  const AdminSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<NavigationProvider>(context);
    final currentRoute = navProvider.currentRoute;

    return Container(
      width: 260,
      decoration: const BoxDecoration(
        color: AdminColors.sidebar,
        border: Border(right: BorderSide(color: AdminColors.divider, width: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AdminColors.primary, Color(0xFFFF8A00)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AdminColors.primary.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.shopping_bag_rounded, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 14),
                const Text(
                  'LARKON',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('MAIN MENU'),
                  _SidebarItem(
                    icon: Icons.grid_view_rounded,
                    label: 'Dashboard',
                    route: AdminRoutes.dashboard,
                    isActive: currentRoute == AdminRoutes.dashboard,
                  ),
                  
                  const SizedBox(height: 12),
                  _buildSectionHeader('MARKETPLACE'),
                  _SidebarItem(
                    icon: Icons.inventory_2_rounded,
                    label: 'Products',
                    route: AdminRoutes.products,
                    isActive: currentRoute == AdminRoutes.products || currentRoute == AdminRoutes.productGrid,
                    subItems: [
                      _SidebarSubItem(label: 'Product List', route: AdminRoutes.products, isActive: currentRoute == AdminRoutes.products),
                      _SidebarSubItem(label: 'Product Grid', route: AdminRoutes.productGrid, isActive: currentRoute == AdminRoutes.productGrid),
                      _SidebarSubItem(label: 'Edit Product', route: AdminRoutes.productEdit, isActive: currentRoute == AdminRoutes.productEdit),
                    ],
                  ),
                  _SidebarItem(
                    icon: Icons.category_rounded,
                    label: 'Category',
                    route: AdminRoutes.categories,
                    isActive: currentRoute == AdminRoutes.categories,
                  ),
                  _SidebarItem(
                    icon: Icons.warehouse_rounded,
                    label: 'Inventory',
                    route: AdminRoutes.inventory,
                    isActive: currentRoute == AdminRoutes.inventory,
                  ),
                  
                  const SizedBox(height: 24),
                  _buildSectionHeader('SALES & ORDERS'),
                  _SidebarItem(
                    icon: Icons.shopping_cart_rounded,
                    label: 'Orders',
                    route: AdminRoutes.orders,
                    isActive: currentRoute == AdminRoutes.orders || currentRoute == AdminRoutes.orderDetails,
                    subItems: [
                      _SidebarSubItem(label: 'Order List', route: AdminRoutes.orders, isActive: currentRoute == AdminRoutes.orders),
                      _SidebarSubItem(label: 'Order Details', route: AdminRoutes.orderDetails, isActive: currentRoute == AdminRoutes.orderDetails),
                      _SidebarSubItem(label: 'Checkout', route: AdminRoutes.checkout, isActive: currentRoute == AdminRoutes.checkout),
                    ],
                  ),
                  _SidebarItem(
                    icon: Icons.receipt_rounded,
                    label: 'Invoices',
                    route: AdminRoutes.invoices,
                    isActive: currentRoute == AdminRoutes.invoices,
                  ),
                  

                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          
          // User Profile at Bottom
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AdminColors.divider, width: 0.5)),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=admin'),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Master Admin',
                        style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Premium Account',
                        style: TextStyle(color: AdminColors.textMuted, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.logout_rounded, color: AdminColors.textMuted, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          color: AdminColors.textMuted,
          fontSize: 10,
          letterSpacing: 1.5,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _SidebarItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final String route;
  final bool isActive;
  final List<_SidebarSubItem>? subItems;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.route,
    required this.isActive,
    this.subItems,
  });

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isActive;
  }

  @override
  void didUpdateWidget(_SidebarItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _isExpanded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasSubitems = widget.subItems != null;

    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if (hasSubitems) {
                setState(() => _isExpanded = !_isExpanded);
              } else if (!widget.isActive) {
                Provider.of<NavigationProvider>(context, listen: false).setRoute(widget.route);
              }
            },
            borderRadius: BorderRadius.circular(10),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(vertical: 2),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: widget.isActive && !hasSubitems 
                    ? AdminColors.primary.withValues(alpha: 0.1) 
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    widget.icon,
                    size: 20,
                    color: widget.isActive ? AdminColors.primary : AdminColors.textSecondary,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      widget.label,
                      style: TextStyle(
                        color: widget.isActive ? Colors.white : AdminColors.textSecondary,
                        fontWeight: widget.isActive ? FontWeight.w700 : FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  if (hasSubitems)
                    AnimatedRotation(
                      turns: _isExpanded ? 0.25 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.chevron_right_rounded,
                        size: 18,
                        color: _isExpanded ? AdminColors.primary : AdminColors.textMuted,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        if (hasSubitems && _isExpanded)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Column(children: widget.subItems!),
          ),
      ],
    );
  }
}

class _SidebarSubItem extends StatelessWidget {
  final String label;
  final String route;
  final bool isActive;

  const _SidebarSubItem({
    required this.label,
    required this.route,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (!isActive) {
          Provider.of<NavigationProvider>(context, listen: false).setRoute(route);
        }
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.only(left: 36, right: 0, top: 4, bottom: 4),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isActive ? AdminColors.primary.withValues(alpha: 0.05) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: isActive ? AdminColors.primary : AdminColors.textMuted.withValues(alpha: 0.5),
                shape: BoxShape.circle,
                boxShadow: isActive ? [
                  BoxShadow(color: AdminColors.primary.withValues(alpha: 0.5), blurRadius: 4)
                ] : null,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : AdminColors.textSecondary,
                fontSize: 13,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
