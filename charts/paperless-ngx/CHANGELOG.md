# Changelog

## [1.0.0](https://github.com/eopo/helm/compare/paperless-ngx-v0.3.1...paperless-ngx-v1.0.0) (2026-08-10)


### ⚠ BREAKING CHANGES

* **charts:** upgrade charts to `0.2.0`
* **charts/paperless-ngx:** finish Paperless-NGX chart version `0.1.0`

### Features

* **charts/paperless-ngx:** finish Paperless-NGX chart version `0.1.0` ([900110b](https://github.com/eopo/helm/commit/900110ba2b629c6ee995e664e142ce51f5c32625))
* **charts:** `README` and `Chart.yaml` updates ([e6b0903](https://github.com/eopo/helm/commit/e6b090396e6396f5f170dd5cc681cf07790e9d72))
* **charts:** accommodate Bitnami's BSI migration ([70c6e18](https://github.com/eopo/helm/commit/70c6e1882e6b44e58e9c0fdcf852fa7119ef9530))
* **charts:** add OCI annotations to charts ([e3935a0](https://github.com/eopo/helm/commit/e3935a05d7b0e60727aa023e04c8aa1915551533))
* **charts:** updated Helm's NOTES for each chart ([979524c](https://github.com/eopo/helm/commit/979524c87377a5044ec26e3d6fcf5237825c0eb2))
* **charts:** upgrade charts to `0.2.0` ([53e1e6d](https://github.com/eopo/helm/commit/53e1e6da557a7d4837e5a48eadadfcb3732e5c39))
* finish Paperless-NGX Chart ([bf9c416](https://github.com/eopo/helm/commit/bf9c41642712d02858cfcdf6222e296aaa71c1da))
* finished Gotenberg chart ([80d0461](https://github.com/eopo/helm/commit/80d0461daea9019fb0b8a3197083a432809d3504))
* finished Vaultwarden & Linkwarden charts ([73ba710](https://github.com/eopo/helm/commit/73ba71062372670ac68301f428e69972d5e43a78))


### Bug Fixes

* **charts/paperless-ngx:** add missing documentation ([8720507](https://github.com/eopo/helm/commit/87205078915d7beda87af35bb89278d43d71ba05))
* **charts/paperless-ngx:** add required new line character ([40cb68d](https://github.com/eopo/helm/commit/40cb68d5fa4099bb823121affb0fb4723b16791f))
* **charts/paperless-ngx:** generate hostnames for Redis and PostgreSQL [#14](https://github.com/eopo/helm/issues/14) ([ffb8f5b](https://github.com/eopo/helm/commit/ffb8f5b486ac6b6e73454ed261d5e64bec42984f))
* **charts/paperless-ngx:** remove invalid dependency breaking `release` ([76e46d7](https://github.com/eopo/helm/commit/76e46d7723d4fd5e5e6f6c5c3675a1242e162263))
* **charts/paperless-ngx:** tika and gotenberg endpoints ([8005814](https://github.com/eopo/helm/commit/8005814b670f20dae6128fad561ee5398fe3d554))
* **charts/paperless-ngx:** too many spaces inside empty braces ([3f7e7af](https://github.com/eopo/helm/commit/3f7e7affc4673f919bf0f087347f651686ea1e08))
* **charts/paperless-ngx:** unused Redis `existingSecret` as in [#8](https://github.com/eopo/helm/issues/8),[#9](https://github.com/eopo/helm/issues/9),[#10](https://github.com/eopo/helm/issues/10) ([39cc552](https://github.com/eopo/helm/commit/39cc552fffdf17bdc7c28c1cbce5289cd604884c))
* **charts/paperless-ngx:** use subPath for volumeMounts ([87e17fd](https://github.com/eopo/helm/commit/87e17fd3357723dfe45356f963f51ee3ef810623))
* **charts/paperless-ngx:** use subPath for volumeMounts ([40c5a53](https://github.com/eopo/helm/commit/40c5a53cd21a7a3d370c4bb2a8fa8b7916d59d92))
* **charts:** fix `kubeVersion` setting to mitigate [#11](https://github.com/eopo/helm/issues/11) ([96d14aa](https://github.com/eopo/helm/commit/96d14aa92b66ed7f6926ca8d9c1d666838423169))
* **charts:** invalid `semverCompare` with `GitVersion` ([8eef255](https://github.com/eopo/helm/commit/8eef255b77eed21f1caec822f7bb3807c035b170))
* **paperless-ngx:** add uri for tika and gotenberg endpoints ([fe9d27d](https://github.com/eopo/helm/commit/fe9d27dca11098224071297454039d24ba50f5e0))
* **paperless-ngx:** ensure tika/gotenberg endpoint is templated ([0eee28d](https://github.com/eopo/helm/commit/0eee28d7ce3993ca6181f9e36748166ffa58eb21))
* **paperless-ngx:** only template gotenberg endpoint if tika enabled ([f63cbd8](https://github.com/eopo/helm/commit/f63cbd8af784af58bea9f102aa6a3a148e398e77))
