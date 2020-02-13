enum OriginalLanguage { KO, EN, CN }

final originalLanguageValues = EnumValues({
    "cn": OriginalLanguage.CN,
    "en": OriginalLanguage.EN,
    "ko": OriginalLanguage.KO
});

class EnumValues<T> {
    Map<String, T> map;
    Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        if (reverseMap == null) {
            reverseMap = map.map((k, v) => new MapEntry(v, k));
        }
        return reverseMap;
    }
}