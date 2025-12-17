# HaLOS Cockpit Branding - System Architecture

**Last Modified**: 2025-12-17

## System Components

### Package Structure

The halos-cockpit-branding package consists of:

1. **Branding Assets** - Static files (CSS, images) that define the visual appearance
2. **Debian Package Metadata** - Control files, scripts, and build configuration
3. **Build System** - Docker container and scripts for reproducible builds
4. **Maintainer Scripts** - Pre/post install scripts for safe file management

### Component Relationships

```
Build System (Docker) → Debian Package → Target System (Cockpit)
```

The build system creates a `.deb` package containing branding assets and installation logic. When installed on a target system, maintainer scripts use `dpkg-divert` to safely replace cockpit-ws's branding files.

## Data Models

### Package Metadata

Defined in `debian/control`:
- Package name: halos-cockpit-branding
- Dependencies: cockpit
- Architecture: all
- Priority: optional
- Section: admin

### File Mappings

Defined in `debian/install`:
```
Source (in package)           → Target (on system)
etc/cockpit/branding/*        → /usr/share/cockpit/branding/debian/
```

### Diverted Files

Managed by preinst/postrm scripts:
- branding.css → branding.css.original
- logo.svg → logo.svg.original
- logo.png → logo.png.original
- apple-touch-icon.png → apple-touch-icon.png.original
- favicon.ico → favicon.ico.original

## Technology Stack

### Build Environment

- **Base Image**: Debian Trixie (stable)
- **Build Tools**: debhelper, build-essential, fakeroot, devscripts, lintian
- **Container**: Docker with docker-compose
- **Build Script**: Bash script (./run) for convenience commands

### Package Format

- **Format**: Debian Binary Package (.deb)
- **Source Format**: 3.0 (native) - defined in debian/source/format
- **Build System**: debhelper (compat level 13)

### Runtime Dependencies

- **cockpit**: The web interface being branded
- No other runtime dependencies (static files only)

## Integration Points

### Cockpit Web Interface

Cockpit loads branding from `/usr/share/cockpit/branding/debian/` on Debian-based systems. The package installs files to this location to override default branding.

### File System Integration

Uses dpkg-divert mechanism to handle file ownership conflicts:

1. **Pre-Installation**: preinst script diverts original files from cockpit-ws
2. **Installation**: New branding files installed to same location
3. **Post-Removal**: postrm script removes diversions, restoring originals

### APT Repository Integration

Package designed for publication to apt.hatlabs.fi repository:
- Can be installed via `apt install halos-cockpit-branding`
- Updates delivered through APT infrastructure
- Can be included in HaLOS metapackage dependencies

## Deployment Architecture

### Build Process

```
Developer → ./run build-deb → Docker Container → .deb Package
```

1. Developer runs build command
2. Docker container started with Debian Trixie environment
3. dpkg-buildpackage creates .deb from source files
4. Package artifacts returned to host system

### Installation Flow

```
.deb Package → dpkg → preinst → install files → postinst
```

1. Package downloaded or copied to target system
2. dpkg processes installation
3. preinst script runs: diverts cockpit-ws files
4. Package files extracted to file system
5. postinst script runs: (currently empty, reserved for future use)

### Removal Flow

```
dpkg remove → prerm → remove files → postrm
```

1. User requests package removal
2. prerm script runs: (currently empty)
3. Package files removed from file system
4. postrm script runs: removes diversions, restores originals

## Security Considerations

### File Permissions

All branding files installed with standard permissions:
- CSS and images: 0644 (readable by all, writable by root)
- No executable files in branding assets
- Maintainer scripts: 0755 (executable)

### Package Integrity

- Package signed when published to APT repository
- dpkg verifies package integrity during installation
- No network access required during installation

### Privilege Requirements

- Installation requires root privileges (standard for system packages)
- No setuid/setgid binaries
- No capability escalation

### Supply Chain

- Source files maintained in version control (git)
- Build process reproducible via Docker
- Package build logs available for audit

## File Tree Structure

```
halos-cockpit-branding/
├── .git/                    # Git repository
├── .gitignore              # Build artifacts exclusion
├── AGENTS.md               # AI assistant guide
├── README.md               # User documentation
├── run                     # Build convenience script
├── docs/
│   ├── SPEC.md            # This specification
│   └── ARCHITECTURE.md    # System architecture
├── debian/                 # Debian package files
│   ├── changelog          # Package version history
│   ├── control            # Package metadata
│   ├── copyright          # License and copyright
│   ├── install            # File installation rules
│   ├── preinst            # Pre-install script (divert files)
│   ├── postrm             # Post-removal script (restore files)
│   ├── rules              # Build rules (minimal, uses dh)
│   └── source/
│       └── format         # Source package format
├── docker/                 # Build environment
│   ├── Dockerfile.debtools
│   └── docker-compose.debtools.yml
└── etc/cockpit/branding/   # Branding assets (source)
    ├── branding.css
    ├── logo.svg
    ├── logo.png
    ├── apple-touch-icon.png
    └── favicon.ico
```

## Design Decisions

### Why dpkg-divert?

Alternative approaches considered:
1. **Install to /etc/cockpit/branding/** - Cockpit's override mechanism didn't work reliably in testing
2. **Conflicts: cockpit-ws** - Would prevent installation alongside cockpit-ws, breaking the system
3. **dpkg-divert (chosen)** - Safely replaces files while maintaining package ownership

Rationale: dpkg-divert is the standard Debian mechanism for packages that need to replace files from other packages. It's well-understood, reliable, and reversible.

### Why Docker-based builds?

Alternative approaches:
1. **Build on host** - Requires installing Debian packaging tools on macOS/other platforms
2. **CI-only builds** - Slower developer feedback, no local testing
3. **Docker (chosen)** - Consistent environment, works on all platforms, fast local builds

Rationale: Docker provides a consistent Debian Trixie environment for builds regardless of host platform, enabling developers to build and test locally before pushing.

### Why /usr/share/cockpit/branding/debian/?

Alternative paths considered:
1. **/etc/cockpit/branding/** - Configuration override path, but didn't work in testing
2. **/usr/local/** - Not standard for Debian packages
3. **/usr/share/cockpit/branding/debian/ (chosen)** - Cockpit's default distribution branding location

Rationale: This is where Cockpit expects distribution-specific branding on Debian-based systems. Installing here requires no Cockpit configuration changes.
