# HaLOS Cockpit Branding - Agentic Coding Guide

**LAST MODIFIED**: 2025-12-17

**Document Purpose**: Guide for AI assistants working on halos-cockpit-branding.

## For Agentic Coding: Use the HaLOS Workspace

**IMPORTANT**: When using Claude Code or other AI assistants, work from the halos-distro workspace repository for full context across all HaLOS repositories.

```bash
# Work from workspace
cd halos-distro/
# This repo is available as: halos-cockpit-branding/
```

**Development Workflows**: See `halos-distro/docs/` folder:
- `halos-distro/docs/DEVELOPMENT_WORKFLOW.md` - Detailed Claude Code workflows
- `halos-distro/docs/PROJECT_PLANNING_GUIDE.md` - Project planning process
- `halos-distro/docs/IMPLEMENTATION_CHECKLIST.md` - Implementation checklist

## About This Project

Custom HaLOS branding package for the Cockpit web interface. Provides Hat Labs logo, colors, and branding to replace default Debian branding.

## Git Workflow Policy

**MANDATORY**: PRs must ALWAYS have all checks passing before merging. No exceptions.

**Branch Workflow:** Never push to main directly - always use feature branches and PRs.

## Quick Start

```bash
# Build package
./run build-debtools  # First time only
./run build-deb

# Check quality
./run lint-deb

# Clean build artifacts
./run clean
```

## Project Structure

```
halos-cockpit-branding/
├── docs/
│   ├── SPEC.md           # Technical specification
│   └── ARCHITECTURE.md   # System architecture
├── debian/               # Debian package files
│   ├── control          # Package metadata
│   ├── changelog        # Package changelog
│   ├── copyright        # License information
│   ├── install          # File installation rules
│   ├── preinst          # Pre-install script (dpkg-divert)
│   ├── postrm           # Post-remove script (cleanup)
│   ├── rules            # Build rules
│   └── source/format    # Source format
├── docker/              # Build container
│   ├── Dockerfile.debtools
│   └── docker-compose.debtools.yml
├── etc/cockpit/branding/  # Branding source files
│   ├── branding.css
│   ├── logo.svg
│   ├── logo.png
│   ├── apple-touch-icon.png
│   └── favicon.ico
└── run                  # Build script

