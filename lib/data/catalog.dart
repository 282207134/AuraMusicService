class Track {
  const Track(
    this.id,
    this.title,
    this.artist,
    this.art, {
    this.length = '3:35',
  });
  final String id, title, artist, art, length;
}

class MusicCollection {
  const MusicCollection(this.title, this.subtitle, this.art);
  final String title, subtitle, art;
}

abstract final class Catalog {
  static const current = Track(
    'saint',
    'Let Me Live My Life',
    'Saint Asonia',
    'saint-asonia',
  );
  static const releases = [
    Track('rescue', 'Rescue Me', 'Thirty Seconds to Mars', 'rescue'),
    Track('carry', 'Carry You', 'Fleurie, Ruelle', 'carry'),
    Track('westworld', 'Heart-Shaped Box', 'Ramin Djawadi', 'westworld'),
    Track('backbone', 'Backbone', 'Daughtry', 'backbone'),
    Track('numb', 'Numb', 'Meg Myers', 'numb'),
  ];
  static const chart = [
    Track('drake', 'Nice For What', 'Drake', 'drake', length: '3:30'),
    Track(
      'psycho',
      'Psycho',
      'Post Malone feat. Ty Dolla \$ign',
      'psycho',
      length: '3:41',
    ),
    Track(
      'camila',
      'Never Be The Same',
      'Camila Cabello',
      'camila',
      length: '3:47',
    ),
    Track('mine', 'Mine', 'Bazzi', 'mine', length: '2:11'),
    Track(
      'powerglide',
      'Powerglide',
      'Rae Sremmurd feat. Juicy J',
      'powerglide',
      length: '5:32',
    ),
    Track('kiss', 'One Kiss', 'Calvin Harris, Dua Lipa', 'backbone'),
  ];
  static const albumTracks = [
    Track('lyra', 'Lyra', 'Breaking Benjamin', 'ember', length: '0:29'),
    Track(
      'wolf',
      'Feed the Wolf',
      'Breaking Benjamin',
      'ember',
      length: '3:18',
    ),
    Track(
      'river',
      'Red Cold River',
      'Breaking Benjamin',
      'ember',
      length: '3:20',
    ),
    Track(
      'tourniquet',
      'Tourniquet',
      'Breaking Benjamin',
      'ember',
      length: '4:09',
    ),
    Track('bb-psycho', 'Psycho', 'Breaking Benjamin', 'ember', length: '3:20'),
    Track(
      'dark',
      'The Dark of You',
      'Breaking Benjamin',
      'ember',
      length: '4:15',
    ),
    Track('down', 'Down', 'Breaking Benjamin', 'ember', length: '4:02'),
    Track('torn', 'Torn in Two', 'Breaking Benjamin', 'ember', length: '4:17'),
    Track('blood', 'Blood', 'Breaking Benjamin', 'ember', length: '3:09'),
    Track(
      'save',
      'Save Yourself',
      'Breaking Benjamin',
      'ember',
      length: '3:06',
    ),
    Track(
      'close',
      'Close Your Eyes',
      'Breaking Benjamin',
      'ember',
      length: '4:01',
    ),
    Track('vega', 'Vega', 'Breaking Benjamin', 'ember', length: '1:23'),
  ];
  static const playlists = [
    MusicCollection(
      'Just rock it',
      'All the most recent and coolest new rock',
      'just-rock',
    ),
    MusicCollection('Hype', 'Listen to the most trending tracks', 'hype'),
    MusicCollection(
      "Loud new month’s",
      'Surprises and unexpected novelties',
      'album-one',
    ),
    MusicCollection(
      'Alternative',
      'The novelties of current alternative music',
      'alternative',
    ),
  ];
  static const albums = [
    MusicCollection('Epitaph', 'God Is an Astronaut', 'album-one'),
    MusicCollection('When Legends Rise', 'Godsmack', 'album-two'),
    MusicCollection('Vortex', 'Toundra', 'album-three'),
    MusicCollection('Ember', 'Breaking Benjamin', 'ember'),
  ];
  static const genres = [
    MusicCollection('Genre day', 'A little of everything', 'spring'),
    MusicCollection('Spring', 'A fresh start', 'spring'),
    MusicCollection('Soul', 'Feel every note', 'soul'),
    MusicCollection('Rock', 'Turn it up', 'rock'),
    MusicCollection('Pop', 'Your daily soundtrack', 'hype'),
    MusicCollection('Alternative', 'A different frequency', 'alternative'),
    MusicCollection('Dance', 'Keep moving', 'radio'),
    MusicCollection('Energetic', 'Find your rhythm', 'band'),
    MusicCollection('Rap', 'Words that move you', 'rap'),
    MusicCollection('Relax', 'Slow things down', 'relax'),
    MusicCollection('Classic', 'Always timeless', 'classic'),
    MusicCollection('Road', 'Take the long way', 'genres'),
  ];
  static List<Track> get allTracks => [
    current,
    ...releases,
    ...chart,
    ...albumTracks,
  ];
  static List<Track> search(String query) {
    final text = query.trim().toLowerCase();
    return text.isEmpty
        ? []
        : allTracks
              .where(
                (t) => '${t.title} ${t.artist}'.toLowerCase().contains(text),
              )
              .toList();
  }
}
