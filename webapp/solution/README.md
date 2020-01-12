# solution

## Exclude unnecessary files from the Docker context with `.dockerignore`

When building an image, Docker has to prepare `context` first - gather all files that may be used in a process. Default context contains all files in a Dockerfile directory.
Usually we don't want to include there the `.git` directory, downloaded libraries and compiled files. `.dockerignore` file looks exactly like `.gitignore`.

```
$ cp solution/.dockerignore .
```

Notice how fast the Docker build process starts after having excluded unnecessary large files such as the 200MB.zip.

The `Sending build context to Docker daemon    25.6kB` operation now is done almost instantly!

## Merge multiple RUN commands into one

 Having `apt-get update` in a separate `RUN` statement from `apt-get install`makes our build non-deterministic (`apt-get update` will invalidate the Docker cache and once the cache is invalidated, all subsequent Dockerfile commands generate new images and the cache is not used.)

Edit the current Dockerfile:

```
RUN apt-get update \
&& apt install -y default-jdk maven
```

Keep in mind, that you should merge commands with similar probability of changing. Currently, every time our source code changes, we need to reinstall JDK and Maven. So, a better option is moving the ADD operation after the installation of your dependencies:

```
RUN apt-get update \
&& apt install -y default-jdk maven

ADD . /app
```

or copy the solution from:

```
$ cp solution/1-merge-run-commands.Dockerfile Dockerfile
```

### Do not use `latest` as base image tag

By default `latest` is the image tag that is used unless specified otherwise. This means that the following two instructions do exactly the same:

```
FROM ubuntu
```

and 

```
FROM ubuntu:latest
```

However, using `latest` is risky as it will point to a different image when a new version of the image will be released - and that's something you may not be interested in.

So, unless you are creating a generic Dockerfile that must stay up-to-date with the base image, provide specific tag.

In our example, let's use 16.04 tag:

```
FROM ubuntu:18.04
```

or copy the solution from:

```
$ cp solution/2-specify-tag.Dockerfile Dockerfile
```

## Remove unneeded files after each RUN step

So, let's assume we updated apt-get sources, installed few packages required for compiling others, downloaded and extracted archives. We obviously don't need them in our final images, so better let's make a cleanup.

Edit the current Dockerfile:

```
RUN apt-get update \
    && apt install -y default-jdk maven \
    && rm -rf /var/lib/apt/lists/*
```
or copy the solution from:

```
$ cp solution/3-remove-unneeded-files.Dockerfile Dockerfile
```

## Use a more purpose-specific image

In our example, we used ubuntu. But why? Do we really need a general-purpose base image, when we just want to run java web application? A much better option is to use a specialized image with only JDK and Maven already installed:

```
FROM maven:3.6.3-jdk-11-slim
```
or copy the solution from:

```
$ cp solution/4-maven-img.Dockerfile Dockerfile
```

## Prefer COPY over ADD

The major difference is that `ADD` can do more than `COPY`:

`ADD` allows <src> to be a URL

The ADD documentation clearly states that:

*If is a local tar archive in a recognized compression format (identity, gzip, bzip2 or xz) then it is unpacked as a directory. Resources from remote URLs are not decompressed.*

> Note that the Best practices for writing Dockerfiles suggests using COPY where the magic of ADD is not required. Otherwise you are likely to get surprised someday when you mean to copy keep_this_archive_intact.tar.gz into your container, but instead you spray the contents onto your filesystem.

Edit the current Dockerfile to use `COPY` instead of `ADD`:

```
COPY . /app
```
or copy the solution from:

```
$ cp solution/5-copy-over-add.Dockerfile Dockerfile
```

## Caching dependencies

Instead of copying everything into `/app`, we are going to copy the Project Object Model file and then fetch all dependencies and plugins based on the pom file.

Copy the solution from:

```
$ cp solution/6-deps-cached.Dockerfile Dockerfile
```


## Use multi-stage builds

The idea is to have one stage to build the app, and then a final stage to copy the binary:

- Build stage: it contains only dependencies required to build your app.

- Final stage: it contains the runtime and the binary to be executed.

Copy the solution from:

```
$ cp solution/7-multi-stage.Dockerfile Dockerfile
```
