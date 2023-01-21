import 'package:coffee_masters/datamodel.dart';
import 'package:flutter/material.dart';

import '../datamanager.dart';

class MenuPage extends StatelessWidget {
  final DataManager dataManager;
  const MenuPage({Key? key, required this.dataManager}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // specify where the future is actually created
      future: dataManager.getMenu(),
      builder: (
        context,
        snapshot,
      ) {
        if (snapshot.hasData) {
          //Future has completed
          var categories = snapshot.data! as List<Category>;

          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      categories[index].name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 23),
                    ),
                  ),
                  ListView.builder(
                    itemCount: categories[index].products.length,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (context, prodIndex) {
                      var product = categories[index].products[prodIndex];
                      return ProductItem(
                        product: product,
                        onAdd: (addedproduct) {
                          dataManager.cartAdd(addedproduct);
                        },
                      );
                    },
                  ),
                ],
              );
            },
          );
        } else {
          if (snapshot.hasError) {
            return const Text("Error");
          } else {
            return const CircularProgressIndicator();
          }
        }
      },
    );
  }
}

class ProductItem extends StatelessWidget {
  final Product product;
  final Function onAdd;
  const ProductItem({Key? key, required this.product, required this.onAdd})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(4),
        child: Card(
          elevation: 4,
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          product.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "\$${product.price.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        onAdd(product);
                      },
                      child: const Text("Add"),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
