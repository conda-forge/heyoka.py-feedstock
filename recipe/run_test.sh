 if [[ "$target_platform" != linux-ppc64le ]]; then
     pytest -v --pyargs heyoka.test
fi
