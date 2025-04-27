// ignore_for_file: constant_identifier_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iron_fit/backend/backend.dart';
import 'package:iron_fit/componants/styles.dart';

import '/flutter_flow/flutter_flow_theme.dart';

class SelectExercise extends StatefulWidget {
  const SelectExercise({super.key});

  @override
  State<SelectExercise> createState() => _SelectExerciseState();
}

class _SelectExerciseState extends State<SelectExercise> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: StreamBuilder(
            stream: queryExercisesRecord(
              queryBuilder: (exercisesRecord) =>
                  exercisesRecord.orderBy('name'),
            ).asStream(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final exercisesRecord = snapshot.data!;
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.all(0.8),
                        itemCount: exercisesRecord.length,
                        itemBuilder: (context, _index) {
                          final exercisesRecord = snapshot.data![_index];
                          if (exercisesRecord.equipment != 'other') {
                            return Container();
                          }
                          return Container(
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).accent1,
                                ),
                                padding: const EdgeInsets.all(8),
                                margin: const EdgeInsets.all(8),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: CachedNetworkImage(
                                        imageUrl: exercisesRecord.gifUrl!,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 24,
                                    ),
                                    Text(
                                      exercisesRecord.name!,
                                      style: AppStyles.textCairo(
                                        context,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 24,
                                    ),
                                    Text(
                                      exercisesRecord.equipment,
                                      style: AppStyles.textCairo(
                                        context,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 24,
                                    ),
                                    Wrap(
                                      alignment: WrapAlignment.center,
                                      spacing: 12,
                                      children: [
                                        TextButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .primary),
                                            ),
                                            onPressed: () {
                                              setState(() {});
                                              exercisesRecord.reference.update(
                                                  {'equipment': 'barbell'});
                                            },
                                            child: const Text(
                                              'barbell',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )),
                                        TextButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .primary),
                                            ),
                                            onPressed: () {
                                              setState(() {});
                                              exercisesRecord.reference.update(
                                                  {'equipment': 'dumbbells'});
                                            },
                                            child: const Text(
                                              'dumbbell',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )),
                                        TextButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .primary),
                                            ),
                                            onPressed: () {
                                              setState(() {});
                                              exercisesRecord.reference.update(
                                                  {'equipment': 'machine'});
                                            },
                                            child: const Text(
                                              'machine',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )),
                                        TextButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .primary),
                                            ),
                                            onPressed: () {
                                              setState(() {});
                                              exercisesRecord.reference.update(
                                                  {'equipment': 'cable'});
                                            },
                                            child: const Text(
                                              'cable',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )),
                                        TextButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .primary),
                                            ),
                                            onPressed: () {
                                              setState(() {});
                                              exercisesRecord.reference.update(
                                                  {'equipment': 'other'});
                                            },
                                            child: const Text(
                                              'other',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )),
                                      ],
                                    )
                                  ],
                                ),
                              ));
                        },
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }
}
