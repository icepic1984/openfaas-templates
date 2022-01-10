FROM --platform=${TARGETPLATFORM:-linux/amd64} ghcr.io/openfaas/classic-watchdog:0.2.0 as watchdog
FROM --platform=${TARGETPLATFORM:-linux/amd64} daewok/sbcl:2.1.4-buster

ARG ADDITIONAL_PACKAGE

# Copy fwatchdog from openfaas
COPY --from=watchdog /fwatchdog /usr/bin/fwatchdog
RUN chmod +x /usr/bin/fwatchdog

# Install additional deps from repo (not used atm)
RUN apt-get update && apt-get install -y \
  ${ADDITIONAL_PACKAGE} \
  && rm -rf /var/lib/apt/lists/*

# Add new user `app`
RUN addgroup --system app
RUN useradd -mrs /bin/sh -g app app

# Install quicklisp
USER app
WORKDIR /tmp/
RUN wget http://beta.quicklisp.org/quicklisp.lisp
RUN echo "(load \"quicklisp.lisp\") (quicklisp-quickstart:install :path \"/home/app/quicklisp\") (ql::without-prompting (ql:add-to-init-file))" | sbcl && rm -rf /tmp/* /var/tmp/*

# Install additional packages using quicklisp.  In theory this could
# be done during compilation of the function. But doing it here will
# speed up the image building.

COPY requirements.lisp .
RUN sbcl --load requirements.lisp

# Copy project files
USER root
WORKDIR /home/app/quicklisp/local-projects
RUN mkdir clisp-sbcl
WORKDIR /home/app/quicklisp/local-projects/clisp-sbcl
COPY clisp-sbcl.asd .
COPY binary-streams.lisp .
COPY index.lisp .
COPY package.lisp .
COPY function function

# Set permission
RUN chown -R app:app /home/app/quicklisp/local-projects

# Switch to user app
USER app

# Build application
RUN sbcl --eval '(ql:quickload :clisp-sbcl)' --eval '(asdf:make :clisp-sbcl)' --quit

# Configure entrypoint for openfaas
ENV fprocess=/home/app/quicklisp/local-projects/clisp-sbcl/index

EXPOSE 8080

HEALTHCHECK --interval=3s CMD [ -e /tmp/.lock ] || exit 1

CMD ["fwatchdog"]




