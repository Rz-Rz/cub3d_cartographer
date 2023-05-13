#!/bin/bash

# Function to print colored output
print_colored() {
    local color="$1"
    local message="$2"

    case "$color" in
        green) echo -e "\033[32m$message\033[0m" ;;
        red) echo -e "\033[31m$message\033[0m" ;;
        *) echo "$message" ;;
    esac
}


# Function to run the test executable without valgrind
run_test_no_valgrind() {
    local executable="$1"
    local input_file="$2"
    local output_file="$3"

    stdbuf -oL ./"$executable" "$input_file" > "$output_file" 2>&1
    local exit_code=$?

    return $exit_code
}

# Function to run the test executable
run_test() {
    local executable="$1"
    local input_file="$2"
    local output_file="$3"

    # Kill the program after 5 seconds
    ( sleep 5; killall "$executable" ) &
    local timer_pid=$!

    # Run the program with valgrind and pipe output to a file
    valgrind --leak-check=full --error-exitcode=1 --log-file="$output_file" ./"$executable" "$input_file"
    local exit_code=$?

    # Kill the timer subprocess
    kill "$timer_pid" 2>/dev/null

    return $exit_code
}

# Function to check test results
# # Function to check test results
check_results() {
    local output_file="$1"
    local folder_type="$2"

    # Check for the "Error" string
	grep -rn "Error" "$output_file"
    local error_found=$?

    # Check for valgrind issues
    local valgrind_errors=$(grep -oP "ERROR SUMMARY: \K\d+" "$output_file")
    local valgrind_success=$((valgrind_errors == 0 ? 0 : 1))

    if [ "$folder_type" == "invalid_map" ]; then
        if [ $error_found -eq 1 ]; then
            print_colored green "Success: Error string found"
        else
            print_colored red "Failure: Error string not found"
        fi
    else
        if [ $error_found -eq 0 ]; then
            print_colored red "Failure: Error string found"
        else
            print_colored green "Success: Error string not found"
        fi
    fi

    if [ $valgrind_success -eq 0 ]; then
        print_colored green "Success: No valgrind issues"
    else
        print_colored red "Failure: Valgrind issues detected"
    fi
}
# check_results() {
#     local output_file="$1"
#     local folder_type="$2"

#     # Check for the "Error" string
#     grep -iq "Error" "$output_file"
#     local error_found=$?

#     # Check for valgrind issues
#     grep -q "ERROR SUMMARY: 0 errors" "$output_file"
#     local valgrind_success=$?

#     if [ "$folder_type" == "invalid_map" ]; then
#         if [ $error_found -eq 0 ]; then
#             print_colored green "Success: Error string found"
#         else
#             print_colored red "Failure: Error string not found"
#         fi
#     elif [ "$folder_type" == "valid_map" ]; then
#         if [ $error_found -ne 0 ]; then
#             print_colored green "Success: Error string not found"
#         else
#             print_colored red "Failure: Error string found"
#         fi
#     fi

#     if [ $valgrind_success -eq 0 ]; then
#         print_colored green "Success: No valgrind issues"
#     else
#         print_colored red "Failure: Valgrind issues detected"
#     fi
# }

# Function to clean up generated files
cleanup() {
    local output_file="$1"
    rm -f "$output_file"
}

# # Function to run the test executable without valgrind
# run_test_no_valgrind() {
#     local executable="$1"
#     local input_file="$2"
#     local output_file="$3"

#     ./"$executable" "$input_file" > "$output_file" 2>&1
#     local exit_code=$?

#     return $exit_code
# }

# Function to run tests with a list of input files
run_tests_with_files() {
    local executable="$1"
    local folder_type="$2"
    shift
    shift

    for input_file in "$@"; do
        echo "Running test with input file: $input_file"
        local output_file="output_$(basename "$input_file")"
        if [ "$folder_type" == "valid_map" ]; then
            run_test_no_valgrind "$executable" "$input_file" "$output_file"
            check_results "$output_file" "$folder_type"
            cleanup "$output_file"
            echo
        fi
        run_test "$executable" "$input_file" "$output_file"
        check_results "$output_file" "$folder_type"
        cleanup "$output_file"
        echo
    done
}

# Check for proper arguments
if [ $# -lt 1 ]; then
    echo "Usage: $0 <executable>"
    exit 1
fi

# Main function
main() {
    local executable="$1"

    local invalid_maps=("invalid_maps"/*)
    local valid_maps=("valid_maps"/*)

    echo "Running tests for invalid_map:"
    run_tests_with_files "$executable" "invalid_map" "${invalid_maps[@]}"

    echo
    echo "Running tests for valid_map:"
    run_tests_with_files "$executable" "valid_map" "${valid_maps[@]}"
}

main "$@"

