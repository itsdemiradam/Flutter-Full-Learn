import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_full_learning/202/Service/comments_learn_view.dart';
import 'package:flutter_full_learning/202/Service/post_model.dart';
import 'package:flutter_full_learning/202/Service/post_service.dart';
import 'package:flutter_full_learning/202/Service/service_post_learn_view.dart';


class ServiceLearn extends StatefulWidget {
  const ServiceLearn({Key? key}) : super(key: key);

  @override
  State<ServiceLearn> createState() => _ServiceLearnState();
}

class _ServiceLearnState extends State<ServiceLearn> {

  List<PostModel>? _items;
  String? name;
  bool _isLoading = false;
  late final Dio _dio;
  final _baseUrl = "https://jsonplaceholder.typicode.com/";

//TEST EDILEBILIR KOD BASLADI
  late final IPostService _postService;

  @override
  void initState() {
    super.initState();
    _dio=Dio(BaseOptions(baseUrl: _baseUrl));
    _postService = PostService();
    name="Emre";
    //
    fetchPostItemsAdvanced();
  }

  void _changeLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  Future<void> fetchPostItems() async {
    _changeLoading();

    final response = await Dio().get("https://jsonplaceholder.typicode.com/posts");
    //xx

    //if(response.statusCode == HttpStatus.ok){
      final _datas = response.data;

      if(_datas is List){
        setState((){
          _items = _datas.map((e) => PostModel.fromJson(e)).toList();
        });
      }
      _changeLoading();
    }
   


  Future<void> fetchPostItemsAdvanced() async {
    _changeLoading();

    _items = await _postService.fetchPostItemsAdvanced();
    _changeLoading();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name ?? ""),
        actions: [_isLoading ? CircularProgressIndicator.adaptive() : SizedBox.shrink()],
      ),
      body: _items == null ? Placeholder() : ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 10),
        itemCount: _items?.length ?? 0,
        itemBuilder: (context, index) {
        return _PostCard(model: _items?[index]);
      },),
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({
    Key? key,
    required PostModel? model,
  }) : _model = model, super(key: key);

  final PostModel? _model;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 20),
      child: ListTile(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => CommentsLearnView(postId:  _model?.id),
          ));
        },
        title: Text(_model?.title ?? ""),
        subtitle: Text(_model?.body ?? ""),),
    );
  }
}