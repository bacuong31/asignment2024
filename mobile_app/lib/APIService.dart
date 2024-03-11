import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app/model/StaffModel.dart';
import 'package:mobile_app/widget/StaffWidget.dart';
import 'package:http_server/http_server.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

class APIService {
  final HttpClient client;
  APIService({required this.client});
  Future<List<StaffModel>> getStaffs() async {
    List<StaffModel> models = [];
    HttpClientRequest request =
        await client.getUrl(Uri.parse('https://10.0.2.2:8443/api/staffs'));
    HttpClientResponse response = await request.close();
    if (response.statusCode == 200) {
      String reply = await response.transform(utf8.decoder).join();

      var list = jsonDecode(reply) as List;
      models = list.map((item) => StaffModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load data');
    }
    return models;
  }

  Future<StaffModel> getStaff(int id) async {
    StaffModel model;
    HttpClientRequest request = await client
        .getUrl(Uri.parse('https://10.0.2.2:8443/api/staffs/' + id.toString()));
    HttpClientResponse response = await request.close();
    if (response.statusCode == 200) {
      String reply = await response.transform(utf8.decoder).join();
      var data = jsonDecode(reply);
      model = StaffModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load staff member');
    }
  }
}
