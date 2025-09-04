docker run -d --restart unless-stopped -it \
  -p 8080:8080 \
  mcp-proxy-node --port 8080 --host 0.0.0.0 -- \
  npx -y "@tyk-technologies/api-to-mcp@latest" \
  --spec "https://raw.githubusercontent.com/APT-Servizi/openapi-ert/main/v1/api-spec.yaml" \
  --targetUrl "https://emiliaromagnaturismo.it/opendata/v1"
