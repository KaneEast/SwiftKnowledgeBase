#  Understanding and Managing Xcode Space
https://www.kodeco.com/19998365-understanding-and-managing-xcode-space


Over time, Xcode’s storage size bloats when considering some of its tools and directories:

- Derived data
- Caches
- Old archives
- Unavailable simulators
- Device support files

## Clearing Derived Data
~/Library/Developer/Xcode/DerivedData

When to Delete Derived Data
Everything in DerivedData is safe to delete. In fact, clearing derived data is a common trick among iOS developers to sort out pesky compilation issues.

Although deleting derived data is safe, your build will take a little longer next time while Xcode builds your project from scratch.


## Clearing the Archived Build
~/Library/Developer/Xcode/Archives

When to Clear Archives
Unlike derived data, your archives have no effect on your future build; they’re the finished product of building the app and don’t speed up compilation in any way. But this doesn’t mean that you can clear the archives folder whenever you’re low on space.

Sometimes, it can be a good idea to save old archives. If you ever need to re-release an old archive, you’ll need the .xcarchive that’s stored in the archives folder.

Also, debugging live versions of an app requires a certain file called a dSYM that’s packaged in your archive.

So a good recommendation is to not delete any archives for versions of apps that are currently live — or old archives that you might want to bring to life later!


## Clearing Simulators
Erasing Simulator Content
With your simulator open, click Device ▸ Erase All Content and Settings

Deleting Unavailable Simulators
`xcrun simctl delete unavailable`

## Device Support
~/Library/Developer/Xcode/iOS DeviceSupport

Other Platforms
~/Library/Developer/Xcode/watchOS DeviceSupport
~/Library/Developer/Xcode/tvOS DeviceSupport

## Caches
~/Library/Caches
~/Library/Caches/com.apple.dt.Xcode
pod cache clean --all


# Creating a Script
cd ~/Documents && touch clean-xcode.sh

```
#!/usr/bin/env bash

# 1
echo "Removing Derived Data..."
rm -rf ~/Library/Developer/Xcode/DerivedData/

# 2
echo "Removing Device Support..."
rm -rf ~/Library/Developer/Xcode/iOS\ DeviceSupport
rm -rf ~/Library/Developer/Xcode/watchOS\ DeviceSupport
rm -rf ~/Library/Developer/Xcode/tvOS\ DeviceSupport

# 3
echo "Removing old simulators..."
xcrun simctl delete unavailable

# 4
echo "Removing caches..."
rm -rf ~/Library/Caches/com.apple.dt.Xcode
rm -rf ~/Library/Caches/org.carthage.CarthageKit

# 5
if command -v pod  &> /dev/null
then
    # 6
    pod cache clean --all
fi

echo "Done!"

```

chmod u+x clean-xcode.sh
./clean-xcode.sh
