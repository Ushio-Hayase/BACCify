add_executable(BAClass Main.cpp)

if(${CMAKE_BUILD_TYPE} MATCHES Debug)
    set(LIB_PATH  ${CMAKE_SOURCE_DIR}/libtorch/libtorch-win-shared-with-deps-debug-2.6.0+cu126/libtorch/lib)
    target_include_directories(BAClass PRIVATE 
    ${CMAKE_SOURCE_DIR}/libtorch/libtorch-win-shared-with-deps-debug-2.6.0+cu126/libtorch/include)
    include(D:/CharacterClassification/libtorch/libtorch-win-shared-with-deps-debug-2.6.0+cu126/libtorch/share/cmake/Torch/TorchConfig.cmake)
    target_link_libraries(BAClass "${TORCH_LIBRARIES}")
else()
    set(LIB_PATH ${CMAKE_SOURCE_DIR}/libtorch/libtorch-win-shared-with-deps-2.6.0+cu126/libtorch/lib)
    target_include_directories(BAClass PRIVATE 
    ${CMAKE_SOURCE_DIR}/libtorch/libtorch-win-shared-with-deps-2.6.0+cu126/libtorch/include)
    include(D:/CharacterClassification/libtorch/libtorch-win-shared-with-deps-2.6.0+cu126/libtorch/share/cmake/Torch/TorchConfig.cmake)
    target_link_libraries(BAClass "${TORCH_LIBRARIES}")
endif()

if(WIN32)
    set(TARGET_OUTPUT_DIR $<TARGET_FILE_DIR:BAClass>)
    file(GLOB TORCH_DLL_FILES "${LIB_PATH}/*.dll")

    # DLL 파일이 존재하는지 확인
    if(TORCH_DLL_FILES)
        # 위에서 만든 헬퍼 스크립트 파일의 경로 설정
        # 이 CMakeLists.txt 파일이 있는 위치 기준으로 cmake/ 폴더 안의 스크립트를 찾음
        set(COPY_DLLS_SCRIPT "${CMAKE_SOURCE_DIR}/cmake/copy_files_if_not_exist.cmake")

        # 스크립트에 리스트를 전달하기 위해 세미콜론으로 구분된 문자열로 변환
        string(JOIN ";" TORCH_DLL_FILES_STR "${TORCH_DLL_FILES}")

        add_custom_command(TARGET BAClass POST_BUILD
        COMMAND ${CMAKE_COMMAND}
            # 스크립트에 필요한 변수를 -D 옵션으로 전달
            -DSOURCE_FILES_LIST_STR="${TORCH_DLL_FILES_STR}"
            # 대상 디렉토리 전달 (Generator Expression 사용, 빌드 시점에 평가됨)
            -DDESTINATION_DIR=$<TARGET_FILE_DIR:BAClass>
            # 실행할 스크립트 지정 (-P 옵션)
            -P "${COPY_DLLS_SCRIPT}"
        # 빌드 시 출력될 메시지
        COMMENT "Checking and copying required LibTorch DLLs if they do not exist..."
        # 인자를 그대로 전달 (경로에 공백 등 포함 시 중요)
        VERBATIM
        )
    else()
        message(WARNING "No DLL files found in ${TORCH_DLL_SOURCE_DIR}. Skipping DLL copy step.")
  endif()
endif()