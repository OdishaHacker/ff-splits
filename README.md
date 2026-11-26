# ff-splits

Free Fire split APK packages consumed by the **ODISHA Loader** download
system (`com.Odisha.Loader` → `utils.Downtwo`).

> Repo me bade binary files (`ffm.zip` / `ffi.zip`) **GitHub Releases** ke
> through serve hote hain — `git push` ka 100 MB hard-limit cross hota hai,
> isliye `raw.githubusercontent.com` use nahi hota. Releases 2 GB per asset
> allow karti hai aur public repo ke liye download URL bina token ke kaam
> karta hai (Downtwo.java ka manual redirect loop + Range resume dono
> support karte hain).

## Release `v1.134.1` — assets

| Asset | Game | Package | Contents |
|---|---|---|---|
| `ffm.zip` | Free Fire MAX | `com.dts.freefiremax` | `base.apk` + `split_config.arm64_v8a.apk` (+ asset pack) |
| `ffi.zip` | Free Fire India | `com.garena.game.ffi` | `base.apk` + `split_config.arm64_v8a.apk` (+ asset pack) |
| `ffm.json` | meta sidecar | — | `{"v":"1.134.1","sha256":"…"}` |
| `ffi.json` | meta sidecar | — | `{"v":"1.134.1","sha256":"…"}` |

## Download URLs (used by `Downtwo.Link(pkg)` in `main.cpp`)

```
https://github.com/OdishaHacker/ff-splits/releases/download/v1.134.1/ffm.zip
https://github.com/OdishaHacker/ff-splits/releases/download/v1.134.1/ffi.zip
```

Meta sidecar URL Downtwo khud derive karta hai:
`<zip-url without .zip> + ".json"` →
`.../releases/download/v1.134.1/ffi.json` etc.

## ZIP structure requirement

Files ZIP ke **root** par hone chahiye (koi nested folder nahi) —
`Downtwo.extractAll()` unhe sidha `filesDir/splits/<pkg>/` me likhta hai.

Required entries:

- `base.apk`
- `split_config.arm64_v8a.apk`
- `split_asset_pack_install_time.apk`  (optional, harmless agar present ho)

Encryption optional. Agar encrypted ho to password `PRIVATE_SRC_FILES`
 hona chahiye (`Downtwo.ZIP_PASSWORD`). Plain zip bhi fine hai.

> Trick: APKMirror se mila hua `.apks` / `.xapk` file already exactly
> yahi structure rakhta hai — bas usko `ffi.zip` / `ffm.zip` me rename
> karke upload kar do.

## Naya FF version aaye to update kaise karein

1. Nayi zip banao / rename karo (naye `.apks` se).
2. `./scripts/make_meta.sh ffi.zip 1.134.2  >  ffi.json`
3. Release tag `v1.134.2` banao, `ffm.zip` + `ffi.zip` + dono `.json`
   upload karo.
4. `main.cpp` me `Java_com_Odisha_Loader_utils_Downtwo_Link` ke 2 URLs
   naye tag (`v1.134.2`) me update kar do, loader rebuild.

## `make_meta.sh` ka use

```bash
chmod +x scripts/make_meta.sh
./scripts/make_meta.sh ffi.zip 1.134.1  >  ffi.json
./scripts/make_meta.sh ffm.zip 1.134.1  >  ffm.json
```

## Warnings

- Public repo me Garena ke copyrighted APK files → DMCA takedown ka real
  risk hai. Long-term me apne khud ke server (jaise `viku.urlking.in`)
  pe host karna zyada stable rahega — `Downtwo.resolveUrl()` pehle
  `loader_ui_prefs → splits_url_<pkg>` override check karta hai, wahan
  apna URL daal do, native `Link()` skip ho jayega.
- GitHub EULA ke hisaab se repo ko pure "binary CDN" ki tarah use karna
  policy violation maana jaata hai agar traffic bahut high ho.
