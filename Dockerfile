FROM ubuntu:22.04

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y software-properties-common
RUN add-apt-repository -y ppa:deadsnakes/ppa
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
                                   opam libgmp-dev m4 python3.9 python3-pip locales nano git curl autoconf

RUN adduser --disabled-password --gecos "" me
RUN locale-gen en_US.UTF-8 &&\
    echo "export LANG=en_US.UTF-8 LANGUAGE=en_US.en LC_ALL=en_US.UTF-8" >> /home/me/.bashrc

USER me
WORKDIR /home/me

# pip
# RUN apt-get install
# RUN python3.9 -m venv venv
# RUN pip install --default-timeout=100 pandas matplotlib tqdm

# opam install
RUN opam init -y --disable-sandboxing
RUN opam update -y
RUN opam switch create 4.13.1
RUN eval `opam env --switch=4.13.1`
RUN opam install -y dune core_kernel base zarith menhir js_of_ocaml js_of_ocaml-ppx \
                    zarith_stubs_js dune-build-info qcheck core_unix pyml calendar z3

ENV WDIR /home/me
WORKDIR ${WDIR}

# Copy EnfGuard
COPY . .
RUN rm Dockerfile

# Permissions
ADD . ${WDIR}
USER root
RUN chmod 755 /home/me
RUN chown -R me:me *
USER me

# Build EnfGuard/MonPoly/EnfPoly/WhyEnf
RUN eval `opam config env`; cd /home/me/enfguard; dune build --release;
RUN eval `opam config env`; git clone https://bitbucket.org/jshs/monpoly.git; cd /home/me/monpoly; dune build --release
RUN eval `opam config env`; git clone https://bitbucket.org/jshs/monpoly.git enfpoly; cd /home/me/enfpoly; git switch enfpoly; dune build --release
RUN eval `opam config env`; git clone https://github.com/runtime-enforcement/whyenf.git; cd /home/me/whyenf; dune build --release

USER root
RUN echo "su - me" >> /root/.bashrc