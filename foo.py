
import numpy as np
import xarray as xr
import rioxarray
from rasterio.enums import Resampling
import sys

np.set_printoptions(threshold=np.inf, suppress=True, linewidth=np.inf)

print("LIME: I am at the module scope. Run only at first call")

def empty_function(STATE):
    return

def bar(STATE):
    # this code runs every function call.
    M = STATE.get("MICBIMP", np.nan)
    E = STATE.get("EICBIMP", np.nan)
    print("LIME_py0: ", M)
    print("LIME_py1: ", E)
    E = E + 1
    STATE["EICBIMP"] = E

def var_2_greenland(STATE):
    tg = STATE.get("tg", np.nan)
    tg1 = tg[:,:,0]
    # print("LIME_py0:", tg)
    print("LIME_py0:", tg1.shape, file=sys.stderr)
    # print("LIME_py0:", type(tg))
    # print("LIME_py0:", type(tg[0,0,0]))

    lat=np.arange(-90, 90, 3.75) + 2
    lon=np.arange(-180, 180, 5) + 2.5
    da = xr.DataArray(tg1,
                      coords={'lat': lat,
                              'lon': lon},
                      dims=["lat", "lon"])
    ds = da.to_dataset(name='tgrnd')
    ds = ds.rio.write_crs('4326')
    
    print("LIME: ", ds, file=sys.stderr)
    
    GL = ds.where( (ds['lat'] > 60) &
                   (ds['lat'] < 82) &
                   (ds['lon'] < 0) &
                   (ds['lon'] > -70),
                   drop = True)
    print("LIME GL SUBSET: ", GL, file=sys.stderr)
    # print("LIME GL SUBSET: ", GL['tgrnd'].values.T, file=sys.stderr)
    #print("LIME GL SUBSET LAT: ", GL['lat'].values, file=sys.stderr)
    # GL = GL.rename({'lat':'y','lon':'x'}).rio.reproject('EPSG:3413')
    GL = GL\
        .rio\
        .set_spatial_dims('lon','lat')\
        .rio\
        .reproject('EPSG:3413', \
                   resolution=100000, \
                   resampling=Resampling.nearest)
    
    print("LIME GL REPROJECT: ", GL, file=sys.stderr)
    # print("LIME GL REPROJECT: ", GL['tgrnd'].values, file=sys.stderr)
    #print("LIME GL REPROJECT LAT: ", GL['y'].values, file=sys.stderr)

    # AQ = ds.where( (ds['lat'] < -60) )\
    #        .rio.reproject('EPSG:3013')


    # print("LIME: ", GL)
    # print("LIME: ", AQ)
    # GL.to_netcdf('GL.nc')
