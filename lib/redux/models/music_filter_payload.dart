// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:html/parser.dart';

class MusicFilterPayloadModel {
  final FilterContext context;
  final String continuation;
  final String apiKey;
  MusicFilterPayloadModel({
    required this.context,
    required this.continuation,
    required this.apiKey,
  });

  factory MusicFilterPayloadModel.fromJson(Map<String, dynamic> json) {
    return MusicFilterPayloadModel(
      context: FilterContext.fromJson(json['context']),
      continuation: json['continuation'],
      apiKey: json['apiKey'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'context': context.toJson(),
      'continuation': continuation,
    };
  }

  @override
  String toString() =>
      'MusicFilterPayloadModel(context: $context, continuation: $continuation, apiKey: $apiKey)';

  factory MusicFilterPayloadModel.fromApiResponse(Response res) {
    final doc = parse(res.data);
    final apiElement = doc.getElementsByTagName('script').firstWhere(
        (element) =>
            element.innerHtml.startsWith('(function() {window.ytplayer={};'));
    final apiHtmlString1 = apiElement.innerHtml
        .replaceAll('(function() {window.ytplayer={};\nytcfg.set(', '');
    final apiHtmlString2 = apiHtmlString1.replaceRange(
        apiHtmlString1.indexOf('); window.ytcfg'), apiHtmlString1.length, '');
    final apiJson = jsonDecode(apiHtmlString2);
    final mainElement = doc
        .getElementsByTagName('script')
        .firstWhere(
            (element) => element.innerHtml.startsWith('var ytInitialData = {'))
        .innerHtml;
    final mainHtmlString = mainElement
        .replaceAll('var ytInitialData = ', '')
        .replaceFirst(';', '', mainElement.length - 40);

    final jsonElement = jsonDecode(mainHtmlString);

    final filterList = jsonElement['contents']['twoColumnBrowseResultsRenderer']
            ['tabs'][0]['tabRenderer']['content']['richGridRenderer']['header']
        ['feedFilterChipBarRenderer']['contents'] as List;
    var token = '';
    for (var item in filterList) {
      final chipTextList =
          item['chipCloudChipRenderer']['text']['runs'] as List;
      for (var chipText in chipTextList) {
        if (chipText['text'] == 'Music') {
          token = item['chipCloudChipRenderer']['navigationEndpoint']
              ['continuationCommand']['token'];
          break;
        }
      }
    }
    return MusicFilterPayloadModel(
      context: FilterContext.fromJson(apiJson['INNERTUBE_CONTEXT']),
      continuation: token,
      apiKey: apiJson['INNERTUBE_API_KEY'],
    );
  }
}

class FilterContext {
  final FilterClient client;
  FilterContext({
    required this.client,
  });

  factory FilterContext.fromJson(Map<String, dynamic> json) {
    return FilterContext(client: FilterClient.fromJson(json['client']));
  }

  Map<String, dynamic> toJson() {
    return {
      'client': client.toJson(),
    };
  }

  @override
  String toString() => 'FilterContext(client: $client)';
}

class FilterClient {
  final String hl;
  final String gl;
  final String remoteHost;
  final String visitorData;
  final String clientName;
  final String clientVersion;
  FilterClient({
    required this.hl,
    required this.gl,
    required this.remoteHost,
    required this.visitorData,
    required this.clientName,
    required this.clientVersion,
  });

  FilterClient copyWith({
    String? hl,
    String? gl,
    String? remoteHost,
    String? visitorData,
    String? clientName,
    String? clientVersion,
  }) {
    return FilterClient(
      hl: hl ?? this.hl,
      gl: gl ?? this.gl,
      remoteHost: remoteHost ?? this.remoteHost,
      visitorData: visitorData ?? this.visitorData,
      clientName: clientName ?? this.clientName,
      clientVersion: clientVersion ?? this.clientVersion,
    );
  }

  factory FilterClient.fromJson(Map<String, dynamic> json) {
    return FilterClient(
      hl: json['hl'],
      gl: json['gl'],
      remoteHost: json['remoteHost'],
      visitorData: json['visitorData'],
      clientName: json['clientName'],
      clientVersion: json['clientVersion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hl': hl,
      'gl': gl,
      'remoteHost': remoteHost,
      'visitorData': visitorData,
      'clientName': clientName,
      'clientVersion': clientVersion,
    };
  }

  @override
  String toString() {
    return 'FilterClient(hl: $hl, gl: $gl, remoteHost: $remoteHost, visitorData: $visitorData, clientName: $clientName, clientVersion: $clientVersion)';
  }
}
