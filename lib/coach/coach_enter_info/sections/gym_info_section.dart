import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_util.dart';
import 'package:iron_fit/widgets/build_text_filed.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '../coach_enter_info_model.dart';
import 'package:provider/provider.dart';
import '../coach_enter_info_widget.dart';

class GymInfoSection extends StatefulWidget {
  final CoachEnterInfoModel model;
  final BuildContext context;
  final int currentSubStage;

  const GymInfoSection({
    super.key,
    required this.model,
    required this.context,
    required this.currentSubStage,
  });

  @override
  State<GymInfoSection> createState() => _GymInfoSectionState();
}

class _GymInfoSectionState extends State<GymInfoSection> {
  @override
  Widget build(BuildContext context) {
    switch (widget.currentSubStage) {
      case 0:
        return _buildBasicGymInfo();
      case 1:
        return _buildLocationInfo();
      case 2:
        return _buildContactInfo();
      case 3:
        return _buildFacilitiesInfo();
      default:
        return const SizedBox();
    }
  }

  Widget _buildBasicGymInfo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            FFLocalizations.of(context).getText('gymBasicInfo'),
            style: AppStyles.textCairo(
              context,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          buildTextField(
            onTap: () {
              // Move cursor to end of text
              widget.model.gymNameController.selection =
                  TextSelection.fromPosition(
                TextPosition(
                    offset: widget.model.gymNameController.text.length),
              );
            },
            context: context,
            controller: widget.model.gymNameController,
            focusNode: widget.model.gymNameFocusNode,
            labelText: FFLocalizations.of(context).getText('gymName'),
            hintText: FFLocalizations.of(context).getText('enterGymName'),
            prefixIcon: Icons.fitness_center,
            validator: (value) =>
                value?.isEmpty ?? true ? 'Field is required' : null,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) {
              FocusScope.of(context)
                  .requestFocus(widget.model.gymWebsiteFocusNode);
            },
          ),
          const SizedBox(height: 16),
          buildTextField(
            onTap: () {
              // Move cursor to end of text
              widget.model.gymWebsiteController.selection =
                  TextSelection.fromPosition(
                TextPosition(
                    offset: widget.model.gymWebsiteController.text.length),
              );
            },
            context: context,
            controller: widget.model.gymWebsiteController,
            focusNode: widget.model.gymWebsiteFocusNode,
            labelText: FFLocalizations.of(context).getText('gymWebsite'),
            hintText: FFLocalizations.of(context).getText('enterGymWebsite'),
            prefixIcon: Icons.web,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) {
              widget.model.gymWebsiteFocusNode.unfocus();
              Provider.of<CoachInfoState>(context, listen: false)
                  .onFieldSubmitted(context);
            },
          ),
          // const SizedBox(height: 16),
          // FFButtonWidget(
          //   onPressed: () {},
          //   text: FFLocalizations.of(context).getText('uploadGymPhotos'),
          //   options: FFButtonOptions(
          //     width: double.infinity,
          //     height: 50,
          //     color: FlutterFlowTheme.of(context).primary,
          //     textStyle: AppStyles.textCairo(
          //       context,
          //       color: Colors.white,
          //       fontWeight: FontWeight.w600,
          //     ),
          //     elevation: 2,
          //     borderRadius: BorderRadius.circular(8),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildLocationInfo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            FFLocalizations.of(context).getText('gymLocation'),
            style: AppStyles.textCairo(
              context,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          buildTextField(
            maxLines: 1,
            context: context,
            onTap: () {
              // Move cursor to end of text
              widget.model.gymCountryController.selection =
                  TextSelection.fromPosition(
                TextPosition(
                    offset: widget.model.gymCountryController.text.length),
              );
            },
            controller: widget.model.gymCountryController,
            focusNode: widget.model.gymCountryFocusNode,
            labelText: FFLocalizations.of(context).getText('country'),
            hintText: FFLocalizations.of(context).getText('enterCountry'),
            prefixIcon: Icons.location_city,
            validator: (value) =>
                value?.isEmpty ?? true ? 'Field is required' : null,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) {
              FocusScope.of(context)
                  .requestFocus(widget.model.gymCityFocusNode);
            },
          ),
          const SizedBox(height: 16),
          buildTextField(
            context: context,
            onTap: () {
              // Move cursor to end of text
              widget.model.gymCityController.selection =
                  TextSelection.fromPosition(
                TextPosition(
                    offset: widget.model.gymCityController.text.length),
              );
            },
            controller: widget.model.gymCityController,
            focusNode: widget.model.gymCityFocusNode,
            labelText: FFLocalizations.of(context).getText('city'),
            hintText: FFLocalizations.of(context).getText('enterCity'),
            prefixIcon: Icons.location_city,
            validator: (value) =>
                value?.isEmpty ?? true ? 'Field is required' : null,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) {
              FocusScope.of(context)
                  .requestFocus(widget.model.gymAddressFocusNode);
            },
          ),
          const SizedBox(height: 16),
          buildTextField(
            context: context,
            onTap: () {
              // Move cursor to end of text
              widget.model.gymAddressController.selection =
                  TextSelection.fromPosition(
                TextPosition(
                    offset: widget.model.gymAddressController.text.length),
              );
            },
            controller: widget.model.gymAddressController,
            focusNode: widget.model.gymAddressFocusNode,
            labelText: FFLocalizations.of(context).getText('address'),
            hintText: FFLocalizations.of(context).getText('enterAddress'),
            prefixIcon: Icons.location_on,
            validator: (value) =>
                value?.isEmpty ?? true ? 'Field is required' : null,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) {
              widget.model.gymAddressFocusNode.unfocus();
              Provider.of<CoachInfoState>(context, listen: false)
                  .onFieldSubmitted(context);
            },
          ),
          const SizedBox(height: 16),
          // Container(
          //   height: 200,
          //   decoration: BoxDecoration(
          //     border: Border.all(color: FlutterFlowTheme.of(context).primary),
          //     borderRadius: BorderRadius.circular(8),
          //   ),
          //   child: gmaps.GoogleMap(
          //     initialCameraPosition: const gmaps.CameraPosition(
          //       target: gmaps.LatLng(0, 0),
          //       zoom: 2,
          //     ),
          //     onTap: (gmaps.LatLng position) {
          //       // Handle map location selection
          //       widget.model.gymLocation = position;
          //     },
          //     markers: widget.model.gymLocation != null
          //         ? {
          //             gmaps.Marker(
          //               markerId: const gmaps.MarkerId('gym'),
          //               position: widget.model.gymLocation!,
          //             ),
          //           }
          //         : {},
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildContactInfo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            FFLocalizations.of(context).getText('gymContact'),
            style: AppStyles.textCairo(
              context,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          buildTextField(
            keyboardType: TextInputType.phone,
            context: context,
            onTap: () {
              // Move cursor to end of text
              widget.model.gymPhoneController.selection =
                  TextSelection.fromPosition(
                TextPosition(
                    offset: widget.model.gymPhoneController.text.length),
              );
            },
            controller: widget.model.gymPhoneController,
            focusNode: widget.model.gymPhoneFocusNode,
            labelText: FFLocalizations.of(context).getText('phoneNumber'),
            hintText: FFLocalizations.of(context).getText('enterPhoneNumber'),
            prefixIcon: Icons.phone,
            validator: (value) =>
                value?.isEmpty ?? true ? 'Field is required' : null,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) {
              FocusScope.of(context)
                  .requestFocus(widget.model.gymEmailFocusNode);
            },
          ),
          const SizedBox(height: 16),
          buildTextField(
            keyboardType: TextInputType.emailAddress,
            context: context,
            onTap: () {
              // Move cursor to end of text
              widget.model.gymEmailController.selection =
                  TextSelection.fromPosition(
                TextPosition(
                    offset: widget.model.gymEmailController.text.length),
              );
            },
            controller: widget.model.gymEmailController,
            focusNode: widget.model.gymEmailFocusNode,
            labelText: FFLocalizations.of(context).getText('email'),
            hintText: FFLocalizations.of(context).getText('enterEmail'),
            prefixIcon: Icons.email,
            validator: (value) =>
                value?.isEmpty ?? true ? 'Field is required' : null,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) {
              FocusScope.of(context)
                  .requestFocus(widget.model.gymInstagramFocusNode);
            },
          ),
          const SizedBox(height: 16),
          // Social Media Links
          buildTextField(
            context: context,
            onTap: () {
              // Move cursor to end of text
              widget.model.gymInstagramController.selection =
                  TextSelection.fromPosition(
                TextPosition(
                    offset: widget.model.gymInstagramController.text.length),
              );
            },
            controller: widget.model.gymInstagramController,
            focusNode: widget.model.gymInstagramFocusNode,
            labelText: 'Instagram',
            hintText: FFLocalizations.of(context).getText('enterInstagram'),
            prefixIcon: Icons.web,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) {
              FocusScope.of(context)
                  .requestFocus(widget.model.gymFacebookFocusNode);
            },
          ),
          const SizedBox(height: 16),
          buildTextField(
            context: context,
            onTap: () {
              // Move cursor to end of text
              widget.model.gymFacebookController.selection =
                  TextSelection.fromPosition(
                TextPosition(
                    offset: widget.model.gymFacebookController.text.length),
              );
            },
            controller: widget.model.gymFacebookController,
            focusNode: widget.model.gymFacebookFocusNode,
            labelText: 'Facebook',
            hintText: FFLocalizations.of(context).getText('enterFacebook'),
            prefixIcon: Icons.web,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) {
              widget.model.gymFacebookFocusNode.unfocus();
              Provider.of<CoachInfoState>(context, listen: false)
                  .onFieldSubmitted(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFacilitiesInfo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            FFLocalizations.of(context).getText('gymFacilities'),
            style: AppStyles.textCairo(
              context,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildFacilityChip(
                  FFLocalizations.of(context).getText('cardioEquipment')),
              _buildFacilityChip(
                  FFLocalizations.of(context).getText('weightTraining')),
              _buildFacilityChip(
                  FFLocalizations.of(context).getText('personalTraining')),
              _buildFacilityChip(
                  FFLocalizations.of(context).getText('groupClasses')),
              _buildFacilityChip(
                  FFLocalizations.of(context).getText('swimmingPool')),
              _buildFacilityChip(FFLocalizations.of(context).getText('sauna')),
              _buildFacilityChip(
                  FFLocalizations.of(context).getText('lockerRooms')),
              _buildFacilityChip(
                  FFLocalizations.of(context).getText('parking')),
              _buildFacilityChip(FFLocalizations.of(context).getText('wifi')),
              _buildFacilityChip(FFLocalizations.of(context).getText('cafe')),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            FFLocalizations.of(context).getText('workingHours'),
            style: AppStyles.textCairo(
              context,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildWorkingHoursField(
              FFLocalizations.of(context).getText('duazsqnb'), 'Monday'),
          _buildWorkingHoursField(
              FFLocalizations.of(context).getText('o89upwj1'), 'Tuesday'),
          _buildWorkingHoursField(
              FFLocalizations.of(context).getText('6g27x925'), 'Wednesday'),
          _buildWorkingHoursField(
              FFLocalizations.of(context).getText('yq96r5o7'), 'Thursday'),
          _buildWorkingHoursField(
              FFLocalizations.of(context).getText('ap0v00n3'), 'Friday'),
          _buildWorkingHoursField(
              FFLocalizations.of(context).getText('0w2atzto'), 'Saturday'),
          _buildWorkingHoursField(
              FFLocalizations.of(context).getText('56cey9g0'), 'Sunday'),
        ],
      ),
    );
  }

  Widget _buildFacilityChip(String facility) {
    final isSelected = widget.model.selectedFacilities.contains(facility);
    return FilterChip(
      selected: isSelected,
      label: Text(facility),
      onSelected: (bool selected) {
        if (selected) {
          setState(() {
            widget.model.selectedFacilities.add(facility);
          });
        } else {
          setState(() {
            widget.model.selectedFacilities.remove(facility);
          });
        }
      },
      selectedColor: FlutterFlowTheme.of(context).primary.withOpacity(0.2),
      checkmarkColor: FlutterFlowTheme.of(context).primary,
    );
  }

  Widget _buildWorkingHoursField(String day, String engDay) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: FlutterFlowTheme.of(context).primaryText.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // Move cursor to end of text when tapped
            final controller = widget.model.workingHoursControllers[engDay];
            if (controller != null) {
              controller.selection = TextSelection.fromPosition(
                TextPosition(offset: controller.text.length),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color:
                        FlutterFlowTheme.of(context).primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.access_time_rounded,
                      color: FlutterFlowTheme.of(context).primary,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        day,
                        style: AppStyles.textCairo(
                          context,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: FlutterFlowTheme.of(context).primaryText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      TextFormField(
                        controller:
                            widget.model.workingHoursControllers[engDay],
                        style: AppStyles.textCairo(
                          context,
                          fontSize: 14,
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: FlutterFlowTheme.of(context).secondary,
                          hintText: FFLocalizations.of(context)
                              .getText('workingHoursHint'),
                          hintStyle: AppStyles.textCairo(
                            context,
                            fontSize: 14,
                            color: FlutterFlowTheme.of(context)
                                .secondaryText
                                .withOpacity(0.5),
                          ),
                          contentPadding: const EdgeInsets.all(4),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
