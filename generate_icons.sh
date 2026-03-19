#!/bin/bash

# Generate app icons for OpenClaw Installer
# This script generates the required icon sizes from a source image

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  OpenClaw Icon Generator${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Check if ImageMagick is installed
if ! command -v convert &> /dev/null; then
    echo -e "${RED}Error: ImageMagick is not installed${NC}"
    echo "Install with: brew install imagemagick"
    exit 1
fi

# Icon sizes for macOS app
SIZES=(
    "16:16x16"
    "32:16x16@2x"
    "32:32x32"
    "64:32x32@2x"
    "128:128x128"
    "256:128x128@2x"
    "256:256x256"
    "512:256x256@2x"
    "512:512x512"
    "1024:512x512@2x"
)

OUTPUT_DIR="OpenClawInstaller/Assets.xcassets/AppIcon.appiconset"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Check if source icon exists
if [ -f "icon_source.png" ]; then
    SOURCE="icon_source.png"
    echo -e "${GREEN}Using icon_source.png as source${NC}"
elif [ -f "icon_source.jpg" ]; then
    SOURCE="icon_source.jpg"
    echo -e "${GREEN}Using icon_source.jpg as source${NC}"
elif [ -f "icon_source.svg" ]; then
    SOURCE="icon_source.svg"
    echo -e "${GREEN}Using icon_source.svg as source${NC}"
else
    echo -e "${YELLOW}No source icon found. Generating a default icon...${NC}"
    
    # Generate a default lobster-themed icon using ImageMagick
    convert -size 1024x1024 xc:transparent \
        -fill '#FF6B35' -draw "circle 512,512 512,100" \
        -fill '#FF4500' -draw "circle 512,512 512,150" \
        -pointsize 400 -fill 'white' -gravity center \
        -annotate +0+0 "🦞" \
        -blur 0x2 \
        "$OUTPUT_DIR/icon_512x512@2x.png"
    
    SOURCE="$OUTPUT_DIR/icon_512x512@2x.png"
    echo -e "${GREEN}Default icon generated${NC}"
fi

# Generate all required sizes
echo -e "${YELLOW}Generating icon sizes...${NC}"

for size_info in "${SIZES[@]}"; do
    IFS=':' read -r pixel_size filename <<< "$size_info"
    output_file="$OUTPUT_DIR/icon_$filename.png"
    
    echo "  Generating $filename (${pixel_size}x${pixel_size})"
    
    if [ -f "$SOURCE" ]; then
        convert "$SOURCE" -resize ${pixel_size}x${pixel_size} "$output_file"
    fi
done

echo ""
echo -e "${GREEN}Icons generated successfully!${NC}"
echo -e "${BLUE}Output directory: $OUTPUT_DIR${NC}"
echo ""
echo -e "${BLUE}Generated files:${NC}"
ls -la "$OUTPUT_DIR/"

# Instructions for custom icon
echo ""
echo -e "${YELLOW}To use a custom icon:${NC}"
echo "1. Create a 1024x1024 PNG image named 'icon_source.png'"
echo "2. Run this script again"
echo "3. Rebuild the project"
