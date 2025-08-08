import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/custom_app_bar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_asset_image_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_bottom_sheet_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_image_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/features/rental_module/common/widgets/custom_switch_button.dart';
import 'package:sixam_mart_store/features/rental_module/common/widgets/search_field_widget.dart';
import 'package:sixam_mart_store/features/rental_module/driver/controllers/driver_controller.dart';
import 'package:sixam_mart_store/features/rental_module/driver/screens/add_driver_screen.dart';
import 'package:sixam_mart_store/features/rental_module/driver/screens/driver_details_screen.dart';
import 'package:sixam_mart_store/features/rental_module/driver/widgets/driver_delete_bottom_sheet.dart';
import 'package:sixam_mart_store/features/rental_module/driver/widgets/shimmer/driver_list_shimmer.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';

class DriverListScreen extends StatefulWidget {
  const DriverListScreen({super.key});

  @override
  State<DriverListScreen> createState() => _DriverListScreenState();
}

class _DriverListScreenState extends State<DriverListScreen> {
  
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    DriverController driverController = Get.find<DriverController>();
    driverController.getDriverList(offset: '1', search: '');

    driverController.setOffset(1);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent
          && driverController.driversList != null && !driverController.isLoading) {
        int pageSize = (driverController.pageSize! / 10).ceil();
        if (driverController.offset < pageSize) {
          driverController.setOffset(driverController.offset + 1);
          driverController.showBottomLoader();
          driverController.getDriverList(offset: driverController.offset.toString(), search: _searchController.text.trim());
        }
      }}
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'driver_list'.tr),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const AddDriverScreen());
        },
        child: Icon(Icons.add, color: Theme.of(context).cardColor, size: 30),
      ),

      body: GetBuilder<DriverController>(builder: (driverController) {
        return driverController.driversList != null ? driverController.driversList!.isNotEmpty ? Column(children: [

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.2), spreadRadius: 1, blurRadius: 5, offset: const Offset(0, 1))],
            ),
            child: Column(children: [

              Row(spacing: Dimensions.paddingSizeSmall, children: [

                Expanded(
                  child: Text('${driverController.pageSize} ${'driver_available'.tr}', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                ),
                const SizedBox(width: Dimensions.paddingSizeDefault),

                InkWell(
                  onTap: () {
                    driverController.setSearchVisibility();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall + 2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    ),
                    child: Icon(driverController.isSearchVisible ? Icons.close : Icons.search, color: Theme.of(context).primaryColor, size: 16),
                  ),
                ),

              ]),
              SizedBox(height: driverController.isSearchVisible ? Dimensions.paddingSizeDefault : 0),

              Visibility(
                visible: driverController.isSearchVisible,
                child: SizedBox(
                  height: 50,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: SearchFieldWidget(
                      fromReview: true,
                      controller: _searchController,
                      hint: '${'search_by_driver_name_phone_email'.tr}...',
                      suffixIcon: driverController.isSearching ? CupertinoIcons.clear_thick : CupertinoIcons.search,
                      iconPressed: () {
                        if (!driverController.isSearching) {
                          if (_searchController.text.trim().isNotEmpty) {
                            driverController.getDriverList(offset: '1', search: _searchController.text.trim());
                          } else {
                            showCustomSnackBar('write_driver_name_phone_email_for_search'.tr);
                          }
                        } else {
                          _searchController.clear();
                          driverController.getDriverList(offset: '1', search: '');
                        }
                      },
                      onSubmit: (String text) {
                        if (_searchController.text.trim().isNotEmpty) {
                          driverController.getDriverList(offset: '1', search: _searchController.text.trim());
                        } else {
                          showCustomSnackBar('write_driver_name_phone_email_for_search'.tr);
                        }
                      },
                    ),

                  ),
                ),
              ),

            ]),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: driverController.driversList!.length,
              padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                  child: InkWell(
                    onTap: () {
                      Get.to(() => DriverDetailsScreen(driver: driverController.driversList![index]));
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                        top: Dimensions.paddingSizeDefault,
                        bottom: Dimensions.paddingSizeDefault,
                        left: Dimensions.paddingSizeDefault,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.2)),
                      ),
                      child: Column(children: [

                        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

                          ClipOval(
                            child: CustomImageWidget(
                              image: driverController.driversList![index].imageFullUrl ?? '',
                              height: 60, width: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: Dimensions.paddingSizeSmall),

                          Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                              Text('${driverController.driversList?[index].firstName ?? ''} ${driverController.driversList?[index].lastName ?? ''}', style: robotoMedium),
                              const SizedBox(height: Dimensions.paddingSizeSmall),

                              Text(driverController.driversList?[index].phone ?? '', style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color?.withValues(alpha: 0.7))),

                            ]),
                          ),
                          const SizedBox(width: Dimensions.paddingSizeSmall),

                          PopupMenuButton(
                            borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                            menuPadding: const EdgeInsets.all(0),
                            icon: Container(
                              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              ),
                              child: Icon(Icons.more_vert, color: Theme.of(context).primaryColor),
                            ),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'status',
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Text('status'.tr, style: robotoRegular),
                                      trailing: CustomSwitchButton(
                                        value: driverController.driversList![index].status == 1,
                                        onChanged: (value) {
                                          driverController.updateDriverStatus(driverId: driverController.driversList![index].id!);
                                        },
                                      ),
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    const Divider(height: 1),
                                  ],
                                ),
                              ),

                              PopupMenuItem(
                                value: 'delete',
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Text('delete'.tr, style: robotoRegular),
                                      trailing: const CustomAssetImageWidget(Images.deleteIcon, height: 20, width: 20),
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    const Divider(height: 1),
                                  ],
                                ),
                              ),

                              PopupMenuItem(
                                value: 'edit',
                                child: ListTile(
                                  title: Text('edit'.tr, style: robotoRegular),
                                  trailing: const CustomAssetImageWidget(Images.editIcon, height: 20, width: 20),
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ],
                            onSelected: (value) {
                              if(value == 'edit') {
                                Get.to(() => AddDriverScreen(driver: driverController.driversList?[index]));
                              }else if(value == 'delete') {
                                showCustomBottomSheet(child: DriverDeleteBottomSheet(driverId: driverController.driversList![index].id!));
                              }else {
                                driverController.updateDriverStatus(driverId: driverController.driversList![index].id!);
                              }
                            },
                          ),

                        ]),
                        const SizedBox(height: Dimensions.paddingSizeDefault),

                        Padding(
                          padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                          child: Row(spacing: Dimensions.paddingSizeSmall, children: [

                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                ),
                                child: Column(spacing: Dimensions.paddingSizeSmall, crossAxisAlignment: CrossAxisAlignment.start, children: [

                                  Text('total_trip'.tr, style: robotoRegular),

                                  Text(driverController.driversList?[index].tripsCount.toString() ?? '', style: robotoBold),

                                ]),
                              ),
                            ),

                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                ),
                                child: Column(spacing: Dimensions.paddingSizeSmall, crossAxisAlignment: CrossAxisAlignment.start, children: [

                                  Text('completed'.tr, style: robotoRegular),

                                  Text(driverController.driversList?[index].totalTripCompleted.toString() ?? '', style: robotoBold),

                                ]),
                              ),
                            ),

                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                ),
                                child: Column(spacing: Dimensions.paddingSizeSmall, crossAxisAlignment: CrossAxisAlignment.start, children: [

                                  Text('canceled'.tr, style: robotoRegular),

                                  Text(driverController.driversList?[index].totalTripCanceled.toString() ?? '', style: robotoBold),

                                ]),
                              ),
                            ),

                          ]),
                        ),

                      ]),
                    ),
                  ),
                );
              },
            ),
          ),

          if (driverController.isLoading)
            const Padding(
              padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),

        ]) : Center(child: Text('no_driver_found'.tr)) : const DriverListShimmer();
      }),
    );
  }
}
