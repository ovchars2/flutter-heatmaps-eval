import json
import os
import gpxpy
import gpxpy.gpx

input_files_path = '<insert base path where gpx files are stored>'

files_list = os.listdir(input_files_path)

res_points_list = list()

for file in files_list:
    if(file.endswith('.gpx')):
        gpx_file = open(input_files_path + '/' + file, 'r')
        gpxdata = gpxpy.parse(gpx_file)

        for track in gpxdata.tracks:
            for segment in track.segments:
                for point in segment.points:
                    res_points_list.append([point.latitude, point.longitude])

with open(input_files_path + '/output.json', 'w') as writefile:
    json.dump(res_points_list, writefile)

print('Done!')
