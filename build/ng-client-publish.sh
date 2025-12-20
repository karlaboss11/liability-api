declare -a elements
while IFS= read -r -d $'\0' d; do
  [ ! -d "${d}/target/generated-sources/openapi" ] && continue
  pushd ${d}/target/generated-sources/openapi
  npx ng-packagr -p ng-package.json
  cd dist && npm publish --verbose
  popd
  elements+=${d}
done < <(find . -mindepth 1 -maxdepth 2 -type d -iname "*-rest-api-client" -print0)

test ${#elements[@]} -gt 0 || { echo "No elements published"; exit 1; }
