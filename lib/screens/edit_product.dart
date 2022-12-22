import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_flutter/providers/product.dart';
import 'package:shop_app_flutter/providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key});
  static const String routeName = '/EditProductScreen';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final List<FocusNode> focusNodes = [FocusNode(), FocusNode(), FocusNode()];
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  bool urlIsValid = false;
  var _editedProduct =
      Product(id: '', title: '', price: 0, description: '', imageUrl: '');
  Map<String, String> _initValues = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': ''
  };

  var isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit) {
      return;
    }
    isInit = true;

    final productId = ModalRoute.of(context)!.settings.arguments as String?;
    if (productId == null) {
      return;
    }
    _editedProduct =
        Provider.of<Products>(context, listen: false).findById(productId);
    _initValues = {
      'title': _editedProduct.title,
      'price': _editedProduct.price.toString(),
      'description': _editedProduct.description,
      'imageUrl': _editedProduct.imageUrl
    };
    _imageUrlController.text = _initValues['imageUrl']!;
  }

  @override
  void initState() {
    focusNodes[2].addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    focusNodes[2].removeListener(_updateImageUrl);
    for (int x = 0; x < focusNodes.length; x++) {
      focusNodes[x].dispose();
    }
    _imageUrlController.dispose();

    super.dispose();
  }

  void _updateImageUrl() {
    if (!focusNodes[2].hasFocus) {
      if (_imageUrlController.text.isEmpty ||
          (_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https'))) {
        urlIsValid = false;
        return;
      }
      urlIsValid = true;
      setState(() {});
    }
  }

  void _saveForm() {
    if (_form.currentState == null) {
      return;
    }

    var isValid = _form.currentState!.validate();
    if (isValid) {
      _form.currentState!.save();
      if (_editedProduct.id == '') {
        Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } else {
        Provider.of<Products>(context, listen: false)
            .editProduct(_editedProduct.id, _editedProduct);
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Title'),
                  initialValue: _initValues['title'],
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(focusNodes[0]);
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'No Input Given';
                    }
                    if (value.isEmpty) {
                      return 'No Input Given';
                    }
                    if (value.length < 3) {
                      return 'Name too short';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _editedProduct = Product(
                        id: _editedProduct.id,
                        title: newValue ?? _editedProduct.title,
                        description: _editedProduct.description,
                        price: _editedProduct.price,
                        imageUrl: _editedProduct.imageUrl,
                        isFavourite: _editedProduct.isFavourite);
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Price'),
                  initialValue: _initValues['price'],
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: focusNodes[0],
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(focusNodes[1]);
                  },
                  validator: (value) {
                    if (value == null || value == '') {
                      return 'Enter a Price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Includes invalid characters';
                    }
                    if (double.tryParse(value)! < 0) {
                      return 'Please use a positive value';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _editedProduct = Product(
                        id: _editedProduct.id,
                        title: _editedProduct.title,
                        description: _editedProduct.description,
                        price: double.parse(newValue!),
                        imageUrl: _editedProduct.imageUrl,
                        isFavourite: _editedProduct.isFavourite);
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  initialValue: _initValues['description'],
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  focusNode: focusNodes[1],
                  validator: (value) {
                    if (value == null) {
                      return 'No Input Given';
                    }
                    if (value.isEmpty) {
                      return 'No Input Given';
                    }
                    if (value.length < 3) {
                      return 'description too short';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _editedProduct = Product(
                        id: _editedProduct.id,
                        title: _editedProduct.title,
                        description: newValue ?? _editedProduct.description,
                        price: _editedProduct.price,
                        imageUrl: _editedProduct.imageUrl,
                        isFavourite: _editedProduct.isFavourite);
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(top: 8, right: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1),
                      ),
                      child: !urlIsValid
                          ? Text('Enter Image Url')
                          : FittedBox(
                              child: CachedNetworkImage(
                                  imageUrl: _imageUrlController.text,
                                  fit: BoxFit.cover),
                            ),
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Image URL',
                        ),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageUrlController,
                        focusNode: focusNodes[2],
                        onEditingComplete: () {
                          setState(() {});
                        },
                        onFieldSubmitted: (_) {
                          _saveForm();
                        },
                        validator: ((value) {
                          if (value == null) {
                            return 'received null value';
                          }
                          if (value.isEmpty) {
                            return 'Please enter a URL';
                          }
                          if (!value.startsWith('http') &&
                              !value.startsWith('https')) {
                            return 'Please enter a valid URL';
                          }
                          return null;
                        }),
                        onSaved: (newValue) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              description: _editedProduct.description,
                              price: _editedProduct.price,
                              imageUrl: newValue ?? _editedProduct.imageUrl,
                              isFavourite: _editedProduct.isFavourite);
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
