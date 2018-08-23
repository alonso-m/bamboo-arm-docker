Bamboo is a continuous integration and continuous deployment server. 

Learn more about Bamboo: <https://www.atlassian.com/software/bamboo>

# Overview

This Docker container makes it easy to get an instance of Bamboo up and running.

** We strongly recommend you run this image using a specific version tag instead of latest. This is because the image referenced by the latest tag changes often and we cannot guarantee that it will be backwards compatible. **

# Quick Start

For the `BAMBOO_HOME` directory that is used to store the configuration data
(amongst other things) we recommend mounting a host directory as a [data volume](https://docs.docker.com/engine/tutorials/dockervolumes/#/data-volumes), or via a named volume if using a docker version >= 1.9. 

Volume permission is managed by entry scripts. To get started you can use a data volume, or named volumes. In this example we'll use named volumes.

    $> docker volume create --name bambooVolume
    $> docker run -v bambooVolume:/var/atlassian/application-data/bamboo --name="bamboo" --init -d -p 54663:54663 -p 8085:8085 atlassian/bamboo-server

Note that this command can be replaced by named volumes.

Start Atlassian Bamboo:
    $> docker run -v /data/bamboo:/var/atlassian/application-data/bamboo --name="bamboo-server" --host=bamboo-server --init -d -p 54663:54663 -p 8085:8085 atlassian/bamboo-server

**Success**. Bamboo is now available on [http://localhost:8085](http://localhost:8085)*. 

Note that the `--init` flag is required to properly reap zombie processes.

Please ensure your container has the necessary resources allocated to it.
We recommend 2GiB of memory allocated to accommodate the application server.
See [Supported Platforms](https://confluence.atlassian.com/display/Bamboo/Supported+platforms) for further information.
    

## JVM Configuration

If you need to override Bamboo's default memory configuration or pass additional JVM arguments, use the environment variables below

* `JVM_MINIMUM_MEMORY` (default: 512m)

   The minimum heap size of the JVM

* `JVM_MAXIMUM_MEMORY` (default: 1024m)

   The maximum heap size of the JVM

* `JVM_SUPPORT_RECOMMENDED_ARGS` (default: NONE)

   Additional JVM arguments for Bamboo, such as a custom Java Trust Store

# Upgrade

To upgrade to a more recent version of Bamboo you can simply stop the `bamboo`
container and start a new one based on a more recent image:

    $> docker stop bamboo
    $> docker rm bamboo
    $> docker pull atlassian/bamboo-server:<desired_version>
    $> docker run ... (See above)

As your data is stored in the data volume directory on the host it will still
be available after the upgrade.

_Note: Please make sure that you **don't** accidentally remove the `bamboo`
container and its volumes using the `-v` option._

# Backup

For evaluations you can use the built-in database that will store its files in the Bamboo home directory. In that case it is sufficient to create a backup archive of the directory on the host that is used as a volume (`/data/bamboo` in the example above).

# Versioning

The `latest` tag matches the most recent version of this repository. Thus using `atlassian/bamboo-server:latest` or `atlassian/bamboo-server` will ensure you are running the most up to date version of this image.

However,  we ** strongly recommend ** that for non-eval workloads you select a specific version in order to prevent breaking changes from impacting your setup.
You can use a specific minor version of Bamboo by using a version number
tag: `atlassian/bamboo-server:6.7`. This will install the latest `6.7.x` version that
is available.

# Support

For image and product support, go to [support.atlassian.com](https://support.atlassian.com/)