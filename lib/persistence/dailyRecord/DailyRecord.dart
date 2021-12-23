class DailyRecord {
  static int getDate(DateTime dateTime) {
    return dateTime.year * 1000 + dateTime.month * 10 + dateTime.day;
  }

  int date = -1;
  int morningPainScale = 0;
  int afternoonPainScale = 0;
  int nightPainScale = 0;
  int sleepingPainScale = 0;
  bool haveSeenADoctor = false;
  bool disgusted = false;
  bool vomited = false;
  bool sensitiveToLight = false;
  bool sensitiveToSound = false;
  bool headacheLikeBeating = false;
  bool headacheStartFromOneSide = false;
  bool physicalActivityAggravateHeadache = false;
  bool eyeFlashes = false;
  bool partialBlindness = false;
  int headacheHours = 0;
  int headacheMinutes = 0;
  String medicineUsage = "[]";
  bool hasMenstruation = false;
  bool hasRestlessLegSyndrome = false;

  DailyRecord(this.date);
  DailyRecord.fromMap(Map<String, dynamic> map) {
    date = map['date'];
    morningPainScale = map['morningPainScale'];
    afternoonPainScale = map['afternoonPainScale'];
    nightPainScale = map['nightPainScale'];
    sleepingPainScale = map['sleepingPainScale'];
    haveSeenADoctor = map['haveSeenADoctor'];
    disgusted = map['disgusted'];
    vomited = map['vomited'];
    sensitiveToLight = map['sensitiveToLight'];
    sensitiveToSound = map['sensitiveToSound'];
    headacheLikeBeating = map['headacheLikeBeating'];
    headacheStartFromOneSide = map['headacheStartFromOneSide'];
    physicalActivityAggravateHeadache = map['physicalActivityAggravateHeadache'];
    eyeFlashes = map['eyeFlashes'];
    partialBlindness = map['partialBlindness'];
    headacheHours = map['headacheHours'];
    headacheMinutes = map['headacheMinutes'];
    medicineUsage = map['medicineUsage'];
    hasMenstruation = map['hasMenstruation'];
    hasRestlessLegSyndrome = map['hasRestlessLegSyndrome'];
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'morningPainScale': morningPainScale,
      'afternoonPainScale': afternoonPainScale,
      'nightPainScale': nightPainScale,
      'sleepingPainScale': sleepingPainScale,
      'haveSeenADoctor': haveSeenADoctor,
      'disgusted': disgusted,
      'vomited': vomited,
      'sensitiveToLight': sensitiveToLight,
      'sensitiveToSound': sensitiveToSound,
      'headacheLikeBeating': headacheLikeBeating,
      'headacheStartFromOneSide': headacheStartFromOneSide,
      'physicalActivityAggravateHeadache': physicalActivityAggravateHeadache,
      'eyeFlashes': eyeFlashes,
      'partialBlindness': partialBlindness,
      'headacheHours': headacheHours,
      'headacheMinutes': headacheMinutes,
      'medicineUsage': medicineUsage,
      'hasMenstruation': hasMenstruation,
      'hasRestlessLegSyndrome': hasRestlessLegSyndrome
    };
  }
}
