import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iron_fit/flutter_flow/custom_functions.dart';
import 'package:iron_fit/utils/logger.dart';
import 'package:iron_fit/utils/responsive_utils.dart';
import 'package:lottie/lottie.dart';
import '/backend/firebase_storage/storage.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/upload_data.dart';

class ProfileImageComponent extends StatefulWidget {
  const ProfileImageComponent({
    super.key,
    required this.uploadedFileUrl,
    required this.onImageUploaded,
    required this.onImageChanged,
  });

  final String uploadedFileUrl;
  final Function(String) onImageUploaded;
  final Function() onImageChanged;

  @override
  State<ProfileImageComponent> createState() => _ProfileImageComponentState();
}

class _ProfileImageComponentState extends State<ProfileImageComponent>
    with SingleTickerProviderStateMixin {
  bool _isDataUploading = false;
  String _currentUploadedFileUrl = '';
  bool _isHovering = false;

  // Animation controller for hover effects
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _borderAnimation;

  @override
  void initState() {
    super.initState();
    _currentUploadedFileUrl = widget.uploadedFileUrl;

    // Initialize animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _borderAnimation = Tween<double>(begin: 2.0, end: 3.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ProfileImageComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.uploadedFileUrl != widget.uploadedFileUrl) {
      _currentUploadedFileUrl = widget.uploadedFileUrl;
    }
  }

  Future<void> _handleProfileImageUpload() async {
    if (_isDataUploading) return;

    // Provide haptic feedback
    HapticFeedback.mediumImpact();

    try {
      widget.onImageChanged();
      final selectedMedia = await selectMediaWithSourceBottomSheet(
        context: context,
        allowPhoto: true,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        textColor: FlutterFlowTheme.of(context).primaryText,
        pickerFontFamily: 'Cairo',
      );

      if (selectedMedia != null &&
          selectedMedia
              .every((m) => validateFileFormat(m.storagePath, context))) {
        setState(() => _isDataUploading = true);
        var selectedUploadedFiles = <FFUploadedFile>[];
        var downloadUrls = <String>[];
        try {
          try {
            if (_currentUploadedFileUrl.isNotEmpty) {
              Logger.debug('Attempting to delete previous profile image');
              await FirebaseStorage.instance
                  .refFromURL(_currentUploadedFileUrl)
                  .delete();
              Logger.info('Previous profile image deleted successfully');
            }
          } catch (e, stackTrace) {
            Logger.error(
                'Error deleting previous profile image', e, stackTrace);
          }

          Logger.debug('Processing selected media for upload');
          selectedUploadedFiles = selectedMedia
              .map((m) => FFUploadedFile(
                    name: m.storagePath.split('/').last,
                    bytes: m.bytes,
                    height: m.dimensions?.height,
                    width: m.dimensions?.width,
                    blurHash: m.blurHash,
                  ))
              .toList();

          Logger.debug('Starting upload of profile image');
          downloadUrls = (await Future.wait(
            selectedMedia.map(
              (m) async => await uploadData(m.storagePath, m.bytes),
            ),
          ))
              .where((u) => u != null)
              .map((u) => u!)
              .toList();
          Logger.info('Profile image upload completed successfully');
        } catch (e, stackTrace) {
          Logger.error(
              'Error during profile image upload process', e, stackTrace);
          if (mounted) {
            showErrorDialog(
                '${FFLocalizations.of(context).getText('uploadFailed')}: ${e.toString().substring(0, min(50, e.toString().length))}',
                context);
          }
        } finally {
          setState(() => _isDataUploading = false);
        }
        if (selectedUploadedFiles.length == selectedMedia.length &&
            downloadUrls.length == selectedMedia.length) {
          setState(() {
            _currentUploadedFileUrl = downloadUrls.first;
          });

          widget.onImageUploaded(downloadUrls.first);

          // Show success toast
          if (mounted) {
            showSuccessDialog(
                FFLocalizations.of(context)
                    .getText('image_uploaded_successfully'),
                context);
          }
        } else if (mounted) {
          Logger.warning('Upload completed but with mismatched file counts');
          showErrorDialog(
              FFLocalizations.of(context).getText('uploadIncomplete'), context);
        }
      } else {
        if (selectedMedia != null) {
          Logger.warning('Invalid file format selected for profile image');
          if (mounted) {
            showErrorDialog(
                FFLocalizations.of(context)
                    .getText('invalidFileFormatSelected'),
                context);
          }
        } else {
          Logger.debug('User cancelled media selection');
        }
      }
    } catch (e, stackTrace) {
      Logger.error(
          'Unexpected error in profile image selection', e, stackTrace);
      if (mounted) {
        showErrorDialog(
            '${FFLocalizations.of(context).getText('errorOccurred')}: ${e.toString().substring(0, min(50, e.toString().length))}',
            context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Hero(
          tag: 'profileImage',
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: MouseRegion(
              onEnter: (_) {
                setState(() => _isHovering = true);
                _animationController.forward();
              },
              onExit: (_) {
                setState(() => _isHovering = false);
                _animationController.reverse();
              },
              child: Tooltip(
                message: 'Edit profile photo',
                waitDuration: const Duration(milliseconds: 800),
                child: Container(
                  width: ResponsiveUtils.width(context, 130.0),
                  height: ResponsiveUtils.height(context, 130.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: FlutterFlowTheme.of(context)
                            .primary
                            .withOpacity(0.2),
                        blurRadius: _isHovering 
                            ? ResponsiveUtils.width(context, 15) 
                            : ResponsiveUtils.width(context, 8),
                        spreadRadius: _isHovering ? 2 : 0,
                        offset: Offset(0, _isHovering 
                            ? ResponsiveUtils.height(context, 4) 
                            : ResponsiveUtils.height(context, 2)),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    shape: CircleBorder(
                      side: BorderSide(
                        color: FlutterFlowTheme.of(context)
                            .primary
                            .withOpacity(_isHovering ? 0.6 : 0.4),
                        width: ResponsiveUtils.width(context, _borderAnimation.value),
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Ink(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        splashColor: FlutterFlowTheme.of(context)
                            .primary
                            .withOpacity(0.3),
                        highlightColor: FlutterFlowTheme.of(context)
                            .primary
                            .withOpacity(0.2),
                        onTap: _handleProfileImageUpload,
                        child: _isDataUploading
                            ? Center(
                                child: SizedBox(
                                  width: ResponsiveUtils.width(context, 45),
                                  height: ResponsiveUtils.height(context, 45),
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      FlutterFlowTheme.of(context).primary,
                                    ),
                                    strokeWidth: ResponsiveUtils.width(context, 2),
                                  ),
                                ),
                              )
                            : Stack(
                                fit: StackFit.expand,
                                children: [
                                  // Profile image
                                  ClipOval(
                                    child: _currentUploadedFileUrl.isEmpty
                                        ? Image.asset(
                                            'assets/images/placeholder_user.png',
                                            fit: BoxFit.cover,
                                          )
                                        : CachedNetworkImage(
                                            fadeInDuration: const Duration(
                                                milliseconds: 300),
                                            fadeOutDuration: const Duration(
                                                milliseconds: 300),
                                            imageUrl: _currentUploadedFileUrl,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                Container(
                                              color: FlutterFlowTheme.of(context)
                                                  .alternate
                                                  .withOpacity(0.5),
                                              child: Center(
                                                child: SizedBox(
                                                  width: ResponsiveUtils.width(context, 30),
                                                  height: ResponsiveUtils.height(context, 30),
                                                  child:
                                                      CircularProgressIndicator(
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                            Color>(
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .primary,
                                                    ),
                                                    strokeWidth: ResponsiveUtils.width(context, 2),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) => Icon(
                                              Icons.error_outline_rounded,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              size: ResponsiveUtils.iconSize(context, 40),
                                            ),
                                          ),
                                  ),
                                  // Upload overlay
                                  Positioned.fill(
                                    child: AnimatedOpacity(
                                      opacity: _isHovering ? 0.85 : 0.0,
                                      duration:
                                          const Duration(milliseconds: 200),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              FlutterFlowTheme.of(context)
                                                  .primary
                                                  .withOpacity(0.5),
                                              FlutterFlowTheme.of(context)
                                                  .primary
                                                  .withOpacity(0.7),
                                            ],
                                          ),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.camera_alt_rounded,
                                            color: FlutterFlowTheme.of(context)
                                                .info,
                                            size: ResponsiveUtils.iconSize(context, 36),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Edit indicator
                                  if (!_isHovering)
                                    Positioned(
                                      bottom: ResponsiveUtils.height(context, 0),
                                      right: ResponsiveUtils.width(context, 0),
                                      child: Container(
                                        width: ResponsiveUtils.width(context, 36),
                                        height: ResponsiveUtils.height(context, 36),
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: FlutterFlowTheme.of(context)
                                                  .primaryText
                                                  .withOpacity(0.25),
                                              blurRadius: ResponsiveUtils.width(context, 4),
                                              offset: Offset(0, ResponsiveUtils.height(context, 2)),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.edit_rounded,
                                            color: FlutterFlowTheme.of(context)
                                                .info,
                                            size: ResponsiveUtils.iconSize(context, 18),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
