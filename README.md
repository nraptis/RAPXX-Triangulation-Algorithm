# Interplanetary
This unifies NASA and Wikipedia's coordinate systems to accurately map objects in the sky.'.</br></br>

This project uses an ever-evolving Metal rendering pipeline in a Cocoa environment to render a sky dome.</br></br>

Stars can be added using the same coordinates that are listed on Wikipedia.</br></br>
![alt text](https://raw.githubusercontent.com/nraptis/Interplanetary/refs/heads/main/ss_01.jpg)</br></br>

```
dubhe = CelestialCoordinate(ra_hours: 11, ra_minutes: 03, ra_seconds: 43.67152,
                            dec_degrees: 61, dec_minutes: 45, dec_seconds: 03.7249, dec_negative: false)
alkaid = CelestialCoordinate(ra_hours: 13, ra_minutes: 47, ra_seconds: 32.43776,
                            dec_degrees: 49, dec_minutes: 18, dec_seconds: 47.7602, dec_negative: false)
mizar = CelestialCoordinate(ra_hours: 13, ra_minutes: 23, ra_seconds: 55.54048,
                            dec_degrees: 54, dec_minutes: 55, dec_seconds: 31.2671, dec_negative: false)
alioth = CelestialCoordinate(ra_hours: 12, ra_minutes: 54, ra_seconds: 01.74959,
                            dec_degrees: 55, dec_minutes: 57, dec_seconds: 35.3627, dec_negative: false)
megrez = CelestialCoordinate(ra_hours: 12, ra_minutes: 15, ra_seconds: 25.56063,
                            dec_degrees: 57, dec_minutes: 01, dec_seconds: 57.4156, dec_negative: false)
phecda = CelestialCoordinate(ra_hours: 11, ra_minutes: 53, ra_seconds: 49.84732,
                            dec_degrees: 53, dec_minutes: 41, dec_seconds: 41.1350, dec_negative: false)
merak = CelestialCoordinate(ra_hours: 11, ra_minutes: 01, ra_seconds: 50.47654,
                            dec_degrees: 56, dec_minutes: 22, dec_seconds: 56.7339, dec_negative: false)
```

Creating 3-D "chords" from the stars to create the Big Dipper.</br></br>
<span style="font-size: larger">
Alkaid -> Mizar</br>
Mizar -> Alioth</br>
Alioth -> Megrez</br>
Megrez -> Dubhe</br>
Dubhe -> Merak</br>
Merak -> Phecda</br>
Phecda -> Megrez</br>
</span>

```
chords.append(Chord3D(coord1: alkaid, coord2: mizar))
chords.append(Chord3D(coord1: mizar, coord2: alioth))
chords.append(Chord3D(coord1: alioth, coord2: megrez))
chords.append(Chord3D(coord1: megrez, coord2: dubhe))
chords.append(Chord3D(coord1: dubhe, coord2: merak))
chords.append(Chord3D(coord1: merak, coord2: phecda))
chords.append(Chord3D(coord1: phecda, coord2: megrez))
```

This project include Jupiter's historical positions in the sky as recorded by [NASA's Horizons System](https://ssd.jpl.nasa.gov/horizons/).</br></br>
[https://ssd.jpl.nasa.gov/horizons/](https://ssd.jpl.nasa.gov/horizons/)</br></br>
![alt text](https://raw.githubusercontent.com/nraptis/Interplanetary/refs/heads/main/ss_02.jpg)</br></br>

