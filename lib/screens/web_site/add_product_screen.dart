import 'dart:io';

import 'package:eco_buy/custom_widgets/ecobutton.dart';
import 'package:eco_buy/custom_widgets/ecotextfield.dart';
import 'package:eco_buy/models/category_model.dart';
import 'package:eco_buy/models/product_model.dart';
import 'package:eco_buy/utils/styles.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
//import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

String? urls;

// ignore: must_be_immutable
class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});
  static const String id = "addproduct";
  // ignore: non_constant_identifier_names

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  TextEditingController categoryC = TextEditingController();
  TextEditingController idC = TextEditingController();
  TextEditingController productNameC = TextEditingController();
  TextEditingController detailC = TextEditingController();
  TextEditingController priceC = TextEditingController();
  TextEditingController discountPriceC = TextEditingController();
  TextEditingController serialCodeC = TextEditingController();
  TextEditingController brandC = TextEditingController();
  // bool? imageUrls;
  bool? isOnsale = false;
  bool? isPopular = false;
  bool? isFavourite = false;

  bool? issaving = false;
  bool? isuploading = false;
  final imagepicker = ImagePicker();
  List<XFile> images = [];
  String? selectedvalue;
  List<dynamic> imageUrls = [];

  var uuid = Uuid();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: Column(
              children: [
                const Text(
                  "Add Product",
                  style: EcoStyle.boldstyle,
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  child: DropdownButtonFormField(
                    hint: const Text("Choose category"),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(10),
                    ),
                    validator: (value) {
                      if (value == null) {
                        return "Please select atleast one value";
                      } else {
                        return null;
                      }
                    },
                    value: selectedvalue,
                    items: categories
                        .map(
                          (e) => DropdownMenuItem<String>(
                            value: e.title,
                            child: Text(
                              e.title!,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(
                        () {
                          selectedvalue = value.toString();
                        },
                      );
                    },
                  ),
                ),
                Ecotextfield(
                  // maxlines: 1,
                  controller: productNameC,
                  hinttext: "Enter product name",
                  labeltext: "Product name",
                  validate: (v) {
                    if (v!.isEmpty) {
                      return "It should not be empty";
                    } else {
                      return null;
                    }
                  },
                ),
                Ecotextfield(
                  // minlines: 1,
                  //  maxlines: 5,
                  controller: detailC,
                  hinttext: "Enter product details",
                  labeltext: "Product details",
                  validate: (v) {
                    if (v!.isEmpty) {
                      return "It should not be empty";
                    } else {
                      return null;
                    }
                  },
                ),
                Ecotextfield(
                  //  maxlines: 1,
                  controller: priceC,
                  hinttext: "Enter product price",
                  labeltext: "Product Price",
                  validate: (v) {
                    if (v!.isEmpty) {
                      return "It should not be empty";
                    } else {
                      return null;
                    }
                  },
                ),
                Ecotextfield(
                  // maxlines: 1,
                  controller: discountPriceC,
                  hinttext: "Enter product discount price",
                  labeltext: "Discount Price",
                  validate: (v) {
                    if (v!.isEmpty) {
                      return "It should not be empty";
                    } else {
                      return null;
                    }
                  },
                ),
                Ecotextfield(
                  // maxlines: 1,
                  controller: serialCodeC,
                  hinttext: "Enter product serial code",
                  labeltext: "Serial code",
                  validate: (v) {
                    if (v!.isEmpty) {
                      return "It should not be empty";
                    } else {
                      return null;
                    }
                  },
                ),
                Ecotextfield(
                  // maxlines: 1,
                  controller: brandC,
                  hinttext: "Enter product brand",
                  labeltext: "Brand name",
                  validate: (v) {
                    if (v!.isEmpty) {
                      return "It should not be empty";
                    } else {
                      return null;
                    }
                  },
                ),
                EcoButton(
                  text: "Pick Images",
                  onpress: () {
                    pickImage();
                  },
                ),
                // EcoButton(
                //   isloading: isuploading,
                //   text: "Upload Images",
                //   onpress: () {
                //     uploadimage();
                //   },
                // ),
                Container(
                  height: 25.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey,
                  ),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                    ),
                    itemCount: images.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                ),
                              ),
                              child: Image.network(
                                File(images[index].path).path,
                                height: 150,
                                width: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  images.removeAt(index);
                                });
                              },
                              icon: const Icon(Icons.cancel),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SwitchListTile(
                    title: const Text("Is this product on Sale"),
                    value: isOnsale!,
                    onChanged: (v) {
                      setState(() {
                        isOnsale = !isOnsale!;
                      });
                    }),
                SwitchListTile(
                    title: const Text("Is this product Popular"),
                    value: isPopular!,
                    onChanged: (v) {
                      setState(() {
                        isPopular = !isPopular!;
                      });
                    }),
                EcoButton(
                  text: "Save",
                  onpress: () {
                    save();
                  },
                  isloading: issaving,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  save() async {
    setState(() {
      issaving = true;
    });

    await uploadimage();
    Products.addProducts(Products(
      brand: brandC.text,
      category: selectedvalue,
      id: uuid.v4(),
      productName: productNameC.text,
      detail: detailC.text,
      price: int.parse(priceC.text),
      discontPrice: int.parse(discountPriceC.text),
      serialCode: serialCodeC.text,
      imageUrls: imageUrls,
      isOnsale: isOnsale,
      isPopular: isPopular,
      isFavourite: isFavourite,
    )).whenComplete(() {
      setState(() {
        issaving = false;
        imageUrls.clear();
        images.clear();
        clearFields();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Added Successfully"),
          ),
        );
      });
    });
    // await FirebaseFirestore.instance
    //     .collection("products")
    //     .add({"images": imageurls}).whenComplete(() {
    //   setState(
    //     () {
    //       issaving = false;
    //       images.clear();
    //       imageurls.clear();
    //     },
    //   );
    // });
  }

  clearFields() {
    setState(() {
      // selectedvalue = "";
      productNameC.clear();
      detailC.clear();
      brandC.clear();
      priceC.clear();
      discountPriceC.clear();
      serialCodeC.clear();
    });
  }

  pickImage() async {
    final List<XFile>? pickedImages = (await imagepicker.pickMultiImage());
    if (pickedImages != null) {
      setState(() {
        images.addAll(pickedImages);
      });
    } else {
      print("no image selected");
    }
  }

  // Future postimage(File? image) async {
  //   var imagefile = FirebaseStorage.instance.ref().child("images");
  //   var timekey = new DateTime.now();
  //   UploadTask task =
  //       imagefile.child(timekey.toString() + ".jpg").putFile(images);
  //   TaskSnapshot snapshot = await task;
  //   urls = await snapshot.ref.getDownloadURL();

  //   await FirebaseFirestore.instance.collection("images").add({
  //     "url": urls,
  //     // "name": name1.text,
  //     // "channel_url": urlsub.text,
  //     "created": DateTime.now().millisecondsSinceEpoch
  //   });
  //   // setState(() {
  //   //   isuploading = false;
  //   // });
  //   return urls;
  // }

  Future postimage(XFile? imagefile) async {
    setState(() {
      isuploading = true;
    });
    Reference ref =
        FirebaseStorage.instance.ref().child("images").child(imagefile!.name);
    if (kIsWeb) {
      await ref.putData(
        await imagefile.readAsBytes(),
        SettableMetadata(contentType: "image/jpeg"),
      );
      urls = await ref.getDownloadURL();
      setState(() {
        isuploading = false;
      });
      return urls;
    }
  }

  uploadimage() async {
    for (var image in images) {
      await postimage(image).then((downloadurl) => imageUrls.add(downloadurl));
    }
  }
}
