# NASA Exoplanets


## Short Description
- This dataset contains information about all the exoplanets - planets beyond our solar system - discovered by NASA.


## Kaggle dataset

Link: https://www.kaggle.com/datasets/adityamishraml/nasaexoplanets/data

- **name** - Name of the planet as per given by NASA
- **distance** - distance of the planet from earth in light years
- **stellar_magnitude**: Brightness of the planet, the brighter the planet the lower number is assigned to the planet
- **planet_type**: Type of the planet, these types are derived from our solar system planets
- **discovery_year**: Year in which planet got discovered
- **mass_multiplier**: mass multiplier of the planet with mass_wrt planet
- **mass_wrt**: mass of the planet in comparison with the mass of planets of our solar system
- **radius_multiplier**: radius multiplier of the planet with radius_wrt planet
- **radius_wrt**: radius of the planet in comparison with the radius of planets of our solar system
- **orbital_radius**: Orbital radius of planets orbiting around their sun (in AU)
- **orbital_period**: Orbital period of planets orbiting around their sun (unknown unit)
- **eccentricity**: Eccentricity of planets orbiting around their sun
- **detection_method**: Method used to detect the planet

**Missing a lot of attributes**

## Retrieving Exoplanet Archive Data With Table Access Protocol

- Table: https://exoplanetarchive.ipac.caltech.edu/cgi-bin/TblView/nph-tblView?app=ExoTbls&config=PSCompPars
- Columns description: https://exoplanetarchive.ipac.caltech.edu/docs/API_PS_columns.html
- How to query: https://exoplanetarchive.ipac.caltech.edu/docs/TAP/usingTAP.html
- Query examples: 
```
https://exoplanetarchive.ipac.caltech.edu/TAP/sync?query=select+pl_name,pl_masse,ra,dec+from+ps+where+upper(soltype)+like+'%CONF%'+and+pl_masse+between+0.5+and+2.0&format=csv
```
    - select+pl_name,pl_masse,ra,dec: select the columns
    - from+ps: from the table ps
    - where+... : where the condition is met
    - format=csv: format of the output

asdf
