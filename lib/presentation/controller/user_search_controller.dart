import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/di/service_locator.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/data/model/search_response_model.dart';
import 'package:kayal_userapp/data/repository/search_repository_impl.dart';
import 'package:kayal_userapp/domain/usecase/search_usecase.dart';
import 'package:kayal_userapp/presentation/widgets/app_notification.dart';

class UserSearchController extends GetxController {
  final SearchUseCase _searchUseCase;

  UserSearchController({SearchUseCase? searchUseCase})
      : _searchUseCase = searchUseCase ??
            (sl.isRegistered<SearchUseCase>()
                ? sl<SearchUseCase>()
                : SearchUseCase(SearchRepositoryImpl(ApiService())));

  final TextEditingController searchInputController = TextEditingController();
  final RxString query = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool hasSearched = false.obs;
  final Rx<SearchResponseModel?> searchResult = Rx<SearchResponseModel?>(null);

  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    searchInputController.addListener(() {
      query.value = searchInputController.text;
    });
  }

  void onQueryChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (value.trim().isNotEmpty) {
        performSearch(value.trim());
      } else {
        clearSearch();
      }
    });
  }

  Future<void> performSearch(String searchQuery) async {
    final trimmed = searchQuery.trim();
    if (trimmed.isEmpty) {
      clearSearch();
      return;
    }

    try {
      isLoading.value = true;
      hasSearched.value = true;

      final response = await _searchUseCase(query: trimmed);
      searchResult.value = response;

      if (!response.success && response.message.isNotEmpty) {
        AppNotification.showError(
          title: 'Search',
          message: response.message,
        );
      }
    } catch (e) {
      debugPrint('Search error: $e');
      AppNotification.showError(
        title: 'Search Error',
        message: 'Could not fetch search results. Please try again.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  void clearSearch() {
    searchInputController.clear();
    query.value = '';
    searchResult.value = null;
    hasSearched.value = false;
  }

  @override
  void onClose() {
    _debounce?.cancel();
    searchInputController.dispose();
    super.onClose();
  }
}
