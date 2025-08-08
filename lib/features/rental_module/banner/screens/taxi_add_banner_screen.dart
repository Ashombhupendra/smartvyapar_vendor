import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/models/config_model.dart';
import 'package:sixam_mart_store/common/widgets/custom_image_widget.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/features/rental_module/banner/controllers/taxi_banner_controller.dart';
import 'package:sixam_mart_store/features/rental_module/banner/domain/models/taxi_banner_list_model.dart';
import 'package:sixam_mart_store/features/rental_module/provider/controllers/provider_controller.dart';
import 'package:sixam_mart_store/helper/url_validator.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/common/widgets/custom_app_bar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_text_field_widget.dart';

class TaxiAddBannerScreen extends StatefulWidget {
final Banners? taxiBanner;
const TaxiAddBannerScreen({super.key, this.taxiBanner});

  @override
  State<TaxiAddBannerScreen> createState() => _TaxiAddBannerScreenState();
}

class _TaxiAddBannerScreenState extends State<TaxiAddBannerScreen> with TickerProviderStateMixin {
  final TextEditingController _urlController = TextEditingController();
  final List<TextEditingController> _titleController = [];

  final List<FocusNode> _titleFocusNode = [];
  final FocusNode _urlFocusNode = FocusNode();

  final List<Language>? _languageList = Get.find<SplashController>().configModel!.language;

  TabController? _tabController;
  final List<Tab> _tabs = [];

  late bool _update;
  Banners? _taxiBanner;

  @override
  void initState() {
    super.initState();
    Get.find<ProviderController>().pickImage(isLogo: true, isRemove: true);
    _update = widget.taxiBanner != null;
    _taxiBanner = widget.taxiBanner;

    _tabController = TabController(length: _languageList!.length, vsync: this);
    for (var language in _languageList) {
      _tabs.add(Tab(text: language.value));
    }

    if(_update) {
      List<Translation> translation = _taxiBanner!.translations!;
      for(int index = 0; index<_languageList.length; index++) {
        _titleController.add(TextEditingController(
          text: translation.isNotEmpty ? translation[index].value : '',
        ));
        _titleFocusNode.add(FocusNode());
        for (var translation in widget.taxiBanner!.translations!) {
          if(_languageList[index].key == translation.locale && translation.key == 'name') {
            _titleController[index] = TextEditingController(text: translation.value);
          }
        }
      }
      _urlController.text = widget.taxiBanner!.defaultLink ?? '';
    }else{
      for(int index = 0; index<_languageList.length; index++) {
        _titleController.add(TextEditingController());
        _titleFocusNode.add(FocusNode());
      }
      _taxiBanner = Banners();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: _update ? 'update_banner'.tr : 'add_banner'.tr),

      body: GetBuilder<TaxiBannerController>(builder: (taxiBannerController) {
        return GetBuilder<ProviderController>(builder: (providerController) {
          return Column(children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: SingleChildScrollView(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('title'.tr, style: robotoBold),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Container(
                      padding: const EdgeInsets.only(
                        left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault,
                        top: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeDefault,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.2)),
                      ),
                      child: Column(children: [

                        SizedBox(
                          height: 40,
                          child: TabBar(
                            tabAlignment: TabAlignment.start,
                            controller: _tabController,
                            indicatorColor: Theme.of(context).textTheme.bodyLarge?.color,
                            indicatorWeight: 3,
                            labelColor: Theme.of(context).textTheme.bodyLarge?.color,
                            unselectedLabelColor: Theme.of(context).disabledColor,
                            unselectedLabelStyle: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
                            labelStyle: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault),
                            labelPadding: const EdgeInsets.only(right: Dimensions.radiusDefault),
                            isScrollable: true,
                            indicatorSize: TabBarIndicatorSize.tab,
                            dividerColor: Colors.transparent,
                            tabs: _tabs,
                            onTap: (int ? value) {
                              setState(() {});
                            },
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: Dimensions.paddingSizeLarge),
                          child: Divider(height: 0),
                        ),

                        CustomTextFieldWidget(
                          hintText: 'enter_title'.tr,
                          showLabelText: false,
                          controller: _titleController[_tabController!.index],
                          capitalization: TextCapitalization.words,
                          focusNode: _titleFocusNode[_tabController!.index],
                          nextFocus: _tabController!.index == _languageList!.length-1 ? _urlFocusNode : _titleFocusNode[_tabController!.index+1],
                          showTitle: false,
                        ),

                      ]),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    Text('redirection_url_link'.tr, style: robotoBold),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Container(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.2)),
                      ),
                      child: CustomTextFieldWidget(
                        hintText: 'enter_url'.tr,
                        showLabelText: false,
                        controller: _urlController,
                        focusNode: _urlFocusNode,
                        inputAction: TextInputAction.done,
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    Text('upload_banner'.tr, style: robotoBold),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Container(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.5)),
                      ),
                      child: Column(children: [

                        DottedBorder(
                          color: Theme.of(context).disabledColor.withValues(alpha: 0.5),
                          strokeWidth: 1,
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(Dimensions.radiusSmall),
                          child: SizedBox(
                            height: 125, width: Get.width,
                            child: Align(
                              alignment: Alignment.center,
                              child: Stack(children: [

                                ClipRRect(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                  child: providerController.logo != null ? GetPlatform.isWeb ? Image.network(
                                    providerController.logo!.path, width: Get.width, height: 125, fit: BoxFit.cover,
                                  ) : Image.file(
                                    File(providerController.logo?.path ?? ''), width: Get.width, height: 125, fit: BoxFit.cover,
                                  ) : widget.taxiBanner == null ? SizedBox(width: context.width, height: 125) : CustomImageWidget(
                                    image: widget.taxiBanner?.imageFullUrl ?? '',
                                    height: 125, width: Get.width, fit: BoxFit.cover,
                                  ),
                                ),

                                Positioned(
                                  right: 0, left: 0, top: 0, bottom: 0,
                                  child: InkWell(
                                    onTap: () => providerController.pickImage(isLogo: true, isRemove: false),
                                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                      const Icon(Icons.cloud_upload, color: Colors.teal),
                                      const SizedBox(height: Dimensions.paddingSizeSmall),

                                      Text(
                                        "drag_drop_file_or_browse_file".tr,
                                        style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
                                      ),
                                    ]),
                                  ),
                                ),

                              ]),
                            ),
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeDefault),

                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "banner_images_ration_5:1".tr,
                            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "image_format_maximum_size_2mb".tr,
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor.withValues(alpha: 0.5)),
                          ),
                        ),

                      ]),
                    ),

                  ]),
                ),
              ),
            ),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: CustomButtonWidget(
                  isLoading: taxiBannerController.isLoading,
                  buttonText: _update ? 'update_banner'.tr : 'add_banner'.tr,
                  onPressed: () {

                    bool defaultLanguageDataNull = false;
                    for(int index=0; index<_languageList.length; index++) {
                      if(_languageList[index].key == 'en') {
                        if (_titleController[index].text.trim().isEmpty) {
                          defaultLanguageDataNull = true;
                        }
                        break;
                      }
                    }

                    if(defaultLanguageDataNull) {
                      showCustomSnackBar('enter_title'.tr);
                    }else if((UrlValidator.isValidUrl(_urlController.text) && _urlController.text.isNotEmpty)) {
                      showCustomSnackBar('enter_valid_url'.tr);
                    }else if(!_update && providerController.logo == null) {
                      showCustomSnackBar('upload_banner'.tr);
                    }else{
                      List<Translation> translations = [];
                      for(int index = 0; index < _languageList.length; index++) {
                        translations.add(Translation(
                          locale: _languageList[index].key, key: 'name',
                          value: _titleController[index].text.trim().isNotEmpty ? _titleController[index].text.trim() : _titleController[0].text.trim(),
                        ));
                      }
                      _taxiBanner?.id = _taxiBanner?.id;
                      _taxiBanner?.translations = [];
                      _taxiBanner?.translations!.addAll(translations);
                      _taxiBanner?.defaultLink = _urlController.text.trim();
                      if(_update){
                        taxiBannerController.updateBanner(taxiBanner: _taxiBanner, image: providerController.logo);
                      }else{
                        taxiBannerController.addBanner(taxiBanner: _taxiBanner, image: providerController.logo!);
                      }
                    }
                  },
                ),
              ),
            ),
          ]);
        });
      }),
    );
  }
}
