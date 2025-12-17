# HaLOS Cockpit Branding - Technical Specification

**Last Modified**: 2025-12-17

## Project Overview

Custom branding package for the Cockpit web interface that replaces default Debian branding with Hat Labs/HaLOS branding. Packaged as a Debian `.deb` package for easy distribution and installation on HaLOS systems.

## Goals

- Provide consistent HaLOS branding across all Cockpit installations
- Package branding files for easy installation and distribution
- Handle conflicts with existing cockpit-ws package files safely
- Integrate seamlessly into HaLOS image builds
- Follow Debian packaging best practices

## Core Features

### Branding Files

The package provides the following branding assets:

- **CSS Styling**: Custom CSS that defines HaLOS branding colors and layout
- **Logo (SVG)**: Scalable vector graphics logo as primary format
- **Logo (PNG)**: Raster fallback logo at 100x100 pixels
- **Apple Touch Icon**: iOS home screen icon at 180x180 pixels
- **Favicon**: Browser tab icon in ICO format

### Visual Branding Elements

- **Badge (#badge)**: Hat Labs logo displayed in upper-right corner of login screen (100x100px)
- **Brand Text (#brand)**: "HaLOS" displayed prominently above login fields
- **Accent Color**: Custom blue-gray color (#576679) matching Hat Labs brand identity

## Technical Requirements

### Packaging

- Package name: `halos-cockpit-branding`
- Architecture: `all` (no platform-specific binaries)
- Depends on: `cockpit` package
- License: MIT
- Maintainer: Matti Airas <matti.airas@hatlabs.fi>

### File Installation

- Install location: `/usr/share/cockpit/branding/debian/`
- Source files from: `etc/cockpit/branding/` in package
- Use `dpkg-divert` to safely replace files owned by cockpit-ws package

### Build System

- Docker-based build environment for consistency
- Debian Trixie base image
- Standard Debian packaging tools (debhelper, devscripts, lintian)
- Build script (`./run`) for convenience

## Key Constraints

### File Ownership Conflicts

Cockpit's default branding files are owned by the cockpit-ws package. To replace them without causing dpkg conflicts, the package must:

- Use `dpkg-divert` in preinst script to move original files aside
- Install replacement files to the same location
- Clean up diversions in postrm script when package is removed

### Cockpit Integration

Cockpit loads branding from `/usr/share/cockpit/branding/debian/` by default on Debian-based systems. Files must be installed to this exact location to be recognized by Cockpit without configuration changes.

## Non-Functional Requirements

### Build Quality

- Package must build cleanly without errors
- Lintian checks should pass (except expected warning about ITP bug for non-Debian packages)
- All files should have correct permissions

### Installation

- Package must install without errors
- Must handle upgrades and downgrades gracefully
- Removal should restore original cockpit-ws branding files

### Testing

- Package must be tested on actual Cockpit installation
- Branding must be visible after installation and Cockpit restart
- Package removal must restore original branding

## Out of Scope

### Future Enhancements

- Dynamic branding configuration (colors, logos) - current version uses fixed branding
- Multiple branding themes - only HaLOS branding provided
- Automatic theme switching - no dark mode support
- Custom login screen layouts - only modifies existing elements

### Not Included

- Modifications to Cockpit functionality - only visual branding
- Custom Cockpit modules - separate concern
- Branding for other web interfaces - Cockpit only
