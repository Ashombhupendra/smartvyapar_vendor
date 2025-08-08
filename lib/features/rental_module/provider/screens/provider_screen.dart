import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/custom_asset_image_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_bottom_sheet_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_image_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/features/rental_module/common/widgets/search_field_widget.dart';
import 'package:sixam_mart_store/features/rental_module/profile/controllers/taxi_profile_controller.dart';
import 'package:sixam_mart_store/features/rental_module/provider/controllers/provider_controller.dart';
import 'package:sixam_mart_store/features/rental_module/provider/screens/add_vehicle_screen.dart';
import 'package:sixam_mart_store/features/rental_module/provider/screens/provider_setting_screen.dart';
import 'package:sixam_mart_store/features/rental_module/provider/screens/taxi_announcement_screen.dart';
import 'package:sixam_mart_store/features/rental_module/provider/screens/vehicle_details_screen.dart';
import 'package:sixam_mart_store/features/rental_module/provider/widgets/shimmer/category_list_shimmer.dart';
import 'package:sixam_mart_store/features/rental_module/provider/widgets/shimmer/vehicle_list_shimmer.dart';
import 'package:sixam_mart_store/features/rental_module/provider/widgets/vehicle_card_widget.dart';
import 'package:sixam_mart_store/features/rental_module/provider/widgets/vehicle_filter_widget.dart';
import 'package:sixam_mart_store/features/rental_module/review/screens/taxi_customer_review_screen.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/features/rental_module/profile/domain/models/taxi_profile_model.dart';

class ProviderScreen extends StatefulWidget {
  const ProviderScreen({super.key});

  @override
  State<ProviderScreen> createState() => _ProviderScreenState();
}

class _ProviderScreenState extends State<ProviderScreen> {
  final ScrollController _verticalScrollController = ScrollController();
  final ScrollController _horizontalScrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ProviderController providerController = Get.find<ProviderController>();

    providerController.getVehicleList(offset: '1', search: '', willUpdate: false);
    providerController.getCategoryList(offset: '1', willUpdate: false);
    providerController.setCategoryInit();
    providerController.resetFilters(willUpdate: false);

    _verticalScrollController.addListener(() {
      if (_verticalScrollController.position.pixels == _verticalScrollController.position.maxScrollExtent) {
        if (!providerController.isLoading && providerController.vehicleList != null) {
          int nextPage = (providerController.vehicleList!.length ~/ providerController.vehiclePageSize!) + 1;
          providerController.showBottomLoader();
          providerController.getVehicleList(offset: nextPage.toString(), search: _searchController.text.trim());
        }
      }

      if (_verticalScrollController.position.userScrollDirection == ScrollDirection.forward) {
        if (!providerController.isFabVisible && _verticalScrollController.offset > 100) {
          providerController.showFab();
        }
      } else if(_verticalScrollController.position.userScrollDirection == ScrollDirection.reverse && _verticalScrollController.offset < 100) {
        if (providerController.isFabVisible) {
          providerController.hideFab();
        }
      }
    });

    _horizontalScrollController.addListener(() {
      if (_horizontalScrollController.position.pixels == _horizontalScrollController.position.maxScrollExtent) {
        if (!providerController.isLoading && providerController.vehicleCategoryList != null && providerController.categoryPageSize != null && providerController.categoryPageSize! > 0) {
          int nextPage = (providerController.vehicleCategoryList!.length ~/ providerController.categoryPageSize!) + 1;
          providerController.getCategoryList(offset: nextPage.toString());
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Get.find<TaxiProfileController>().taxiModulePermission != null && Get.find<TaxiProfileController>().taxiModulePermission!.myShop! ? SafeArea(
      child: GetBuilder<ProviderController>(builder: (providerController) {
        return GetBuilder<TaxiProfileController>(builder: (taxiProfileController) {

          Store? provider = taxiProfileController.profileModel != null ? taxiProfileController.profileModel!.stores![0] : null;

          return provider != null ? Scaffold(
            floatingActionButton: providerController.isFabVisible ? Get.find<TaxiProfileController>().taxiModulePermission!.vehicle! ? FloatingActionButton(
              heroTag: 'nothing',
              onPressed: () {
                if(Get.find<TaxiProfileController>().profileModel!.stores![0].itemSection!) {
                  Get.to(() => const AddVehicleScreen());
                }else {
                  showCustomSnackBar('this_feature_is_blocked_by_admin'.tr);
                }
              },
              backgroundColor: Theme.of(context).primaryColor,
              child: Icon(Icons.add, color: Theme.of(context).cardColor, size: 30),
            ) : const SizedBox() : const SizedBox(),
            body: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: _verticalScrollController,
              slivers: [
                SliverAppBar(
                  expandedHeight: 230, toolbarHeight: 50,
                  floating: false,
                  backgroundColor: Theme.of(context).cardColor,
                  flexibleSpace: FlexibleSpaceBar(
                    background: CustomImageWidget(
                      fit: BoxFit.cover,
                      image: provider.coverPhotoFullUrl ?? '',
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: Container(
                  padding: const EdgeInsets.only(
                    left: Dimensions.paddingSizeLarge, right: Dimensions.paddingSizeLarge, top: Dimensions.paddingSizeLarge,
                  ),
                  child: Column(children: [
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      ClipOval(
                        child: CustomImageWidget(
                          image: provider.logoFullUrl ?? '',
                          height: 70, width: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeSmall),

                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                          Text(provider.name ?? '', style: robotoBlack.copyWith(fontSize: Dimensions.fontSizeExtraLarge)),
                          Text(provider.address ?? '', style: robotoRegular.copyWith(color: Theme.of(context).disabledColor), maxLines: 1, overflow: TextOverflow.ellipsis),
                          Get.find<TaxiProfileController>().taxiModulePermission!.reviews! ? Row(children: [
                            Icon(Icons.star_rounded, color: Theme.of(context).primaryColor, size: 20),
                            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                            Text(provider.avgRating!.toStringAsFixed(1), style: robotoMedium.copyWith(color: Theme.of(context).primaryColor)),
                            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                            InkWell(
                              onTap: () {
                                Get.to(() => const TaxiCustomerReviewScreen());
                              },
                              child: Text('see_reviews'.tr, style: robotoRegular.copyWith(color: Colors.blue, decoration: TextDecoration.underline, decorationColor: Colors.blue)),
                            ),
                          ]) : const SizedBox(),
                        ]),
                      ),

                      Column(children: [
                        InkWell(
                          onTap: () {
                            if(Get.find<TaxiProfileController>().taxiModulePermission!.storeSetup!){
                              Get.to(() => ProviderSettingScreen(provider: provider));
                            }else {
                              showCustomSnackBar('you_have_no_permission_to_access_this_feature'.tr);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall + 2),
                            decoration: BoxDecoration(
                              color: Colors.blue.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            ),
                            child: const CustomAssetImageWidget(Images.editIcon, height: 20, width: 20),
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        InkWell(
                          onTap: () {
                            Get.to(() => TaxiAnnouncementScreen(announcementStatus: provider.isAnnouncementActive!, announcementMessage: provider.announcementMessage ?? ''));
                          },
                          child: Container(
                            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall + 2),
                            decoration: BoxDecoration(
                              color: Colors.orange.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            ),
                            child: const CustomAssetImageWidget(Images.taxiAnnouncementIcon, height: 20, width: 20),
                          ),
                        ),
                      ]),
                    ]),
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                    const Divider(thickness: 0.2),
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                  ]),
                )),

                Get.find<TaxiProfileController>().taxiModulePermission!.vehicle! ? SliverPersistentHeader(
                  pinned: true,
                  delegate: SliverDelegate(child: Container(
                    padding: const EdgeInsets.only(
                      left: Dimensions.paddingSizeLarge, right: Dimensions.paddingSizeLarge, bottom: Dimensions.paddingSizeDefault,
                    ),
                    decoration: BoxDecoration(color: Theme.of(context).cardColor),
                    child: Column(children: [
                      Row(children: [
                        Expanded(child: Text('vehicle_list'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge))),

                        InkWell(
                          onTap: () {
                            providerController.setSearchVisibility();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall - 2),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            ),
                            child: Icon(providerController.isSearchVisible ? Icons.close : CupertinoIcons.search, color: Theme.of(context).primaryColor, size: 18),
                          ),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        InkWell(
                          onTap: () {
                            showCustomBottomSheet(child: const VehicleFilterWidget(), height:  MediaQuery.of(context).size.height * 0.71);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              border: Border.all(color: Theme.of(context).primaryColor),
                            ),
                            child: const CustomAssetImageWidget(Images.filterIcon, height: 20, width: 20),
                          ),
                        ),
                      ]),
                      const SizedBox(height: Dimensions.paddingSizeDefault),

                      Visibility(
                        visible: providerController.isSearchVisible,
                        child: SizedBox(
                          height: 50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: SearchFieldWidget(
                              fromReview: true,
                              controller: _searchController,
                              hint: '${'search_by_vehicle_name'.tr}...',
                              suffixIcon: providerController.isSearching ? CupertinoIcons.clear_thick : CupertinoIcons.search,
                              iconPressed: () {
                                if (!providerController.isSearching) {
                                  if (_searchController.text.trim().isNotEmpty) {
                                    providerController.getVehicleList(offset: '1', search: _searchController.text.trim());
                                  } else {
                                    showCustomSnackBar('write_vehicle_name_for_search'.tr);
                                  }
                                } else {
                                  _searchController.clear();
                                  providerController.getVehicleList(offset: '1', search: '');
                                }
                              },
                              onSubmit: (String text) {
                                if (_searchController.text.trim().isNotEmpty) {
                                  providerController.getVehicleList(offset: '1', search: _searchController.text.trim());
                                } else {
                                  showCustomSnackBar('write_vehicle_name_for_search'.tr);
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: providerController.isSearchVisible ? Dimensions.paddingSizeDefault : 0),
                  
                      SizedBox(
                        height: 30,
                        child: providerController.vehicleCategoryList != null ? providerController.vehicleCategoryList!.isNotEmpty ? ListView.builder(
                          controller: _horizontalScrollController,
                          scrollDirection: Axis.horizontal,
                          itemCount: providerController.vehicleCategoryList?.length ?? 0,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                providerController.setSelectedCategoryIndex(index);
                                providerController.setSelectedCategoryId(index == 0 ? '' : providerController.vehicleCategoryList![index].id.toString());
                                providerController.setOffset(1);
                                providerController.getVehicleList(offset: '1', search: _searchController.text.trim());
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall - 1),
                                margin: EdgeInsets.only(right: index == providerController.vehicleCategoryList!.length - 1 ? Dimensions.paddingSizeLarge : Dimensions.paddingSizeSmall),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall + 2),
                                  border: Border.all(color: index == providerController.selectedCategoryIndex ? Theme.of(context).primaryColor : Colors.transparent),
                                ),
                                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                  Text(
                                    providerController.vehicleCategoryList?[index].name ?? '',
                                    style: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeSmall,
                                      color:index == providerController.selectedCategoryIndex ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
                                      fontWeight: index == providerController.selectedCategoryIndex ? FontWeight.w700 : FontWeight.w400,
                                    ),
                                  ),
                                ]),
                              ),
                            );
                          },
                        ) : const SizedBox() : const CategoryListShimmer(),
                      ),
                    ]),
                  )),
                ) : const SliverToBoxAdapter(),

                Get.find<TaxiProfileController>().taxiModulePermission!.reviews! ? providerController.vehicleList != null ? providerController.vehicleList!.isNotEmpty ? SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        left: Dimensions.paddingSizeLarge, right: Dimensions.paddingSizeLarge,
                        top: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeSmall,
                      ),
                      child: InkWell(
                        onTap: () {
                          Get.to(() => VehicleDetailsScreen(vehicleId: providerController.vehicleList![index].id!));
                        },
                        child: VehicleCardWidget(vehicle: providerController.vehicleList![index]),
                      ),
                    );
                  },
                    childCount: providerController.vehicleList?.length ?? 0,
                  ),
                ) : SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: Center(
                      child: Text('no_vehicle_found'.tr, style: robotoRegular),
                    ),
                  ),
                ) : const VehicleListShimmer() : const SliverToBoxAdapter(),

                if (providerController.isLoading)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),

              ],
            ),
          ) : const Center(child: CircularProgressIndicator());
        });
      }),
    ) : Scaffold(
      body: Center(child: Text('you_have_no_permission_to_access_this_feature'.tr, style: robotoMedium)),
    );
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;

  SliverDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => Get.find<ProviderController>().isSearchVisible ? 160 : 95;

  @override
  double get minExtent => Get.find<ProviderController>().isSearchVisible ? 160 : 95;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != (Get.find<ProviderController>().isSearchVisible ? 160 : 95) || oldDelegate.minExtent != (Get.find<ProviderController>().isSearchVisible ? 160 : 95) || child != oldDelegate.child;
  }
}