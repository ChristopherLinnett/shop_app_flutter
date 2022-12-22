import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key});
  static const String routeName = '/EditProductScreen';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final List<FocusNode> focusNodes = [FocusNode(), FocusNode(), FocusNode()];
  final _imageUrlController = TextEditingController(text: '');

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
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Title'),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(focusNodes[0]);
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Price'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: focusNodes[0],
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(focusNodes[1]);
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  focusNode: focusNodes[1],
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
                      child: _imageUrlController.text == ''
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
                          }),
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
