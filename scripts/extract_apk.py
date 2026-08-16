#!/usr/bin/env python3
"""Extract the pieces we need from the official Bleach vs Naruto Android APK.

An AIR Android app is a zip. We need:
  * the main SWF (usually `launch.swf` at the APK root or under `assets/`)
  * the runtime asset tree (fighter/*.swf, map/*.swf, bgm/*, config/*, ...)
  * icon PNGs (to build the iOS icon set)

Usage:
    extract_apk.py input.apk output_dir
"""
import os
import re
import sys
import zipfile


def find_main_swf(names):
    for n in names:
        if n.endswith('.swf') and re.search(r'(^|/)(launch|main|app)\.swf$', n):
            return n
    for n in names:
        if n.endswith('.swf'):
            return n
    return None


def main():
    if len(sys.argv) != 3:
        print(__doc__)
        sys.exit(2)
    apk, out = sys.argv[1], sys.argv[2]

    with zipfile.ZipFile(apk) as z:
        names = z.namelist()

        main = find_main_swf(names)
        if main is None:
            print('ERROR: no launch/main swf found in APK')
            sys.exit(1)
        print(f'main swf: {main}')

        os.makedirs(out, exist_ok=True)

        # 1) main swf -> main.swf
        with open(os.path.join(out, 'main.swf'), 'wb') as f:
            f.write(z.read(main))

        # 2) asset tree -> assets/  (skip launch.swf inside assets/, skip res/meta/lib)
        asset_names = [
            n for n in names
            if n.startswith('assets/')
            and not n.endswith('/')
            and not n.replace('assets/', '', 1).startswith('launch.swf')
        ]
        for n in asset_names:
            target = os.path.join(out, 'assets', n[len('assets/'):])
            os.makedirs(os.path.dirname(target), exist_ok=True)
            with open(target, 'wb') as f:
                f.write(z.read(n))
        print(f'assets copied: {len(asset_names)} files')

        # 3) largest PNGs (likely icons) -> icons/
        pngs = [n for n in names if n.endswith('.png') and not n.startswith('assets/')]
        pngs = [n for n in pngs if 'icon' in n.lower() or 'mipmap' in n.lower() or n.startswith('res/')]
        icon_dir = os.path.join(out, 'icons')
        os.makedirs(icon_dir, exist_ok=True)
        saved = 0
        for n in sorted(pngs, key=lambda x: -z.getinfo(x).file_size)[:12]:
            base = os.path.basename(n).replace('.png', '')
            with open(os.path.join(icon_dir, f'{saved}_{base}.png'), 'wb') as f:
                f.write(z.read(n))
            saved += 1
        print(f'icons copied: {saved}')

    print(f'done -> {out}')


if __name__ == '__main__':
    main()