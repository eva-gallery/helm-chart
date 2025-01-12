<div align="center">

<img src="https://evagallery.eu/logo.jpg" alt="https://evagallery.eu" width="600" />

##### A modern art gallery environment allowing with NFT minting

</div>

- **[Official Website](https://evagallery.eu)**

<div align="center">
E.V.A. Gallery is an open source project.
</div>

## Introduction

This chart bootstraps an E.V.A. Gallery deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also optionally packages the [PostgreSQL](https://github.com/kubernetes/charts/tree/master/stable/postgresql) as the database but you are free to bring your own.

## Prerequisites

- PV provisioner support in the underlying infrastructure (with persistence storage enabled) if you want data persistance

## Adding the E.V.A. Gallery Helm Repository

```console
$ helm repo add <TODO>
```

## Installing the Chart

To install the chart with the release name `my-release` run the following:

### Using Helm 3:
```console
$ helm install my-release <TODO>/<EVA>
```

The command deploys E.V.A. Gallery on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

> **Warning**: Persistant Volume Claims for the database are not deleted automatically. They need to be manually deleted

```console
$ kubectl delete pvc/data-eva-postgresql-0
```

## Configuration

The following table lists the configurable parameters of the E.V.A. Gallery chart and their default values.

A YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml <TODO:HELM_CHART>
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## PostgresSQL

By default, PostgreSQL is installed as part of the chart.

### Using an external PostgreSQL server

To use an external PostgreSQL server, set `postgresql.enabled` to `false` and then set `postgresql.postgresqlHost` and `postgresql.postgresqlPassword`. To use an existing `Secret`, set `postgresql.existingSecret`. The other options (`postgresql.postgresqlDatabase`, `postgresql.postgresqlUser`, `postgresql.postgresqlPort` and `postgresql.existingSecretKey`) may also want changing from their default values.

To use an SSL connection you can set `postgresql.ssl` to `true` and if needed the path to a Certificate of Authority can be set using `postgresql.ca` to `/path/to/ca`. Default `postgresql.ssl` value is `false`.

If `postgresql.existingSecret` is not specified, you also need to add the following Helm template to your deployment in order to create the postgresql `Secret`:

```yaml
kind: Secret
apiVersion: v1
metadata:
  name: {{ template "eva.postgresql.secret" . }}
data:
  {{ template "eva.postgresql.secretKey" . }}: "{{ .Values.postgresql.postgresqlPassword | b64enc }}"
```

## Persistence

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Configuration](#configuration) section to configure the PVC or to disable persistence.

## Ingress

This chart provides support for Ingress resource. If you have an available Ingress Controller such as Nginx or Traefik you maybe want to set `ingress.enabled` to true and add `ingress.host` for the URL. Then, you should be able to access the installation using that address.
