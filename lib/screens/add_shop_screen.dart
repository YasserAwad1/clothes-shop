import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/shop.dart';
import '../providers/shops.dart';
import '../widgets/my_textformfield.dart';

class AddShopScreen extends StatefulWidget {
  static const routeName = '/add-shop=screen';

  @override
  State<AddShopScreen> createState() => _AddShopScreenState();
}

class _AddShopScreenState extends State<AddShopScreen> {
  final imageUrlController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    Color gold = Theme.of(context).colorScheme.secondary;
    var newShop = Shop(
      id: '',
      name: '',
      imageUrl: '',
    );

    Future<void> saveForm() async {
      if (formKey.currentState!.validate()) {
        setState(() {
          isLoading = true;
        });
        formKey.currentState!.save();
        try {
          await Provider.of<Shops>(context, listen: false).addShop(newShop);
        } catch (error) {
          await showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                      title: const Text('Something went wrong'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            child: Text(
                              'Okay',
                              style: TextStyle(color: gold),
                            ))
                      ]));
        } finally {
          setState(() {
            isLoading = false;
          });
          Navigator.of(context).pop();
        }
        // print(newShop.id);
      }
      return;
    }

    return SafeArea(
      child: Scaffold(
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: gold,
                ),
              )
            : Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(
                          Icons.arrow_back_rounded,
                          color: Theme.of(context).colorScheme.secondary,
                          size: 30,
                        ),
                      ),
                    ),
                    const Text(
                      'Add a new shop!',
                      style: TextStyle(
                        fontSize: 48,
                        fontFamily: 'PORKYS_',
                      ),
                    ),
                    Expanded(
                      child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  shadowColor: gold,
                                  elevation: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 10, left: 8, right: 8),
                                    child: MyTextFormField(
                                      context: context,
                                      labelText: 'Store Name',
                                      hintText: 'enter store name',
                                      inputAction: TextInputAction.next,
                                      myKeyboardType: TextInputType.text,
                                      isTextObscure: false,
                                      myController: null,
                                      myValidator: (value) {
                                        if (value!.isEmpty) {
                                          return 'please provide a store name';
                                        }
                                        return null;
                                      },
                                      myOnSaved: (value) => newShop = Shop(
                                        id: newShop.id,
                                        name: value!.trim(),
                                        imageUrl: newShop.imageUrl,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  shadowColor: gold,
                                  elevation: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 10, left: 8, right: 8),
                                    child: MyTextFormField(
                                      context: context,
                                      labelText: 'Image URL',
                                      hintText: 'enter image URL',
                                      inputAction: TextInputAction.done,
                                      myKeyboardType: TextInputType.url,
                                      isTextObscure: false,
                                      myController: null,
                                      myValidator: (value) {
                                        if (value!.isEmpty) {
                                          return 'please provide an image url';
                                        }
                                        return null;
                                      },
                                      myOnSaved: (value) => newShop = Shop(
                                        id: newShop.id,
                                        name: newShop.name,
                                        imageUrl: value!.trim(),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      style: TextButton.styleFrom(
                                          backgroundColor: gold,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20))),
                                      onPressed: () {
                                        if (imageUrlController
                                            .text.isNotEmpty) {
                                          showDialog(
                                            context: context,
                                            builder: (ctx) => SimpleDialog(
                                              contentPadding:
                                                  const EdgeInsets.all(0),
                                              children: [
                                                Image.network(
                                                    imageUrlController.text)
                                              ],
                                            ),
                                          );
                                          // FocusManager.instance.primaryFocus!.unfocus();
                                        } else {
                                          null;
                                        }
                                      },
                                      child: Row(
                                        children: const [
                                          Icon(Icons.image),
                                          Text(' Preview Image'),
                                        ],
                                      ),
                                    ),
                                    ElevatedButton(
                                        style: TextButton.styleFrom(
                                            backgroundColor: gold,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20))),
                                        onPressed: () => saveForm(),
                                        child: Row(
                                          children: const [
                                            Icon(Icons.add),
                                            Text('Add Shop')
                                          ],
                                        ))
                                  ],
                                ),
                              ],
                            ),
                          )),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
