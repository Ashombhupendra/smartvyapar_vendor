import 'package:sixam_mart_store/features/category/domain/models/category_model.dart';
import 'package:sixam_mart_store/features/store/domain/models/item_model.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/features/category/domain/services/category_service_interface.dart';

class CategoryController extends GetxController implements GetxService {
  final CategoryServiceInterface categoryServiceInterface;

  CategoryController({required this.categoryServiceInterface});

  List<CategoryModel>? _categoryList;
  List<CategoryModel>? get categoryList => _categoryList;

  List<CategoryModel>? _subCategoryList;
  List<CategoryModel>? get subCategoryList => _subCategoryList;

  int? _categoryIndex;
  int? get categoryIndex => _categoryIndex;

  int? _subCategoryIndex;
  int? get subCategoryIndex => _subCategoryIndex;

  Future<void> getCategoryList(Item? item) async {
    _categoryList = null;
    update();
    List<CategoryModel>? fetchedCategoryList = await categoryServiceInterface.getCategoryList();
    if (fetchedCategoryList != null) {
      _categoryList = fetchedCategoryList;
      _categoryIndex = categoryServiceInterface.categoryIndex(_categoryList, item);
      if (item != null && item.categoryIds != null && item.categoryIds!.isNotEmpty) {
        await getSubCategoryList(int.parse(item.categoryIds![0].id!), item);
      }
    }
    update();
  }

  Future<void> getSubCategoryList(int? categoryID, Item? item) async {
    _subCategoryList = null;
    update();
    if (categoryID != 0) {
      List<CategoryModel>? fetchedSubCategoryList = await categoryServiceInterface.getSubCategoryList(categoryID);
      if (fetchedSubCategoryList != null) {
        _subCategoryList = fetchedSubCategoryList;
        _subCategoryIndex = categoryServiceInterface.subCategoryIndex(_subCategoryList, item);
      }
    }
    update();
  }

  void setCategoryIndex(int index, bool notify) {
    _categoryIndex = index;
    if (notify) {
      update();
    }
  }

  void setSubCategoryIndex(int index, bool notify) {
    _subCategoryIndex = index;
    if (notify) {
      update();
    }
  }
}
