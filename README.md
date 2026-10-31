# fbv (FrameBuffer Viewer)

A simple, fast, and ultra-lightweight utility to view images directly on a Linux framebuffer device (`/dev/fb0`). Originally created in 2000 because no suitable tool existed, `fbv` remains ideal for minimal runtime environments like **initramfs**, embedded system displays, and recovery consoles.

---

## 🚀 1. NEW: Static Build Mode (Recommended for Initramfs)

For modern Linux systems and early-boot deployment layouts (such as a custom initramfs splash screen), you can bypass the legacy `./configure` scripts entirely. Using the specialized `build_static.sh` automation script compiles a **100% standalone static binary** utilizing standard GCC.

### Prerequisites (Host System packages)
Ensure your development environment contains the essential static architecture development archives:
```bash
# On Ubuntu / Debian / Mint
sudo apt update && sudo apt install build-essential pkgconf libpng-dev libjpeg-dev libgif-dev zlib1g-dev

# On Alpine Linux
apk add build-base pkgconf libpng-dev jpeg-dev libgif-dev zlib-dev libpng-static jpeg-static zlib-static
```

### Compilation Workflow
Simply run the compilation wrapper directly out of your workspace repository root directory:
```bash
# Build the regular unstripped static profile
./build_static.sh

# Build and automatically strip debug symbols (Optimized for tight RAM space)
./build_static.sh --strip
```
Your ready-to-run portable executable asset will be generated and packaged straight into your local directory structure at: `./build/bin/fbv`.

---

## 🛠️ 2. Core Legacy Requirements

If you intend to run a standard dynamic system build instead of a static compile matrix, your system requires access to the following underlying target image decoding frameworks:
* **Linux Kernel:** Configured to expose the native framebuffer interface (`/dev/fb0` or `/dev/fb/0`).
* **libungif / libgif:** For GIF file decoding.
* **libjpeg:** For JPEG image rendering.
* **libpng:** For standard PNG decompression support.

---

## 📦 3. Legacy Dynamic Installation

To perform a classic system-wide shared dynamic linkage installation path:
```bash
./configure
make
sudo make install
```

---

## 📖 4. Usage

Running `fbv` without any trailing command arguments will spit a clean help dashboard message directly onto your terminal.

```bash
# Fit an image to your full native monitor resolution size
fbv -g /path/to/your/image.png

# Cycle an automated image directory loop animation slideshow (time interval in ms)
fbv --slideshow 3000 /path/to/images_folder/
```

### Core Keybindings
When an active image container pipeline is rendering inside a terminal screen frame, use these quick-access keyboard operations:
* `Space` or `>` : Advance forward to show the next directory image asset.
* `<` : Fall backward to the previous image.
* `+` / `-` : Dynamic image zooming modification inputs.
* `Arrow Keys` : Pan and navigate coordinates across large imagery matrices.
* `q` : Instantly quit the viewer application loop context.

---

## 👥 5. Authors & Community

* **Tomasz 'smoku' Sterna** – <tomek@smoczy.net>
* **Mateusz 'mteg' Golicz** – <mtg@elsat.net.pl>

### Acknowledgements
* **The fbset authors** – Core display interface code structures inside `fb_display.c` are derived from their foundation rules.
* **Nat Ersoz** – Line stride handling suggestions and layout patch stability revisions.
* **Mauro Meneghin** – Transparent structural GIF rendering processing logic layer.
* **Marcin 'Piaskowy' Zieba** – Early command flag options logic parser and initial port stability validations.
* **Mariusz 'Ma-rYu-sH' Witkowski** – Core test parameters verification and Alpha blending channel integration.

---

## 📄 6. License

This entire project framework is distributed as open-source code package structures managed under the rules of the **GNU General Public License (GPL) Version 2**. For full license condition guidelines, read your local copy or visit the official GNU organization repository portal at [gnu.org](http://gnu.org).
