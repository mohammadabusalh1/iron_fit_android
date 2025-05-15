import 'package:flutter/material.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_theme.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_util.dart';
import 'package:iron_fit/utils/responsive_utils.dart';
import 'package:lottie/lottie.dart';
import 'dart:typed_data';

class ProfileImageUploader extends StatelessWidget {
  const ProfileImageUploader({
    super.key,
    required this.uploadedFileUrl,
    required this.isUploading,
    required this.onImageSelected,
    this.localImageBytes,
  });

  final String uploadedFileUrl;
  final bool isUploading;
  final Function() onImageSelected;
  final Uint8List? localImageBytes;

  @override
  Widget build(BuildContext context) {
    // Determine if we have an image to display (either local or remote)
    final bool hasImage =
        uploadedFileUrl.isNotEmpty || localImageBytes?.length != 0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isUploading)
          Container(
            width: ResponsiveUtils.width(context, 150),
            height: ResponsiveUtils.width(context, 150),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SizedBox(
                width: ResponsiveUtils.width(context, 40),
                height: ResponsiveUtils.width(context, 40),
                child: CircularProgressIndicator(
                  color: FlutterFlowTheme.of(context).primary,
                  strokeWidth: 3,
                ),
              ),
            ),
          )
        else
          GestureDetector(
            onTap: onImageSelected,
            child: Container(
              width: ResponsiveUtils.width(context, 150),
              height: ResponsiveUtils.width(context, 150),
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    color: Colors.grey.withOpacity(0.3),
                    offset: const Offset(0, 5),
                  )
                ],
                border: Border.all(
                  color: FlutterFlowTheme.of(context).primary.withOpacity(0.2),
                  width: 4,
                ),
                image: hasImage
                    ? (localImageBytes != null
                        ? DecorationImage(
                            fit: BoxFit.cover,
                            image: MemoryImage(localImageBytes!),
                          )
                        : DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(uploadedFileUrl),
                          ))
                    : null,
              ),
              child: !hasImage
                  ? Lottie.asset(
                      'assets/lottie/profile_placeholder.json',
                      animate: true,
                      repeat: true,
                      options: LottieOptions(enableMergePaths: true),
                    )
                  : null,
            ),
          ),
        SizedBox(height: ResponsiveUtils.height(context, 16)),
        ElevatedButton.icon(
          onPressed: isUploading ? null : onImageSelected,
          icon: Icon(
            !hasImage ? Icons.add_photo_alternate : Icons.edit,
            size: ResponsiveUtils.iconSize(context, 20),
          ),
          label: Text(
            !hasImage
                ? FFLocalizations.of(context).getText('upload_photo')
                : FFLocalizations.of(context).getText('change_photo'),
            style: AppStyles.textCairo(
              context,
              fontSize: ResponsiveUtils.fontSize(context, 14),
              fontWeight: FontWeight.w700,
              color: FlutterFlowTheme.of(context).black.withOpacity(0.8),
            ),
          ),
          style: ElevatedButton.styleFrom(
            foregroundColor: FlutterFlowTheme.of(context).primaryBackground,
            backgroundColor: FlutterFlowTheme.of(context).primary,
            padding:
                ResponsiveUtils.padding(context, horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
          ),
        ),
        // if (uploadedFileUrl.isNotEmpty)
        //   Align(
        //     alignment: Alignment.bottomCenter,
        //     child: AnimatedSlide(
        //       offset: const Offset(0, 0),
        //       duration: const Duration(milliseconds: 400),
        //       curve: Curves.easeOutCubic,
        //       child: Container(
        //         margin: EdgeInsets.only(
        //           top: ResponsiveUtils.height(context, 16),
        //           bottom: ResponsiveUtils.height(context, 8)
        //         ),
        //         padding: ResponsiveUtils.padding(
        //           context,
        //           horizontal: 16,
        //           vertical: 12
        //         ),
        //         decoration: BoxDecoration(
        //           color: FlutterFlowTheme.of(context).primaryBackground,
        //           borderRadius: BorderRadius.circular(12),
        //           boxShadow: [
        //             BoxShadow(
        //               color: Colors.black.withOpacity(0.1),
        //               blurRadius: 8,
        //               offset: const Offset(0, 4),
        //             ),
        //           ],
        //           border: Border.all(
        //             color: Colors.green.withOpacity(0.3),
        //             width: 1,
        //           ),
        //         ),
        //         child: Row(
        //           mainAxisSize: MainAxisSize.min,
        //           children: [
        //             Icon(
        //               Icons.check_circle,
        //               color: Colors.green,
        //               size: ResponsiveUtils.iconSize(context, 20),
        //             ),
        //             SizedBox(width: ResponsiveUtils.width(context, 10)),
        //             Flexible(
        //               child: Text(
        //                 FFLocalizations.of(context)
        //                     .getText('photo_uploaded_success'),
        //                 style: AppStyles.textCairo(
        //                   context,
        //                   color: FlutterFlowTheme.of(context).primaryText,
        //                   fontSize: ResponsiveUtils.fontSize(context, 14),
        //                   fontWeight: FontWeight.w500,
        //                 ),
        //               ),
        //             ),
        //             SizedBox(width: ResponsiveUtils.width(context, 10)),
        //             InkWell(
        //               onTap: () {
        //                 // This would typically dismiss the notification
        //                 // but we're just using it for visual effect
        //               },
        //               child: Icon(
        //                 Icons.close,
        //                 color: FlutterFlowTheme.of(context).secondaryText,
        //                 size: ResponsiveUtils.iconSize(context, 16),
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //     ),
        //   ),
      ],
    );
  }
}
