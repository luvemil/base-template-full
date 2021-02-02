FROM haskell:8.10.2 as build
RUN mkdir /opt/build
COPY . /opt/build
RUN cd /opt/build && stack build --system-ghc

FROM ubuntu:20.04
RUN mkdir -p /opt/myapp
WORKDIR /opt/myapp
COPY --from=build /opt/build/.stack-work/install/x86_64-linux-*/*/bin .
CMD ["/opt/myapp/base-template-full-exe"]