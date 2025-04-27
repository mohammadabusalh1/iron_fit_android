import 'package:flutter/material.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_theme.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_util.dart';
import 'package:lottie/lottie.dart';

class ProfileImageUploader extends StatelessWidget {
  const ProfileImageUploader({
    super.key,
    required this.uploadedFileUrl,
    required this.isUploading,
    required this.onImageSelected,
  });

  final String uploadedFileUrl;
  final bool isUploading;
  final Function() onImageSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isUploading)
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SizedBox(
                width: 40,
                height: 40,
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
              width: 150,
              height: 150,
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
                image: uploadedFileUrl.isNotEmpty
                    ? DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          uploadedFileUrl,
                        ),
                      )
                    : null,
              ),
              child: uploadedFileUrl.isEmpty
                  ? Lottie.asset(
                      'assets/lottie/profile_placeholder.json',
                      animate: true,
                      repeat: true,
                      options: LottieOptions(enableMergePaths: true),
                    )
                  : null,
            ),
          ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: isUploading ? null : onImageSelected,
          icon: Icon(
            uploadedFileUrl.isEmpty ? Icons.add_photo_alternate : Icons.edit,
            size: 20,
          ),
          label: Text(
            uploadedFileUrl.isEmpty
                ? FFLocalizations.of(context).getText('upload_photo')
                : FFLocalizations.of(context).getText('change_photo'),
            style: AppStyles.textCairo(
              context,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: FlutterFlowTheme.of(context).black.withOpacity(0.8),
            ),
          ),
          style: ElevatedButton.styleFrom(
            foregroundColor: FlutterFlowTheme.of(context).primaryBackground,
            backgroundColor: FlutterFlowTheme.of(context).primary,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
        //         margin: const EdgeInsets.only(top: 16, bottom: 8),
        //         padding:
        //             const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
        //             const Icon(
        //               Icons.check_circle,
        //               color: Colors.green,
        //               size: 20,
        //             ),
        //             const SizedBox(width: 10),
        //             Flexible(
        //               child: Text(
        //                 FFLocalizations.of(context)
        //                     .getText('photo_uploaded_success'),
        //                 style: AppStyles.textCairo(
        //                   context,
        //                   color: FlutterFlowTheme.of(context).primaryText,
        //                   fontSize: 14,
        //                   fontWeight: FontWeight.w500,
        //                 ),
        //               ),
        //             ),
        //             const SizedBox(width: 10),
        //             InkWell(
        //               onTap: () {
        //                 // This would typically dismiss the notification
        //                 // but we're just using it for visual effect
        //               },
        //               child: Icon(
        //                 Icons.close,
        //                 color: FlutterFlowTheme.of(context).secondaryText,
        //                 size: 16,
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
