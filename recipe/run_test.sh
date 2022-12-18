 if [[ "$target_platform" != linux-ppc64le ]]; then
     python -c "from heyoka import test; test.run_test_suite()"
fi
