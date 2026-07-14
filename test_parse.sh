#!/bin/bash

# Paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR" && pwd)"
WEBSERV="$PROJECT_ROOT/webserv"
TEST_FILES_DIR="$SCRIPT_DIR/config_file"
SEPARATOR="#•❅──────✧❅✦❅✧──────❅•❅──────✧❅✦❅✧────✧❅✦❅✧──────❅•❅──────✧❅✦❅✧─────❅•#"

# Check executable
if [ ! -f "$WEBSERV" ]; then
	echo -e "Error: webserv not found"
	exit 1
fi

test_num=0
passed=0
failed=0

echo "========================================="
echo "  NEGATIVE TESTS (ALL MUST FAIL PARSING)"
echo "========================================="
echo ""

# Test files array (Tu lista completa)
declare -a test_files=(
	# Listen tests
	"$TEST_FILES_DIR/syntax/empty.conf"
	"$TEST_FILES_DIR/syntax/only_comments.conf"
	"$TEST_FILES_DIR/syntax/syntax_error_1.conf"
	"$TEST_FILES_DIR/syntax/syntax_error_2.conf"
	"$TEST_FILES_DIR/syntax/syntax_error_3.conf"
	"$TEST_FILES_DIR/syntax/syntax_error_4.conf"

	"$TEST_FILES_DIR/server_body/worng_end_1.conf"

	"$TEST_FILES_DIR/listen/1_empty_directive.conf"
	"$TEST_FILES_DIR/listen/2_wrong_char_1.conf"
	"$TEST_FILES_DIR/listen/3_wrong_port.conf"
	"$TEST_FILES_DIR/listen/4_wrong_host_dot.conf"
	"$TEST_FILES_DIR/listen/4_wrong_host_octet_1.conf"
	"$TEST_FILES_DIR/listen/4_wrong_host_octet_2.conf"
	"$TEST_FILES_DIR/listen/4_wrong_host_octet_3.conf"
	"$TEST_FILES_DIR/listen/4_wrong_host_octet_4.conf"
	"$TEST_FILES_DIR/listen/5_wrong_host_and_port.conf"
	"$TEST_FILES_DIR/listen/6_wrong_end_1.conf"
	"$TEST_FILES_DIR/listen/6_wrong_end_2.conf"
	"$TEST_FILES_DIR/listen/6_wrong_end_3.conf"
	
	"$TEST_FILES_DIR/server_names/1_wrong_separator.conf"
	"$TEST_FILES_DIR/server_names/1_empty_directive.conf"
	"$TEST_FILES_DIR/server_names/2_wrong_char_1.conf"
	"$TEST_FILES_DIR/server_names/2_wrong_char_2.conf"
	"$TEST_FILES_DIR/server_names/2_wrong_char_3.conf"
	"$TEST_FILES_DIR/server_names/2_wrong_char_4.conf"
	"$TEST_FILES_DIR/server_names/3_wrong_end_1.conf"
	"$TEST_FILES_DIR/server_names/3_wrong_end_2.conf"
	"$TEST_FILES_DIR/server_names/3_wrong_end_3.conf"

	"$TEST_FILES_DIR/root/1_empty_directive.conf"
	"$TEST_FILES_DIR/root/2_wrong_char_1.conf"
	"$TEST_FILES_DIR/root/2_wrong_char_2.conf"
	"$TEST_FILES_DIR/root/2_wrong_char_3.conf"
	"$TEST_FILES_DIR/root/2_wrong_char_4.conf"
	"$TEST_FILES_DIR/root/2_wrong_char_5.conf"
	"$TEST_FILES_DIR/root/3_wrong_end_1.conf"
	"$TEST_FILES_DIR/root/3_wrong_end_2.conf"
	"$TEST_FILES_DIR/root/3_wrong_end_3.conf"
	"$TEST_FILES_DIR/root/3_wrong_end_4.conf"
	"$TEST_FILES_DIR/root/1_wrong_separator.conf"
	"$TEST_FILES_DIR/root/2_without_directive.conf"

	"$TEST_FILES_DIR/index/1_index_wrong_separator.conf"
	"$TEST_FILES_DIR/index/1_empty_directive.conf"
	"$TEST_FILES_DIR/index/2_index_wrong_char_1.conf"
	"$TEST_FILES_DIR/index/2_index_wrong_char_2.conf"
	"$TEST_FILES_DIR/index/2_index_wrong_char_3.conf"
	"$TEST_FILES_DIR/index/2_index_wrong_char_4.conf"
	"$TEST_FILES_DIR/index/3_index_wrong_end_1.conf"
	"$TEST_FILES_DIR/index/3_index_wrong_end_2.conf"
	"$TEST_FILES_DIR/index/3_index_wrong_end_3.conf"

	"$TEST_FILES_DIR/autoindex/1_wrong_arg_1.conf"
	"$TEST_FILES_DIR/autoindex/1_wrong_arg_2.conf"
	"$TEST_FILES_DIR/autoindex/1_wrong_arg_3.conf"
	"$TEST_FILES_DIR/autoindex/1_wrong_arg_4.conf"
	"$TEST_FILES_DIR/autoindex/2_wrong_end.conf"

	"$TEST_FILES_DIR/upload_path/1_wrong_arg_1.conf"
	"$TEST_FILES_DIR/upload_path/1_wrong_arg_2.conf"
	"$TEST_FILES_DIR/upload_path/1_wrong_arg_3.conf"
	"$TEST_FILES_DIR/upload_path/1_wrong_arg_4.conf"
	"$TEST_FILES_DIR/upload_path/2_wrong_end.conf"

	"$TEST_FILES_DIR/server_return/1_wrong_arg_1.conf"
	"$TEST_FILES_DIR/server_return/1_wrong_arg_2.conf"
	"$TEST_FILES_DIR/server_return/1_wrong_arg_3.conf"
	"$TEST_FILES_DIR/server_return/1_wrong_arg_4.conf"
	"$TEST_FILES_DIR/server_return/1_wrong_arg_5.conf"
	"$TEST_FILES_DIR/server_return/2_wrong_end.conf"

	"$TEST_FILES_DIR/body_size/1_empty_directive.conf"
	"$TEST_FILES_DIR/body_size/1_index_wrong_separator.conf"
	"$TEST_FILES_DIR/body_size/2_wrong_char_1.conf"
	"$TEST_FILES_DIR/body_size/2_wrong_char_2.conf"
	"$TEST_FILES_DIR/body_size/2_wrong_char_3.conf"
	"$TEST_FILES_DIR/body_size/2_wrong_char_4.conf"
	"$TEST_FILES_DIR/body_size/3_wrong_end_1.conf"
	"$TEST_FILES_DIR/body_size/3_wrong_end_2.conf"
	"$TEST_FILES_DIR/body_size/3_wrong_end_3.conf"
	"$TEST_FILES_DIR/body_size/4_wrong_suffix_1.conf"
	"$TEST_FILES_DIR/body_size/4_wrong_suffix_2.conf"
	"$TEST_FILES_DIR/body_size/4_wrong_suffix_3.conf"
	"$TEST_FILES_DIR/body_size/4_wrong_suffix_4.conf"
	"$TEST_FILES_DIR/body_size/4_wrong_suffix_5.conf"
	"$TEST_FILES_DIR/body_size/4_wrong_suffix_6.conf"
	"$TEST_FILES_DIR/body_size/4_wrong_suffix_7.conf"
	"$TEST_FILES_DIR/body_size/4_wrong_suffix_8.conf"
	"$TEST_FILES_DIR/body_size/4_wrong_suffix_9.conf"
	"$TEST_FILES_DIR/body_size/4_wrong_suffix_10.conf"
	"$TEST_FILES_DIR/body_size/4_wrong_suffix_11.conf"
	"$TEST_FILES_DIR/body_size/4_wrong_suffix_12.conf"
	"$TEST_FILES_DIR/body_size/4_wrong_suffix_13.conf"
	"$TEST_FILES_DIR/body_size/4_wrong_suffix_14.conf"
	"$TEST_FILES_DIR/body_size/syntax_error_1.conf"

	"$TEST_FILES_DIR/error_page/1_empty_directive.conf"
	"$TEST_FILES_DIR/error_page/1_wrong_num_args_1.conf"
	"$TEST_FILES_DIR/error_page/1_wrong_num_args_2.conf"
	"$TEST_FILES_DIR/error_page/2_wrong_key_1.conf"
	"$TEST_FILES_DIR/error_page/2_wrong_key_2.conf"
	"$TEST_FILES_DIR/error_page/2_wrong_key_3.conf"
	"$TEST_FILES_DIR/error_page/2_wrong_key_4.conf"
	"$TEST_FILES_DIR/error_page/2_wrong_key_5.conf"
	"$TEST_FILES_DIR/error_page/3_wrong_end_1.conf"
	"$TEST_FILES_DIR/error_page/3_wrong_end_2.conf"
	"$TEST_FILES_DIR/error_page/4_wrong_val_1.conf"
	"$TEST_FILES_DIR/error_page/4_wrong_val_2.conf"
	"$TEST_FILES_DIR/error_page/4_wrong_val_3.conf"

	"$TEST_FILES_DIR/location/1_empty_directive.conf"
	"$TEST_FILES_DIR/location/1_wrong_path.conf"
	"$TEST_FILES_DIR/location/2_syntax_1.conf"
	"$TEST_FILES_DIR/location/2_syntax_2.conf"
	"$TEST_FILES_DIR/location/2_syntax_3.conf"
	"$TEST_FILES_DIR/location/3_wrong_end_1.conf"
	"$TEST_FILES_DIR/location/4_wrong_char_1.conf"
	"$TEST_FILES_DIR/location/4_wrong_autoindex_1.conf"
	"$TEST_FILES_DIR/location/4_wrong_autoindex_2.conf"
	"$TEST_FILES_DIR/location/4_wrong_cgi_ext_1.conf"
	"$TEST_FILES_DIR/location/4_wrong_cgi_ext_2.conf"
	"$TEST_FILES_DIR/location/4_wrong_cgi_ext_3.conf"
	"$TEST_FILES_DIR/location/4_wrong_cgi_ext_4.conf"
	"$TEST_FILES_DIR/location/4_wrong_cgi_ext_5.conf"
	"$TEST_FILES_DIR/location/4_wrong_cgi_ext_6.conf"
	"$TEST_FILES_DIR/location/4_wrong_cgi_ext_7.conf"
	"$TEST_FILES_DIR/location/4_wrong_cgi_ext_8.conf"
	"$TEST_FILES_DIR/location/4_wrong_cgi_ext_9.conf"
	"$TEST_FILES_DIR/location/4_wrong_cgi_path_1.conf"
	"$TEST_FILES_DIR/location/4_wrong_root_1.conf"
	"$TEST_FILES_DIR/location/4_wrong_root_2.conf"
	"$TEST_FILES_DIR/location/4_wrong_index_1.conf"
	"$TEST_FILES_DIR/location/4_wrong_index_2.conf"
	"$TEST_FILES_DIR/location/4_wrong_method_1.conf"
	"$TEST_FILES_DIR/location/4_wrong_method_2.conf"
	"$TEST_FILES_DIR/location/4_wrong_method_3.conf"
	"$TEST_FILES_DIR/location/4_wrong_method_4.conf"
	"$TEST_FILES_DIR/location/4_wrong_return_1.conf"
	"$TEST_FILES_DIR/location/4_wrong_return_2.conf"
	"$TEST_FILES_DIR/location/4_wrong_return_3.conf"

	"$TEST_FILES_DIR/validate_data/1_without_root_1.conf"
	"$TEST_FILES_DIR/validate_data/1_without_root_2.conf"
	"$TEST_FILES_DIR/validate_data/1_without_root_3.conf"
	"$TEST_FILES_DIR/validate_data/1_without_root_4.conf"
	"$TEST_FILES_DIR/validate_data/2_duplicated_servers_1.conf"
	"$TEST_FILES_DIR/validate_data/2_duplicated_servers_2.conf"
	"$TEST_FILES_DIR/validate_data/3_location.conf"

	"$TEST_FILES_DIR/server_allow_methods/4_wrong_method_1.conf"
	"$TEST_FILES_DIR/server_allow_methods/4_wrong_method_2.conf"
	"$TEST_FILES_DIR/server_allow_methods/4_wrong_method_3.conf"
	"$TEST_FILES_DIR/server_allow_methods/4_wrong_method_4.conf"
	"$TEST_FILES_DIR/server_allow_methods/4_wrong_method_5.conf"
	"$TEST_FILES_DIR/server_allow_methods/4_wrong_method_6.conf"

)

# ------------------------------------------------------------------------------
#  LA LÓGICA CORRECTA PARA TESTS NEGATIVOS
# ------------------------------------------------------------------------------
run_test() {
	local test_file="$1"
	local relative_path="${test_file#"$TEST_FILES_DIR"/}"

	((test_num++))
	
	if [ ! -f "$test_file" ]; then
		echo -e "TEST $test_num: [$relative_path]: FAIL -> File not found"
		((failed++))
		return
	fi

	# 1. EJECUTAR CON TIMEOUT (La clave para que no se cuelgue)
	# Si el servidor arranca (porque el parser falló al detectar el error),
	# timeout lo matará a los 0.5s y devolverá exit status 124.
	output=$(timeout 0.5s "$WEBSERV" "$test_file" 2>&1)
	exit_status=$?
	
	exception=$(echo "$output" | grep -iE "(Error|Exception|Syntax)" | grep -v "Error Pages" | head -n 1)
	
	# 2. EVALUACIÓN
	# Queremos que el programa falle RÁPIDO (status != 0) y NO sea por timeout (status != 124).
	
	if [ $exit_status -eq 124 ]; then
		# CASO CRÍTICO: El servidor arrancó -> El parser se comió el error.
		echo -e "TEST $test_num: [$relative_path]: FAIL -> Server started (Parser accepted bad config!)"
		((failed++))
	
	elif [ $exit_status -eq 0 ]; then
		# CASO MALO: El programa terminó con éxito sin arrancar el server (raro, pero fail).
		echo -e "TEST $test_num: [$relative_path]: FAIL -> Program exited with 0 (No error detected)"
		((failed++))

	else
		# CASO BUENO: El programa dio error (exit 1) antes del timeout.
		# Imprimimos la excepción capturada para confirmar visualmente.
		echo -e "TEST $test_num: [$relative_path]: OK -> Caught: $exception"
		((passed++))
	fi
}

# Ejecución (Igual que tenías)
last_dir=""
for test_file in "${test_files[@]}"; do
	relative_path="${test_file#"$TEST_FILES_DIR"/}"
	current_dir=$(dirname "$relative_path")

	if [ -n "$last_dir" ] && [ "$current_dir" != "$last_dir" ]; then
		echo ""
		echo -e "$SEPARATOR"
		echo ""
	fi
	last_dir="$current_dir"
	run_test "$test_file"
done

# Summary
echo ""
echo "========================================="
echo "  Summary"
echo "========================================="
echo -e "Total: $test_num"
echo -e "Detected Errors: $passed"
echo -e "Missed Errors:   $failed"

if [ $failed -eq 0 ]; then
	exit 0
else
	exit 1
fi