import 'dart:io';
import 'package:doctor/features/auth/data/sources/customer_info_service.dart';
import 'package:doctor/features/auth/presentation/managers/customer_info_cubit.dart';
import 'package:doctor/features/home/presentation/managers/delete_photo_cubit.dart';
import 'package:doctor/features/home/presentation/managers/delete_photo_state.dart';
import 'package:doctor/features/home/presentation/managers/update_photo_cubit.dart';
import 'package:doctor/features/home/presentation/managers/update_photo_state.dart';
import 'package:doctor/features/home/presentation/pages/edit_cv_experience_section.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doctor/core/classes/icon_classes.dart';
import 'package:doctor/core/localization/app_strings.dart';
import 'package:doctor/core/theme/app_color.dart';
import 'package:doctor/features/home/presentation/pages/home_page.dart';
import 'package:doctor/features/home/presentation/widgets/widgets_page.dart';

import 'package:doctor/features/home/presentation/managers/doctor_display_case_cubit.dart';
import 'package:doctor/features/home/presentation/managers/doctor_display_case_state.dart';
import 'package:doctor/features/home/data/models/doctor_display_case_model.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  /// ===== User data controllers (ADDED) =====
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  XFile? _profileImage;
  String? networkImageUrl;
  bool _isNewImage = false;
  final _formKey = GlobalKey<FormState>();

  File? beforeImage;
  File? afterImage;
  XFile? _image;
  bool showAllStatus = false;

  /// ===== CV (same as DoctorProfilePage) =====
  File? cvFile; // mobile
  Uint8List? cvBytes; // web
  String? cvFileName;

  /// ===== Experience =====
  final TextEditingController experienceController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  /// ===== LOAD USER DATA (ADDED) =====
  Future<void> _loadUserData() async {
    final username = await _secureStorage.read(key: 'username');
    final email = await _secureStorage.read(key: 'email');
    final phone = await _secureStorage.read(key: 'phone');
    final imagePath = await _secureStorage.read(key: 'image');

    setState(() {
      usernameController.text = username ?? '';
      emailController.text = email ?? '';
      phoneController.text = phone ?? '';

      if (imagePath != null && imagePath.isNotEmpty) {
        if (imagePath.startsWith('http')) {
          networkImageUrl = imagePath;
        } else {
          _profileImage = XFile(imagePath);
        }
      }
    });
  }

  @override
  void dispose() {
    experienceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final theme = Theme.of(context);

    return MultiBlocListener(
      listeners: [
        BlocListener<UpdatePhotoCubit, UpdatePhotoState>(
          listener: (context, state) {
            if (state.isLoading) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(strings.uploadingPhoto)));
            } else if (state.successMessage != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.successMessage!)));
            } else if (state.errorMessage != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
            }
          },
        ),
        BlocListener<DeletePhotoCubit, DeletePhotoState>(
          listener: (context, state) async {
            if (state.isLoading) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(strings.deletingPhoto)));
            } else if (state.successMessage != null) {
              setState(() {
                _image = null;
                networkImageUrl = null;
              });
              await _secureStorage.delete(key: 'image');
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.successMessage!)));
            }
          },
        ),
      ],
      child: Directionality(
        textDirection: strings.isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,

          /// ================= AppBar =================
          appBar: AppBar(
            backgroundColor: theme.appBarTheme.backgroundColor,
            titleTextStyle: theme.appBarTheme.titleTextStyle,
            leading:
                strings.isArabic
                    ? null
                    : IconButton(
                      icon: Iconarrowleft.arrow(context),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const HomePage()),
                          (_) => false,
                        );
                      },
                    ),
            actions:
                strings.isArabic
                    ? [
                      IconButton(
                        icon: Iconarrowleft.arrow(context),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => const HomePage()),
                            (_) => false,
                          );
                        },
                      ),
                    ]
                    : null,
            title: Text(strings.editProfile),
            centerTitle: true,
          ),

          /// ================= BODY =================
          body: LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth > 900;

              return SingleChildScrollView(
                child: Center(
                  child: Container(
                    width: isDesktop ? 500 : double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        children: [
                          /// ===== PROFILE IMAGE (ADDED – SAME UI) =====
                          Form(
                            key: _formKey,
                            child: _card(
                              context,
                              child: Column(
                                children: [
                                  _buildProfileSection(context, strings),
                                  const SizedBox(height: 20),
                                  Text(
                                    strings.displayName,
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                  const SizedBox(height: 5),
                                  buildTextFieldEdit(
                                    usernameController,
                                    strings.userName,
                                    Icons.person,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    strings.email,
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                  const SizedBox(height: 5),
                                  buildTextFieldEdit(
                                    emailController,
                                    strings.emailOptional,
                                    Icons.email,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    strings.phoneNumber,
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                  const SizedBox(height: 5),
                                  buildTextFieldEdit(
                                    phoneController,
                                    strings.phoneNumber,
                                    Icons.phone,
                                  ),
                                  const SizedBox(height: 20),
                                  buildButtonProfilewithonpressed(
                                    strings.saveEdit,
                                    () => _saveChanges(context, strings),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          /// Upload CV , Experience
                          BlocProvider(
                            create:
                                (_) =>
                                    DoctorProfileCubit(DoctorProfileService()),
                            child: EditCvExperienceSection(),
                          ),

                          /// ================= Upload Status =================
                          _card(
                            context,
                            child: BlocConsumer<
                              DoctorDisplayCaseCubit,
                              DoctorDisplayCaseState
                            >(
                              listener: (context, state) {
                                if (state.errorMessage != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(state.errorMessage!),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                                if (state.successMessage != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(state.successMessage!),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              },
                              builder: (context, state) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      strings.uploadNewStatus,
                                      style: theme.textTheme.bodyLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        _imageBox(
                                          context,
                                          title: strings.photoBefore,
                                          file: beforeImage,
                                          onTap:
                                              () => _pickImage(isBefore: true),
                                        ),
                                        const SizedBox(width: 16),
                                        _imageBox(
                                          context,
                                          title: strings.photoAfter,
                                          file: afterImage,
                                          onTap:
                                              () => _pickImage(isBefore: false),
                                        ),
                                      ],
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 8.0,
                                        bottom: 8,
                                        left: 18,
                                        right: 8,
                                      ),
                                      child: buildButtonProfilewithonpressed(
                                        state.isLoading
                                            ? strings.uploading
                                            : strings.submit,
                                        () {
                                          if (beforeImage == null ||
                                              afterImage == null) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  strings.selectImageFirst,
                                                ),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                            return;
                                          }

                                          context
                                              .read<DoctorDisplayCaseCubit>()
                                              .uploadDisplayCase(
                                                beforeImage: beforeImage!,
                                                afterImage: afterImage!,
                                              );
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(
                                          color: AppColor.darkblue,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(
                                          () => showAllStatus = !showAllStatus,
                                        );
                                        if (showAllStatus) {
                                          context
                                              .read<DoctorDisplayCaseCubit>()
                                              .loadDisplayCases();
                                        }
                                      },
                                      child: Text(
                                        showAllStatus
                                            ? strings.hideAllStatus
                                            : strings.showAllStatus,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColor.darkblue,
                                        ),
                                      ),
                                    ),

                                    if (showAllStatus) ...[
                                      const SizedBox(height: 20),

                                      if (state.isLoading)
                                        Center(
                                          child: CircularProgressIndicator(
                                            color: AppColor.darkblue,
                                          ),
                                        ),

                                      if (!state.isLoading &&
                                          state.cases.isEmpty)
                                        Center(
                                          child: Text(strings.noStatusFound),
                                        ),

                                      if (!state.isLoading &&
                                          state.cases.isNotEmpty)
                                        ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: state.cases.length,
                                          itemBuilder: (context, index) {
                                            return _statusCard(
                                              context,
                                              state.cases[index],
                                              strings,
                                            );
                                          },
                                        ),
                                    ],
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _statusCard(
    BuildContext context,
    DoctorDisplayCaseModel model,
    AppStrings strings,
  ) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          if (theme.brightness == Brightness.light)
            BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "ID: ${model.id}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              TextButton(onPressed: () {}, child: Text(strings.edit)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _networkImage(model.photoBefore),
              const SizedBox(width: 12),
              _networkImage(model.photoAfter),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () => _confirmDelete(model.id, strings),
                  child: Text(strings.deleteStatus),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.darkblue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    context.read<DoctorDisplayCaseCubit>().setFavorite(
                      model.id,
                      model.favoriteFlag == 1 ? 0 : 1,
                    );
                  },
                  child: Text(
                    model.favoriteFlag == 1
                        ? strings.removeFavorite
                        : strings.setAsFavorite,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _networkImage(String url) {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(url, height: 120, fit: BoxFit.cover),
      ),
    );
  }

  void _confirmDelete(int id, AppStrings strings) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(strings.deleteStatus),
            content: Text(strings.confirmDeleteStatus),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(strings.cancel),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  final cubit = context.read<DoctorDisplayCaseCubit>();
                  cubit.deleteCase(id).then((_) {
                    if (showAllStatus) cubit.loadDisplayCases();
                  });
                },
                child: Text(
                  strings.deleteStatus,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  /// ================= PROFILE IMAGE =================
  Widget _buildProfileSection(BuildContext context, AppStrings strings) {
    ImageProvider imageProvider;

    if (_profileImage != null) {
      imageProvider =
          kIsWeb
              ? NetworkImage(_profileImage!.path)
              : FileImage(File(_profileImage!.path));
    } else if (networkImageUrl != null) {
      imageProvider = NetworkImage(networkImageUrl!);
    } else {
      imageProvider = const AssetImage('assets/images/default_profile.png');
    }

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: imageProvider,
              backgroundColor: AppColor.darkblue.withOpacity(0.4),
            ),
            InkWell(
              onTap: _pickProfileImage,
              child: Image.asset(
                'assets/icons/camera-01.png',
                width: 30,
                height: 30,
                color: Colors.white,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => context.read<DeletePhotoCubit>().deletePhoto(),
            ),
            const Icon(Icons.horizontal_rule),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                if (_profileImage != null) {
                  context.read<UpdatePhotoCubit>().updatePhoto(
                    File(_profileImage!.path),
                  );
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _pickProfileImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = image;
        _isNewImage = true;
      });
    }
  }

  /// ================= HELPERS (UNCHANGED) =================
  ///

  Widget _card(BuildContext context, {required Widget child}) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          if (theme.brightness == Brightness.light)
            BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12),
        ],
      ),
      child: child,
    );
  }

  Widget _imageBox(
    BuildContext context, {
    required String title,
    required File? file,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColor.darkblue),
            color: theme.cardColor,
          ),
          child:
              file == null
                  ? Center(child: Text(title))
                  : ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Image.file(file, fit: BoxFit.cover),
                  ),
        ),
      ),
    );
  }

  Future<void> _pickCV() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      setState(() {
        cvFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _pickImage({required bool isBefore}) async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        isBefore
            ? beforeImage = File(image.path)
            : afterImage = File(image.path);
      });
    }
  }

  Future<void> _saveChanges(BuildContext context, AppStrings strings) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    await _secureStorage.write(key: 'username', value: usernameController.text);
    await _secureStorage.write(key: 'email', value: emailController.text);
    await _secureStorage.write(key: 'phone', value: phoneController.text);

    if (_isNewImage && _image != null) {
      await context.read<UpdatePhotoCubit>().updatePhoto(File(_image!.path));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(strings.profileUpdated)));
    }
  }
}
