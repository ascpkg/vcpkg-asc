# set options
set(VCPKG_POLICY_DLLS_IN_STATIC_LIBRARY enabled)

# Download required file
if(VCPKG_TARGET_ARCHITECTURE STREQUAL "x64")
    vcpkg_download_distfile(ARCHIVE
        URLS "https://github.com/shinchiro/mpv-winbuild-cmake/releases/download/20241205/mpv-dev-x86_64-20241205-git-91f1f4f.7z"
        FILENAME "mpv-dev-x86_64-20241205-git-91f1f4f.7z"
        SHA512 C21692ADFD9D11D0264FEA47E49B44D92C1423E2DFC39F10906E07005233E641DCF93570149DFA689E9F663A1728810E1EC44A33599D36299CC4E9ECD38C2FBE
    )
elseif(VCPKG_TARGET_ARCHITECTURE STREQUAL "arm64")
    vcpkg_download_distfile(ARCHIVE
        URLS "https://github.com/shinchiro/mpv-winbuild-cmake/releases/download/20241205/mpv-dev-aarch64-20241205-git-91f1f4f.7z"
        FILENAME "mpv-dev-aarch64-20241205-git-91f1f4f.7z"
        SHA512 9CB8959553C7F3D79BE687ED37DB2D63377721A00152ECD4E013BCB5ECE4317C19798F2BAF99C529C4129B2643BE2127792A097D1037813B818DE7790AE9CAD6
    )
endif()

# Check 7z and extract
vcpkg_find_acquire_program(7Z)
set(ENV{PM_LIBMPV_PATH} "${CURRENT_BUILDTREES_DIR}/libmpv")
file(MAKE_DIRECTORY "$ENV{PM_LIBMPV_PATH}")
vcpkg_execute_required_process(
    COMMAND "${7Z}" x "${ARCHIVE}" "-o$ENV{PM_LIBMPV_PATH}" "-y"
    WORKING_DIRECTORY "$ENV{PM_LIBMPV_PATH}"
    LOGNAME "extract-libmpv"
)

# install lib files
file(INSTALL "$ENV{PM_LIBMPV_PATH}/libmpv-2.dll" DESTINATION "${CURRENT_PACKAGES_DIR}/bin")
file(INSTALL "$ENV{PM_LIBMPV_PATH}/libmpv.dll.a" DESTINATION "${CURRENT_PACKAGES_DIR}/lib")
file(RENAME "${CURRENT_PACKAGES_DIR}/lib/libmpv.dll.a" "${CURRENT_PACKAGES_DIR}/lib/libmpv-2.lib")
file(INSTALL "$ENV{PM_LIBMPV_PATH}/libmpv-2.dll" DESTINATION "${CURRENT_PACKAGES_DIR}/debug/bin")
file(INSTALL "$ENV{PM_LIBMPV_PATH}/libmpv.dll.a" DESTINATION "${CURRENT_PACKAGES_DIR}/debug/lib")
file(RENAME "${CURRENT_PACKAGES_DIR}/debug/lib/libmpv.dll.a" "${CURRENT_PACKAGES_DIR}/debug/lib/libmpv-2.lib")

# install include dir
file(COPY "$ENV{PM_LIBMPV_PATH}/include/mpv" DESTINATION "${CURRENT_PACKAGES_DIR}/include")

# install cmake config
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/libmpvConfig.cmake" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")

# install copywrite
vcpkg_install_copyright(FILE_LIST "${CMAKE_CURRENT_LIST_DIR}/Copyright.txt")

# install usage
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")