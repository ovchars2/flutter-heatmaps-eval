# map_heatmap

Google Maps / Leaflet Heatmap Layers

## To build

Flutter 3.10.5 (.fvm config available)

Add API key to manifest `android/app/src/main/AndroidManifest.xml` :

```xml

<meta-data android:name="com.google.android.geo.API_KEY" android:value="Insert API Key here" />
```

`[fvm] flutter run`
`[fvm] flutter build apk`

iOS not supported =(

### Helpful tools
Coordinates list JSON can be created from a bunch of `.gpx` files using `gpx_to_latlng_list.py`
insert the base path inside the script if you want to run it:
```
input_files_path = '<insert base path where gpx files are stored>'
```
