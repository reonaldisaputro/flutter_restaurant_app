import 'dart:async';
import 'package:flutter_fundamental2/data/model/restaurant.dart';
import 'package:flutter_fundamental2/data/response/list_search.dart';
import 'package:flutter_fundamental2/provider/provider_search.dart';
import 'package:flutter_fundamental2/utils/state.dart';
import 'package:flutter_fundamental2/widgets/card_custom.dart';
import 'package:flutter_fundamental2/widgets/platform_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RestaurantSearch extends StatefulWidget {
  static const routeName = 'page_search';
  const RestaurantSearch({Key? key}) : super(key: key);

  @override
  _RestaurantSearchState createState() => _RestaurantSearchState();
}

class _RestaurantSearchState extends State<RestaurantSearch> {
  Widget _buildList() {
    Timer? _debounce;
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Column(
        children: [
          Flexible(
              flex: 0,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                      label: Text('Search'),
                      hintText: 'Input type name restaurant',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)))),
                  onChanged: (text) {
                    if (_debounce?.isActive ?? false) _debounce!.cancel();
                    _debounce = Timer(const Duration(milliseconds: 500), () {
                      if (text.isNotEmpty) {
                        SearchProvider provider =
                            Provider.of(context, listen: false);
                        provider.fetchSearchRestaurant(text);
                      }
                    });
                  },
                ),
              )),
          Flexible(
              flex: 1,
              child: Consumer<SearchProvider>(
                builder: (context, provider, _) {
                  ResultState<RestaurantSearchResponse> state = provider.state;
                  switch (state.status) {
                    case Status.loading:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    case Status.error:
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text("Tidak Ada Koneksi Internet"),
                        ),
                      );
                    case Status.hasData:
                      {
                        {
                          List<Restaurant> restaurants = state.data!.restaurant;
                          if (restaurants.isEmpty) {
                            return const Center(
                              child: Text('The search result is empty'),
                            );
                          } else {
                            return CardCustom(restaurant: restaurants);
                          }
                        }
                      }
                  }
                },
              ))
        ],
      ),
    );
  }

  Widget _buildIos(BuildContext context) {
    return Scaffold(
      body: _buildList(),
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      body: _buildList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(androidBuilder: _buildAndroid, iosBuilder: _buildIos);
  }
}
