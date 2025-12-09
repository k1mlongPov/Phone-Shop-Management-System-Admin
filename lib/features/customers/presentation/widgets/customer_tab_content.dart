import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phone_management_system_admin/features/users/domains/user_model.dart';
import 'package:phone_management_system_admin/features/customers/domain/models/customer_model.dart';
import 'package:phone_management_system_admin/features/customers/logic/customers_controller.dart';
import 'package:phone_management_system_admin/features/customers/presentation/pages/customer_detail_page.dart';
import 'package:phone_management_system_admin/features/users/presentation/pages/user_detail_page.dart';
import 'package:phone_management_system_admin/features/customers/presentation/widgets/person_tile.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

class CustomerTabContent extends StatelessWidget {
  final CustomersController c;

  const CustomerTabContent({super.key, required this.c});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (c.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (c.filteredList.isEmpty) {
          return Center(
            child: ReusableText(
              text: "No results found",
              style: appStyle(14, Colors.grey, FontWeight.w600),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: c.refreshData,
          child: ListView.separated(
            padding: EdgeInsets.all(16.w),
            itemCount: c.filteredList.length,
            separatorBuilder: (_, __) => SizedBox(height: 12.h),
            itemBuilder: (_, index) {
              final item = c.filteredList[index];

              if (item is Customer) {
                return PersonTile(
                  name: item.name,
                  phone: item.phone,
                  email: item.email!,
                  roles: const [],
                  onTap: () => Get.to(() => CustomerDetailPage(customer: item)),
                );
              }

              if (item is UserModel) {
                return PersonTile(
                  name: item.username,
                  phone: item.phone,
                  email: item.email,
                  roles: item.roles,
                  onTap: () => Get.to(() => UserDetailPage(user: item)),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        );
      },
    );
  }
}
