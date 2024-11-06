// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $DocSitesTable extends DocSites with TableInfo<$DocSitesTable, DocSite> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DocSitesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
      'url', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _overviewMeta =
      const VerificationMeta('overview');
  @override
  late final GeneratedColumn<String> overview = GeneratedColumn<String>(
      'overview', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _faviconMeta =
      const VerificationMeta('favicon');
  @override
  late final GeneratedColumn<String> favicon = GeneratedColumn<String>(
      'favicon', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<String> version = GeneratedColumn<String>(
      'version', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, url, name, overview, favicon, version, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'doc_sites';
  @override
  VerificationContext validateIntegrity(Insertable<DocSite> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('url')) {
      context.handle(
          _urlMeta, url.isAcceptableOrUnknown(data['url']!, _urlMeta));
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('overview')) {
      context.handle(_overviewMeta,
          overview.isAcceptableOrUnknown(data['overview']!, _overviewMeta));
    }
    if (data.containsKey('favicon')) {
      context.handle(_faviconMeta,
          favicon.isAcceptableOrUnknown(data['favicon']!, _faviconMeta));
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DocSite map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DocSite(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      url: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}url'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      overview: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}overview']),
      favicon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}favicon']),
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}version']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $DocSitesTable createAlias(String alias) {
    return $DocSitesTable(attachedDatabase, alias);
  }
}

class DocSite extends DataClass implements Insertable<DocSite> {
  final int id;
  final String url;
  final String name;
  final String? overview;
  final String? favicon;
  final String? version;
  final DateTime createdAt;
  const DocSite(
      {required this.id,
      required this.url,
      required this.name,
      this.overview,
      this.favicon,
      this.version,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['url'] = Variable<String>(url);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || overview != null) {
      map['overview'] = Variable<String>(overview);
    }
    if (!nullToAbsent || favicon != null) {
      map['favicon'] = Variable<String>(favicon);
    }
    if (!nullToAbsent || version != null) {
      map['version'] = Variable<String>(version);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DocSitesCompanion toCompanion(bool nullToAbsent) {
    return DocSitesCompanion(
      id: Value(id),
      url: Value(url),
      name: Value(name),
      overview: overview == null && nullToAbsent
          ? const Value.absent()
          : Value(overview),
      favicon: favicon == null && nullToAbsent
          ? const Value.absent()
          : Value(favicon),
      version: version == null && nullToAbsent
          ? const Value.absent()
          : Value(version),
      createdAt: Value(createdAt),
    );
  }

  factory DocSite.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DocSite(
      id: serializer.fromJson<int>(json['id']),
      url: serializer.fromJson<String>(json['url']),
      name: serializer.fromJson<String>(json['name']),
      overview: serializer.fromJson<String?>(json['overview']),
      favicon: serializer.fromJson<String?>(json['favicon']),
      version: serializer.fromJson<String?>(json['version']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'url': serializer.toJson<String>(url),
      'name': serializer.toJson<String>(name),
      'overview': serializer.toJson<String?>(overview),
      'favicon': serializer.toJson<String?>(favicon),
      'version': serializer.toJson<String?>(version),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DocSite copyWith(
          {int? id,
          String? url,
          String? name,
          Value<String?> overview = const Value.absent(),
          Value<String?> favicon = const Value.absent(),
          Value<String?> version = const Value.absent(),
          DateTime? createdAt}) =>
      DocSite(
        id: id ?? this.id,
        url: url ?? this.url,
        name: name ?? this.name,
        overview: overview.present ? overview.value : this.overview,
        favicon: favicon.present ? favicon.value : this.favicon,
        version: version.present ? version.value : this.version,
        createdAt: createdAt ?? this.createdAt,
      );
  DocSite copyWithCompanion(DocSitesCompanion data) {
    return DocSite(
      id: data.id.present ? data.id.value : this.id,
      url: data.url.present ? data.url.value : this.url,
      name: data.name.present ? data.name.value : this.name,
      overview: data.overview.present ? data.overview.value : this.overview,
      favicon: data.favicon.present ? data.favicon.value : this.favicon,
      version: data.version.present ? data.version.value : this.version,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DocSite(')
          ..write('id: $id, ')
          ..write('url: $url, ')
          ..write('name: $name, ')
          ..write('overview: $overview, ')
          ..write('favicon: $favicon, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, url, name, overview, favicon, version, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DocSite &&
          other.id == this.id &&
          other.url == this.url &&
          other.name == this.name &&
          other.overview == this.overview &&
          other.favicon == this.favicon &&
          other.version == this.version &&
          other.createdAt == this.createdAt);
}

class DocSitesCompanion extends UpdateCompanion<DocSite> {
  final Value<int> id;
  final Value<String> url;
  final Value<String> name;
  final Value<String?> overview;
  final Value<String?> favicon;
  final Value<String?> version;
  final Value<DateTime> createdAt;
  const DocSitesCompanion({
    this.id = const Value.absent(),
    this.url = const Value.absent(),
    this.name = const Value.absent(),
    this.overview = const Value.absent(),
    this.favicon = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  DocSitesCompanion.insert({
    this.id = const Value.absent(),
    required String url,
    required String name,
    this.overview = const Value.absent(),
    this.favicon = const Value.absent(),
    this.version = const Value.absent(),
    required DateTime createdAt,
  })  : url = Value(url),
        name = Value(name),
        createdAt = Value(createdAt);
  static Insertable<DocSite> custom({
    Expression<int>? id,
    Expression<String>? url,
    Expression<String>? name,
    Expression<String>? overview,
    Expression<String>? favicon,
    Expression<String>? version,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (url != null) 'url': url,
      if (name != null) 'name': name,
      if (overview != null) 'overview': overview,
      if (favicon != null) 'favicon': favicon,
      if (version != null) 'version': version,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  DocSitesCompanion copyWith(
      {Value<int>? id,
      Value<String>? url,
      Value<String>? name,
      Value<String?>? overview,
      Value<String?>? favicon,
      Value<String?>? version,
      Value<DateTime>? createdAt}) {
    return DocSitesCompanion(
      id: id ?? this.id,
      url: url ?? this.url,
      name: name ?? this.name,
      overview: overview ?? this.overview,
      favicon: favicon ?? this.favicon,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (overview.present) {
      map['overview'] = Variable<String>(overview.value);
    }
    if (favicon.present) {
      map['favicon'] = Variable<String>(favicon.value);
    }
    if (version.present) {
      map['version'] = Variable<String>(version.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DocSitesCompanion(')
          ..write('id: $id, ')
          ..write('url: $url, ')
          ..write('name: $name, ')
          ..write('overview: $overview, ')
          ..write('favicon: $favicon, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $WebResourcesTable extends WebResources
    with TableInfo<$WebResourcesTable, WebResource> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WebResourcesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
      'url', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _headersMeta =
      const VerificationMeta('headers');
  @override
  late final GeneratedColumn<String> headers = GeneratedColumn<String>(
      'headers', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
      'method', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _faviconMeta =
      const VerificationMeta('favicon');
  @override
  late final GeneratedColumn<String> favicon = GeneratedColumn<String>(
      'favicon', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _filekeyMeta =
      const VerificationMeta('filekey');
  @override
  late final GeneratedColumn<String> filekey = GeneratedColumn<String>(
      'file_key', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _siteFromMeta =
      const VerificationMeta('siteFrom');
  @override
  late final GeneratedColumn<int> siteFrom = GeneratedColumn<int>(
      'site_from_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES doc_sites (id)'));
  @override
  List<GeneratedColumn> get $columns =>
      [url, headers, method, favicon, filekey, siteFrom];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'web_resources';
  @override
  VerificationContext validateIntegrity(Insertable<WebResource> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('url')) {
      context.handle(
          _urlMeta, url.isAcceptableOrUnknown(data['url']!, _urlMeta));
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('headers')) {
      context.handle(_headersMeta,
          headers.isAcceptableOrUnknown(data['headers']!, _headersMeta));
    }
    if (data.containsKey('method')) {
      context.handle(_methodMeta,
          method.isAcceptableOrUnknown(data['method']!, _methodMeta));
    }
    if (data.containsKey('favicon')) {
      context.handle(_faviconMeta,
          favicon.isAcceptableOrUnknown(data['favicon']!, _faviconMeta));
    }
    if (data.containsKey('file_key')) {
      context.handle(_filekeyMeta,
          filekey.isAcceptableOrUnknown(data['file_key']!, _filekeyMeta));
    }
    if (data.containsKey('site_from_id')) {
      context.handle(_siteFromMeta,
          siteFrom.isAcceptableOrUnknown(data['site_from_id']!, _siteFromMeta));
    } else if (isInserting) {
      context.missing(_siteFromMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  WebResource map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WebResource(
      url: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}url'])!,
      headers: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}headers']),
      method: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}method']),
      favicon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}favicon']),
      filekey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_key']),
      siteFrom: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}site_from_id'])!,
    );
  }

  @override
  $WebResourcesTable createAlias(String alias) {
    return $WebResourcesTable(attachedDatabase, alias);
  }
}

class WebResource extends DataClass implements Insertable<WebResource> {
  final String url;
  final String? headers;
  final String? method;
  final String? favicon;
  final String? filekey;
  final int siteFrom;
  const WebResource(
      {required this.url,
      this.headers,
      this.method,
      this.favicon,
      this.filekey,
      required this.siteFrom});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['url'] = Variable<String>(url);
    if (!nullToAbsent || headers != null) {
      map['headers'] = Variable<String>(headers);
    }
    if (!nullToAbsent || method != null) {
      map['method'] = Variable<String>(method);
    }
    if (!nullToAbsent || favicon != null) {
      map['favicon'] = Variable<String>(favicon);
    }
    if (!nullToAbsent || filekey != null) {
      map['file_key'] = Variable<String>(filekey);
    }
    map['site_from_id'] = Variable<int>(siteFrom);
    return map;
  }

  WebResourcesCompanion toCompanion(bool nullToAbsent) {
    return WebResourcesCompanion(
      url: Value(url),
      headers: headers == null && nullToAbsent
          ? const Value.absent()
          : Value(headers),
      method:
          method == null && nullToAbsent ? const Value.absent() : Value(method),
      favicon: favicon == null && nullToAbsent
          ? const Value.absent()
          : Value(favicon),
      filekey: filekey == null && nullToAbsent
          ? const Value.absent()
          : Value(filekey),
      siteFrom: Value(siteFrom),
    );
  }

  factory WebResource.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WebResource(
      url: serializer.fromJson<String>(json['url']),
      headers: serializer.fromJson<String?>(json['headers']),
      method: serializer.fromJson<String?>(json['method']),
      favicon: serializer.fromJson<String?>(json['favicon']),
      filekey: serializer.fromJson<String?>(json['filekey']),
      siteFrom: serializer.fromJson<int>(json['siteFrom']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'url': serializer.toJson<String>(url),
      'headers': serializer.toJson<String?>(headers),
      'method': serializer.toJson<String?>(method),
      'favicon': serializer.toJson<String?>(favicon),
      'filekey': serializer.toJson<String?>(filekey),
      'siteFrom': serializer.toJson<int>(siteFrom),
    };
  }

  WebResource copyWith(
          {String? url,
          Value<String?> headers = const Value.absent(),
          Value<String?> method = const Value.absent(),
          Value<String?> favicon = const Value.absent(),
          Value<String?> filekey = const Value.absent(),
          int? siteFrom}) =>
      WebResource(
        url: url ?? this.url,
        headers: headers.present ? headers.value : this.headers,
        method: method.present ? method.value : this.method,
        favicon: favicon.present ? favicon.value : this.favicon,
        filekey: filekey.present ? filekey.value : this.filekey,
        siteFrom: siteFrom ?? this.siteFrom,
      );
  WebResource copyWithCompanion(WebResourcesCompanion data) {
    return WebResource(
      url: data.url.present ? data.url.value : this.url,
      headers: data.headers.present ? data.headers.value : this.headers,
      method: data.method.present ? data.method.value : this.method,
      favicon: data.favicon.present ? data.favicon.value : this.favicon,
      filekey: data.filekey.present ? data.filekey.value : this.filekey,
      siteFrom: data.siteFrom.present ? data.siteFrom.value : this.siteFrom,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WebResource(')
          ..write('url: $url, ')
          ..write('headers: $headers, ')
          ..write('method: $method, ')
          ..write('favicon: $favicon, ')
          ..write('filekey: $filekey, ')
          ..write('siteFrom: $siteFrom')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(url, headers, method, favicon, filekey, siteFrom);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WebResource &&
          other.url == this.url &&
          other.headers == this.headers &&
          other.method == this.method &&
          other.favicon == this.favicon &&
          other.filekey == this.filekey &&
          other.siteFrom == this.siteFrom);
}

class WebResourcesCompanion extends UpdateCompanion<WebResource> {
  final Value<String> url;
  final Value<String?> headers;
  final Value<String?> method;
  final Value<String?> favicon;
  final Value<String?> filekey;
  final Value<int> siteFrom;
  final Value<int> rowid;
  const WebResourcesCompanion({
    this.url = const Value.absent(),
    this.headers = const Value.absent(),
    this.method = const Value.absent(),
    this.favicon = const Value.absent(),
    this.filekey = const Value.absent(),
    this.siteFrom = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WebResourcesCompanion.insert({
    required String url,
    this.headers = const Value.absent(),
    this.method = const Value.absent(),
    this.favicon = const Value.absent(),
    this.filekey = const Value.absent(),
    required int siteFrom,
    this.rowid = const Value.absent(),
  })  : url = Value(url),
        siteFrom = Value(siteFrom);
  static Insertable<WebResource> custom({
    Expression<String>? url,
    Expression<String>? headers,
    Expression<String>? method,
    Expression<String>? favicon,
    Expression<String>? filekey,
    Expression<int>? siteFrom,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (url != null) 'url': url,
      if (headers != null) 'headers': headers,
      if (method != null) 'method': method,
      if (favicon != null) 'favicon': favicon,
      if (filekey != null) 'file_key': filekey,
      if (siteFrom != null) 'site_from_id': siteFrom,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WebResourcesCompanion copyWith(
      {Value<String>? url,
      Value<String?>? headers,
      Value<String?>? method,
      Value<String?>? favicon,
      Value<String?>? filekey,
      Value<int>? siteFrom,
      Value<int>? rowid}) {
    return WebResourcesCompanion(
      url: url ?? this.url,
      headers: headers ?? this.headers,
      method: method ?? this.method,
      favicon: favicon ?? this.favicon,
      filekey: filekey ?? this.filekey,
      siteFrom: siteFrom ?? this.siteFrom,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (headers.present) {
      map['headers'] = Variable<String>(headers.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (favicon.present) {
      map['favicon'] = Variable<String>(favicon.value);
    }
    if (filekey.present) {
      map['file_key'] = Variable<String>(filekey.value);
    }
    if (siteFrom.present) {
      map['site_from_id'] = Variable<int>(siteFrom.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WebResourcesCompanion(')
          ..write('url: $url, ')
          ..write('headers: $headers, ')
          ..write('method: $method, ')
          ..write('favicon: $favicon, ')
          ..write('filekey: $filekey, ')
          ..write('siteFrom: $siteFrom, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _jsonMeta = const VerificationMeta('json');
  @override
  late final GeneratedColumn<String> json = GeneratedColumn<String>(
      'json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [json];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(Insertable<Setting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('json')) {
      context.handle(
          _jsonMeta, json.isAcceptableOrUnknown(data['json']!, _jsonMeta));
    } else if (isInserting) {
      context.missing(_jsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      json: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}json'])!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final String json;
  const Setting({required this.json});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['json'] = Variable<String>(json);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      json: Value(json),
    );
  }

  factory Setting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      json: serializer.fromJson<String>(json['json']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'json': serializer.toJson<String>(json),
    };
  }

  Setting copyWith({String? json}) => Setting(
        json: json ?? this.json,
      );
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      json: data.json.present ? data.json.value : this.json,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('json: $json')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => json.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Setting && other.json == this.json);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<String> json;
  final Value<int> rowid;
  const SettingsCompanion({
    this.json = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String json,
    this.rowid = const Value.absent(),
  }) : json = Value(json);
  static Insertable<Setting> custom({
    Expression<String>? json,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (json != null) 'json': json,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith({Value<String>? json, Value<int>? rowid}) {
    return SettingsCompanion(
      json: json ?? this.json,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (json.present) {
      map['json'] = Variable<String>(json.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('json: $json, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DocSitesTable docSites = $DocSitesTable(this);
  late final $WebResourcesTable webResources = $WebResourcesTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [docSites, webResources, settings];
}

typedef $$DocSitesTableCreateCompanionBuilder = DocSitesCompanion Function({
  Value<int> id,
  required String url,
  required String name,
  Value<String?> overview,
  Value<String?> favicon,
  Value<String?> version,
  required DateTime createdAt,
});
typedef $$DocSitesTableUpdateCompanionBuilder = DocSitesCompanion Function({
  Value<int> id,
  Value<String> url,
  Value<String> name,
  Value<String?> overview,
  Value<String?> favicon,
  Value<String?> version,
  Value<DateTime> createdAt,
});

final class $$DocSitesTableReferences
    extends BaseReferences<_$AppDatabase, $DocSitesTable, DocSite> {
  $$DocSitesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$WebResourcesTable, List<WebResource>>
      _webResourcesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.webResources,
          aliasName:
              $_aliasNameGenerator(db.docSites.id, db.webResources.siteFrom));

  $$WebResourcesTableProcessedTableManager get webResourcesRefs {
    final manager = $$WebResourcesTableTableManager($_db, $_db.webResources)
        .filter((f) => f.siteFrom.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_webResourcesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$DocSitesTableFilterComposer
    extends Composer<_$AppDatabase, $DocSitesTable> {
  $$DocSitesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get url => $composableBuilder(
      column: $table.url, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get overview => $composableBuilder(
      column: $table.overview, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get favicon => $composableBuilder(
      column: $table.favicon, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> webResourcesRefs(
      Expression<bool> Function($$WebResourcesTableFilterComposer f) f) {
    final $$WebResourcesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.webResources,
        getReferencedColumn: (t) => t.siteFrom,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WebResourcesTableFilterComposer(
              $db: $db,
              $table: $db.webResources,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DocSitesTableOrderingComposer
    extends Composer<_$AppDatabase, $DocSitesTable> {
  $$DocSitesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get url => $composableBuilder(
      column: $table.url, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get overview => $composableBuilder(
      column: $table.overview, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get favicon => $composableBuilder(
      column: $table.favicon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$DocSitesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DocSitesTable> {
  $$DocSitesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get overview =>
      $composableBuilder(column: $table.overview, builder: (column) => column);

  GeneratedColumn<String> get favicon =>
      $composableBuilder(column: $table.favicon, builder: (column) => column);

  GeneratedColumn<String> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> webResourcesRefs<T extends Object>(
      Expression<T> Function($$WebResourcesTableAnnotationComposer a) f) {
    final $$WebResourcesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.webResources,
        getReferencedColumn: (t) => t.siteFrom,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WebResourcesTableAnnotationComposer(
              $db: $db,
              $table: $db.webResources,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DocSitesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DocSitesTable,
    DocSite,
    $$DocSitesTableFilterComposer,
    $$DocSitesTableOrderingComposer,
    $$DocSitesTableAnnotationComposer,
    $$DocSitesTableCreateCompanionBuilder,
    $$DocSitesTableUpdateCompanionBuilder,
    (DocSite, $$DocSitesTableReferences),
    DocSite,
    PrefetchHooks Function({bool webResourcesRefs})> {
  $$DocSitesTableTableManager(_$AppDatabase db, $DocSitesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DocSitesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DocSitesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DocSitesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> url = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> overview = const Value.absent(),
            Value<String?> favicon = const Value.absent(),
            Value<String?> version = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              DocSitesCompanion(
            id: id,
            url: url,
            name: name,
            overview: overview,
            favicon: favicon,
            version: version,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String url,
            required String name,
            Value<String?> overview = const Value.absent(),
            Value<String?> favicon = const Value.absent(),
            Value<String?> version = const Value.absent(),
            required DateTime createdAt,
          }) =>
              DocSitesCompanion.insert(
            id: id,
            url: url,
            name: name,
            overview: overview,
            favicon: favicon,
            version: version,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$DocSitesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({webResourcesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (webResourcesRefs) db.webResources],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (webResourcesRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$DocSitesTableReferences
                            ._webResourcesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DocSitesTableReferences(db, table, p0)
                                .webResourcesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.siteFrom == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$DocSitesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DocSitesTable,
    DocSite,
    $$DocSitesTableFilterComposer,
    $$DocSitesTableOrderingComposer,
    $$DocSitesTableAnnotationComposer,
    $$DocSitesTableCreateCompanionBuilder,
    $$DocSitesTableUpdateCompanionBuilder,
    (DocSite, $$DocSitesTableReferences),
    DocSite,
    PrefetchHooks Function({bool webResourcesRefs})>;
typedef $$WebResourcesTableCreateCompanionBuilder = WebResourcesCompanion
    Function({
  required String url,
  Value<String?> headers,
  Value<String?> method,
  Value<String?> favicon,
  Value<String?> filekey,
  required int siteFrom,
  Value<int> rowid,
});
typedef $$WebResourcesTableUpdateCompanionBuilder = WebResourcesCompanion
    Function({
  Value<String> url,
  Value<String?> headers,
  Value<String?> method,
  Value<String?> favicon,
  Value<String?> filekey,
  Value<int> siteFrom,
  Value<int> rowid,
});

final class $$WebResourcesTableReferences
    extends BaseReferences<_$AppDatabase, $WebResourcesTable, WebResource> {
  $$WebResourcesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DocSitesTable _siteFromTable(_$AppDatabase db) =>
      db.docSites.createAlias(
          $_aliasNameGenerator(db.webResources.siteFrom, db.docSites.id));

  $$DocSitesTableProcessedTableManager? get siteFrom {
    if ($_item.siteFrom == null) return null;
    final manager = $$DocSitesTableTableManager($_db, $_db.docSites)
        .filter((f) => f.id($_item.siteFrom!));
    final item = $_typedResult.readTableOrNull(_siteFromTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$WebResourcesTableFilterComposer
    extends Composer<_$AppDatabase, $WebResourcesTable> {
  $$WebResourcesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get url => $composableBuilder(
      column: $table.url, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get headers => $composableBuilder(
      column: $table.headers, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get method => $composableBuilder(
      column: $table.method, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get favicon => $composableBuilder(
      column: $table.favicon, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get filekey => $composableBuilder(
      column: $table.filekey, builder: (column) => ColumnFilters(column));

  $$DocSitesTableFilterComposer get siteFrom {
    final $$DocSitesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.siteFrom,
        referencedTable: $db.docSites,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DocSitesTableFilterComposer(
              $db: $db,
              $table: $db.docSites,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$WebResourcesTableOrderingComposer
    extends Composer<_$AppDatabase, $WebResourcesTable> {
  $$WebResourcesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get url => $composableBuilder(
      column: $table.url, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get headers => $composableBuilder(
      column: $table.headers, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get method => $composableBuilder(
      column: $table.method, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get favicon => $composableBuilder(
      column: $table.favicon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get filekey => $composableBuilder(
      column: $table.filekey, builder: (column) => ColumnOrderings(column));

  $$DocSitesTableOrderingComposer get siteFrom {
    final $$DocSitesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.siteFrom,
        referencedTable: $db.docSites,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DocSitesTableOrderingComposer(
              $db: $db,
              $table: $db.docSites,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$WebResourcesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WebResourcesTable> {
  $$WebResourcesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get headers =>
      $composableBuilder(column: $table.headers, builder: (column) => column);

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<String> get favicon =>
      $composableBuilder(column: $table.favicon, builder: (column) => column);

  GeneratedColumn<String> get filekey =>
      $composableBuilder(column: $table.filekey, builder: (column) => column);

  $$DocSitesTableAnnotationComposer get siteFrom {
    final $$DocSitesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.siteFrom,
        referencedTable: $db.docSites,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DocSitesTableAnnotationComposer(
              $db: $db,
              $table: $db.docSites,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$WebResourcesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WebResourcesTable,
    WebResource,
    $$WebResourcesTableFilterComposer,
    $$WebResourcesTableOrderingComposer,
    $$WebResourcesTableAnnotationComposer,
    $$WebResourcesTableCreateCompanionBuilder,
    $$WebResourcesTableUpdateCompanionBuilder,
    (WebResource, $$WebResourcesTableReferences),
    WebResource,
    PrefetchHooks Function({bool siteFrom})> {
  $$WebResourcesTableTableManager(_$AppDatabase db, $WebResourcesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WebResourcesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WebResourcesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WebResourcesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> url = const Value.absent(),
            Value<String?> headers = const Value.absent(),
            Value<String?> method = const Value.absent(),
            Value<String?> favicon = const Value.absent(),
            Value<String?> filekey = const Value.absent(),
            Value<int> siteFrom = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WebResourcesCompanion(
            url: url,
            headers: headers,
            method: method,
            favicon: favicon,
            filekey: filekey,
            siteFrom: siteFrom,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String url,
            Value<String?> headers = const Value.absent(),
            Value<String?> method = const Value.absent(),
            Value<String?> favicon = const Value.absent(),
            Value<String?> filekey = const Value.absent(),
            required int siteFrom,
            Value<int> rowid = const Value.absent(),
          }) =>
              WebResourcesCompanion.insert(
            url: url,
            headers: headers,
            method: method,
            favicon: favicon,
            filekey: filekey,
            siteFrom: siteFrom,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$WebResourcesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({siteFrom = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (siteFrom) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.siteFrom,
                    referencedTable:
                        $$WebResourcesTableReferences._siteFromTable(db),
                    referencedColumn:
                        $$WebResourcesTableReferences._siteFromTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$WebResourcesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WebResourcesTable,
    WebResource,
    $$WebResourcesTableFilterComposer,
    $$WebResourcesTableOrderingComposer,
    $$WebResourcesTableAnnotationComposer,
    $$WebResourcesTableCreateCompanionBuilder,
    $$WebResourcesTableUpdateCompanionBuilder,
    (WebResource, $$WebResourcesTableReferences),
    WebResource,
    PrefetchHooks Function({bool siteFrom})>;
typedef $$SettingsTableCreateCompanionBuilder = SettingsCompanion Function({
  required String json,
  Value<int> rowid,
});
typedef $$SettingsTableUpdateCompanionBuilder = SettingsCompanion Function({
  Value<String> json,
  Value<int> rowid,
});

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get json => $composableBuilder(
      column: $table.json, builder: (column) => ColumnFilters(column));
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get json => $composableBuilder(
      column: $table.json, builder: (column) => ColumnOrderings(column));
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get json =>
      $composableBuilder(column: $table.json, builder: (column) => column);
}

class $$SettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SettingsTable,
    Setting,
    $$SettingsTableFilterComposer,
    $$SettingsTableOrderingComposer,
    $$SettingsTableAnnotationComposer,
    $$SettingsTableCreateCompanionBuilder,
    $$SettingsTableUpdateCompanionBuilder,
    (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
    Setting,
    PrefetchHooks Function()> {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> json = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SettingsCompanion(
            json: json,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String json,
            Value<int> rowid = const Value.absent(),
          }) =>
              SettingsCompanion.insert(
            json: json,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SettingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SettingsTable,
    Setting,
    $$SettingsTableFilterComposer,
    $$SettingsTableOrderingComposer,
    $$SettingsTableAnnotationComposer,
    $$SettingsTableCreateCompanionBuilder,
    $$SettingsTableUpdateCompanionBuilder,
    (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
    Setting,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DocSitesTableTableManager get docSites =>
      $$DocSitesTableTableManager(_db, _db.docSites);
  $$WebResourcesTableTableManager get webResources =>
      $$WebResourcesTableTableManager(_db, _db.webResources);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
}
