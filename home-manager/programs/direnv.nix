{
    enable = true;
    enableZshIntegration = true;
    stdlib = ''
__secrets_at_exit() {

  if [ "$ENVCHAIN" ] && $(which envchain >/dev/null 2>&1); then
    log_status "ENVCHAIN=$ENVCHAIN Loading envchain secrets"
    while IFS= read -r -d $'\0' clause <&3; do
      export "$clause" 2>/dev/null
    done 3< <(envchain $ENVCHAIN env -0)
  fi

  if [ "$HCP_APP" ] && $(which hcp >/dev/null 2>&1); then
    log_status "HCP_APP=$HCP_APP Loading hcp secrets"
    _keys="$(hcp vs s list --app="$HCP_APP" --format=json | jq -r '.[].name')"
    for _key in $_keys; do
      _value="$(hcp vs s open "$_key" --app="$HCP_APP" --format=json \
              | jq -r '.static_version.value')"
      log_status "HCP_APP=$HCP_APP Found secret $_key"
      export $_key="$_value"
    done
  fi

  __dump_at_exit
}
trap __secrets_at_exit EXIT
'';
}
