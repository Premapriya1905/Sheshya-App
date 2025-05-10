class CourseContent {
  final List<Map<String, dynamic>>? fill;
  final List<Map<String, dynamic>>? imageMatch;
  final List<Map<String, dynamic>>? audio;
  final List<Map<String, dynamic>>? sentence;

  CourseContent({
    this.fill,
    this.imageMatch,
    this.audio,
    this.sentence,
  });

  factory CourseContent.fromJson(Map<String, dynamic> json) {
    return CourseContent(
      fill: json['fill'] != null
          ? List<Map<String, dynamic>>.from(json['fill'])
          : null,
      imageMatch: json['image_match'] != null
          ? List<Map<String, dynamic>>.from(json['image_match'])
          : null,
      audio: json['audio'] != null
          ? List<Map<String, dynamic>>.from(json['audio'])
          : null,
      sentence: json['sentence'] != null
          ? List<Map<String, dynamic>>.from(json['sentence'])
          : null,
    );
  }
}