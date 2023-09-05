FROM ghcr.io/graalvm/graalvm-ce:ol7-java17 AS base

FROM base AS builder

WORKDIR /build

COPY ./src /build/src
COPY ./gradle /build/gradle
COPY ./build.gradle /build/build.gradle
COPY ./settings.gradle /build/settings.gradle
COPY ./gradlew /build/gradlew

RUN ./gradlew nativeCompile

FROM gcr.io/distroless/base

ENV LD_LIBRARY_PATH /usr/lib64/

COPY --from=builder /usr/lib64/libz* /usr/lib64/
COPY --from=builder /build/build/native/nativeCompile/app /usr/local/bin/app

ENTRYPOINT ["app"]
