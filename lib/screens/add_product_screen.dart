import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';
import '../widgets/multi_select_chip.dart';
import '../widgets/my_textformfield.dart';

class AddProductScreen extends StatefulWidget {
  static const routeName = '/add-product-screen';

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final imageUrlController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  var isLoading = false;

  List<String> catergories = [
    'Men',
    'Women',
    'Shoes',
    'Pants',
  ];

  @override
  Widget build(BuildContext context) {
    Color gold = Theme.of(context).colorScheme.secondary;
    //final product = Provider.of<Product>(context, listen: false);
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final String? shopName = routeArgs['ShopName'];

    var newProduct = Product(
      id: DateTime.now().toString(),
      manufacturer: shopName.toString(),
      imageUrl: '',
      title: '',
      price: 0,
      categories: [],
      isFavorite: false,
    );

    Future<void> saveForm() async {
      if (formKey.currentState!.validate()) {
        setState(() {
          isLoading = true;
        });
        formKey.currentState!.save();
        try {
          await Provider.of<Products>(context, listen: false)
              .addProduct(newProduct);
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
      }
      return;
    }

    return SafeArea(
      child: Scaffold(
        body: Form(
          key: formKey,
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(
                  color: gold,
                ))
              : Column(
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
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ListView(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                'Add a new product to $shopName! ',
                                maxLines: 3,
                                style: const TextStyle(
                                  fontSize: 43,
                                  fontFamily: 'PORKYS_',
                                ),
                              ),
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
                                  labelText: 'Name',
                                  hintText: 'enter product name',
                                  inputAction: TextInputAction.next,
                                  myKeyboardType: TextInputType.text,
                                  isTextObscure: false,
                                  myController: null,
                                  myValidator: (value) {
                                    if (value!.isEmpty) {
                                      return 'please provide a product name';
                                    }
                                    return null;
                                  },
                                  myOnSaved: (value) => newProduct = Product(
                                      id: newProduct.id,
                                      manufacturer: newProduct.manufacturer,
                                      imageUrl: newProduct.imageUrl,
                                      title: value!.trim(),
                                      price: newProduct.price,
                                      categories: newProduct.categories),
                                ),
                              ),
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
                                  labelText: 'Price',
                                  hintText: 'Enter product price',
                                  inputAction: TextInputAction.next,
                                  myKeyboardType: TextInputType.number,
                                  isTextObscure: false,
                                  myController: null,
                                  myValidator: (value) {
                                    if (value!.isEmpty) {
                                      return 'please provide a price for your product';
                                    }
                                    return null;
                                  },
                                  myOnSaved: (value) => newProduct = Product(
                                    id: newProduct.id,
                                    manufacturer: newProduct.manufacturer,
                                    imageUrl: newProduct.imageUrl,
                                    title: newProduct.title,
                                    price: double.parse(value!),
                                    categories: newProduct.categories,
                                  ),
                                ),
                              ),
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
                                  hintText: 'Enter product image URL',
                                  inputAction: TextInputAction.done,
                                  myKeyboardType: TextInputType.url,
                                  isTextObscure: false,
                                  myController: imageUrlController,
                                  myValidator: (value) {
                                    if (value!.isEmpty) {
                                      return 'please provide an image URL';
                                    }
                                    return null;
                                  },
                                  myOnSaved: (value) => newProduct = Product(
                                    id: newProduct.id,
                                    manufacturer: newProduct.manufacturer,
                                    imageUrl: value!.trim(),
                                    title: newProduct.title,
                                    price: newProduct.price,
                                    categories: newProduct.categories,
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
                              elevation: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    const Text(
                                      'product category',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    MultiSelectChip(
                                      catergories,
                                      onSelectionChanged: (selectedList) =>
                                          newProduct = Product(
                                        id: newProduct.id,
                                        manufacturer: newProduct.manufacturer,
                                        imageUrl: newProduct.imageUrl,
                                        title: newProduct.title,
                                        price: newProduct.price,
                                        categories: selectedList,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: gold,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (imageUrlController.text.isNotEmpty) {
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => SimpleDialog(
                                          contentPadding:
                                              const EdgeInsets.all(0),
                                          children: [
                                            Image.network(
                                              imageUrlController.text,
                                              fit: BoxFit.fill,
                                            )
                                          ],
                                        ),
                                      );
                                    } else {
                                      null;
                                    }
                                  },
                                  child: Row(
                                    children: const [
                                      Icon(Icons.image),
                                      Text(' Preview product Image'),
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: gold,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  onPressed: () => saveForm(),
                                  child: Row(
                                    children: const [
                                      Icon(Icons.add),
                                      Text('Add product')
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
