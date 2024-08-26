FROM public.ecr.aws/lambda/provided:al2023

ENV R_VERSION=4.0.3

RUN dnf -y install R-core libcurl-devel openssl-devel
RUN dnf -y clean all

ENV PATH="${PATH}:/opt/R/${R_VERSION}/bin/"

RUN Rscript -e "install.packages(c('httr', 'jsonlite', 'logger', 'remotes'), repos = 'https://packagemanager.rstudio.com/all/__linux__/centos7/latest')"
RUN Rscript -e "remotes::install_github('mdneuzerling/lambdr')"

RUN mkdir /lambda
COPY runtime.R /lambda
RUN chmod 755 -R /lambda

RUN printf '#!/bin/sh\ncd /lambda\nRscript runtime.R' > /var/runtime/bootstrap \
  && chmod +x /var/runtime/bootstrap

CMD ["parity"]
