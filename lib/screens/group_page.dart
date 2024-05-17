import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupPage extends StatelessWidget {
  const GroupPage({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<GroupPage>(
      //specify the type oof the model we want to access. If you don't specify the generic (<GroupPage>), the provider package won't be able to help you. provider is based on types, an without the type, it doesn't know what you want. The only required argument of the Consumer widget is the builder. Builder is a function that is called whenever the ChangeNotifier changes. It is best practice to put your Consumer widgets as deep in the tree as possible. You don't want to rebuild large portions of the UI just because some detail somewhere changed.
      builder: (context, value, child) {
        //value replace with cart
        return Scaffold(
          //Text('Total price': ${cart.totalPrice});
          appBar: AppBar(
            title: Text('Group Page'),
          ),
          body: Center(
            child: Text('Group Page'),
          ),
        );
      },
    );
  }
}

//Provider.of
//Sometimes, you don't really need the data in the model to change the UI but you still need to access it. For example, a ClearCart button wants to allow the user to remove everything from the cart. It doesn't need to display the contents of the cart, it just needs to call the clear() method. We could use Consumer<CartModel> for this, but that would be wasteful. We'd be asking the framework to rebuild a widget that doesn't need to be rebuilt. For this use case, we can use Provider.of, with the listen parameter set to false.

//Provider.of<CartModel>(context, listen:false).removeAll()

//Using the above line in a build method won't cause this widget to rebuild when notifyListeners is called.