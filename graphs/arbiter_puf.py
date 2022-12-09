from os import listdir, chdir, getcwd
import seaborn as sns
import matplotlib.pyplot as plt
import re
import numpy as np
from sklearn.linear_model import LinearRegression
from math import ceil
import pandas as pd

def get_areas():
    cwd = getcwd()
    res = {}
    r = re.compile(r'area([0-9]+).rpt')
    r2 = re.compile(r'Total cell area:\s+([0-9]+\.[0-9]+)')
    chdir("../results/igzo/arbiter_puf")
    for f in filter(lambda x: x.startswith("area"), listdir('.')):
        m = r.match(f)
        if m is None:
            print(f"Cannot find parameter for {f}")
            exit(1)
        else:
            num = int(m[1])
        with open(f, 'r') as g:
            buf = g.read()
        m = r2.search(buf)
        if m is None:
            print(f"Cannot find total cell area in {f}")
            print(buf)
            exit(1)
        else:
            area = float(m[1])
        res[num] = area

    chdir(cwd)
    return res

def get_power():
    cwd = getcwd()
    res = {}
    r = re.compile(r'power([0-9]+).rpt')
    r2 = re.compile(r'Cell Leakage Power\s+=\s+([0-9]+\.[0-9]+)\s+([umn]W)')
    chdir("../results/igzo/arbiter_puf")
    for f in filter(lambda x: x.startswith("power"), listdir('.')):
        m = r.match(f)
        if m is None:
            print(f"Cannot find parameter for {f}")
            exit(1)
        else:
            num = int(m[1])
        with open(f, 'r') as g:
            buf = g.read()
        m = r2.search(buf)
        if m is None:
            print(f"Cannot find total cell area in {f}")
            print(buf)
            exit(1)
        else:
            area = float(m[1])
            assert(m[2] == 'uW')
        res[num] = area

    chdir(cwd)
    return res


def plot_area():
    res = get_areas()
    keys = list(res.keys())
    vals = [float(res[key]) / 1000**2 for key in keys]
    ax = sns.barplot(x=keys, y=vals)
    ax.set(xlabel='slices', ylabel='Area (mm²)')

    plt.show()

def plot_power():
    res = get_power()
    keys = list(res.keys())
    vals = [float(res[key]) / 1000 for key in keys]
    ax = sns.barplot(x=keys, y=vals)
    ax.set(xlabel='slices', ylabel='Power (mW)')
    plt.show()


def lr_area(fac=1000**2):
    res = get_areas()
    keys = np.array(list(res.keys()))
    vals = [float(res[key]) / fac for key in keys]
    keys = keys.reshape((-1, 1))
    reg = LinearRegression().fit(keys, vals)
    print(reg.coef_)
    print(reg.intercept_)
    print(reg.get_params())
    return reg


def lr_power():
    res = get_power()
    keys = np.array(list(res.keys()))
    vals = [float(res[key]) for key in keys]
    keys = keys.reshape((-1, 1))
    reg = LinearRegression().fit(keys, vals)
    print(reg.coef_)
    print(reg.intercept_)
    print(reg.get_params())
    return reg

def lprom_area(bits):
    ''' Returns area in micron squared '''
    return bits * 328.91

def lprom_power(bits):
    ''' Returns power in uW '''
    return bits * 0.33


def lprom_puf_area(area_lr, target=128):
    ns = []
    rs = []
    areas = []
    for n in range(8, 65):
        for r in range(1, 17):
            t = ceil(target / r)
            rom_area = lprom_area(t * n) / (1000.*1000.)
            puf_area = area_lr.predict([[n]])[0] * r
            total_area = puf_area + rom_area
            areas.append(total_area)
            ns.append(n)
            rs.append(r)

    ns = np.array(ns)
    rs = np.array(rs)
    areas = np.array(areas)
    fig = plt.figure()
    ax = plt.axes(projection='3d')
    ax.set_xlabel("Slices")
    ax.set_ylabel("PUFs")
    ax.set_zlabel("Area (mm²)")
    ax.plot_trisurf(ns, rs, areas)
    plt.show()

def lprom_puf_power(power_lr, target=1024):
    ns = []
    rs = []
    areas = []
    for n in range(8, 65):
        for r in range(1, 17):
            t = ceil(target / r)
            rom_area = lprom_power(t * n)
            puf_area = power_lr.predict([[n]])[0] * r
            total_area = puf_area + rom_area
            areas.append(total_area)
            ns.append(n)
            rs.append(r)

    ns = np.array(ns)
    rs = np.array(rs)
    areas = np.array(areas)
    fig = plt.figure()
    ax = plt.axes(projection='3d')
    ax.set_xlabel("Slices")
    ax.set_ylabel("PUFs")
    ax.set_zlabel("Power (uW)")
    ax.plot_trisurf(ns, rs, areas)
    plt.show()

if __name__ == '__main__':
    area_lr = lr_area()
    power_lr = lr_power()
    #lprom_puf_area(area_lr)
    lprom_puf_power(power_lr)
    # print(area_lr.predict([[64]]))
    # print(power_lr.predict([[64]]))
    # plot_area()
    # plot_power()
