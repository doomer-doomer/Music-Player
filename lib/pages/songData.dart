class SongData {
  final String id;
  final String imageUrl;
  final String title;
  final String singer;
  final String artistID;
  final List<String> genre;
  final int duration;
  final String audioUrl;
  

  SongData({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.singer,
    required this.artistID,
    required this.genre,
    required this.duration,
    required this.audioUrl,
  });
}