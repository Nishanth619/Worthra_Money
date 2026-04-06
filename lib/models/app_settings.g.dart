// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAppSettingsCollection on Isar {
  IsarCollection<AppSettings> get appSettings => this.collection();
}

const AppSettingsSchema = CollectionSchema(
  name: r'AppSettings',
  id: -5633561779022347008,
  properties: {
    r'biometricLockEnabled': PropertySchema(
      id: 0,
      name: r'biometricLockEnabled',
      type: IsarType.bool,
    ),
    r'currencyCode': PropertySchema(
      id: 1,
      name: r'currencyCode',
      type: IsarType.string,
    ),
    r'currencySymbol': PropertySchema(
      id: 2,
      name: r'currencySymbol',
      type: IsarType.string,
    ),
    r'dailyReminderEnabled': PropertySchema(
      id: 3,
      name: r'dailyReminderEnabled',
      type: IsarType.bool,
    ),
    r'dailyReminderHour': PropertySchema(
      id: 4,
      name: r'dailyReminderHour',
      type: IsarType.long,
    ),
    r'dailyReminderMinute': PropertySchema(
      id: 5,
      name: r'dailyReminderMinute',
      type: IsarType.long,
    ),
    r'hasCompletedInitialSeed': PropertySchema(
      id: 6,
      name: r'hasCompletedInitialSeed',
      type: IsarType.bool,
    ),
    r'insightsPeriod': PropertySchema(
      id: 7,
      name: r'insightsPeriod',
      type: IsarType.string,
    ),
    r'languageCode': PropertySchema(
      id: 8,
      name: r'languageCode',
      type: IsarType.string,
    ),
    r'lastSyncAt': PropertySchema(
      id: 9,
      name: r'lastSyncAt',
      type: IsarType.string,
    ),
    r'localUserAvatarIndex': PropertySchema(
      id: 10,
      name: r'localUserAvatarIndex',
      type: IsarType.long,
    ),
    r'localUserName': PropertySchema(
      id: 11,
      name: r'localUserName',
      type: IsarType.string,
    ),
    r'themeMode': PropertySchema(
      id: 12,
      name: r'themeMode',
      type: IsarType.string,
    ),
    r'userId': PropertySchema(id: 13, name: r'userId', type: IsarType.string),
  },

  estimateSize: _appSettingsEstimateSize,
  serialize: _appSettingsSerialize,
  deserialize: _appSettingsDeserialize,
  deserializeProp: _appSettingsDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _appSettingsGetId,
  getLinks: _appSettingsGetLinks,
  attach: _appSettingsAttach,
  version: '3.3.2',
);

int _appSettingsEstimateSize(
  AppSettings object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.currencyCode.length * 3;
  bytesCount += 3 + object.currencySymbol.length * 3;
  bytesCount += 3 + object.insightsPeriod.length * 3;
  bytesCount += 3 + object.languageCode.length * 3;
  {
    final value = object.lastSyncAt;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.localUserName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.themeMode.length * 3;
  {
    final value = object.userId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _appSettingsSerialize(
  AppSettings object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.biometricLockEnabled);
  writer.writeString(offsets[1], object.currencyCode);
  writer.writeString(offsets[2], object.currencySymbol);
  writer.writeBool(offsets[3], object.dailyReminderEnabled);
  writer.writeLong(offsets[4], object.dailyReminderHour);
  writer.writeLong(offsets[5], object.dailyReminderMinute);
  writer.writeBool(offsets[6], object.hasCompletedInitialSeed);
  writer.writeString(offsets[7], object.insightsPeriod);
  writer.writeString(offsets[8], object.languageCode);
  writer.writeString(offsets[9], object.lastSyncAt);
  writer.writeLong(offsets[10], object.localUserAvatarIndex);
  writer.writeString(offsets[11], object.localUserName);
  writer.writeString(offsets[12], object.themeMode);
  writer.writeString(offsets[13], object.userId);
}

AppSettings _appSettingsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AppSettings(
    biometricLockEnabled: reader.readBoolOrNull(offsets[0]) ?? false,
    currencyCode: reader.readStringOrNull(offsets[1]) ?? 'USD',
    currencySymbol: reader.readStringOrNull(offsets[2]) ?? '\$',
    dailyReminderEnabled: reader.readBoolOrNull(offsets[3]) ?? false,
    dailyReminderHour: reader.readLongOrNull(offsets[4]) ?? 20,
    dailyReminderMinute: reader.readLongOrNull(offsets[5]) ?? 0,
    hasCompletedInitialSeed: reader.readBoolOrNull(offsets[6]) ?? false,
    id: id,
    insightsPeriod:
        reader.readStringOrNull(offsets[7]) ??
        InsightsPeriodPreferenceX.weeklyValue,
    languageCode:
        reader.readStringOrNull(offsets[8]) ??
        AppLanguagePreferenceX.defaultValue,
    lastSyncAt: reader.readStringOrNull(offsets[9]),
    localUserAvatarIndex: reader.readLongOrNull(offsets[10]) ?? 0,
    localUserName: reader.readStringOrNull(offsets[11]),
    themeMode:
        reader.readStringOrNull(offsets[12]) ?? AppThemePreferenceX.lightValue,
    userId: reader.readStringOrNull(offsets[13]),
  );
  return object;
}

P _appSettingsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 1:
      return (reader.readStringOrNull(offset) ?? 'USD') as P;
    case 2:
      return (reader.readStringOrNull(offset) ?? '\$') as P;
    case 3:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 4:
      return (reader.readLongOrNull(offset) ?? 20) as P;
    case 5:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 6:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 7:
      return (reader.readStringOrNull(offset) ??
              InsightsPeriodPreferenceX.weeklyValue)
          as P;
    case 8:
      return (reader.readStringOrNull(offset) ??
              AppLanguagePreferenceX.defaultValue)
          as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (reader.readStringOrNull(offset) ?? AppThemePreferenceX.lightValue)
          as P;
    case 13:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _appSettingsGetId(AppSettings object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _appSettingsGetLinks(AppSettings object) {
  return [];
}

void _appSettingsAttach(
  IsarCollection<dynamic> col,
  Id id,
  AppSettings object,
) {
  object.id = id;
}

extension AppSettingsQueryWhereSort
    on QueryBuilder<AppSettings, AppSettings, QWhere> {
  QueryBuilder<AppSettings, AppSettings, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AppSettingsQueryWhere
    on QueryBuilder<AppSettings, AppSettings, QWhereClause> {
  QueryBuilder<AppSettings, AppSettings, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterWhereClause> idNotEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension AppSettingsQueryFilter
    on QueryBuilder<AppSettings, AppSettings, QFilterCondition> {
  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  biometricLockEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'biometricLockEnabled',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  currencyCodeEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'currencyCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  currencyCodeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'currencyCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  currencyCodeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'currencyCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  currencyCodeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'currencyCode',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  currencyCodeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'currencyCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  currencyCodeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'currencyCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  currencyCodeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'currencyCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  currencyCodeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'currencyCode',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  currencyCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'currencyCode', value: ''),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  currencyCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'currencyCode', value: ''),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  currencySymbolEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'currencySymbol',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  currencySymbolGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'currencySymbol',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  currencySymbolLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'currencySymbol',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  currencySymbolBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'currencySymbol',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  currencySymbolStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'currencySymbol',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  currencySymbolEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'currencySymbol',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  currencySymbolContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'currencySymbol',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  currencySymbolMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'currencySymbol',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  currencySymbolIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'currencySymbol', value: ''),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  currencySymbolIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'currencySymbol', value: ''),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  dailyReminderEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'dailyReminderEnabled',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  dailyReminderHourEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'dailyReminderHour', value: value),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  dailyReminderHourGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'dailyReminderHour',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  dailyReminderHourLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'dailyReminderHour',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  dailyReminderHourBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'dailyReminderHour',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  dailyReminderMinuteEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'dailyReminderMinute', value: value),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  dailyReminderMinuteGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'dailyReminderMinute',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  dailyReminderMinuteLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'dailyReminderMinute',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  dailyReminderMinuteBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'dailyReminderMinute',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  hasCompletedInitialSeedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'hasCompletedInitialSeed',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  insightsPeriodEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'insightsPeriod',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  insightsPeriodGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'insightsPeriod',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  insightsPeriodLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'insightsPeriod',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  insightsPeriodBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'insightsPeriod',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  insightsPeriodStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'insightsPeriod',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  insightsPeriodEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'insightsPeriod',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  insightsPeriodContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'insightsPeriod',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  insightsPeriodMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'insightsPeriod',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  insightsPeriodIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'insightsPeriod', value: ''),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  insightsPeriodIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'insightsPeriod', value: ''),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  languageCodeEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'languageCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  languageCodeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'languageCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  languageCodeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'languageCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  languageCodeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'languageCode',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  languageCodeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'languageCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  languageCodeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'languageCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  languageCodeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'languageCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  languageCodeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'languageCode',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  languageCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'languageCode', value: ''),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  languageCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'languageCode', value: ''),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  lastSyncAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'lastSyncAt'),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  lastSyncAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'lastSyncAt'),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  lastSyncAtEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'lastSyncAt',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  lastSyncAtGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lastSyncAt',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  lastSyncAtLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lastSyncAt',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  lastSyncAtBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lastSyncAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  lastSyncAtStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'lastSyncAt',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  lastSyncAtEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'lastSyncAt',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  lastSyncAtContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'lastSyncAt',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  lastSyncAtMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'lastSyncAt',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  lastSyncAtIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lastSyncAt', value: ''),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  lastSyncAtIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'lastSyncAt', value: ''),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  localUserAvatarIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'localUserAvatarIndex',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  localUserAvatarIndexGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'localUserAvatarIndex',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  localUserAvatarIndexLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'localUserAvatarIndex',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  localUserAvatarIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'localUserAvatarIndex',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  localUserNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'localUserName'),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  localUserNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'localUserName'),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  localUserNameEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'localUserName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  localUserNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'localUserName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  localUserNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'localUserName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  localUserNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'localUserName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  localUserNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'localUserName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  localUserNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'localUserName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  localUserNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'localUserName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  localUserNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'localUserName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  localUserNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'localUserName', value: ''),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  localUserNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'localUserName', value: ''),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  themeModeEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'themeMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  themeModeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'themeMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  themeModeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'themeMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  themeModeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'themeMode',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  themeModeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'themeMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  themeModeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'themeMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  themeModeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'themeMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  themeModeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'themeMode',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  themeModeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'themeMode', value: ''),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  themeModeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'themeMode', value: ''),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition> userIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'userId'),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  userIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'userId'),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition> userIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'userId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  userIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'userId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition> userIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'userId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition> userIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'userId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  userIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'userId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition> userIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'userId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition> userIdContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'userId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition> userIdMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'userId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'userId', value: ''),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
  userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'userId', value: ''),
      );
    });
  }
}

extension AppSettingsQueryObject
    on QueryBuilder<AppSettings, AppSettings, QFilterCondition> {}

extension AppSettingsQueryLinks
    on QueryBuilder<AppSettings, AppSettings, QFilterCondition> {}

extension AppSettingsQuerySortBy
    on QueryBuilder<AppSettings, AppSettings, QSortBy> {
  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
  sortByBiometricLockEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'biometricLockEnabled', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
  sortByBiometricLockEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'biometricLockEnabled', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortByCurrencyCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currencyCode', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
  sortByCurrencyCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currencyCode', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortByCurrencySymbol() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currencySymbol', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
  sortByCurrencySymbolDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currencySymbol', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
  sortByDailyReminderEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyReminderEnabled', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
  sortByDailyReminderEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyReminderEnabled', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
  sortByDailyReminderHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyReminderHour', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
  sortByDailyReminderHourDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyReminderHour', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
  sortByDailyReminderMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyReminderMinute', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
  sortByDailyReminderMinuteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyReminderMinute', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
  sortByHasCompletedInitialSeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasCompletedInitialSeed', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
  sortByHasCompletedInitialSeedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasCompletedInitialSeed', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortByInsightsPeriod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'insightsPeriod', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
  sortByInsightsPeriodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'insightsPeriod', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortByLanguageCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'languageCode', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
  sortByLanguageCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'languageCode', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortByLastSyncAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncAt', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortByLastSyncAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncAt', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
  sortByLocalUserAvatarIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localUserAvatarIndex', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
  sortByLocalUserAvatarIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localUserAvatarIndex', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortByLocalUserName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localUserName', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
  sortByLocalUserNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localUserName', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortByThemeMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeMode', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortByThemeModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeMode', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension AppSettingsQuerySortThenBy
    on QueryBuilder<AppSettings, AppSettings, QSortThenBy> {
  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
  thenByBiometricLockEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'biometricLockEnabled', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
  thenByBiometricLockEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'biometricLockEnabled', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByCurrencyCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currencyCode', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
  thenByCurrencyCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currencyCode', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByCurrencySymbol() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currencySymbol', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
  thenByCurrencySymbolDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currencySymbol', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
  thenByDailyReminderEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyReminderEnabled', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
  thenByDailyReminderEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyReminderEnabled', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
  thenByDailyReminderHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyReminderHour', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
  thenByDailyReminderHourDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyReminderHour', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
  thenByDailyReminderMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyReminderMinute', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
  thenByDailyReminderMinuteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyReminderMinute', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
  thenByHasCompletedInitialSeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasCompletedInitialSeed', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
  thenByHasCompletedInitialSeedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasCompletedInitialSeed', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByInsightsPeriod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'insightsPeriod', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
  thenByInsightsPeriodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'insightsPeriod', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByLanguageCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'languageCode', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
  thenByLanguageCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'languageCode', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByLastSyncAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncAt', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByLastSyncAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncAt', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
  thenByLocalUserAvatarIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localUserAvatarIndex', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
  thenByLocalUserAvatarIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localUserAvatarIndex', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByLocalUserName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localUserName', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
  thenByLocalUserNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localUserName', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByThemeMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeMode', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByThemeModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeMode', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension AppSettingsQueryWhereDistinct
    on QueryBuilder<AppSettings, AppSettings, QDistinct> {
  QueryBuilder<AppSettings, AppSettings, QDistinct>
  distinctByBiometricLockEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'biometricLockEnabled');
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct> distinctByCurrencyCode({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currencyCode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct> distinctByCurrencySymbol({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'currencySymbol',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct>
  distinctByDailyReminderEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dailyReminderEnabled');
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct>
  distinctByDailyReminderHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dailyReminderHour');
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct>
  distinctByDailyReminderMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dailyReminderMinute');
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct>
  distinctByHasCompletedInitialSeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hasCompletedInitialSeed');
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct> distinctByInsightsPeriod({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'insightsPeriod',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct> distinctByLanguageCode({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'languageCode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct> distinctByLastSyncAt({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastSyncAt', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct>
  distinctByLocalUserAvatarIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'localUserAvatarIndex');
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct> distinctByLocalUserName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'localUserName',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct> distinctByThemeMode({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'themeMode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct> distinctByUserId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId', caseSensitive: caseSensitive);
    });
  }
}

extension AppSettingsQueryProperty
    on QueryBuilder<AppSettings, AppSettings, QQueryProperty> {
  QueryBuilder<AppSettings, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AppSettings, bool, QQueryOperations>
  biometricLockEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'biometricLockEnabled');
    });
  }

  QueryBuilder<AppSettings, String, QQueryOperations> currencyCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currencyCode');
    });
  }

  QueryBuilder<AppSettings, String, QQueryOperations> currencySymbolProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currencySymbol');
    });
  }

  QueryBuilder<AppSettings, bool, QQueryOperations>
  dailyReminderEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dailyReminderEnabled');
    });
  }

  QueryBuilder<AppSettings, int, QQueryOperations> dailyReminderHourProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dailyReminderHour');
    });
  }

  QueryBuilder<AppSettings, int, QQueryOperations>
  dailyReminderMinuteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dailyReminderMinute');
    });
  }

  QueryBuilder<AppSettings, bool, QQueryOperations>
  hasCompletedInitialSeedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hasCompletedInitialSeed');
    });
  }

  QueryBuilder<AppSettings, String, QQueryOperations> insightsPeriodProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'insightsPeriod');
    });
  }

  QueryBuilder<AppSettings, String, QQueryOperations> languageCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'languageCode');
    });
  }

  QueryBuilder<AppSettings, String?, QQueryOperations> lastSyncAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastSyncAt');
    });
  }

  QueryBuilder<AppSettings, int, QQueryOperations>
  localUserAvatarIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'localUserAvatarIndex');
    });
  }

  QueryBuilder<AppSettings, String?, QQueryOperations> localUserNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'localUserName');
    });
  }

  QueryBuilder<AppSettings, String, QQueryOperations> themeModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'themeMode');
    });
  }

  QueryBuilder<AppSettings, String?, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }
}
