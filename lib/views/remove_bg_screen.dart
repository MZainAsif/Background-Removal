// ignore_for_file: deprecated_member_use, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screenshot/screenshot.dart';
import '../components/choose_image.dart';
import '../components/primary_button.dart';
import '../components/snackbar.dart';
import '../controllers/remove_bg_controller.dart';

class RemoveBackroundScreen extends StatelessWidget {
  const RemoveBackroundScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          elevation: 0,
          leading: const Icon(Icons.sort),
          centerTitle: true,
          title: Text(
            'Remove Background',
            style: GoogleFonts.aBeeZee(
              fontSize: 22,
              color: Colors.white,
            ),
          ),
        ),
        body: Center(
          child: GetBuilder<RemoveBgController>(
              init: RemoveBgController(),
              builder: (controller) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    (controller.imageFile != null)
                        ? Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Screenshot(
                                  controller: controller.controller,
                                  child: Image.memory(
                                    controller.imageFile!,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 40),
                              controller.isLoading.value
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : ReusablePrimaryButton(
                                      childText: "Remove Background",
                                      textColor: Colors.white,
                                      buttonColor: Colors.deepPurpleAccent,
                                      onPressed: () async {
                                        if (controller.imageFile == null) {
                                          showSnackBar("Error",
                                              "Please select an image", true);
                                        } else {
                                          controller.imageFile =
                                              await RemoveBgController()
                                                  .removeBg(
                                                      controller.imagePath!);
                                          print("Success");
                                          showSnackBar("Success",
                                            "Removed successfully", false,);
                                        }
                                        controller.update();
                                      }),
                              const SizedBox(height: 20),
                              ReusablePrimaryButton(
                                  childText: "Save Image",
                                  textColor: Colors.white,
                                  buttonColor: Colors.deepPurpleAccent,
                                  onPressed: () async {
                                    if (controller.imageFile != null) {
                                      controller.saveImage();
                                     // Fluttertoast.showToast(msg: 'Save Successfully');

                                      showSnackBar("Success",
                                          "Image saved successfully", false,);
                                    } else {
                                      showSnackBar("Error",
                                          "Please select an image", true);
                                    }
                                  }),
                              const SizedBox(height: 20),
                              ReusablePrimaryButton(
                                  childText: "Add New Image",
                                  textColor: Colors.white,
                                  buttonColor: Colors.deepPurpleAccent,
                                  onPressed: () async {
                                    controller.cleanUp();
                                  }),
                            ],
                          )
                        : Column(
                            children: [
                              Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Colors.deepPurpleAccent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.image,
                                  size: 100,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 40),
                              ReusablePrimaryButton(
                                  childText: "Select Image",
                                  textColor: Colors.white,
                                  buttonColor: Colors.deepPurpleAccent,
                                  onPressed: () async {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return bottomSheet(
                                              controller, context);
                                        });
                                  }),
                            ],
                          ),
                  ],
                );
              }),
        ));
  }
}
