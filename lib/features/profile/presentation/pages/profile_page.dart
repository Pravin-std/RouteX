import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:routex/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../../../../backend/providers/user_profile_provider.dart';
import '../../../../backend/providers/auth_provider.dart';
import '../widgets/profile_edit_dialog.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../../../backend/repositories/auth_repository_impl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  Future<void> _updateField(String fieldName, String value) async {
    try {
      await ref.read(userProfileProvider.notifier).updateProfile({
        fieldName: value,
      });
      if (context.mounted) {
        SnackbarUtils.showSuccess(
          context,
          AppLocalizations.of(context)!.profileUpdated,
        );
      }
    } catch (e) {
      if (context.mounted) {
        SnackbarUtils.showError(
          context,
          '${AppLocalizations.of(context)!.error}: $e',
        );
      }
    }
  }

  void _showEditDialog(String title, String fieldName, String currentValue) {
    showDialog(
      context: context,
      builder: (context) => ProfileEditDialog(
        title: title,
        initialValue: currentValue,
        onSave: (newValue) {
          if (newValue != currentValue) {
            _updateField(fieldName, newValue);
          }
        },
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 70,
      );
      if (image != null) {
        setState(() => _isUploading = true);

        final bytes = await image.readAsBytes();
        final fileName = image.name;

        // Instantiate repository or get from provider. We'll instantiate directly for simplicity here
        // as we only need it for upload. Ideally this should go through userProfileProvider.
        final repo = AuthRepositoryImpl(
          supabaseClient: Supabase.instance.client,
        );
        final url = await repo.uploadProfilePhoto(fileName, bytes);

        await ref.read(userProfileProvider.notifier).updateProfile({
          'avatar_url': url,
        });

        if (context.mounted) {
          SnackbarUtils.showSuccess(context, l10n.profileUpdated);
        }
      }
    } catch (e) {
      if (context.mounted) {
        SnackbarUtils.showError(context, '${l10n.imageUploadError}: $e');
      }
    } finally {
      if (context.mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  void _showImageSourceDialog() {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(l10n.gallery),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(l10n.camera),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final profileState = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFAF6F0),
      appBar: AppBar(
        title: Text(
          l10n.myProfile,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: () async {
              await ref.read(authStateProvider.notifier).logout();
              if (context.mounted) {
                context.go('/login');
              }
            },
          ),
        ],
      ),
      body: profileState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('${l10n.error}: $error')),
        data: (profile) {
          if (profile == null) {
            return Center(child: Text(l10n.unauthorized));
          }

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Column(
              children: [
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60.r,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage:
                            profile.profilePhotoUrl != null &&
                                profile.profilePhotoUrl!.isNotEmpty
                            ? NetworkImage(profile.profilePhotoUrl!)
                            : null,
                        child:
                            profile.profilePhotoUrl == null ||
                                profile.profilePhotoUrl!.isEmpty
                            ? Icon(
                                Icons.person,
                                size: 60.sp,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      if (_isUploading)
                        Positioned.fill(
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.black45,
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _isUploading ? null : _showImageSourceDialog,
                          child: Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: const BoxDecoration(
                              color: Color(0xFF1E4DB7),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32.h),
                _buildProfileItem(
                  l10n.fullName,
                  profile.fullName,
                  'full_name',
                  l10n,
                ),
                _buildProfileItem(
                  l10n.email,
                  profile.email,
                  '',
                  l10n,
                  isEditable: false,
                ),
                _buildProfileItem(
                  l10n.phoneNumber,
                  profile.phoneNumber,
                  'phone_number',
                  l10n,
                ),
                _buildProfileItem(
                  l10n.gender,
                  profile.gender ?? l10n.notAdded,
                  'gender',
                  l10n,
                ),
                _buildProfileItem(
                  l10n.dateOfBirth,
                  profile.dob ?? l10n.notAdded,
                  'dob',
                  l10n,
                ),
                _buildProfileItem(
                  l10n.address,
                  profile.address ?? l10n.notAdded,
                  'address',
                  l10n,
                ),
                _buildProfileItem(
                  l10n.city,
                  profile.city ?? l10n.notAdded,
                  'city',
                  l10n,
                ),
                _buildProfileItem(
                  l10n.state,
                  profile.state ?? l10n.notAdded,
                  'state',
                  l10n,
                ),
                _buildProfileItem(
                  l10n.country,
                  profile.country ?? l10n.notAdded,
                  'country',
                  l10n,
                ),
                SizedBox(height: 40.h),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileItem(
    String title,
    String value,
    String fieldName,
    AppLocalizations l10n, {
    bool isEditable = true,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value.isEmpty ? l10n.notAdded : value,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: value.isEmpty || value == l10n.notAdded
                        ? Colors.grey.shade400
                        : Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (isEditable)
            IconButton(
              icon: Icon(
                Icons.edit_outlined,
                color: const Color(0xFF1E4DB7),
                size: 20.sp,
              ),
              onPressed: () => _showEditDialog(
                title,
                fieldName,
                value == l10n.notAdded ? '' : value,
              ),
            ),
        ],
      ),
    );
  }
}
