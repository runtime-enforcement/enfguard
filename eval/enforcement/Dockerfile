FROM ubuntu:22.04

# Install packages
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:deadsnakes/ppa && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        opam libgmp-dev m4 python3.9 python3-pip python3-dev python3.9-distutils \
	     locales nano git curl autoconf && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
    
# Install a minimal TeXLive setup
RUN apt-get update && apt-get install -y --no-install-recommends \
    texlive-base \
    texlive-latex-recommended \
    texlive-fonts-recommended \
    texlive-latex-extra \
    dvipng cm-super \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set up user and locale
RUN adduser --disabled-password --gecos "" me
RUN locale-gen en_US.UTF-8 && \
    echo "export LANG=en_US.UTF-8 LANGUAGE=en_US.en LC_ALL=en_US.UTF-8" >> /home/me/.bashrc

# Login as user, set working directory
USER me
ENV WDIR=/home/me
WORKDIR ${WDIR}

# Install opam dependencies
RUN opam init -y --disable-sandboxing
RUN opam update -y
RUN opam switch create 4.13.1
RUN eval `opam env --switch=4.13.1`
RUN opam install -y dune core_kernel base zarith menhir js_of_ocaml js_of_ocaml-ppx \
                    zarith_stubs_js dune-build-info qcheck core_unix pyml calendar z3

# Copy EnfGuard into working directory
COPY . .
RUN rm Dockerfile

# As root, set permissions
ADD . ${WDIR}
USER root
RUN chmod 755 ${WDIR}
RUN chown -R me:me *

# As user again, build EnfGuard/MonPoly/EnfPoly/WhyEnf
USER me
RUN eval `opam config env`; \
    cd /home/me/enfguard; \
    dune build --release
RUN eval `opam config env`; \
    git clone https://bitbucket.org/jshs/monpoly.git; \
    cd /home/me/monpoly; \
    dune build --release
RUN eval `opam config env`; \
    git clone https://bitbucket.org/jshs/monpoly.git enfpoly; \
    cd /home/me/enfpoly; \
    git switch enfpoly; \
    dune build --release
RUN eval `opam config env`; \
    git clone https://github.com/runtime-enforcement/whyenf.git; \
    cd /home/me/whyenf; \
    dune build --release

# Create symlinks for tools
ENV EDIR=${WDIR}/enfguard/eval/enforcement
WORKDIR ${EDIR}
RUN ln -s ${WDIR}/monpoly/_build/default/src/main.exe monpoly.exe && \
    ln -s ${WDIR}/enfguard/_build/default/bin/enfguard.exe enfguard.exe && \
    ln -s ${WDIR}/enfpoly/_build/default/src/main.exe enfpoly.exe && \
    ln -s ${WDIR}/whyenf/_build/default/bin/whyenf.exe whyenf.exe

# Set up virtualenv and install Python dependencies
RUN python3.9 -m pip install virtualenv && \
    python3.9 -m virtualenv venv && \
    . venv/bin/activate && \
    python3.9 -m pip install -r requirements.txt

ENV VIRTUAL_ENV=${EDIR}/venv
ENV PATH="${EDIR}/venv/bin:${EDIR}:$PATH"

COPY enfguard/entrypoint.sh entrypoint.sh
USER root
RUN chmod +x entrypoint.sh

USER me
ENTRYPOINT ["entrypoint.sh"]


