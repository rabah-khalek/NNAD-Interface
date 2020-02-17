# build exacutable
add_executable(main main.cc)
target_link_libraries(main NNAD_INTERFACE CERES)