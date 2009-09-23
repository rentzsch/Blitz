#!/bin/bash
cd "`dirname \"$0\"`"

if [ -z "$PROJECT_DIR" ]; then
	# Script invoked outside of Xcode, figure out environmental vars for ourself.
	TARGET_BUILD_DIR='build/Release'
	PRODUCT_NAME='Blitz'
	FULL_PRODUCT_NAME="$PRODUCT_NAME.app"
	INFOPLIST_PATH="$FULL_PRODUCT_NAME/Contents/Info.plist"
fi

PRODUCT_VERSION=`/usr/libexec/PlistBuddy -c "Print :CFBundleVersion" "$TARGET_BUILD_DIR/$INFOPLIST_PATH"`
VERSIONED_NAME="$PRODUCT_NAME-$PRODUCT_VERSION"

cd "$TARGET_BUILD_DIR"
rm *.zip *.sparkle_dsa_sig
zip -qr "$VERSIONED_NAME.zip" "$FULL_PRODUCT_NAME"

if [ -f "$HOME/Documents/releases/Blitz/dsa_priv.pem" ]; then
	`openssl dgst -sha1 -binary < "$VERSIONED_NAME.zip" | openssl dgst -dss1 -sign "$HOME/Documents/releases/Blitz/dsa_priv.pem" | openssl enc -base64 > $VERSIONED_NAME.dsaSignature`
fi
