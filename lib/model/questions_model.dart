class QuestionsModel {
  String name;
  int phone;
  int age;
  String gender;
  String course;
  int semester;
  String college;
  String disabilities;
  String previousMedicalRecords;
  int q1;
  int q2;
  int q3;
  int q4;
  int q5;
  int q6;
  int q7;
  int q8;
  int q9;
  int q10;
  int q11;
  int q12;
  int q13;
  int q14;
  int q15;
  int q16;
  int q17;
  int q18;
  int q19;
  int q20;
  int q21;
  int q22;
  int q23;
  int q24;
  int q25;

  QuestionsModel(
      {name,
      phone,
      age,
      gender,
      course,
      semester,
      college,
      disabilities,
      previousMedicalRecords,
      q1,
      q2,
      q3,
      q4,
      q5,
      q6,
      q7,
      q8,
      q9,
      q10,
      q11,
      q12,
      q13,
      q14,
      q15,
      q16,
      q17,
      q18,
      q19,
      q20,
      q21,
      q22,
      q23,
      q24,
      q25});

  QuestionsModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    age = json['age'];
    gender = json['gender'];
    course = json['course'];
    semester = json['semester'];
    college = json['college'];
    disabilities = json['disabilities'];
    previousMedicalRecords = json['previousMedicalRecords'];
    q1 = json['q1'];
    q2 = json['q2'];
    q3 = json['q3'];
    q4 = json['q4'];
    q5 = json['q5'];
    q6 = json['q6'];
    q7 = json['q7'];
    q8 = json['q8'];
    q9 = json['q9'];
    q10 = json['q10'];
    q11 = json['q11'];
    q12 = json['q12'];
    q13 = json['q13'];
    q14 = json['q14'];
    q15 = json['q15'];
    q16 = json['q16'];
    q17 = json['q17'];
    q18 = json['q18'];
    q19 = json['q19'];
    q20 = json['q20'];
    q21 = json['q21'];
    q22 = json['q22'];
    q23 = json['q23'];
    q24 = json['q24'];
    q25 = json['q25'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['phone'] = phone;
    data['age'] = age;
    data['gender'] = gender;
    data['course'] = course;
    data['semester'] = semester;
    data['college'] = college;
    data['disabilities'] = disabilities;
    data['previousMedicalRecords'] = previousMedicalRecords;
    data['q1'] = q1;
    data['q2'] = q2;
    data['q3'] = q3;
    data['q4'] = q4;
    data['q5'] = q5;
    data['q6'] = q6;
    data['q7'] = q7;
    data['q8'] = q8;
    data['q9'] = q9;
    data['q10'] = q10;
    data['q11'] = q11;
    data['q12'] = q12;
    data['q13'] = q13;
    data['q14'] = q14;
    data['q15'] = q15;
    data['q16'] = q16;
    data['q17'] = q17;
    data['q18'] = q18;
    data['q19'] = q19;
    data['q20'] = q20;
    data['q21'] = q21;
    data['q22'] = q22;
    data['q23'] = q23;
    data['q24'] = q24;
    data['q25'] = q25;
    return data;
  }
}
