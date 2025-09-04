# Build stage with explicit platform specification
FROM ghcr.io/astral-sh/uv:python3.12-alpine AS uv

WORKDIR /app

ENV UV_COMPILE_BYTECODE=1
ENV UV_LINK_MODE=copy

RUN --mount=type=cache,target=/root/.cache/uv \
    --mount=type=bind,source=uv.lock,target=uv.lock \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    uv sync --frozen --no-install-project --no-dev --no-editable

ADD . /app
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --no-dev --no-editable

# Final stage with explicit platform specification
FROM python:3.12-alpine

# Install Node.js & npm (alpine version)
RUN apk add --no-cache nodejs npm bash curl

# Copy the Python virtualenv from the build stage
COPY --from=uv --chown=app:app /app/.venv /app/.venv

ENV PATH="/app/.venv/bin:$PATH"
WORKDIR /app

# Optional: default entrypoint is still mcp-proxy
ENTRYPOINT ["mcp-proxy"]

# Optional: allow running npx commands directly via docker run
CMD ["sh"]
