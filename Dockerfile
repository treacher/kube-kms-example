FROM alpine:3.5

RUN apk add --update bash curl && rm -rf /var/cache/apk/*

# Install shush
RUN curl -sL -o /usr/local/bin/shush \
  https://github.com/realestate-com-au/shush/releases/download/v1.3.0/shush_linux_amd64 \
  && chmod +x /usr/local/bin/shush

# Add a user so that we're not running our executables as root.
RUN addgroup -S kube-kms-example && adduser -S -g kube-kms-example kube-kms-example

USER kube-kms-example

COPY print-secrets .

# Use shush exec as an entrypoint for decrypting our secrets
ENTRYPOINT ["/usr/local/bin/shush", "exec", "--"]

CMD ["./print-secrets"]
