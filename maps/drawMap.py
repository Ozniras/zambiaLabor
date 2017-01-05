# %matplotlib inline
import matplotlib.pyplot as plt
import matplotlib.cm

from mpl_toolkits.basemap import Basemap
from matplotlib.patches import Polygon
from matplotlib.collections import PatchCollection
from matplotlib.colors import Normalize

import pandas as pd
import numpy as np

def doplot(plotWhat, title):
        
    fig, ax = plt.subplots(figsize=(20, 20))

    cmap = plt.get_cmap('Oranges')   

    pc = PatchCollection(dfPoly.shapes, zorder=2)
    norm = Normalize()

    pc.set_facecolor(cmap(norm(dfPoly[plotWhat].fillna(0).values)))
    ax.add_collection(pc)

    mapper = matplotlib.cm.ScalarMappable(norm=norm, cmap=cmap)
    mapper.set_array(dfPoly[plotWhat])

    m.drawmapboundary(fill_color = '#46bcec')
    m.fillcontinents(color='#f2f2f2', lake_color = '#46bcec')
    m.drawcountries()

    plt.colorbar(mapper, shrink=0.4)
    plt.title(title, fontsize = 25)
                                                                
    fig.savefig(plotWhat, bbox_inches='tight')
    plt.close(fig)

def prepCsv(ending, base, profession = False):

    file = '/home/ram22/dataDrive/dataProjects/povMap/zambiaLFSmapping/3_csvOutput/censuswardlabor' + \
        ending + '.csv'
    db = pd.read_csv(file)
    db.rename(columns={
        'pop12plus': 'pop' + ending.title(), 
        'lf12months': 'lf12m' + ending.title(), 
        'empl12months': 'empl12m' + ending.title()},
        inplace = True)
    db.drop(
        ['dist', 'const', 'ward', 'population', 'lf7days', 'empl7days', 'unem7days', 'unem12months'], 
        axis = 1, inplace = True)
    if profession == True:
        db.drop(['pop' + ending.title(), 'lf12m' + ending.title(),], axis = 1, inplace = True)
     
    base = base.merge(db, on = 'wardid', how = 'outer', indicator = True)
    print(base._merge.value_counts())
    base.drop('_merge', axis = 1, inplace = True)
     
    return base

def prepCsvRegion(region, ending, base, profession = False):
    file = '/home/ram22/dataDrive/dataProjects/povMap/zambiaLFSmapping/3_csvOutput/censusward' + \
        region + 'labor' + ending + '.csv'
    db = pd.read_csv(file)
    db.rename(columns={
        'population' : 'pop' + region.title() + ending.title(),
        'pop12plus' : 'pop12plus' + region.title() + ending.title(), 
        'lf12months' : 'lf12m' + region.title() + ending.title(), 
        'empl12months' : 'empl12m' + region.title() + ending.title()},
        inplace = True)
    db.drop(
        ['dist', 'const', 'ward', 'region', 'wardregionid', 'lf7days', 'empl7days', 'unem7days', 'unem12months'], 
        axis = 1, inplace = True)
    if profession == True:
        db.drop(
            ['pop' + region.title() + ending.title(), 'lf12m' + region.title() + ending.title(),], 
            axis = 1, inplace = True)
     
    base = base.merge(db, on = 'wardid', how = 'outer', indicator = True)
    print(base._merge.value_counts())
    base.drop('_merge', axis = 1, inplace = True)
     
    return base

# Prepare basemap and load ward borders into it
m = Basemap(resolution = 'h', # c, l, i, h, f or None
    projection = 'merc',
    lat_0 = 27.80, lon_0 = -13.20,
    llcrnrlon = 21.01, llcrnrlat = -18.69, urcrnrlon = 34.61, urcrnrlat = -7.56)

m.readshapefile(
    '/home/ram22/dataDrive/dataProjects/povMap/zambiaLFSmapping/0_originalData/Zambia/administrative_shapefiles/ward/WardShapefiles11June2014/Final_edits_Zambia_Wards_2014t', 
    'wards')

laborAll = pd.read_csv('/home/ram22/dataDrive/dataProjects/povMap/zambiaLFSmapping/3_csvOutput/censuswardlaborall.csv')
laborAll.drop(['dist', 'const', 'ward', 'lf7days', 'empl7days', 'unem7days', 'unem12months'], 
    axis = 1, inplace = True)

laborAll = prepCsv('1524', laborAll)
laborAll = prepCsv('2564', laborAll)
laborAll = prepCsv('male', laborAll)
laborAll = prepCsv('female', laborAll)
laborAll = prepCsv('agriculture', laborAll, profession = True)
laborAll = prepCsv('manufacture', laborAll, profession = True)
laborAll = prepCsv('otherindustry', laborAll, profession = True)
laborAll = prepCsv('mining', laborAll, profession = True)
laborAll = prepCsv('semiskilled', laborAll)
laborAll = prepCsv('unskilled', laborAll)
laborAll = prepCsv('skilled', laborAll)

laborAll = prepCsvRegion('urban', 'all', laborAll)
laborAll = prepCsvRegion('rural', 'all', laborAll)

laborAll.fillna(0, inplace = True)

#Create indicators
dataFile = laborAll
dataFile['lfRate12months'] = round(dataFile.lf12months / dataFile.pop12plus * 100, 2)

dfPoly = pd.DataFrame({
    'shapes': [Polygon(np.array(shape), True) for shape in m.wards],
    'wardid': [int(ward['ID']) for ward in m.wards_info]
    })
dfPoly = dfPoly.merge(dataFile, on = 'wardid', how = 'outer', indicator = True)

doplot('lfRate12months', 'Zambia: labor force participation (12 months)')


