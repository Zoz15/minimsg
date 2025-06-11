import 'package:get/get.dart';
import 'package:minimsg/core/model/proriles_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Search_Controller extends GetxController {
  final RxList<Map<String, dynamic>> users = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;
  final RxString sortBy = 'name'.obs; // 'name' or 'time'

  Map<String, dynamic> userdata = {};

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      isLoading.value = true;
      final profiles = await fetchAllProfiles();
      users.value = profiles;
      sortUsers();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch users');
    } finally {
      isLoading.value = false;
    }
  }

  // get all profiles and me
  Future<List<Map<String, dynamic>>> fetchAllProfiles() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await Supabase.instance.client.from('profiles').select();
    // .neq('id', userId);
    print(response);
    print('get users');

    return response;
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    sortUsers();
  }

  void updateSortBy(String value) {
    sortBy.value = value;
    sortUsers();
  }

  void sortUsers() {
    if (sortBy.value == 'name') {
      users.sort(
        (a, b) =>
            (a[ProfilesModel.username]).compareTo((b[ProfilesModel.username])),
      );
    } else {
      users.sort(
        (a, b) => (b[ProfilesModel.created_at]).compareTo(
          (a[ProfilesModel.created_at]),
        ),
      );
    }
  }

  List<Map<String, dynamic>> get filteredUsers {
    if (searchQuery.isEmpty) return users;
    return users.where((user) {
      final name = (user[ProfilesModel.username]).toLowerCase();
      return name.contains(searchQuery.value.toLowerCase());
    }).toList();
  }
}
