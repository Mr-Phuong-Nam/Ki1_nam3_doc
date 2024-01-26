# SBDB Close-Approach Data
[SBDB Close Approach Data API (nasa.gov)](https://ssd-api.jpl.nasa.gov/doc/cad.html)
This API provides access to current close-approach data for all asteroids and comets in JPL’s [SBDB](https://ssd.jpl.nasa.gov/tools/sbdb_lookup.html) (Small-Body Database).
```
# example: from 01-01-2000 up to now
url = https://ssd-api.jpl.nasa.gov/cad.api?date-min=2000-01-01&date-max=now
```
Each CAD record is packaged as an array of fields (corresponding to those listed) in the following order:
- **des** - primary designation of the asteroid or comet (e.g., `443`, `2000 SG344`)
- **orbit_id** - orbit ID used for the close-approach computation
- **jd** - time of close-approach (JD Ephemeris Time, TDB)
- **cd** - time of close-approach (formatted calendar date/time, TDB)
- **dist** - nominal approach distance (au)
- **dist_min** - minimum (3-sigma) approach distance (au)
- **dist_max** - maximum (3-sigma) approach distance (au)
- **v_rel** - velocity relative to the approach body at close approach (km/s)
- **v_inf** - velocity relative to a massless body (km/s)
- **t_sigma_f** - 3-sigma uncertainty in the time of close-approach (formatted in days, hours, and minutes; days are not included if zero; example “`13:02`” is 13 hours 2 minutes; example “`2_09:08`” is 2 days 9 hours 8 minutes)
- **body** - name of the close-approach body (e.g., `Earth`)
    - only output if the body query parameters is set to `ALL`
- **h** - absolute magnitude H (mag)
- **diameter** - diameter of the body (km)
    - optional - only output if requested with the `diameter` query parameter
    - `null` if not known
- **diameter_sigma** - 1-sigma uncertainty in the diameter of the body (km)
    - optional - only output if requested with the `diameter` query parameter
    - `null` if not known
- **fullname** - formatted full-name/designation of the asteroid or comet
    - optional - only output if requested with the `fullname` query parameter
    - formatted with leading spaces for column alignment in monospaced font tables