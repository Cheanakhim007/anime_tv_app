
class VideoPlay {
  final List source;
  final List sourceBk;
  // final List track;
  final List advertising;
  final String linkIframe;

  VideoPlay(
      this.source,
      this.sourceBk,
      // this.track,
      this.advertising,
      this.linkIframe
      );

  VideoPlay.fromJson(Map<String, dynamic> json)
    : source = json['source'] ?? [],
      sourceBk = json['source_bk'] ?? [],
      // track = json['track'] ?? [],
      advertising = json['advertising'] ?? [],
      linkIframe = json['linkiframe'] ?? ""
  ;

  @override
  String toString() {
    return 'VideoPlay{source: $source, sourceBk: $sourceBk, advertising: $advertising, linkIframe: $linkIframe}';
  }
}