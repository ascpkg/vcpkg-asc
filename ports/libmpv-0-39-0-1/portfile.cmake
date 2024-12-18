# set options
set(VCPKG_POLICY_DLLS_IN_STATIC_LIBRARY enabled)

# Download required file
if(VCPKG_TARGET_ARCHITECTURE STREQUAL "x64")
    vcpkg_download_distfile(ARCHIVE
        URLS "https://github.com/shinchiro/mpv-winbuild-cmake/releases/download/20241218/mpv-dev-x86_64-20241218-git-32d103c.7z"
        FILENAME "mpv-dev-x86_64-20241218-git-32d103c.7z"
        SHA512 23197C01894B395397DD1DA34332F577B23580E9AFA46809EDBE0EF4ED16CED587437F9BFF9AFA91601B6870F56AF892D23152210A702226435E59F675260355
    )
elseif(VCPKG_TARGET_ARCHITECTURE STREQUAL "arm64")
    vcpkg_download_distfile(ARCHIVE
        URLS "https://github.com/shinchiro/mpv-winbuild-cmake/releases/download/20241218/mpv-dev-aarch64-20241218-git-32d103c.7z"
        FILENAME "mpv-dev-aarch64-20241218-git-32d103c.7z"
        SHA512 931B326527E7A36530CE2ACA32B7F2CCDDB706B38A991755C383359B555D241B3DE17C97B2523AE2504DCC5F384AA8A11B91C5F0A0AAA6F7673DBB5629FB6FAD
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