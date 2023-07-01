import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                elevation: 3,
                child: ClipRRect(
                  child: CachedNetworkImage(
                    imageUrl:
                    'https://th.bing.com/th/id/OIP.HDO6iVF_qfcQQzMDHTG2TQHaIe?w=159&h=182&c=7&r=0&o=5&dpr=1.3&pid=1.7.jpeg',
                    imageBuilder: (context, imageBuilder) {
                      return Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius:
                          const BorderRadius.all(
                              Radius.circular(100)),
                          image: DecorationImage(
                            image: imageBuilder,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                    placeholder: (context, url) => Container(
                      width: 100,
                      height: 100,
                      child: Center(
                        child: Platform.isAndroid
                            ? const Padding(
                          padding:
                          EdgeInsets.all(150.0),
                          child: LoadingIndicator(
                            indicatorType: Indicator
                                .lineSpinFadeLoader,
                          ),
                        )
                            : const CupertinoActivityIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        Container(
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/image_not_found.jpeg'),
                            ),
                          ),
                        ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Mugiwara no Luffy',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Movie Enthusiast',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
