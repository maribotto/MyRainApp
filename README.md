# MyRainApp  
[![license](https://img.shields.io/badge/license-Unlicense-blue)](https://github.com/maribotto/MyRainApp/blob/main/LICENSE)

![Screenshot](https://i.imgur.com/AsQnGf0.jpeg "Screenshot")

Like in real life, the raindrops look longer in motion.  
This app is easy on resources.
* Bites ***less than 1% of CPU and GPU*** on my 2024 M4.  
* Memory footprint is less than ***15 MB***.  
* 12 h Average Energy Impact is about ***0,01***.

![Screenshot of Activity Monitor](https://i.imgur.com/y7uzwWI.jpeg "Screenshot of Activity Monitor")

Download release, or...
---
```
git clone https://github.com/maribotto/MyRainApp && cd MyRainApp  
```
...run compile.sh...
---
```
./compile.sh
```
...or...
---
```
mkdir -p MyRainApp.app/Contents/MacOS  
mkdir -p MyRainApp.app/Contents/Resources 
```
```
cp Info.plist MyRainApp.app/Contents/  
cp AppIcon.icns MyRainApp.app/Contents/Resources/
```
```
swiftc MyRainApp.swift -o MyRainApp.app/Contents/MacOS/MyRainApp\
  -framework AppKit -framework CoreVideo -framework CoreGraphics
```
> [!TIP]
> Add to **System Settings -> General -> Login Items & Extension** to launch on login.  

Right-click on app icon to quit.
