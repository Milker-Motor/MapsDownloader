# Maps Downloader

# Description:

Make an app to download maps.

Prototype – https://www.figma.com/proto/B5GM80kuHy9c1eSImjyqL01l/Download-Maps---Test-Task?page-id=354%3A0&node-id=3919-2436&viewport=406%2C218%2C0.5&t=TkDOqcpzyvBDx6nA-1&scaling=scale-down&content-scaling=fixed&starting-point-node-id=3919%3A2436&hide-ui=1


Implement sequential map loading, one after another (with a sequential queue).
API: HTTP REST map download, e.g.: 
https://download.osmand.net/download?standard=yes&file=Denmark_europe_2.obf.zip
https://download.osmand.net/download?standard=yes&file=Germany_berlin_europe_2.obf.zip
https://download.osmand.net/download?standard=yes&file=France_corse_europe_2.obf.zip

The complete list of maps and active links is available here: https://download.osmand.net/list. This resource can be used to test the link generation algorithm

How to get the link
Map information is stored in an XML file named: regions.xml https://drive.google.com/file/d/1vu1Pf3tcIc6RxXdJF-PGaN1N1tWU6TUc/view
This file should be stored on the client
The map="yes" or map="no" attribute, along with the type="map" attribute, determines whether a map is available for download (see line 24 for a detailed description).
Append _2.obf.zip to the filename.  Capitalize the first letter of the map name in the filename. For example: 
denmark_europe_2.obf.zip becomes Denmark_europe_2.obf.zip
france_corse_europe_2.obf.zip becomes France_corse_europe_2.obf.zip


UI & Interactions
A banner displaying information about available free space on the device.
A list of European regions.

Region item: 
Display the region name
Display a download icon if the region has no nested elements
Tapping the download icon should display a progress indicator 
Change the icon color after the download is complete
Display a chevron if the region has nested items
Tapping the item should open the next screen, which displays a list of regions

Resources
Icons –  Download
Nav bar color –  #FF8800
View background color – #F2F2F3
TabelCell background color – #FFFFFF
Separator color – #CBC7D1
Text –  use Dynamic type: Body style, Typography | Apple Developer Documentation
Icon map  – default color #BEB9C5
Downloaded map icon color – #14CC9E
