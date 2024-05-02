----------
# _DEPRECATION NOTICE_

_[ACCESS-NRI](https://www.access-nri.org.au/) has taken on responsibility for ongoing support of ACCESS-OM2, so this repository is not being updated and will eventually be archived._

_**New ACCESS-OM2 experiments and code development should use the latest code release from [ACCESS-NRI/ACCESS-OM2](https://github.com/ACCESS-NRI/ACCESS-OM2) and configurations from [ACCESS-NRI/access-om2-configs](https://github.com/ACCESS-NRI/access-om2-configs), and all new issues should be posted on one of those repositories.**_

-----------

# 01deg_jra55_iaf with BGC
Standard configuration for 0.1 degree [ACCESS-OM2](https://github.com/COSIMA/access-om2) experiment (ACCESS-OM2-01) with JRA55-do interannual forcing (IAF) and coupled biogeochemistry in the ocean and sea ice.

This is the BGC version, on the `master+bgc` branch. For the physics-only version (no BGC), use the `master` branch.

This BGC setup includes both ocean and sea ice BGC. To turn off the sea ice BGC and have BGC only in the ocean, set `skl_bgc = .false.` in `ice/cice_input.nml`.

For usage instructions, see the [ACCESS-OM2 wiki](https://github.com/COSIMA/access-om2/wiki).

Run length and timestep are set in `accessom2.nml`. The configuration is supplied with a 300s timestep which is stable for a startup from rest, but very slow. **After the model has equilibrated for a few months you should increase the timestep to 450s and then to 540s** for improved throughput. You may even find it runs stably at 600s.

**NOTE:** All ACCESS-OM2 model components and configurations are undergoing continual improvement. We strongly recommend that you "watch" this repo (see button at top of screen; ask to be notified of all conversations) and also watch [ACCESS-OM2](https://github.com/COSIMA/access-om2), all the [component models](https://github.com/COSIMA/access-om2/tree/master/src), and [payu](https://github.com/payu-org/payu) to be kept informed of updates, problems and bug fixes as they arise.

## Conditions of use

We request that users of this or other ACCESS-OM2 model code:
1. consider citing Kiss et al. (2020) ([http://doi.org/10.5194/gmd-13-401-2020](http://doi.org/10.5194/gmd-13-401-2020))
2. include an acknowledgement such as the following:
*The authors thank the Consortium for Ocean-Sea Ice Modelling in Australia (COSIMA; [http://www.cosima.org.au](http://www.cosima.org.au)) for making the ACCESS-OM2 suite of models available at [https://github.com/COSIMA/access-om2](https://github.com/COSIMA/access-om2).*
3. let us know of any publications which use these models or data so we can add them to [our list](https://scholar.google.com/citations?hl=en&user=inVqu_4AAAAJ).
