FROM debian:stretch

MAINTAINER ctassisf@gmail.com

ENV ["LANG", "en_US.UTF-8"]
ENV ["LANGUAGE", "en_US:en"]
ENV ["LC_ALL", "en_US.UTF-8"]

RUN ["apt-get", "-y", "update"]
RUN ["apt-get", "-y", "install", "apt-src", "build-essential", "cmake", "git", "golang", "gnupg", "libunwind-dev", "ninja-build", "wget"]

RUN ["wget", "https://nginx.org/keys/nginx_signing.key", "-O", "/etc/apt/trusted.gpg.d/nginx"]
RUN ["gpg", "--dearmor", "/etc/apt/trusted.gpg.d/nginx"]
RUN ["rm", "/etc/apt/trusted.gpg.d/nginx"]

COPY ["nginx.list", "/etc/apt/sources.list.d/nginx.list"]

RUN ["apt-get", "-y", "update"]

WORKDIR /tmp

RUN ["git", "clone", "https://boringssl.googlesource.com/boringssl"]

WORKDIR boringssl
WORKDIR build

RUN ["cmake", "-DCMAKE_BUILD_TYPE=Release", "-GNinja", ".."]
RUN ["ninja"]

WORKDIR /tmp
WORKDIR boringssl
WORKDIR .openssl

RUN ["ln", "-s", "../include"]

WORKDIR lib

RUN ["ln", "-s", "../../build/crypto/libcrypto.a"]
RUN ["ln", "-s", "../../build/decrepit/libdecrepit.a"]
RUN ["ln", "-s", "../../build/ssl/libssl.a"]

WORKDIR /tmp

RUN ["apt-src", "update"]
RUN ["apt-src", "install", "nginx"]

COPY ["patch.sh", "patch.sh"]
RUN ["bash", "patch.sh"]

RUN ["apt-src", "build", "nginx"]
