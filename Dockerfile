# Estágio 1: baixa um binário estático do ffmpeg (não precisa de apk/apt)
FROM alpine:3.20 AS ffmpeg-fetcher
RUN apk add --no-cache curl xz && \
    curl -L -o /tmp/ffmpeg.tar.xz \
      https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-arm64-static.tar.xz && \
    mkdir -p /tmp/ffmpeg-extracted && \
    tar -xf /tmp/ffmpeg.tar.xz -C /tmp/ffmpeg-extracted --strip-components=1

# Estágio 2: imagem final, baseada na imagem hardened do n8n
FROM n8nio/n8n:latest
USER root
COPY --from=ffmpeg-fetcher /tmp/ffmpeg-extracted/ffmpeg /usr/local/bin/ffmpeg
COPY --from=ffmpeg-fetcher /tmp/ffmpeg-extracted/ffprobe /usr/local/bin/ffprobe
RUN chmod +x /usr/local/bin/ffmpeg /usr/local/bin/ffprobe
USER node
