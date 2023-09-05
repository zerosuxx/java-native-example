FROM ghcr.io/graalvm/graalvm-ce:ol7-java17 AS base

FROM base AS builder

WORKDIR /build

COPY ./src ./src
COPY ./gradle ./gradle
COPY ./build.gradle ./build.gradle
COPY ./settings.gradle ./settings.gradle
COPY ./gradlew ./gradlew

RUN useradd -m app

RUN ./gradlew nativeCompile


FROM gcr.io/distroless/base

ENV LD_LIBRARY_PATH /usr/lib64/

COPY --from=builder /usr/lib64/libz* /usr/lib64/
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /build/build/native/nativeCompile/app /usr/local/bin/app

USER app

ENTRYPOINT ["app"]
