openapi () {
  compgen -G "/work/openapi/*-openapi.yaml" >/dev/null || return
  for f in /work/openapi/*.yaml; do
    apif=$(basename -- "${f}")
    api=${apif%.*}
    echo "<a href=\"./swagger-ui/index.html?api=/openapi/${apif}\">$(yq -r '.info."x-drv-id"' ${f} | sed -e "s#^.\+/##")-$(yq -r '.info.title' ${f})-$(yq -r '.info.version' ${f})</a><br>"
  done
}

mkdir /app
cat /work/index/header.part.html > /app/index.html
openapi >> /app/index.html
sed -e "s/\$GEN_DATETIME/$(date --iso-8601=seconds)/" /work/index/footer.part.html >> /app/index.html
