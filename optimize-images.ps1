# Create optimized-images directory if it doesn't exist
New-Item -ItemType Directory -Force -Path "optimized-images"

# Function to optimize images in a directory
function Optimize-Images {
    param (
        [string]$sourceDir,
        [string]$targetDir
    )
    
    # Create target directory if it doesn't exist
    New-Item -ItemType Directory -Force -Path $targetDir

    # Get all image files
    Get-ChildItem -Path $sourceDir -Include @("*.jpg","*.jpeg","*.png") -File -Recurse | ForEach-Object {
        $targetPath = Join-Path $targetDir $_.Name
        $placeholderPath = Join-Path $targetDir ("placeholder_" + $_.Name)
        
        # Get image dimensions
        $dimensions = magick identify -format "%w %h" $_.FullName
        $width, $height = $dimensions.Split(" ")
        
        # Determine if landscape or portrait
        $isLandscape = [int]$width -gt [int]$height
        
        # Set max width based on orientation
        $maxWidth = if ($isLandscape) { "1200" } else { "800" }
        
        # Optimize main image
        # Resize to max width while maintaining aspect ratio, quality 85%, strip metadata
        magick convert $_.FullName -resize "$maxWidth`x>" -quality 85 -strip $targetPath
        
        # Create placeholder (small, blurred version)
        # Resize to 20px width, apply Gaussian blur, then resize to match original dimensions
        magick convert $_.FullName -resize "20x>" -blur "0x8" -quality 50 -strip $placeholderPath
        
        Write-Host "Optimized: $($_.Name)"
    }
}

# Process each project directory
$projectDirs = @(
    "Farm Road 36",
    "Hong Lok Yuen",
    "Farm Road 47 D",
    "Vietnam Showroom",
    "The Reach",
    "Venice Biennale",
    "Design Competition for Transformation of Sensory Garden at Kwun Tong Promenade"
)

foreach ($dir in $projectDirs) {
    $targetDir = Join-Path "optimized-images" $dir
    Write-Host "Processing directory: $dir"
    Optimize-Images -sourceDir $dir -targetDir $targetDir
}

Write-Host "Image optimization complete. Optimized images are in the 'optimized-images' directory." 