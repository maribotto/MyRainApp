# 1. Create the .app folder structure
# (This will delete your old app bundle if it exists)
rm -rf MyRainApp.app
mkdir -p MyRainApp.app/Contents/MacOS
mkdir -p MyRainApp.app/Contents/Resources

# 2. Copy the Info.plist file into the bundle
cp Info.plist MyRainApp.app/Contents/

# 3. (NEW STEP) Copy the icon file into the Resources folder
echo "Looking for AppIcon.icns..."
if [ -f "AppIcon.icns" ]; then
    cp AppIcon.icns MyRainApp.app/Contents/Resources/
    echo "Icon found and copied."
else
    echo "Warning: AppIcon.icns not found. Building without an icon."
fi

# 4. Compile and link the Swift code directly into the bundle
swiftc MyRainApp.swift \
       -o MyRainApp.app/Contents/MacOS/MyRainApp \
       -framework AppKit \
       -framework CoreVideo \
       -framework CoreGraphics

echo "Done! App bundle 'MyRainApp.app' created."