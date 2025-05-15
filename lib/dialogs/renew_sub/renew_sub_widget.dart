import 'package:flutter/services.dart';
import 'package:iron_fit/componants/styles.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'renew_sub_model.dart';
export 'renew_sub_model.dart';
import '/utils/logger.dart';
import '/utils/responsive_utils.dart';

class RenewSubWidget extends StatefulWidget {
  const RenewSubWidget({
    super.key,
    required this.subRef,
    required this.refreshSubscription,
  });

  final DocumentReference? subRef;
  final VoidCallback refreshSubscription;
  @override
  State<RenewSubWidget> createState() => _RenewSubWidgetState();
}

class _RenewSubWidgetState extends State<RenewSubWidget> {
  late RenewSubModel _model;
  final _formKey = GlobalKey<FormState>();
  final _containerDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(16.0),
    border: Border.all(
      width: 1.0,
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RenewSubModel());
    _initializeControllers();
  }

  void _initializeControllers() {
    _model.paidTextController ??= TextEditingController();
    _model.paidFocusNode ??= FocusNode();
    _model.deptsTextController ??= TextEditingController();
    _model.deptsFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: FlutterFlowTheme.of(context).error,
              size: ResponsiveUtils.iconSize(context, 24),
            ),
            SizedBox(width: ResponsiveUtils.width(context, 8)),
            Text(
              FFLocalizations.of(context).getText('error'),
              style: AppStyles.textCairo(
                context,
                fontSize: ResponsiveUtils.fontSize(context, 16),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: AppStyles.textCairo(
            context,
            fontSize: ResponsiveUtils.fontSize(context, 14),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              FFLocalizations.of(context).getText('ok'),
              style: AppStyles.textCairo(
                context,
                fontSize: ResponsiveUtils.fontSize(context, 14),
                color: FlutterFlowTheme.of(context).primary,
              ),
            ),
          ),
        ],
      ),
    ).then((_) {
      // Dialog is closed, no need to animate
    });
  }

  String _generateBillId() {
    return '${DateTime.now().millisecondsSinceEpoch}_${UniqueKey().toString()}';
  }

  Future<void> _handleRenewSubscription() async {
    try {
      if (!_formKey.currentState!.validate() ||
          _model.startDate == null ||
          _model.endDate == null) {
        _showErrorDialog(FFLocalizations.of(context).getText(
            'pleaseFillAllRequiredFields' /* Please fill all required fields */));
        return;
      }

      if (DateTime.parse(_model.startDate!.text)
          .isAfter(DateTime.parse(_model.endDate!.text))) {
        _showErrorDialog(FFLocalizations.of(context).getText(
            'error_start_before_end' /* Start date must be before end date */));
        return;
      }

      final paidAmount =
          double.parse(_model.paidTextController.text.replaceAll(',', ''));
      final debtsAmount =
          double.parse(_model.deptsTextController.text.replaceAll(',', ''));

      final newBill = {
        'id': _generateBillId(),
        'date': DateTime.now(),
        'paid': paidAmount,
      };

      final newDebt = {
        'id': _generateBillId(),
        'name': FFLocalizations.of(context).getText('first_debt'),
        'date': DateTime.now(),
        'debt': debtsAmount,
        'type': '+',
      };

      if (paidAmount == 0) {
        await widget.subRef!.update({
          ...createSubscriptionsRecordData(
            startDate: DateTime.parse(_model.startDate!.text),
            endDate: DateTime.parse(_model.endDate!.text),
          ),
          ...mapToFirestore(
            {
              'debts': FieldValue.increment(debtsAmount),
              'totalPaid': FieldValue.increment(0),
              'bills': FieldValue.arrayUnion([newBill]),
              'debtList': FieldValue.arrayUnion([newDebt]),
            },
          ),
        });
      } else {
        await widget.subRef!.update({
          ...createSubscriptionsRecordData(
            amountPaid: paidAmount.toDouble(),
            startDate: DateTime.parse(_model.startDate!.text),
            endDate: DateTime.parse(_model.endDate!.text),
          ),
          ...mapToFirestore(
            {
              'debts': FieldValue.increment(debtsAmount),
              'totalPaid': FieldValue.increment(paidAmount),
              'bills': FieldValue.arrayUnion([newBill]),
              'debtList': FieldValue.arrayUnion([newDebt]),
            },
          ),
        });
      }
      widget.refreshSubscription();
      if (mounted) {
        context.safePop();
      }
    } catch (e, s) {
      Logger.error('Error renewing subscription: $e', error: e, stackTrace: s);
      _showErrorDialog(
          FFLocalizations.of(context).getText('error_renewing_subscription'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Container(
          width: double.infinity,
          decoration: _containerDecoration.copyWith(
            color: theme.secondaryBackground,
            border: Border.all(color: theme.alternate),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              ResponsiveUtils.width(context, 16.0),
              ResponsiveUtils.height(context, 40),
              ResponsiveUtils.width(context, 16.0),
              MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(context),
                SizedBox(height: ResponsiveUtils.height(context, 24)),
                TextFormField(
                  controller: _model.startDate,
                  focusNode: _model.startDateFocusNode,
                  readOnly: true,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: FFLocalizations.of(context).getText('1qacacys'),
                    labelStyle: FlutterFlowTheme.of(context).labelMedium,
                    hintText:
                        FFLocalizations.of(context).getText('dateOfBirth_hint'),
                    hintStyle: FlutterFlowTheme.of(context).labelMedium,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).alternate,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).primary,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).error,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).error,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                    contentPadding: EdgeInsetsDirectional.fromSTEB(
                      ResponsiveUtils.width(context, 16),
                      ResponsiveUtils.height(context, 24),
                      ResponsiveUtils.width(context, 16),
                      ResponsiveUtils.height(context, 24),
                    ),
                    prefixIcon: Icon(
                      Icons.calendar_today,
                      color: FlutterFlowTheme.of(context).secondaryText,
                      size: ResponsiveUtils.iconSize(context, 24),
                    ),
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return FFLocalizations.of(context)
                          .getText('dateOfBirth_required');
                    }
                    return null;
                  },
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                      builder: (context, child) {
                        return Theme(
                          data: ThemeData.dark().copyWith(
                            colorScheme: ColorScheme.fromSeed(
                                seedColor:
                                    FlutterFlowTheme.of(context).primary),
                            textTheme: TextTheme(
                              bodyMedium:
                                  FlutterFlowTheme.of(context).bodyMedium,
                            ),
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                textStyle: AppStyles.textCairo(context,
                                    fontSize:
                                        ResponsiveUtils.fontSize(context, 16),
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (date != null) {
                      setState(() {
                        _model.startDate!.text =
                            date.toIso8601String().split('T')[0];
                      });
                    }
                  },
                ).animate().fadeIn(delay: 100.ms).slideX(
                      begin: -0.2,
                      end: 0,
                      duration: 300.ms,
                      curve: Curves.easeOutBack,
                    ),
                SizedBox(height: ResponsiveUtils.height(context, 16)),
                TextFormField(
                  controller: _model.endDate,
                  focusNode: _model.endDateFocusNode,
                  readOnly: true,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: FFLocalizations.of(context).getText('r448i96u'),
                    labelStyle: FlutterFlowTheme.of(context).labelMedium,
                    hintText:
                        FFLocalizations.of(context).getText('dateOfBirth_hint'),
                    hintStyle: FlutterFlowTheme.of(context).labelMedium,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).alternate,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).primary,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).error,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).error,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                    contentPadding: EdgeInsetsDirectional.fromSTEB(
                      ResponsiveUtils.width(context, 16),
                      ResponsiveUtils.height(context, 24),
                      ResponsiveUtils.width(context, 16),
                      ResponsiveUtils.height(context, 24),
                    ),
                    prefixIcon: Icon(
                      Icons.calendar_today,
                      color: FlutterFlowTheme.of(context).secondaryText,
                      size: ResponsiveUtils.iconSize(context, 24),
                    ),
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return FFLocalizations.of(context)
                          .getText('dateOfBirth_required');
                    }
                    return null;
                  },
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                      builder: (context, child) {
                        return Theme(
                          data: ThemeData.dark().copyWith(
                            colorScheme: ColorScheme.fromSeed(
                                seedColor:
                                    FlutterFlowTheme.of(context).primary),
                            textTheme: TextTheme(
                              bodyMedium:
                                  FlutterFlowTheme.of(context).bodyMedium,
                            ),
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                textStyle: AppStyles.textCairo(context,
                                    fontSize:
                                        ResponsiveUtils.fontSize(context, 16),
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (date != null) {
                      setState(() {
                        _model.endDate!.text =
                            date.toIso8601String().split('T')[0];
                      });
                    }
                  },
                ).animate().fadeIn(delay: 200.ms).slideX(
                      begin: -0.2,
                      end: 0,
                      duration: 300.ms,
                      curve: Curves.easeOutBack,
                    ),
                SizedBox(height: ResponsiveUtils.height(context, 16)),
                _buildAmountPaidField(context)
                    .animate()
                    .fadeIn(delay: 300.ms)
                    .slideX(
                      begin: -0.2,
                      end: 0,
                      duration: 300.ms,
                      curve: Curves.easeOutBack,
                    ),
                SizedBox(height: ResponsiveUtils.height(context, 16)),
                _buildDebtsField(context)
                    .animate()
                    .fadeIn(delay: 400.ms)
                    .slideX(
                      begin: -0.2,
                      end: 0,
                      duration: 300.ms,
                      curve: Curves.easeOutBack,
                    ),
                SizedBox(height: ResponsiveUtils.height(context, 24)),
                _buildRenewButton(context)
                    .animate()
                    .fadeIn(delay: 500.ms)
                    .slideY(
                      begin: 0.2,
                      end: 0,
                      duration: 300.ms,
                      curve: Curves.easeOutBack,
                    ),
                SizedBox(height: ResponsiveUtils.height(context, 24)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(ResponsiveUtils.width(context, 8)),
              decoration: BoxDecoration(
                color: theme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.workspace_premium,
                color: theme.primary,
                size: ResponsiveUtils.iconSize(context, 24),
              ),
            ),
            SizedBox(width: ResponsiveUtils.width(context, 12)),
            Text(
              FFLocalizations.of(context).getText('d34tbdlp'),
              style: AppStyles.textCairo(
                context,
                fontSize: ResponsiveUtils.fontSize(context, 20),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        IconButton(
          icon: Icon(
            Icons.close,
            color: theme.secondaryText,
            size: ResponsiveUtils.iconSize(context, 24),
          ),
          onPressed: () => Navigator.pop(context),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          splashRadius: ResponsiveUtils.width(context, 24),
        ),
      ],
    );
  }

  Widget _buildAmountPaidField(BuildContext context) {
    return _FormField(
      context: context,
      label: FFLocalizations.of(context).getText('52ckancw'),
      child: _CustomTextField(
        controller: _model.paidTextController!,
        focusNode: _model.paidFocusNode!,
        icon: Icons.attach_money,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return FFLocalizations.of(context).getText('thisFieldIsRequired');
          }
          if (double.tryParse(value) == null) {
            return FFLocalizations.of(context)
                .getText('pleaseEnterAValidNumber');
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDebtsField(BuildContext context) {
    return _FormField(
      context: context,
      label: FFLocalizations.of(context).getText('mi6j1k95'),
      child: _CustomTextField(
        controller: _model.deptsTextController!,
        focusNode: _model.deptsFocusNode!,
        icon: Icons.money_off,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return FFLocalizations.of(context).getText('thisFieldIsRequired');
          }
          if (double.tryParse(value) == null) {
            return FFLocalizations.of(context)
                .getText('pleaseEnterAValidNumber');
          }
          return null;
        },
      ),
    );
  }

  Widget _buildRenewButton(BuildContext context) {
    return FFButtonWidget(
      onPressed: _handleRenewSubscription,
      text: FFLocalizations.of(context).getText('ivengb0e'),
      options: FFButtonOptions(
        width: double.infinity,
        height: ResponsiveUtils.height(context, 56.0),
        padding: EdgeInsets.zero,
        color: FlutterFlowTheme.of(context).primary,
        textStyle: AppStyles.textCairo(
          context,
          fontSize: ResponsiveUtils.fontSize(context, 16),
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        elevation: 0.0,
        borderSide: const BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(12.0),
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  const _FormField({
    required this.context,
    required this.label,
    required this.child,
  });

  final BuildContext context;
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: theme.alternate,
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.alternate.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(ResponsiveUtils.width(context, 16.0)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  label,
                  style: AppStyles.textCairo(
                    context,
                    fontSize: ResponsiveUtils.fontSize(context, 14),
                    fontWeight: FontWeight.w600,
                    color: theme.primaryText.withOpacity(0.9),
                  ),
                ),
                SizedBox(width: ResponsiveUtils.width(context, 4)),
                Container(
                  width: ResponsiveUtils.width(context, 4),
                  height: ResponsiveUtils.width(context, 4),
                  decoration: BoxDecoration(
                    color: theme.primary.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveUtils.height(context, 12)),
            child,
          ],
        ),
      ),
    );
  }
}

class _CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final IconData icon;
  final String? Function(String?)? validator;

  const _CustomTextField({
    required this.controller,
    required this.focusNode,
    required this.icon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return TextFormField(
      onTap: () {
        controller.selection = TextSelection.fromPosition(
          TextPosition(offset: controller.text.length),
        );
      },
      controller: controller,
      focusNode: focusNode,
      style: AppStyles.textCairo(
        context,
        fontSize: ResponsiveUtils.fontSize(context, 16),
        color: theme.primaryText,
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: validator,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
        TextInputFormatter.withFunction((oldValue, newValue) {
          if (newValue.text.isEmpty) return newValue;

          if (newValue.text.endsWith('.')) return newValue;

          try {
            final number = double.parse(newValue.text);
            final formatted = NumberFormat('#,##0.##').format(number);

            final selectionIndex = newValue.selection.end +
                (formatted.length - newValue.text.length);

            return TextEditingValue(
              text: formatted,
              selection: TextSelection.collapsed(
                offset: selectionIndex.clamp(0, formatted.length),
              ),
            );
          } catch (e) {
            return oldValue;
          }
        }),
      ],
      textAlign: TextAlign.right,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        hintStyle: AppStyles.textCairo(
          context,
          color: theme.secondaryText.withOpacity(0.7),
          fontSize: ResponsiveUtils.fontSize(context, 16),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: theme.alternate,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: theme.primary,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: theme.error,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: theme.error,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        filled: true,
        fillColor: theme.secondaryBackground,
        prefixText: '\$ ',
        prefixStyle: AppStyles.textCairo(
          context,
          fontSize: ResponsiveUtils.fontSize(context, 16),
          color: theme.primaryText,
          fontWeight: FontWeight.w600,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.width(context, 16.0),
          vertical: ResponsiveUtils.height(context, 16.0),
        ),
        suffixIcon: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: Icon(
            icon,
            color: focusNode.hasFocus
                ? theme.primary
                : theme.secondaryText.withOpacity(0.7),
            size: ResponsiveUtils.iconSize(context, 20),
          ),
        ),
      ),
    );
  }
}
